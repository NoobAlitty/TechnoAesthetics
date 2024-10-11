package org.example.server_springboot.repository;
import org.example.server_springboot.model.entity.Friend;
import org.example.server_springboot.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FriendRepository extends JpaRepository<Friend,Integer> {
    @Query("SELECT u  FROM User u WHERE u.id IN (SELECT f.user1 FROM Friend f WHERE f.user2 = :userId AND f.friendshipStatus='confirmed') OR u.id IN (SELECT f.user2 FROM Friend f WHERE f.user1 = :userId AND f.friendshipStatus='confirmed')")
    List<User> findFriendsByUserId(@Param("userId") int userId);

    @Query("SELECT CASE WHEN f.user1 = :userId THEN f.user2 ELSE f.user1 END FROM Friend f WHERE :userId IN (f.user1, f.user2) AND f.friendshipStatus='confirmed'")
    List<Integer> findFriendIdsByUserId(@Param("userId") int userId);

    @Query("select f from Friend f where (f.user1 = :userId AND f.user2 = :friendId) OR (f.user1 = :friendId AND f.user2 = :userId)")
    Friend findFriendShip(@Param("userId")int userId, @Param("friendId")int friendId);

    @Query("SELECT user1 FROM Friend WHERE user2 = :userId AND friendshipStatus = 'pending'")
    List<Integer> findInvitedFriends(@Param("userId")int userId);
}
