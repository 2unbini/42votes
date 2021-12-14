package com.example.votesspring.service;

import com.example.votesspring.domain.Answer;
import com.example.votesspring.domain.Question;
import com.example.votesspring.dto.request.VoteRequestDto;
import com.example.votesspring.dto.response.QuestionResponseDto;
import com.example.votesspring.dto.response.VoteResponseDto;
import com.example.votesspring.exception.model.AnswerEmptyException;
import com.example.votesspring.exception.model.QuestionNotFoundException;
import com.example.votesspring.mapper.AnswerMapper;
import com.example.votesspring.mapper.QuestionMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class QuestionService {

    private final QuestionMapper questionMapper;
    private final AnswerMapper answerMapper;

    public QuestionService(QuestionMapper questionMapper, AnswerMapper answerMapper) {
        this.questionMapper = questionMapper;
        this.answerMapper = answerMapper;
    }

    public List<QuestionResponseDto> findQuestions() {
        return questionMapper.findAll().
                stream().
                map(Question::questionResponseDtoConverter).
                collect(Collectors.toList()
                );
    }

    public List<QuestionResponseDto> findMyQuestions(Long userId) {
        return questionMapper.findByUserId(userId).
                stream().
                map(Question::questionResponseDtoConverter).
                collect(Collectors.toList());
    }

    public VoteResponseDto findVoteByQuestionId(Long questionId) throws QuestionNotFoundException, AnswerEmptyException {
        Question question = questionMapper.findById(questionId).orElseThrow(QuestionNotFoundException::new);
        List<Answer> answers = answerMapper.findAllByQuestionId(questionId);
        if (answers.isEmpty())
            throw new AnswerEmptyException();
        return VoteResponseDto.builder().
                question(question.questionResponseDtoConverter()).
                answers(answers.
                        stream().
                        map(Answer::answerResponseDtoConverter).
                        collect(Collectors.toList())
                ).
                build();
    }

    @Transactional
    public VoteResponseDto registerVote(Long userId, VoteRequestDto voteRequestDto) throws AnswerEmptyException {
        Question question = Question.builder().
                userId(userId).
                question(voteRequestDto.getQuestion()).
                expiresAt(voteRequestDto.getExpiresAt()).
                build();
        questionMapper.save(question);
        List<Answer> answerList = voteRequestDto.getAnswers().
                stream().
                map(s -> {
                    Answer answer = Answer.builder().questionId(question.getId()).answer(s).build();
                    answerMapper.save(answer);
                    return answer;
                }).
                collect(Collectors.toList());
        if (answerList.isEmpty())
            throw new AnswerEmptyException();
        return VoteResponseDto.builder().
                question(question.questionResponseDtoConverter()).
                answers(answerList.
                        stream().
                        map(Answer::answerResponseDtoConverter).
                        collect(Collectors.toList())).
                build();
    }
}
