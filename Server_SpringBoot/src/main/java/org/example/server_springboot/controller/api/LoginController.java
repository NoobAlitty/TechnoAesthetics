package org.example.server_springboot.controller.api;

import org.example.server_springboot.model.entity.User;
import org.example.server_springboot.model.view.ResponseData;
import org.example.server_springboot.model.view.Token;
import org.example.server_springboot.repository.UserRepository;
import org.example.server_springboot.service.PasswordService;
import org.example.server_springboot.util.JwtTokenUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class LoginController {

    public record LoginRequest(String username, String password) {
    }
    private final UserRepository userRepository;
    private final JwtTokenUtil jwtTokenUtil;

    public LoginController(UserRepository userRepository, JwtTokenUtil jwtTokenUtil) {
        this.userRepository = userRepository;
        this.jwtTokenUtil = jwtTokenUtil;
    }

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginRequest loginRequest) {
        System.out.println(loginRequest.username+" "+loginRequest.password+" is trying to login");
        // 根据用户名查询用户信息
        User user = userRepository.findByUsername(loginRequest.username());

        // 如果用户不存在或密码不正确,返回错误信息
        if (user == null || !PasswordService.verifyPassword(loginRequest.password(), user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseData<>().status(401).message("Invalid username or password").log());
        }
        // 登录成功,返回成功消息
        return ResponseEntity.ok(new ResponseData<Token>().status(200).message("Login successful").data( new Token(jwtTokenUtil.generateToken(user.getId()))).log());
    }
}