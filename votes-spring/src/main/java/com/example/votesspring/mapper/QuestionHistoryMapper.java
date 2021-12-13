package com.example.votesspring.mapper;

import com.example.votesspring.domain.QuestionHistory;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface QuestionHistoryMapper {

    void save(QuestionHistory questionHistory);

    boolean existsByUserIdQuestionId(Long userId, Long questionId);

    void deleteByAllId(Long userId, Long questionId);
}
