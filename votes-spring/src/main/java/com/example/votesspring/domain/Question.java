package com.example.votesspring.domain;

import com.example.votesspring.dto.response.QuestionResponseDto;
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
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    @Builder
    public Question(Long id, Long userId, String question, LocalDateTime expiresAt, LocalDateTime createdAt, LocalDateTime updatedAt, LocalDateTime deletedAt) {
        this.id = id;
        this.userId = userId;
        this.question = question;
        this.expiresAt = expiresAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }

    public QuestionResponseDto questionResponseDtoConverter() {
        return QuestionResponseDto.builder()
                .id(this.id)
                .question(this.question)
                .expiresAt(this.expiresAt)
                .build();
    }
}
