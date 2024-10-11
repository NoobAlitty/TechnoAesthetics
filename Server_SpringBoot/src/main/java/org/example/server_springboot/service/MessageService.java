package org.example.server_springboot.service;

import org.example.server_springboot.model.entity.Message;
import org.example.server_springboot.repository.MessageRepository;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
public class MessageService {
    MessageRepository messageRepository;
    MessageService(MessageRepository messageRepository) {
        this.messageRepository = messageRepository;
    }
    public void saveMessage(JSONObject json, int receiver) {
        Message message = new Message();
        message.setType(json.getString("type"));
        message.setSender(json.getInt("sender"));
        message.setReceiver(receiver);
        message.setContent(json.getString("content"));
        message.setFormat(json.getString("format"));
        message.setTime(Instant.parse(json.getString("time")));
        messageRepository.save(message);
    }
    public List<Message> findAllMessages(int userId){
        List<Message>Messages= messageRepository.findGroupMessages(userId,"group");
        Messages.addAll(messageRepository.findPrivateMessages(userId,"ai"));
        Messages.addAll(messageRepository.findPrivateMessages(userId,"private"));
        return Messages;
    }
}
