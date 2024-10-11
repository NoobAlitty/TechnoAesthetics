package org.example.server_springboot.repository;

import org.example.server_springboot.model.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Integer> {

    @Query("select mg from Message mg where mg.type=:type and mg.receiver in (select mp.groupId from UserGroupMapping mp where mp.userId=:userId)order by mg.time asc ")
    List<Message> findGroupMessages(@Param("userId") int userId, @Param("type") String type);

    @Query("select mg from Message mg where (mg.sender=:userId or mg.receiver=:userId) and mg.type=:type order by mg.time asc")
    List<Message> findPrivateMessages(@Param("userId") int userId, @Param("type") String type);
}
