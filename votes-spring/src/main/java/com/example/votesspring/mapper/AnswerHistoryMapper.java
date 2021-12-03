package com.example.votesspring.mapper;

import com.example.votesspring.domain.AnswerHistory;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AnswerHistoryMapper {

    void save(AnswerHistory answerHistory);

    boolean existsByUserIdAnswerId(Long userId, Long answerId);

    void deleteByAllId(Long userId, Long answerId);
}
