package com.example.votesspring.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class AnswerResponseDto {
    private Long id;
    private String answer;
    private Long count;

    @Builder
    public AnswerResponseDto(Long id, String answer, Long count) {
        this.id = id;
        this.answer = answer;
        this.count = count;
    }

    @Deprecated
    public static List<AnswerResponseDto> mockObjectList() {
        return List.of(
                AnswerResponseDto.builder()
                        .id(1L)
                        .answer("mock : 예")
                        .count(1L)
                .build(),
                AnswerResponseDto.builder()
                        .id(2L)
                        .answer("mock : 아니요")
                        .count(2L)
                .build(),
                AnswerResponseDto.builder()
                        .id(3L)
                        .answer("mock : 잘 모르겠습니다.")
                        .count(3L)
                .build()
        );
    }
}
