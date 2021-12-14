package com.example.votesspring.controller;

import com.example.votesspring.dto.request.VoteRequestDto;
import com.example.votesspring.dto.response.QuestionResponseDto;
import com.example.votesspring.dto.response.VoteResponseDto;
import com.example.votesspring.exception.model.AnswerEmptyException;
import com.example.votesspring.exception.model.QuestionNotFoundException;
import com.example.votesspring.service.QuestionService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/v1/questions/")
public class QuestionController {

    private final QuestionService questionService;

    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }

    @GetMapping("/{questionId}")
    @Operation(summary = "하나의 질문을 가져옵니다.",
                description = "Pathvariable의 questionId와 일치하는 question과 answer을 가져옵니다.")
    public ResponseEntity<VoteResponseDto> getQuestionById(@PathVariable Long questionId)
            throws AnswerEmptyException, QuestionNotFoundException {
        return ResponseEntity.ok(questionService.findVoteByQuestionId(questionId));
    }

    @GetMapping("/all")
    @Operation(summary = "모든 질문을 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getAllQuestions() {
        return ResponseEntity.ok(questionService.findQuestions());
    }

    @GetMapping("/my/{userId}")
    @Operation(summary = "유저의 질문을 가져옵니다.",
            description = "유저의 정보를 바탕으로 정보를 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getMyQuestions(@PathVariable Long userId) {
        return ResponseEntity.ok(questionService.findMyQuestions(userId));
    }

    @PostMapping("/my/{userId}")
    @Operation(summary = "유저의 질문을 등록합니다.",
            description = "유저의 정보를 바탕으로 Request body를 통해서 question과 answers를 등록합니다.")
    public ResponseEntity<VoteResponseDto> addQuestion(@PathVariable Long userId,
                                                      @RequestBody VoteRequestDto voteRequestDto)
            throws AnswerEmptyException {
        return ResponseEntity.ok(questionService.registerVote(userId, voteRequestDto));
    }
}
