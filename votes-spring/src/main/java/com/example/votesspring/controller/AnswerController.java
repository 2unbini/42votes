package com.example.votesspring.controller;

import com.example.votesspring.dto.request.AnswerRequestDto;
import com.example.votesspring.exception.model.AnswerNotFoundException;
import com.example.votesspring.exception.model.DuplicateVote;
import com.example.votesspring.service.AnswerService;
import io.swagger.annotations.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Api
@RestController
@RequestMapping("/v1/answers")
public class AnswerController {

    private final AnswerService answerService;

    public AnswerController(AnswerService answerService) {
        this.answerService = answerService;
    }

    @PostMapping("/{userId}")
    @Operation(summary = "투표를 진행합니다.",
            description = "User의 정보를 통해서 선택한 question_id가 중복으로 진행되었는지 확인하고 answer의 count를 증가시킵니다.")
    public ResponseEntity<String> voteAnswer(@PathVariable Long userId,
                                             @RequestBody AnswerRequestDto answerRequestDto)
            throws DuplicateVote, AnswerNotFoundException {
        return ResponseEntity.ok(answerService.updateAnswerCount(userId, answerRequestDto));
    }
}
