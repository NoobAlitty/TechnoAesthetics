package org.example.server_springboot.controller.my;

import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.binary.Base64;
import org.example.server_springboot.service.SpeechSynthesisService;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/my")
public class SpeechController {
    public record Speech(String q,String voiceName){}

    @PostMapping("/getSpeech")
    public ResponseEntity<Object> getSpeech(@RequestBody Speech speech) throws NoSuchAlgorithmException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            SpeechSynthesisService speechSynthesisService = new SpeechSynthesisService();
            byte[] result = speechSynthesisService.getSpeech(speech.q, speech.voiceName);
            byte[]mp3Bytes=convertToMp3(result);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDisposition(ContentDisposition.attachment().filename("speech.mp3").build());
            return new ResponseEntity<>(mp3Bytes, headers, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    private byte[] convertToMp3(byte[] result) {
        try {
            // 创建 Base64 编码器
            Base64 base64 = new Base64();
            // 将 byte[] 编码为 Base64 字符串
            String base64String = base64.encodeToString(result);
            // 将 Base64 字符串解码为 byte[]
            return base64.decode(base64String);
        } catch (Exception e) {
            throw new RuntimeException("转换为 MP3 失败", e);
        }
    }
}

