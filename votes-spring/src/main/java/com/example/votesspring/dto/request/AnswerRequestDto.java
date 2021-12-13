package com.example.votesspring.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class AnswerRequestDto {

    private Long questionId;
    private Long answerId;

    @Builder
    public AnswerRequestDto(Long questionId, Long answerId) {
        this.questionId = questionId;
        this.answerId = answerId;
    }
}
