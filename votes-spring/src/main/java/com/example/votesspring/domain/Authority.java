package com.example.votesspring.domain;

import org.springframework.security.core.GrantedAuthority;

public class Authority implements GrantedAuthority {
    public Authority() {

    }

    @Override
    public String getAuthority() {
        return "USER";
    }
}
