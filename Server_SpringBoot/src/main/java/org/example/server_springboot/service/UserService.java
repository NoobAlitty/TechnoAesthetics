package org.example.server_springboot.service;

import org.example.server_springboot.model.dto.UserDTO;
import org.example.server_springboot.model.entity.User;
import org.example.server_springboot.repository.UserRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void updateUser(UserDTO userDTO) {
        User user = userRepository.findById(userDTO.getId());
        BeanUtils.copyProperties(userDTO, user);
        userRepository.save(user);
    }
    public UserDTO convertToDTO(User user) {
        UserDTO userDTO = new UserDTO();
        BeanUtils.copyProperties(user, userDTO);
        return userDTO;
    }

    public UserDTO findDTOById(int userId) {
        User user = userRepository.findById(userId);
        return user != null ? convertToDTO(user) : null;
    }

    public List<UserDTO> convertToDTOs(List<User> users) {
        List<UserDTO> userDTOS = new ArrayList<>();
        for (User user : users) {
            userDTOS.add(convertToDTO(user));
        }
        return userDTOS;
    }

    public void setUserOnlineStatus(int userId, boolean online) {
        // 从数据库中查找指定ID的用户
        User user = userRepository.findById(userId);
        if(user==null) return;
        // 更新用户的在线状态
        user.setOnline(online);
        // 保存更新后的用户信息
        userRepository.save(user);
    }
}
