package org.example.server_springboot.controller.api;

import lombok.Getter;
import lombok.Setter;
import org.example.server_springboot.model.entity.User;
import org.example.server_springboot.model.view.ResponseData;
import org.example.server_springboot.repository.UserRepository;
import org.example.server_springboot.service.CodeService;
import org.example.server_springboot.service.PasswordService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class RegisterController {

    private final UserRepository userRepository;
    private final CodeService codeService;

    public RegisterController(UserRepository userRepository, CodeService codeService) {
        this.userRepository = userRepository;
        this.codeService = codeService;
    }

    @Getter
    @Setter
    public static class RegisterRequest {
        private String username;
        private String password;
        private String email;
        private String code;

        // 生成 getter 和 setter 方法
    }

    @PostMapping("/register")
    public ResponseEntity<Object> register(@RequestBody RegisterRequest registerRequest) {
        // 检查用户名是否已存在
        User user = userRepository.findByUsername(registerRequest.getUsername());
        if (user != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new ResponseData<>().status(409).message("Username already exists").log());
        }

        // 检查邮箱是否已存在
        user = userRepository.findByEmail(registerRequest.getEmail());
        if (user != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new ResponseData<>().status(409).message("Email already exists").log());
        }

        // 检查验证码是否正确
        if(!codeService.verifyCode(registerRequest.getEmail(),registerRequest.getCode()))
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseData<>().status(400).message("Wrong or expired code").log());

        // 创建新用户
        User us1 = new User();
        us1.setPassword(PasswordService.hashPassword(registerRequest.getPassword()));
        us1.setUsername(registerRequest.getUsername());
        us1.setEmail(registerRequest.getEmail());
        userRepository.save(us1);

        return ResponseEntity.ok(new ResponseData<>().status(201).message("Registration successful").data(us1).log());
    }
}