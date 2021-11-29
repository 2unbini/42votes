-- Drop All Table if Table Exist
DROP TABLE IF EXISTS ANSWER_HISTORY;
DROP TABLE IF EXISTS ANSWER;
DROP TABLE IF EXISTS QUESTION;
DROP TABLE IF EXISTS USER;

-- USER Table Create SQL
CREATE TABLE USER
(
    `id`          BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '유저 id',
    `username`    VARCHAR(200)    NOT NULL    COMMENT '유저 이름',
    `password`    VARCHAR(200)    NOT NULL    COMMENT '암호화된 유저 비밀번호',
    `email`       VARCHAR(200)    NOT NULL    COMMENT '유저 이메일',
    `created_at`  DATETIME        NOT NULL    DEFAULT NOW() COMMENT '생성된 시간',
    `updated_at`  DATETIME        NOT NULL    DEFAULT NOW() COMMENT '업데이트된 시간',
    `deleted_at`  DATETIME        NULL        DEFAULT NULL COMMENT '삭제된 시간',
    PRIMARY KEY (id)
);

ALTER TABLE USER COMMENT 'oauth2를 이용해서 가입한 유저의 정보를 저장합니다.';

-- QUESTION Table Create SQL
CREATE TABLE QUESTION
(
    `id`          BIGINT          NOT NULL    AUTO_INCREMENT COMMENT 'question id',
    `user_id`     BIGINT          NOT NULL    COMMENT '질문을 만든 유저 id',
    `question`    VARCHAR(255)    NOT NULL    COMMENT '질문 내용',
    `expires_at`  DATETIME        NOT NULL    COMMENT '투표 기한',
    `created_at`  DATETIME        NOT NULL    DEFAULT NOW() COMMENT '생성된 시간',
    `deleted_at`  DATETIME        NULL        DEFAULT NULL COMMENT '삭제된 시간',
    `is_expired`  TINYINT         NULL        COMMENT '투표 마감 여부',
    PRIMARY KEY (id)
);

ALTER TABLE QUESTION COMMENT '유저가 만든 투표(질문)이다.';

ALTER TABLE QUESTION
    ADD CONSTRAINT FK_QUESTION_user_id_USER_id FOREIGN KEY (user_id)
        REFERENCES USER (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ANSWER Table Create SQL
CREATE TABLE ANSWER
(
    `id`           BIGINT         NOT NULL    AUTO_INCREMENT COMMENT 'answer id',
    `question_id`  BIGINT         NOT NULL    COMMENT '답변과 연관된 질문의 id',
    `answer`       VARCHAR(45)    NOT NULL    COMMENT '답변 내용',
    `count`        BIGINT         NOT NULL    DEFAULT 0 COMMENT '답변의 응답 개수',
    PRIMARY KEY (id)
);

ALTER TABLE ANSWER COMMENT '유저가 만든 투표의 질문이다.';

ALTER TABLE ANSWER
    ADD CONSTRAINT FK_ANSWER_question_id_QUESTION_id FOREIGN KEY (question_id)
        REFERENCES QUESTION (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ANSWER_HISTORY Table Create SQL
CREATE TABLE ANSWER_HISTORY
(
    `id`         BIGINT    NOT NULL    AUTO_INCREMENT COMMENT 'answer history id',
    `user_id`    BIGINT    NOT NULL    COMMENT 'user id',
    `answer_id`  BIGINT    NOT NULL    COMMENT 'answer id',
    PRIMARY KEY (id)
);

ALTER TABLE ANSWER_HISTORY COMMENT '같은 유저가 같은 답변을 하는 것을 방지합니다.';

ALTER TABLE ANSWER_HISTORY
    ADD CONSTRAINT FK_ANSWER_HISTORY_user_id_USER_id FOREIGN KEY (user_id)
        REFERENCES USER (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE ANSWER_HISTORY
    ADD CONSTRAINT FK_ANSWER_HISTORY_answer_id_ANSWER_id FOREIGN KEY (answer_id)
        REFERENCES ANSWER (id) ON DELETE RESTRICT ON UPDATE RESTRICT;


