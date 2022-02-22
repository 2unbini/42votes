package com.example.votesspring.dto.request;

import io.swagger.annotations.ApiModelProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
public class VoteRequestDto {

    @ApiModelProperty(example = "프로젝트 진행이 잘 되어가고 있나요?")
    private String question;
    private List<String> answers;
    @ApiModelProperty(dataType = "date-time", example = "2021-12-02T12:00:00")
    private LocalDateTime expiresAt;

    @Builder
    public VoteRequestDto(String question, List<String> answers, LocalDateTime expiresAt) {
        this.question = question;
        this.answers = answers;
        this.expiresAt = expiresAt;
    }

    @Deprecated
    public static VoteRequestDto mockObject(LocalDateTime localDateTime) {
        return VoteRequestDto.builder()
                .question("이 질문은 가짜 질문입니다. 잘 작동하나요?")
                .answers(List.of("예", "아니요.", "잘 모르겠습니다."))
                .expiresAt(localDateTime)
                .build();
    }

}
