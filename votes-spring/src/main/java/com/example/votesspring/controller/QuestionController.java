package com.example.votesspring.controller;

import com.example.votesspring.domain.Question;
import com.example.votesspring.domain.User;
import com.example.votesspring.dto.request.VoteRequestDto;
import com.example.votesspring.dto.response.QuestionResponseDto;
import com.example.votesspring.dto.response.VoteResponseDto;
import com.example.votesspring.exception.model.AnswerEmptyException;
import com.example.votesspring.exception.model.QuestionNotFoundException;
import com.example.votesspring.service.AnswerService;
import com.example.votesspring.service.QuestionService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/v1/questions/")
public class QuestionController {

    private final QuestionService questionService;
    private final AnswerService answerService;

    public QuestionController(QuestionService questionService, AnswerService answerService) {
        this.questionService = questionService;
        this.answerService = answerService;
    }

    @GetMapping("/{questionId}")
    @Operation(summary = "하나의 질문을 가져옵니다.",
                description = "Pathvariable의 questionId와 일치하는 question과 answer을 가져옵니다.")
    public ResponseEntity<VoteResponseDto> getQuestionById(@PathVariable Long questionId)
            throws AnswerEmptyException, QuestionNotFoundException {
        return ResponseEntity.ok(questionService.findVoteByQuestionId(questionId));
    }

    @DeleteMapping("/{questionId}")
    @Operation(summary = "질문과 관련된 모든 정보를 삭제합니다.",
            description = "Pathvariable의 questionId와 일치하는 question과 answer을 가져옵니다.")
    public ResponseEntity<String> deleteQuestionById(Principal principal, @PathVariable Long questionId)
            throws AnswerEmptyException, QuestionNotFoundException {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = (UsernamePasswordAuthenticationToken) principal;
        User user = (User) usernamePasswordAuthenticationToken.getPrincipal();
        Long userId = user.getId();
        Question question = questionService.findQuestion(questionId);
        if (!Objects.equals(question.getUserId(), userId)) {
            return ResponseEntity.status(401).body("질문의 작성자가 아닙니다.");
        }
        answerService.deleteAnswer(question);
        questionService.deleteQuestion(question);
        return ResponseEntity.ok("질문이 삭제되었습니다.");
    }

    @GetMapping("/all")
    @Operation(summary = "모든 질문을 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getAllQuestions() {
        return ResponseEntity.ok(questionService.findQuestions());
    }

    @GetMapping("/my")
    @Operation(summary = "유저의 질문을 가져옵니다.",
            description = "유저의 정보를 바탕으로 정보를 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getMyQuestions(Principal principal) {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = (UsernamePasswordAuthenticationToken) principal;
        User user = (User) usernamePasswordAuthenticationToken.getPrincipal();
        Long userId = user.getId();
        return ResponseEntity.ok(questionService.findMyQuestions(userId));
    }

    @PostMapping("/my")
    @Operation(summary = "유저의 질문을 등록합니다.",
            description = "유저의 정보를 바탕으로 Request body를 통해서 question과 answers를 등록합니다.")
    public ResponseEntity<VoteResponseDto> addQuestion(Principal principal, @RequestBody VoteRequestDto voteRequestDto)
            throws AnswerEmptyException {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = (UsernamePasswordAuthenticationToken) principal;
        User user = (User) usernamePasswordAuthenticationToken.getPrincipal();
        Long userId = user.getId();
        return ResponseEntity.ok(questionService.registerVote(userId, voteRequestDto));
    }
}
