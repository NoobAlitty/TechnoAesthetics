package org.example.server_springboot.controller.api;

import org.example.server_springboot.model.entity.ValidationCode;
import org.example.server_springboot.model.view.ResponseData;
import org.example.server_springboot.service.CodeService;
import org.example.server_springboot.service.EmailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ValidationCodeController {

    public record EmailRequest(String email) {
    }

    private final CodeService codeService;
    private final EmailService emailService;

    public ValidationCodeController(CodeService codeService, EmailService emailService) {
        this.codeService = codeService;
        this.emailService = emailService;
    }

    @PostMapping("/sendRegisterCode")
    public ResponseEntity<Object> sendRegisterCode(@RequestBody EmailRequest emailRequest) {
        String email = emailRequest.email();
        System.out.println(email + " is trying to send email");
        try {
            ValidationCode validationCode = codeService.generateCode(email);
            if(emailService.sendRegisterEmail(email, validationCode.getCode())) {
                codeService.saveCode(validationCode);
                return ResponseEntity.ok(new ResponseData<>().status(200).message("Verification code sent").log());
            } // 处理非法邮箱地址
            else return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseData<>().status(400).message("Invalid email address").log());
            }  catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(new ResponseData<>().status(500).message("Failed to send verification code").log());
        }
    }
}