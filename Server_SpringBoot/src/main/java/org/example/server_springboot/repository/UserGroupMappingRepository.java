package org.example.server_springboot.repository;

import org.example.server_springboot.model.entity.ChatGroup;
import org.example.server_springboot.model.entity.User;
import org.example.server_springboot.model.entity.UserGroupMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserGroupMappingRepository extends JpaRepository<UserGroupMapping, Integer> {

    @Query("SELECT m.userId from UserGroupMapping m where m.groupId=:groupId")
    List<Integer> getUserIdByGroupId(@Param("groupId") Integer groupId);

    @Query("SELECT u FROM User u INNER JOIN UserGroupMapping m ON u.id = m.userId WHERE m.groupId = :groupId")
    List<User> findUsersByGroupId(@Param("groupId") Integer groupId);

    @Query("SELECT g FROM ChatGroup g INNER JOIN UserGroupMapping m ON g.id = m.groupId WHERE m.userId = :userId")
    List<ChatGroup> findGroupsByUserId(@Param("userId") Integer userId);
}
