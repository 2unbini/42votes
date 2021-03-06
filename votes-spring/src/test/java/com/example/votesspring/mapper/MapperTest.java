package com.example.votesspring.mapper;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.QuestionHistory;
import com.example.votesspring.domain.Question;
import com.example.votesspring.domain.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@SpringBootTest
class MapperTest {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private QuestionMapper questionMapper;

    @Autowired
    private AnswerMapper answerMapper;

    @Autowired
    private QuestionHistoryMapper questionHistoryMapper;

    @Test
    @DisplayName("1. 모든 매퍼 클래스들의 메서드 잘 작동되는지 확인합니다.")
    void AllMapperTest() {
        //User save and find test
        userMapper.save(User.builder()
                .username("userTester")
                .password("testPassword")
                .email("gpark@nosuch.com")
                .build()
        );
        Optional<User> user = userMapper.findByName("userTester");
        Assertions.assertTrue(user.isPresent());
        Question build = Question.builder()
                .userId(user.get().getId())
                .question("시험용 데이터입니다.")
                .expiresAt(LocalDateTime.now().plusDays(1))
                .build();

        Long save = questionMapper.save(build);
        List<Question> questionList = questionMapper.findByUserId(user.get().getId());
        Assertions.assertNotEquals(0, questionList.size());
        Optional<Question> question = questionMapper.findById(questionList.get(0).getId());
        Assertions.assertTrue(question.isPresent());

        // Answer save and find test
        answerMapper.save(Answer.builder()
                .answer("시험용 예")
                .questionId(question.get().getId())
                .build());
        answerMapper.save(Answer.builder()
                .answer("시험용 아니요.")
                .questionId(question.get().getId())
                .build());
        List<Answer> answerList = answerMapper.findAllByQuestionId(question.get().getId());
        Assertions.assertNotEquals(0, answerList.size());
        answerList.get(0).setCount(answerList.get(0).getCount() + 1L);
        answerMapper.updateCountById(answerList.get(0));
        answerList = answerMapper.findAllByQuestionId(question.get().getId());
        Assertions.assertNotEquals(0, answerList.get(0).getCount());

        // Answer History save and exist test
        Assertions.assertFalse(questionHistoryMapper.existsByUserIdQuestionId(user.get().getId(), questionList.get(0).getId()));
        questionHistoryMapper.save(QuestionHistory.builder()
                .userId(user.get().getId())
                .questionId(questionList.get(0)
                .getId())
                .build());
        Assertions.assertTrue(questionHistoryMapper.existsByUserIdQuestionId(user.get().getId(), questionList.get(0).getId()));

        // Delete Tester
        questionHistoryMapper.deleteByAllId(user.get().getId(), questionList.get(0).getId());
        answerList.forEach(answer -> answerMapper.deleteById(answer.getId()));
        questionMapper.deleteById(question.get().getId());
        userMapper.deleteByName(user.get().getUsername());
        Assertions.assertFalse(userMapper.findByName("userTester").isPresent());
        Assertions.assertFalse(questionMapper.findById(question.get().getId()).isPresent());
        Assertions.assertTrue(answerMapper.findAllByQuestionId(question.get().getId()).isEmpty());
    }
}