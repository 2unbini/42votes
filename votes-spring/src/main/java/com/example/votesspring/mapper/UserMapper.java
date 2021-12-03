package com.example.votesspring.mapper;

import com.example.votesspring.domain.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface UserMapper {

    void save(User user);

    List<User> findAll();

    Optional<User> findByName(String username);

    void deleteByName(String username);
}
