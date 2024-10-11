package org.example.server_springboot.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
public class User {
    @Id
    private int id;
    private String username;
    private String password;
    private String role;
    private String email;
    private String nickname;
    private int age;
    private String phone;
    private String avatar;
    private String introduction;
    private boolean online;
    private String sex;
    private String address;
}
