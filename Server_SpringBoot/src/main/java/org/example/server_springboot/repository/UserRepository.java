package org.example.server_springboot.repository;

import org.example.server_springboot.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    User findById(int id);
    User findByUsername(String username);
    User findByEmail(String email);
    @Query("SELECT u FROM User u WHERE LOWER(u.nickname) LIKE CONCAT('%', LOWER(:searchKey), '%') OR LOWER(u.introduction) LIKE CONCAT('%', LOWER(:searchKey), '%')")
    List<User> findByNicknameContaining(@Param("searchKey") String searchKey);
}