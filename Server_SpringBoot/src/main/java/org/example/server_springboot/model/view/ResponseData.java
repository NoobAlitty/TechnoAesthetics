package org.example.server_springboot.model.view;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponseData<T> {
    private String message;
    private int status;
    private T data;

    public ResponseData() {
        this.message = "";
        this.status = 200;
        this.data = null;
    }
    public ResponseData(String message, int status, T data) {
        this.message = message;
        this.status = status;
        this.data = data;
    }

    public ResponseData<T> message(String message) {
        this.message=message;
        return this;
    }
    public ResponseData<T> status(int status) {
        this.status=status;
        return this;
    }
    public ResponseData<T> data(T data) {
        this.data=data;
        return this;
    }
    public ResponseData<T> log() {
        System.out.println("Message: " + message);
        System.out.println("Status: " + status);
        System.out.println("Data: " + data);
        return this;
    }
}