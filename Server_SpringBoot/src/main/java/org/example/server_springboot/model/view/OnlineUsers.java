package org.example.server_springboot.model.view;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class OnlineUsers {
    private final Map<Integer, WebSocketSession> users = new ConcurrentHashMap<>();

    public void add(int userId, WebSocketSession session) {
        users.put(userId, session);
    }

    public void remove(int userId) {
        users.remove(userId);
    }

    public WebSocketSession get(int userId) {
        return users.get(userId);
    }

    public boolean isExisted(int userId) {
        return users.containsKey(userId);
    }
}

