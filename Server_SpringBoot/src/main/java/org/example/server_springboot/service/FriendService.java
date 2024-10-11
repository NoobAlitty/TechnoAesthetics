package org.example.server_springboot.service;

import org.example.server_springboot.model.dto.UserDTO;
import org.example.server_springboot.model.entity.Friend;
import org.example.server_springboot.model.entity.User;
import org.example.server_springboot.repository.FriendRepository;
import org.example.server_springboot.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class FriendService {
    public FriendRepository friendRepository;
    public UserRepository userRepository;
    public UserService  userService;

    FriendService(FriendRepository friendRepository,UserRepository userRepository,UserService userService) {
        this.friendRepository = friendRepository;
        this.userRepository = userRepository;
        this.userService = userService;
    }

    public void handleFriend(int userId,int friendId,String friendShipState) {
        Friend friendShip=friendRepository.findFriendShip(userId,friendId);
        if(friendShip!=null){
            friendShip.setFriendshipStatus(friendShipState);
            friendRepository.save(friendShip);
        }
    }
    public void addFriend(int userId, int friendId ){
        Friend friendShip=friendRepository.findFriendShip(userId,friendId);
        if(friendShip==null){
            friendShip=new Friend();
            friendShip.setUser1(userId);
            friendShip.setUser2(friendId);
            friendShip.setFriendshipStatus("pending");
            friendRepository.save(friendShip);
        }
        else{
            friendShip.setFriendshipStatus("pending");
            friendRepository.save(friendShip);
        }
    }
    public void deleteFriend(int userId, int friendId){
        Friend friendShip=friendRepository.findFriendShip(userId,friendId);
        if(friendShip!=null){
            friendRepository.delete(friendShip);
        }
    }
    public List<UserDTO> searchFriend(String key){
        List<User>friends=userRepository.findByNicknameContaining(key);
        return userService.convertToDTOs(friends);
    }
    public List<UserDTO> getInvitedFriend(int userId){
        List<UserDTO> invitedFriends=new ArrayList<>();
        List<Integer>friendIds=friendRepository.findInvitedFriends(userId);
        for (Integer friendId:friendIds ) {
            invitedFriends.add(userService.findDTOById(friendId));
        }
        return invitedFriends;
    }
}
