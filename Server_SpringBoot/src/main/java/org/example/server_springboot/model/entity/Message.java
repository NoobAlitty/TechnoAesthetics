package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Entity
@Setter
@Getter
public class Message {
    @Id
    private int id;
    private String type;
    private int sender;
    private int receiver;
    private String content;
    private String format;
    private Instant time;
}
