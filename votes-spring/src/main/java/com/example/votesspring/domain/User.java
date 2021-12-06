package com.example.votesspring.domain;


import lombok.*;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Setter
@Alias("User")
public class User {

    private Long id;
    private String username;
    private String password;
    private String email;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    @Builder
    public User(Long id, String username, String password, String email, LocalDateTime createdAt, LocalDateTime updatedAt, LocalDateTime deletedAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", deletedAt=" + deletedAt +
                '}';
    }
}
