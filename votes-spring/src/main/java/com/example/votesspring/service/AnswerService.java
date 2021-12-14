package com.example.votesspring.service;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.QuestionHistory;
import com.example.votesspring.dto.request.AnswerRequestDto;
import com.example.votesspring.exception.model.AnswerNotFoundException;
import com.example.votesspring.exception.model.AnswerNotMatchQuesitonId;
import com.example.votesspring.exception.model.DuplicateVote;
import com.example.votesspring.exception.model.QuestionNotFoundException;
import com.example.votesspring.mapper.AnswerMapper;
import com.example.votesspring.mapper.QuestionHistoryMapper;
import com.example.votesspring.mapper.QuestionMapper;
import org.springframework.stereotype.Service;

@Service
public class AnswerService {

    private final AnswerMapper answerMapper;
    private final QuestionMapper questionMapper;
    private final QuestionHistoryMapper questionHistoryMapper;

    public AnswerService(AnswerMapper answerMapper, QuestionMapper questionMapper, QuestionHistoryMapper questionHistoryMapper) {
        this.answerMapper = answerMapper;
        this.questionMapper = questionMapper;
        this.questionHistoryMapper = questionHistoryMapper;
    }

    public String updateAnswerCount(Long userId, AnswerRequestDto answerRequestDto) throws DuplicateVote, AnswerNotFoundException {
        questionMapper.findById(answerRequestDto.getQuestionId()).orElseThrow(QuestionNotFoundException::new);
        boolean isExist = questionHistoryMapper.existsByUserIdQuestionId(userId, answerRequestDto.getQuestionId());
        if (isExist) {
            throw new DuplicateVote();
        } else {
            Answer answer = answerMapper.findById(answerRequestDto.getAnswerId()).orElseThrow(AnswerNotFoundException::new);
            if (!answerRequestDto.getQuestionId().equals(answer.getQuestionId()))
                throw new AnswerNotMatchQuesitonId();
            questionHistoryMapper.save(QuestionHistory.builder()
                    .userId(userId)
                    .questionId(answerRequestDto.getQuestionId())
                    .build());
            answer.setCount(answer.getCount() + 1);
            answerMapper.updateCountById(answer);
            return userId + "가 question id : " + answerRequestDto.getQuestionId() + "에 투표했습니다.";
        }
    }
}
