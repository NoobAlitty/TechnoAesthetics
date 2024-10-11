package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Entity
@Setter
@Getter
public class Friend {
    @Id
    private int id;
    private int user1;
    private int user2;
    private Instant createdTime;
    private String friendshipStatus;
}
