package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Entity
@Setter
@Getter
public class UserGroupMapping {
    @Id
    private int id;
    private int groupId;
    private int userId;
    private Instant createdAt;
    private String groupShipStatus;
}
