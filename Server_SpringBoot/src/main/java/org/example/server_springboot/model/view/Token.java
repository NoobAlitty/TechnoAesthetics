package org.example.server_springboot.model.view;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Token{
    @Id
    public String token;

    public Token(String token) {
        this.token = token;
    }

    public Token() {

    }
}
