package org.example.server_springboot.model.dto;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
public class UserDTO {
    @Id
    private int id;
    private String username;
    private String email;
    private String nickname;
    private String phone;
    private String avatar;
    private int age;
    private String introduction;
    private boolean online;
    private String sex;
    private String address;
}