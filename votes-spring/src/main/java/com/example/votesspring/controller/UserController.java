package com.example.votesspring.controller;

import com.example.votesspring.dto.request.UserRegisterRequest;
import com.example.votesspring.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/v1/register")
    public ResponseEntity<?> registerUser(@RequestBody UserRegisterRequest userRegisterRequest) {
        userService.registerUser(userRegisterRequest);
        return ResponseEntity.ok("register");
    }
}
