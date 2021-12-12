-- Drop All Table if Table Exist
DROP TABLE IF EXISTS answer_history;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS user;
-- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- user Table Create SQL
CREATE TABLE user
(
    `user_id`     BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '유저 id',
    `username`    VARCHAR(200)    NOT NULL    COMMENT '유저 이름',
    `email`       VARCHAR(200)    NOT NULL    COMMENT '유저 이메일',
    `password`    VARCHAR(200)    NOT NULL    COMMENT '유저 비밀번호',
    `updated_at`  DATETIME        NOT NULL    DEFAULT NOW() COMMENT '업데이트된 시간',
    `deleted_at`  DATETIME        NULL        COMMENT '삭제된 시간',
    `created_at`  DATETIME        NOT NULL    DEFAULT NOW() COMMENT '생성된 시간',
    PRIMARY KEY (user_id)
);

ALTER TABLE user COMMENT '가입한 유저의 정보를 저장합니다.';


-- question Table Create SQL
CREATE TABLE question
(
    `question_id`  BIGINT          NOT NULL    AUTO_INCREMENT COMMENT 'question id',
    `user_id`      BIGINT          NOT NULL    COMMENT '질문을 만든 유저 id',
    `question`     VARCHAR(255)    NOT NULL    COMMENT '질문 내용',
    `expires_at`   DATETIME        NOT NULL    COMMENT '투표 기한',
    `created_at`   DATETIME        NOT NULL    DEFAULT NOW() COMMENT '생성된 시간',
    `deleted_at`   DATETIME        NULL        COMMENT '삭제된 시간',
    `is_expired`   BIT             NULL        COMMENT '투표 마감 여부',
    PRIMARY KEY (question_id)
);

ALTER TABLE question COMMENT '유저가 만든 투표(질문)이다.';

ALTER TABLE question
    ADD CONSTRAINT FK_question_user_id_user_user_id FOREIGN KEY (user_id)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- answer Table Create SQL
CREATE TABLE answer
(
    `answer_id`    BIGINT         NOT NULL    AUTO_INCREMENT COMMENT 'answer id',
    `question_id`  BIGINT         NOT NULL    COMMENT '답변과 연관된 질문의 id',
    `answer`       VARCHAR(45)    NOT NULL    COMMENT '답변 내용',
    `count`        BIGINT         NOT NULL    DEFAULT 0 COMMENT '답변의 응답 개수',
    PRIMARY KEY (answer_id)
);

ALTER TABLE answer COMMENT '유저가 만든 질문의 선택지이다.';

ALTER TABLE answer
    ADD CONSTRAINT FK_answer_question_id_question_question_id FOREIGN KEY (question_id)
        REFERENCES question (question_id) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- answer_history Table Create SQL
CREATE TABLE answer_history
(
    `answer_history_id`  BIGINT    NOT NULL    AUTO_INCREMENT COMMENT 'question history id',
    `user_id`            BIGINT    NOT NULL    COMMENT 'user id',
    `answer_id`          BIGINT    NOT NULL    COMMENT 'answer id',
    PRIMARY KEY (answer_history_id)
);

ALTER TABLE answer_history COMMENT '같은 유저가 같은 질문에 두번 답하는 것을 방지합니다.';

ALTER TABLE answer_history
    ADD CONSTRAINT FK_answer_history_user_id_user_user_id FOREIGN KEY (user_id)
        REFERENCES user (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE answer_history
    ADD CONSTRAINT FK_answer_history_answer_id_answer_answer_id FOREIGN KEY (answer_id)
        REFERENCES answer (answer_id) ON DELETE RESTRICT ON UPDATE RESTRICT;