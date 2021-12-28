package com.example.votesspring.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class UserLoginRequest {
    private String username;
    private String password;

    @Builder
    public UserLoginRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
