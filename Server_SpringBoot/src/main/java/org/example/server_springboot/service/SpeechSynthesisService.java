package org.example.server_springboot.service;

import org.example.server_springboot.util.AuthV3Util;
import org.example.server_springboot.util.HttpUtil;

import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

/**
 * 网易有道智云语音合成服务api调用demo
 * api接口: <a href="https://openapi.youdao.com/ttsapi">...</a>
 */
public class SpeechSynthesisService {

    private static final String APP_KEY = "44d0216710d0c83e";     // 您的应用ID
    private static final String APP_SECRET = "cvWfrSS8amkrkXb7KKqe7tGS6xbjW1ja";  // 您的应用密钥

    //阻塞函数，直到得到https返回值
    public byte[] getSpeech(String q,String voiceName) throws NoSuchAlgorithmException {
        // 添加请求参数
        Map<String, String[]> params = createRequestParams(q,voiceName);
        // 添加鉴权相关参数
        AuthV3Util.addAuthParams(APP_KEY, APP_SECRET, params);
        // AuthV4Util.addAuthParams(APP_KEY,APP_SECRET,params);
        // 请求api服务
        return HttpUtil.doPost("https://openapi.youdao.com/ttsapi", null, params, "audio");
    }

    private static Map<String, String[]> createRequestParams(String q,String voiceName) {
        /*
         * note: 将下列变量替换为需要请求的参数
         */
        String format = "mp3";

        return new HashMap<String, String[]>() {{
            put("q", new String[]{q});
            put("voiceName", new String[]{voiceName});
            put("format", new String[]{format});
        }};
    }
}
