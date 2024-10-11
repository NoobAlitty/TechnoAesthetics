package org.example.server_springboot.configuration;

import org.example.server_springboot.controller.ws.ChatController;
import org.example.server_springboot.model.view.Correspond;
import org.example.server_springboot.model.view.OnlineUsers;
import org.example.server_springboot.repository.FriendRepository;
import org.example.server_springboot.repository.UserGroupMappingRepository;
import org.example.server_springboot.service.MessageService;
import org.example.server_springboot.service.UserService;
import org.example.server_springboot.util.JwtTokenUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final OnlineUsers onlineUsers;
    private final Correspond correspond;
    private final UserGroupMappingRepository userGroupMappingRepository;
    private final MessageService messageService;
    private final JwtTokenUtil jwtTokenUtil;
    private final FriendRepository friendRepository;
    private final UserService userService;

    public WebSocketConfig(OnlineUsers onlineUsers, Correspond correspond, UserGroupMappingRepository userGroupMappingRepository,  JwtTokenUtil jwtTokenUtil, FriendRepository friendRepository, MessageService messageService, UserService userService) {
        this.onlineUsers = onlineUsers;
        this.correspond = correspond;
        this.userGroupMappingRepository = userGroupMappingRepository;
        this.messageService = messageService;
        this.userService = userService;
        this.jwtTokenUtil = jwtTokenUtil;
        this.friendRepository = friendRepository;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new ChatController(onlineUsers,  correspond,  jwtTokenUtil , userGroupMappingRepository,friendRepository,userService,messageService), "/websocket");
    }
}

