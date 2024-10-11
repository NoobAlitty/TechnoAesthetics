package org.example.server_springboot.controller.my;

import org.example.server_springboot.model.dto.UserDTO;
import org.example.server_springboot.model.view.ResponseData;
import org.example.server_springboot.service.FriendService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/my")
public class FriendController {

    public record Search(String key){}
    public record Add(int friendId){}
    public record Delete(int friendId){}
    public record Handle(int friendId,String friendship_state){}

    FriendService friendService;
    public FriendController(FriendService friendService) {
        this.friendService = friendService;
    }

    @PostMapping("/searchFriend")
    public ResponseEntity<Object> searchFriend(@RequestBody Search search) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            return ResponseEntity.ok(new ResponseData<List<UserDTO>>().status(200).message("Search friends successfully!").data(friendService.searchFriend(search.key)).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @GetMapping("/getInvite")
    public ResponseEntity<Object> getInvite() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            return ResponseEntity.ok(new ResponseData<List<UserDTO>>().status(200).message("Get invited information successfully!").data(friendService.getInvitedFriend(userId)).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @PostMapping("/addFriend")
    public ResponseEntity<Object> addFriend(@RequestBody Add add) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            friendService.addFriend(userId, add.friendId);
            return ResponseEntity.ok(new ResponseData<>().status(200).message("Send addFriend successfully!").log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @PostMapping("/deleteFriend")
    public ResponseEntity<Object> deleteFriend(@RequestBody Delete delete) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            friendService.deleteFriend(userId, delete.friendId);
            return ResponseEntity.ok(new ResponseData<>().status(200).message("Delete friend successfully!").log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }

    @PostMapping("/handleFriend")
    public ResponseEntity<Object> handleFriend(@RequestBody Handle handle) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            int userId = Integer.parseInt(authentication.getName());
            friendService.handleFriend(userId,handle.friendId,handle.friendship_state);
            return ResponseEntity.ok(new ResponseData<>().status(200).message(handle.friendship_state).log());
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
    }
}
