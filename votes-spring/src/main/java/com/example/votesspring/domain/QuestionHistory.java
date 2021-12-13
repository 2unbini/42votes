package com.example.votesspring.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@Getter
@Setter
@Alias("QuestionHistory")
public class QuestionHistory {

    private Long id;
    private Long userId;
    private Long questionId;

    @Builder
    public QuestionHistory(Long id, Long userId, Long questionId) {
        this.id = id;
        this.userId = userId;
        this.questionId = questionId;
    }
}
