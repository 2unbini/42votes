package com.example.votesspring.domain;

//CREATE TABLE QUESTION
//        (
//        `id`          BIGINT          NOT NULL    AUTO_INCREMENT COMMENT 'question id',
//        `user_id`     BIGINT          NOT NULL    COMMENT '질문을 만든 유저 id',
//        `question`    VARCHAR(255)    NOT NULL    COMMENT '질문 내용',
//        `expires_at`  TIMESTAMP       NOT NULL    COMMENT '투표 기한',
//        `created_at`  TIMESTAMP       NOT NULL    DEFAULT NOW() COMMENT '생성된 시간',
//        `deleted_at`  TIMESTAMP       NULL        DEFAULT NULL COMMENT '삭제된 시간',
//        `is_expired`  TINYINT         NULL        COMMENT '투표 마감 여부',
//        PRIMARY KEY (id)
//        );

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Setter
@Alias("Question")
public class Question{

    private Long id;
    private Long userId;
    private String question;
    private Boolean isExpired;
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    @Builder
    public Question(Long id, Long userId, String question, Boolean isExpired, LocalDateTime expiresAt, LocalDateTime createdAt, LocalDateTime updatedAt, LocalDateTime deletedAt) {
        this.id = id;
        this.userId = userId;
        this.question = question;
        this.isExpired = isExpired;
        this.expiresAt = expiresAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }
}
