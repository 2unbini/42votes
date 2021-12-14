package com.example.votesspring.service;

import com.example.votesspring.domain.User;
import com.example.votesspring.dto.request.AnswerRequestDto;
import com.example.votesspring.dto.request.VoteRequestDto;
import com.example.votesspring.dto.response.QuestionResponseDto;
import com.example.votesspring.dto.response.VoteResponseDto;
import com.example.votesspring.exception.model.AnswerEmptyException;
import com.example.votesspring.exception.model.AnswerNotFoundException;
import com.example.votesspring.exception.model.DuplicateVote;
import com.example.votesspring.exception.model.QuestionNotFoundException;
import com.example.votesspring.mapper.UserMapper;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@SpringBootTest
class ServiceTest {

    @Autowired
    private QuestionService questionService;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private AnswerService answerService;

    @Test
    @DisplayName("1. Answer Service와 Question Service의 모든 메서드를 테스트합니다.")
    public void AllServiceTest()
            throws AnswerEmptyException, QuestionNotFoundException, DuplicateVote, AnswerNotFoundException {
        userMapper.save(User.builder().
                username("testUser").
                password("1234").
                email("testUser@NoSuch.com").
                build());
        User testUser = userMapper.findByName("testUser").orElseThrow();
        //VoteRequestDto json.answers 빈 배열인 경우.
        Assertions.assertThrows(AnswerEmptyException.class, () ->
                questionService.registerVote(testUser.getId(), VoteRequestDto.builder().
                        question("Answer가 없는 데이터입니다.").
                        expiresAt(LocalDateTime.now()).
                        answers(new ArrayList<>()).
                        build())
        );
        VoteRequestDto voteRequestDto = VoteRequestDto.builder().question("테스트 데이터입니다.").
                answers(List.of("예", "아니요")).
                expiresAt(LocalDateTime.now().plusDays(1L)).
                build();
        questionService.registerVote(testUser.getId(), voteRequestDto);
        List<QuestionResponseDto> questions = questionService.findQuestions().stream().
                sorted(Comparator.comparingLong(QuestionResponseDto::getId)).
                collect(Collectors.toList());

        Assertions.assertNotEquals(0, questionService.findMyQuestions(testUser.getId()).size());
        Assertions.assertNotEquals(0, questions.size());
        Assertions.assertThrows(QuestionNotFoundException.class,
                () -> questionService.findVoteByQuestionId(questions.size() + 1L));
        Assertions.assertNotNull(questionService.findVoteByQuestionId(questions.get(0).getId()));
        VoteResponseDto voteResponseDto = questionService.findVoteByQuestionId(questions.get(0).getId());
        answerService.updateAnswerCount(testUser.getId(), AnswerRequestDto.builder().
                questionId(voteResponseDto.getQuestion().getId()).
                answerId(voteResponseDto.getAnswers().get(0).getId()).
                build());
        Assertions.assertNotEquals(voteResponseDto.getAnswers().get(0).getCount(),
                questionService.findVoteByQuestionId(questions.get(0).getId()).getAnswers().get(0).getCount());
        Assertions.assertThrows(DuplicateVote.class, () -> answerService.updateAnswerCount(testUser.getId(),
                AnswerRequestDto.builder().
                        questionId(voteResponseDto.getQuestion().getId()).
                        answerId(voteResponseDto.getAnswers().get(0).getId()).
                        build()
                )
        );
    }


}