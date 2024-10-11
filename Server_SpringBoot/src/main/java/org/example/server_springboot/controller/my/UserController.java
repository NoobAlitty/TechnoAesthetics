package org.example.server_springboot.controller.my;

import org.example.server_springboot.model.dto.UserDTO;
import org.example.server_springboot.model.entity.ChatGroup;
import org.example.server_springboot.model.entity.Message;
import org.example.server_springboot.model.view.ResponseData;
import org.example.server_springboot.repository.FriendRepository;
import org.example.server_springboot.repository.UserGroupMappingRepository;
import org.example.server_springboot.service.MessageService;
import org.example.server_springboot.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/my")
public class UserController {
    final FriendRepository friendRepository;
    final UserGroupMappingRepository userGroupMappingRepository;
    final UserService userService;
    final MessageService messageService;

    public UserController(FriendRepository friendRepository,UserGroupMappingRepository userGroupMappingRepository, UserService userService, MessageService messageService) {
        this.friendRepository = friendRepository;
        this.userGroupMappingRepository = userGroupMappingRepository;
        this.userService = userService;
        this.messageService = messageService;
    }

    @GetMapping("/getFriendInfo")
    public ResponseEntity<Object> getFriendInfo() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            List<UserDTO> friendInfo=userService.convertToDTOs(friendRepository.findFriendsByUserId(userId));
            return ResponseEntity.ok(new ResponseData<List<UserDTO>>().message("Requesting friend information successful!").data(friendInfo).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @GetMapping("/getUserInfo")
    public ResponseEntity<Object> getUserInfo() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            UserDTO userInfo= userService.findDTOById(userId);
            return ResponseEntity.ok(new ResponseData<UserDTO>().message("Requesting user information successful!").data(userInfo).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }
    @GetMapping("/getMessage")
    public ResponseEntity<Object> getMessage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            List<Message> messageList= messageService.findAllMessages(userId);
            return ResponseEntity.ok(new ResponseData<List<Message>>().message("Requesting messages successful! ").data(messageList).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @GetMapping("/getGroupInfo")
    public ResponseEntity<Object> getGroupInfo() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            List<ChatGroup>groupList= userGroupMappingRepository.findGroupsByUserId(userId);
            return ResponseEntity.ok(new ResponseData<List<ChatGroup>>().message("Requesting group information successful!").data(groupList).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @GetMapping("/getGroupUser")
    public ResponseEntity<Object> getGroupUser(@RequestParam int groupId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            List<UserDTO> groupInfo=userService.convertToDTOs(userGroupMappingRepository.findUsersByGroupId(groupId));
            return ResponseEntity.ok(new ResponseData<List<UserDTO>>().message("Requesting group user successful!").data(groupInfo).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @PostMapping("/updateUserInfo")
    public ResponseEntity<Object> updateUserInfo(@RequestBody UserDTO userDTO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            if(userDTO.getId()==userId) {
                userService.updateUser(userDTO);
                return ResponseEntity.ok(new ResponseData<UserDTO>().message("User updated successful!").data(userDTO).log());
            }
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }
}
