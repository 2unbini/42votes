package com.example.votesspring.mapper;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.Question;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface AnswerMapper {
    void save(Answer answer);

    List<Answer> findAllByQuestionId(Question question);

    void updateCountById(Answer answer);

    void deleteById(Long id);

    void deleteByQuestinoId(Long questionId);
}
