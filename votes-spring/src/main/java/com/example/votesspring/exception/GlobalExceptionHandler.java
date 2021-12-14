package com.example.votesspring.exception;

import com.example.votesspring.exception.model.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(AnswerEmptyException.class)
    protected ResponseEntity<String> handleAnserEmptyException() {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("질문에는 답변이 반드시 존재해야합니다.");
    }

    @ExceptionHandler(AnswerNotFoundException.class)
    protected ResponseEntity<String> handleAnswerNotFoundException() {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("요청한 답변이 존재하지 않습니다.");
    }

    @ExceptionHandler(QuestionNotFoundException.class)
    protected ResponseEntity<String> handleQuestionNotFoundException() {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("요청한 질문이 존재하지 않습니다.");
    }

    @ExceptionHandler(DuplicateVote.class)
    protected ResponseEntity<String> handleDuplicateVote() {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("질문에 중복으로 답변할 수 없습니다.");
    }

    @ExceptionHandler(AnswerNotMatchQuesitonId.class)
    protected ResponseEntity<String> handleAnswerNotMatchQuestionId() {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("잘못된 투표 요청입니다.");
    }
}
