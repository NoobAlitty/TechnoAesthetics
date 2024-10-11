package org.example.server_springboot.repository;

import org.example.server_springboot.model.entity.ValidationCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ValidationCodeRepository extends JpaRepository<ValidationCode, Integer> {
    ValidationCode findByUserEmail(String userEmail);
}