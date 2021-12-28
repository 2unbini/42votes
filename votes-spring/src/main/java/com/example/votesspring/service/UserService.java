package com.example.votesspring.service;

import com.example.votesspring.domain.User;
import com.example.votesspring.dto.request.UserRegisterRequest;
import com.example.votesspring.mapper.UserMapper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }

    public void registerUser(UserRegisterRequest userRegisterRequest) {
        userMapper.save(User.builder()
                        .username(userRegisterRequest.getUsername())
                        .password(passwordEncoder.encode(userRegisterRequest.getPassword()))
                        .email(userRegisterRequest.getEmail())
                .build());
    }
}
