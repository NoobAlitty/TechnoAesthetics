package org.example.server_springboot.service;

import org.example.server_springboot.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    private final JavaMailSender mailSender;
    private final SimpleMailMessage message;
    public UserRepository userRepository;
    @Autowired
    public EmailService(JavaMailSender mailSender, @Value("${email.from}") String from) {
        this.mailSender = mailSender;
        this.message = new SimpleMailMessage();
        this.message.setFrom(from);
    }
    public boolean isInValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\."+
                "[a-zA-Z0-9_+&*-]+)*@" +
                "(?:[a-zA-Z0-9-]+\\.)+[a-z" +
                "A-Z]{2,7}$";
        return !email.matches(emailRegex);
    }
    public boolean sendRegisterEmail(String to, String validationCode) {
        if (isInValidEmail(to)) {
            return false;
        }
        try {
            String emailBody = """
                   <body style="text-align: center;">
                        Dear %s,<div style="text-align: center;">
                                    <img src="https://img.zcool.cn/community/01ab0e5b32ffc5a80120b95946c52b.JPG@1280w_1l_2o_100sh.jpg" alt="TechnoAesthetics Logo" width="96" height="64">
                                </div>
                        We are pleased to welcome you to our TechnoAesthetics community!

                        Thank you for registering with us. To complete your registration, please enter the following verification validationCode:
                        <p style="font-weight: bold;">%s</p>
                        This validationCode is required to verify your email address and activate your account. Please enter the validationCode on the registration page to proceed.

                        If you have any questions or need further assistance, please don't hesitate to reach out to our customer support team at %s.

                        We look forward to having you as part of our TechnoAesthetics family.

                        Best regards,
                        TechnoAesthetics
                    </body>
                   """.formatted(to,validationCode,message.getFrom());
            message.setTo(to);
            message.setSubject("Confirm Your Registration - Your Verification Code");
            message.setText(emailBody);
            mailSender.send(message);
        } catch (Exception e) {
            // 处理异常,记录错误日志等
            System.err.println("Failed to send registration email: " + e.getMessage());
            return false;
        }
        return true;
    }

    public boolean sendForgotPasswordEmail(String to, String validationCode) {
        if (isInValidEmail(to)) {
            return false;
        }
        try {
            String emailBody = """
                <body style="text-align: center;">
                    Dear %s,
                
                    We recently received a request to reset the password for your [Company Name] account.
                
                    To proceed with the password reset, please enter the following verification validationCode:
                
                    <p style="font-weight: bold;">%s</p>
                
                    This validationCode is required to verify your identity and allow you to reset your password. If you did not request a password reset, please disregard this email.
                
                    If you have any questions or need further assistance, please contact our customer support team at %s.
                
                    Thank you for your continued trust in [Company Name].
                
                    <div style="text-align: center;">
                        <img src="https://img.zcool.cn/community/01ab0e5b32ffc5a80120b95946c52b.JPG@1280w_1l_2o_100sh.jpg" alt="TechnoAesthetics Logo" width="64" height="64">
                    </div>
            
                    Best regards,
                    TechnoAesthetics
                </body>
                """.formatted(userRepository.findByEmail(to).getUsername(),validationCode,message.getFrom());
            message.setTo(to);
            message.setSubject("Reset Your TechnoAesthetics Password - Verification Code");
            message.setText(emailBody);
            mailSender.send(message);
        } catch (Exception e) {
            // 处理异常,记录错误日志等
            System.err.println("Failed to send forgot password email: " + e.getMessage());
            return false;
        }
        return true;
    }
}