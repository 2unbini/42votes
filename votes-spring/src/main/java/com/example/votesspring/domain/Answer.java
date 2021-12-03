package com.example.votesspring.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@Getter
@Setter
@Alias("Answer")
public class Answer {

    private Long id;
    private Long questionId;
    private String answer;
    private Long count;

    @Builder
    public Answer(Long id, Long questionId, String answer, Long count) {
        this.id = id;
        this.questionId = questionId;
        this.answer = answer;
        this.count = count;
    }
}
