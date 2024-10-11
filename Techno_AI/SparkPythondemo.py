# coding: utf-8
import SparkApi
import time
import websocket
import threading
from concurrent.futures import ThreadPoolExecutor
import json
from datetime import datetime
import re

#以下密钥信息从控制台获取   https://console.xfyun.cn/services/bm35
appid = ""  #填写控制台中获取的 APPID 信息
api_secret = ""  #填写控制台中获取的 APISecret 信息
api_key = ""  #填写控制台中获取的 APIKey 信息

# domain = "generalv3.5"  # Max版本
#domain = "generalv3"       # Pro版本
domain = "general"         # Lite版本

# Spark_url = "wss://spark-api.xf-yun.com/v3.5/chat"  # Max服务地址
#Spark_url = "wss://spark-api.xf-yun.com/v3.1/chat"  # Pro服务地址
Spark_url = "wss://spark-api.xf-yun.com/v1.1/chat"  # Lite服务地址

#初始上下文内容，当前可传system、user、assistant 等角色
text = []

# 创建线程池
executor = ThreadPoolExecutor(max_workers=5)

#工作线程
def workfunction(message):
    # 解析收到的JSON消息
    received_data = json.loads(message)

    # 读取id，type，sender，receiver，content，time等字段
    message_type = received_data['type']
    sender = received_data['sender']
    receiver = received_data['receiver']
    content = received_data['content']
    format=received_data['format']
    current_time = received_data['time']
    print("\nreceived:\n"+content)

    SparkApi.answer=''
    question = checklen(getText("user", content))
    SparkApi.main(appid, api_key, api_secret, Spark_url, domain, question)

    #处理函数
    processed_content=re.sub(r"\s+", "", SparkApi.answer)
    SparkApi.answer=''

    print("send:\n"+processed_content)
    # 交换sender和receiver
    modified_data = {
        "type": message_type,
        "sender": receiver,
        "receiver": sender,
        "content": processed_content,
        "time": current_time,
        "format":format
    }

    # 发送修改后的数据回去
    ws.send(json.dumps(modified_data))

def on_message(ws, message):
    print("\n当前活跃线程的数量", threading.active_count())
    # 提交任务给线程池执行
    future = executor.submit(workfunction, message)

def on_error(ws, error):
    print("Error:", error)


def on_close(ws):
    print("### closed ###")


def on_open(ws):
    print("Connection established.")


def getText(role, content):
    jsoncon = {}
    jsoncon["role"] = role
    jsoncon["content"] = content
    text.append(jsoncon)
    return text


def getlength(text):
    length = 0
    for content in text:
        temp = content["content"]
        leng = len(temp)
        length += leng
    return length


def checklen(text):
    while (getlength(text) > 8000):
        del text[0]
    return text


if __name__ == '__main__':
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp("ws://localhost:8080/websocket?token=Techno_Aesthetics_Token",
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()