package com.example.votesspring.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
public class VoteResponseDto {

    private QuestionResponseDto question;
    private List<AnswerResponseDto> answers;

    @Builder
    public VoteResponseDto(QuestionResponseDto question, List<AnswerResponseDto> answers) {
        this.question = question;
        this.answers = answers;
    }

    @Deprecated
    public static VoteResponseDto mockObject() {
        return VoteResponseDto.builder()
                .question(QuestionResponseDto.mockObject())
                .answers(AnswerResponseDto.mockObjectList())
                .build();
    }
}
