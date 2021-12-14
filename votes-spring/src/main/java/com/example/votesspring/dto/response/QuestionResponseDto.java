package com.example.votesspring.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
public class QuestionResponseDto {
    private Long id;
    private String question;
    private LocalDateTime expiresAt;
    private Boolean isExpired;

    @Builder
    public QuestionResponseDto(Long id, String question, LocalDateTime expiresAt, Boolean isExpired) {
        this.id = id;
        this.question = question;
        this.expiresAt = expiresAt;
        this.isExpired = expiresAt.isBefore(LocalDateTime.now());
    }

    @Deprecated
    public static List<QuestionResponseDto> mockObjectList() {
        return List.of(
                QuestionResponseDto.builder()
                        .id(1L)
                        .question("mock : 지팍은 코딩을 싫어한다.")
                        .isExpired(true)
                        .build(),
                QuestionResponseDto.builder()
                        .id(2L)
                        .question("mock : 지팍은 코딩을 좋아한다.")
                        .isExpired(true)
                        .build(),
                QuestionResponseDto.builder()
                        .id(3L)
                        .question("mock : 이퀀은 코딩을 싫어한다.")
                        .isExpired(true)
                        .build(),
                QuestionResponseDto.builder()
                        .id(4L)
                        .question("mock : 이퀀은 코딩을 좋아한다.")
                        .isExpired(true)
                        .build(),
                QuestionResponseDto.builder()
                        .id(5L)
                        .question("mock : 이것은 목 데이터이다.")
                        .isExpired(true)
                        .build()
                );
    }

    @Deprecated
    public static QuestionResponseDto mockObject() {
        return QuestionResponseDto.builder()
                        .id(5L)
                        .question("mock : 이것은 목 데이터이다.")
                        .isExpired(true)
                        .build();
    }
}
