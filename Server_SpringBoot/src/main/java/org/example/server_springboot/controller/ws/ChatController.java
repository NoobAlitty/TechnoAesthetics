package org.example.server_springboot.controller.ws;

import org.example.server_springboot.model.view.Correspond;
import org.example.server_springboot.model.view.OnlineUsers;
import org.example.server_springboot.repository.FriendRepository;
import org.example.server_springboot.repository.UserGroupMappingRepository;
import org.example.server_springboot.service.MessageService;
import org.example.server_springboot.service.UserService;
import org.example.server_springboot.util.JwtTokenUtil;
import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.net.URI;
import java.util.List;
import java.util.Objects;

@Component
public class ChatController extends TextWebSocketHandler {

    private final OnlineUsers onlineUsers;
    private final Correspond correspond;

    final JwtTokenUtil jwtTokenUtil;
    final UserGroupMappingRepository userGroupMappingRepository;
    final FriendRepository friendRepository;
    final UserService userService;
    final MessageService messageService;

    @Value("${ai.token}")
    private String AI_Token="Techno_Aesthetics_Token";

    public ChatController(OnlineUsers onlineUsers, Correspond correspond, JwtTokenUtil jwtTokenUtil,  UserGroupMappingRepository userGroupMappingRepository, FriendRepository friendRepository, UserService userService, MessageService messageService) {
        this.onlineUsers = onlineUsers;
        this.correspond = correspond;
        this.jwtTokenUtil = jwtTokenUtil;
        this.userGroupMappingRepository = userGroupMappingRepository;
        this.friendRepository = friendRepository;
        this.userService = userService;
        this.messageService = messageService;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // 连接建立后的操作
        // 获取 WebSocket 连接 URL 中的 Token
        URI uri = session.getUri();
        String token = null;
        if (uri != null) {
            token = UriComponentsBuilder.fromUri(uri)
                    .build()
                    .getQueryParams()
                    .getFirst("token");
        }
        // 验证 Token，并获取用户信息
        if(Objects.equals(token, AI_Token)){
            onlineUsers.add(1, session);
            correspond.add(session.getId(),1);
            System.out.println("ChatAI connection opened for session " + session.getId());
        }
        else if (jwtTokenUtil.validateToken(token)) {
            int userId = jwtTokenUtil.getUserIdFromToken(token);
            //是否已登陆？
            if(onlineUsers.isExisted(userId)){
                userService.setUserOnlineStatus(userId,false);
                correspond.remove(onlineUsers.get(userId).getId());
                onlineUsers.get(userId).close();
                onlineUsers.remove(userId);
            }
            // 将用户添加到在线用户列表
            onlineUsers.add(userId, session);
            correspond.add(session.getId(),userId);
            userService.setUserOnlineStatus(userId,true);
            //上线消息
            OnlineStatus(userId);
            System.out.println("WebSocket connection opened for session "+session.getId());
        }
        else{
            session.close(CloseStatus.POLICY_VIOLATION.withReason("Unauthorized access"));
        }
    }

    @Override
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
        // 处理收到的消息
        JSONObject json = new JSONObject(message.getPayload().toString());
        // 添加发送者的 ID 到消息中
        json.put("sender", correspond.get(session.getId()));
        // 检查消息类型是否为私人消息
        if (json.getString("type").equals("private")||json.getString("type").equals("ai")) {
            int receiverId = json.getInt("receiver");
            // 目标用户是否在线
            if (onlineUsers.isExisted(receiverId)) {
                // 发送私人消息给目标用户
                onlineUsers.get(receiverId).sendMessage(new TextMessage(json.toString()));
            }
            // 目标用户不在线
            messageService.saveMessage(json, receiverId);
        }
        else if (json.getString("type").equals("group")) {
            int groupId = json.getInt("receiver");
             List<Integer> userIds = userGroupMappingRepository.getUserIdByGroupId(groupId);
             for (Integer userId : userIds) {
                 if (onlineUsers.isExisted(userId)&& !userId.equals(correspond.get(session.getId()))) {
                     onlineUsers.get(userId).sendMessage(new TextMessage(json.toString()));
                 }
             }
             messageService.saveMessage(json, groupId);
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) {
        // 处理传输错误
        System.err.println("WebSocket transport error on session " + session.getId() + ": " + exception.getMessage());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, @NotNull CloseStatus closeStatus) throws Exception {
        // 连接关闭后的操作
        int userId=correspond.get(session.getId());
        if (userId!=1) {
            System.out.println("WebSocket connection closed for session " + session.getId());
            //上线消息
            OnlineStatus(userId);
            // 从在线用户列表中移除用户
            userService.setUserOnlineStatus(userId, false);
        }
        else System.out.println("ChatAI connection closed for session " + session.getId());
        onlineUsers.remove(userId);
        correspond.remove(session.getId());
    }

    private void OnlineStatus(int userId) throws IOException {
        List<Integer> friendIds=friendRepository.findFriendIdsByUserId(userId);
        JSONObject json=new JSONObject();
        json.put("id",userId);
        json.put("type","online");
        for(Integer friendId:friendIds){
            if(onlineUsers.isExisted(friendId)){
                onlineUsers.get(friendId).sendMessage(new TextMessage(json.toString()));
            }
        }
    }
}

