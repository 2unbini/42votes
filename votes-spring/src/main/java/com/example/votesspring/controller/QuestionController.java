package com.example.votesspring.controller;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.Question;
import com.example.votesspring.dto.request.VoteRequestDto;
import com.example.votesspring.dto.response.QuestionResponseDto;
import com.example.votesspring.dto.response.VoteResponseDto;
import com.example.votesspring.mapper.AnswerMapper;
import com.example.votesspring.mapper.QuestionMapper;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/v1/questions/")
public class QuestionController {

    private final AnswerMapper answerMapper;
    private final QuestionMapper questionMapper;

    public QuestionController(AnswerMapper answerMapper, QuestionMapper questionMapper) {
        this.answerMapper = answerMapper;
        this.questionMapper = questionMapper;
    }

    @GetMapping("/{questionId}")
    @Operation(summary = "하나의 질문을 가져옵니다.",
                description = "Pathvariable의 questionId와 일치하는 question과 answer을 가져옵니다.")
    public ResponseEntity<VoteResponseDto> getQuestionById(@PathVariable Long questionId) {
        return ResponseEntity.ok(VoteResponseDto.builder()
                .question(questionMapper.findById(questionId)
                        .orElseThrow().questionResponseDtoConverter()
                )
                .answers(answerMapper.findAllByQuestionId(questionId)
                        .stream()
                        .map(Answer::answerResponseDtoConverter)
                        .collect(Collectors.toList())
                )
                .build()
        );
    }

    @GetMapping("/all")
    @Operation(summary = "모든 질문을 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getAllQuestions() {
        return ResponseEntity.ok(questionMapper.findAll()
                .stream()
                .map(Question::questionResponseDtoConverter)
                .collect(Collectors.toList())
        );
    }

    @GetMapping("/my/{userId}")
    @Operation(summary = "유저의 질문을 가져옵니다.",
            description = "유저의 정보를 바탕으로 정보를 가져옵니다.")
    public ResponseEntity<List<QuestionResponseDto>> getMyQuestions(@PathVariable Long userId) {
        return ResponseEntity.ok(questionMapper.findByUserId(userId)
                .stream()
                .map(Question::questionResponseDtoConverter)
                .collect(Collectors.toList())
        );
    }

    @PostMapping("/my/{userId}")
    @Operation(summary = "유저의 질문을 등록합니다.",
            description = "유저의 정보를 바탕으로 Request body를 통해서 question과 answers를 등록합니다.")
    public ResponseEntity<VoteRequestDto> addQuestion(@PathVariable Long userId,
                                                      @RequestBody VoteRequestDto voteRequestDto) {
        Question build = Question.builder()
                .userId(userId)
                .question(voteRequestDto.getQuestion())
                .expiresAt(voteRequestDto.getExpiresAt())
                .build();
        questionMapper.save(build);
        voteRequestDto
                .getAnswers().forEach(answer -> answerMapper.save(Answer.builder()
                        .questionId(build.getId())
                        .answer(answer)
                        .build()));
        Question question = questionMapper.findById(build.getId()).orElseThrow();
        return ResponseEntity.ok(VoteRequestDto.builder()
                .question(question.getQuestion())
                .answers(answerMapper.findAllByQuestionId(build.getId())
                        .stream()
                        .map(Answer::getAnswer)
                        .collect(Collectors.toList())
                )
                .expiresAt(question.getExpiresAt())
                .build()
        );
    }
}
