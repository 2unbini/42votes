package com.example.votesspring.mapper;

import com.example.votesspring.domain.Question;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface QuestionMapper {
    Long save(Question question);

    List<Question> findAll();

    Optional<Question> findById(Long id);

    List<Question> findByUserId(Long userId);

    void deleteById(Long id);
}
