package com.example.votesspring.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
public class VoteRequestDto {

    private String question;
    private List<String> answers;
    private LocalDateTime expiresAt;

    @Builder
    public VoteRequestDto(String question, List<String> answers, LocalDateTime expiresAt) {
        this.question = question;
        this.answers = answers;
        this.expiresAt = expiresAt;
    }

    @Deprecated
    public static VoteRequestDto mockObject() {
        return VoteRequestDto.builder()
                .question("이 질문은 가짜 질문입니다. 잘 작동하나요?")
                .answers(List.of("예", "아니요.", "잘 모르겠습니다."))
                .expiresAt(LocalDateTime.now().plusDays(1))
                .build();
    }

}
