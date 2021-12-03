package com.example.votesspring.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@Getter
@Setter
@Alias("AnswerHistory")
public class AnswerHistory {

    private Long id;
    private Long userId;
    private Long answerId;

    @Builder
    public AnswerHistory(Long id, Long userId, Long answerId) {
        this.id = id;
        this.userId = userId;
        this.answerId = answerId;
    }
}
