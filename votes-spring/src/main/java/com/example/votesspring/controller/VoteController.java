package com.example.votesspring.controller;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.AnswerHistory;
import com.example.votesspring.mapper.AnswerHistoryMapper;
import com.example.votesspring.mapper.AnswerMapper;
import com.example.votesspring.mapper.QuestionMapper;
import com.example.votesspring.mapper.UserMapper;
import io.swagger.annotations.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Api
@RestController
@RequestMapping("/v1")
public class VoteController {

    private final AnswerMapper answerMapper;
    private final AnswerHistoryMapper answerHistoryMapper;

    public VoteController(AnswerMapper answerMapper, AnswerHistoryMapper answerHistoryMapper) {
        this.answerMapper = answerMapper;
        this.answerHistoryMapper = answerHistoryMapper;
    }

    @PostMapping("/answers/{userId}")
    @Operation(summary = "투표를 진행합니다.",
            description = "User의 정보를 통해서 선택한 answer_id가 중복으로 진행되었는지 확인하고 answer의 count를 증가시킵니다.")
    public ResponseEntity<String> postAnswer(@PathVariable Long userId,
                                             @RequestBody Long answerId) {
        boolean isExist = answerHistoryMapper.existsByUserIdAnswerId(userId, answerId);
        if (isExist) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(userId + "가 " + answerId + "에 이미 투표했습니다.");
        } else {
            Answer answer = answerMapper.findById(answerId).orElseThrow();
            answerHistoryMapper.save(AnswerHistory.builder()
                    .userId(userId)
                    .answerId(answerId)
                    .build());
            answer.setCount(answer.getCount() + 1);
            answerMapper.updateCountById(answer);
            return ResponseEntity.ok(userId + "가 " + answerId + "에 투표했습니다.");
        }
    }
}
