package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Entity
@Setter
@Getter
public class ValidationCode {
    @Id
    private int id;
    private String userEmail;
    private String code;
    private Instant createTime;
    private Instant expireTime;
    private boolean isUsed = false;
    private Instant usedTime;
}
