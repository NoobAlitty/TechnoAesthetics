package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Entity
@Setter
@Getter
public class ChatGroup {
    @Id
    private int id;
    private String name;
    private String description;
    private String image;
    private int createdBy;
    private Instant createdAt;
    private String groupType;
}
