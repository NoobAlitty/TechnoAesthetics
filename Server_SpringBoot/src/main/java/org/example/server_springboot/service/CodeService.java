package org.example.server_springboot.service;

import org.example.server_springboot.model.entity.ValidationCode;
import org.example.server_springboot.repository.ValidationCodeRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class CodeService {

    private final ValidationCodeRepository validationCodeRepository;

    @Value("${validationCode.expiration-minutes}")
    private int codeExpirationMinutes;

    public CodeService(ValidationCodeRepository validationCodeRepository) {
        this.validationCodeRepository = validationCodeRepository;
    }

    public ValidationCode generateCode(String userEmail) {
        // 生成随机验证码
        String code = generateRandomCode();

        // 创建新的 Code 实体
        ValidationCode validationCodeEntity = new ValidationCode();
        validationCodeEntity.setUserEmail(userEmail);
        validationCodeEntity.setCode(code);
        validationCodeEntity.setCreateTime(Instant.now());
        validationCodeEntity.setExpireTime(Instant.now().plusSeconds(codeExpirationMinutes * 60L));

        return validationCodeEntity;
    }
    public void saveCode(ValidationCode validationCodeEntity) {
        // 保存验证码实体到数据库
        validationCodeRepository.save(validationCodeEntity);
    }

    public boolean verifyCode(String userEmail, String code) {
        // 检查验证码长度
        if (code.length() != 6) {
            return false;
        }
        // 根据用户邮箱查找验证码实体
        ValidationCode validationCodeEntity = validationCodeRepository.findByUserEmail(userEmail);

        // 检查验证码是否存在且未过期
        if (validationCodeEntity != null && !validationCodeEntity.isUsed() && validationCodeEntity.getExpireTime().isAfter(Instant.now())) {
            // 检查验证码是否匹配
            if (validationCodeEntity.getCode().equals(code)) {
                // 标记验证码为已使用
                validationCodeEntity.setUsed(true);
                validationCodeEntity.setUsedTime(Instant.now());
                validationCodeRepository.delete(validationCodeEntity);
                return true;
            }
        }

        return false;
    }

    private String generateRandomCode() {
        return String.format("%06d", (int) (Math.random() * 1_000_000));
    }
}