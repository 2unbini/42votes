package com.example.votesspring.controller;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.QuestionHistory;
import com.example.votesspring.dto.request.AnswerRequestDto;
import com.example.votesspring.mapper.QuestionHistoryMapper;
import com.example.votesspring.mapper.AnswerMapper;
import io.swagger.annotations.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Api
@RestController
@RequestMapping("/v1")
public class VoteController {

    private final AnswerMapper answerMapper;
    private final QuestionHistoryMapper questionHistoryMapper;

    public VoteController(AnswerMapper answerMapper, QuestionHistoryMapper questionHistoryMapper) {
        this.answerMapper = answerMapper;
        this.questionHistoryMapper = questionHistoryMapper;
    }

    @PostMapping("/answers/{userId}")
    @Operation(summary = "투표를 진행합니다.",
            description = "User의 정보를 통해서 선택한 question_id가 중복으로 진행되었는지 확인하고 answer의 count를 증가시킵니다.")
    public ResponseEntity<String> postAnswer(@PathVariable Long userId,
                                             @RequestBody AnswerRequestDto answerRequestDto) {
        boolean isExist = questionHistoryMapper.existsByUserIdQuestionId(userId, answerRequestDto.getQuestionId());
        if (isExist) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(userId + "가 " + answerRequestDto.getQuestionId() + "에 이미 투표했습니다.");
        } else {
            Answer answer = answerMapper.findById(answerRequestDto.getAnswerId()).orElseThrow();
            questionHistoryMapper.save(QuestionHistory.builder()
                    .userId(userId)
                    .questionId(answerRequestDto.getQuestionId())
                    .build());
            answer.setCount(answer.getCount() + 1);
            answerMapper.updateCountById(answer);
            return ResponseEntity.ok(userId + "가 " + answerRequestDto.getQuestionId() + "에 투표했습니다.");
        }
    }
}
