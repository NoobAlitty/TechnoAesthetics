package org.example.server_springboot.model.view;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class Correspond {
    private final Map<String, Integer> sessionToUserIdMap = new ConcurrentHashMap<>();

    public void add(String sessionId, Integer userId) {
        sessionToUserIdMap.put(sessionId, userId);
    }

    public void remove(String sessionId) {
        sessionToUserIdMap.remove(sessionId);
    }

    public Integer get(String sessionId) {
        return sessionToUserIdMap.get(sessionId);
    }

    public boolean isExisted(String sessionId) {
        return sessionToUserIdMap.containsKey(sessionId);
    }
}
