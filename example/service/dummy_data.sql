DROP TABLE if exists member;
CREATE TABLE member (
	idx int NOT NULL AUTO_INCREMENT,
	id varchar(20) NOT NULL,
	password varchar(20) NOT NULL,
	name varchar(20) NOT NULL,
	email varchar(30) NOT NULL,
	PRIMARY KEY(idx)
);

DROP TABLE if exists board;
CREATE TABLE board (
	idx int NOT NULL AUTO_INCREMENT,
    title varchar(50) NOT NULL,
    contents varchar(500) NOT NULL,
    date_time datetime DEFAULT now(),
    id varchar(20) NOT NULL,
    name varchar(20) NOT NULL,
    PRIMARY KEY(idx)
);

INSERT INTO member(idx, id, password, name, email) VALUES (1, 'jin', 'jin123', '김명진', 'jin@google.com');
INSERT INTO member(idx, id, password, name, email) VALUES (2, 'sun', 'sun123', '정밝은태양', 'sun@naver.com');
INSERT INTO member(idx, id, password, name, email) VALUES (3, 'sky', 'sky123', '정하늘', 'sky@google.com');
INSERT INTO member(idx, id, password, name, email) VALUES (4, 'jae', 'jae123', '우희제', 'jae@naver.com');
INSERT INTO member(idx, id, password, name, email) VALUES (5, 'hyun', 'hyun123', '남정현', 'hyun@naver.com');
INSERT INTO member(idx, id, password, name, email) VALUES (6, '익명', '익명123', '익명', '익명@naver.com');
INSERT INTO member(idx, id, password, name, email) VALUES (8, '익명', '익명123', '익명', '익명@google.com');
INSERT INTO member(idx, id, password, name, email) VALUES (9, '익명', '익명3', '익명', '익명@naver.com');

INSERT INTO board(idx, title, contents, id, name) VALUES (1, '취업 질문이요', '취업 질문이 있습니다. 가나다라마바사', 'jin', '김명진');
INSERT INTO board(idx, title, contents, id, name) VALUES (2, '채용 시점이 궁금해요', '채용 관련 하나둘셋넷다섯', 'sun', '정밝은태양');
INSERT INTO board(idx, title, contents, id, name) VALUES (3, 'Test 3', 'Test Contents 123123', 'jin', '김명진');
INSERT INTO board(idx, title, contents, id, name) VALUES (4, '가나다abc123', '테스트를위한테스트를위한', 'hyun', '남정현');
INSERT INTO board(idx, title, contents, id, name) VALUES (5, '123123하나abcabc Test4', '4번----4번', 'jin', '김명진');
INSERT INTO board(idx, title, contents, id, name) VALUES (7, 'Test Data 7', 'No.7 Data Test', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (8, '8번에서 피어나는', 'Test Contents 123123', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (9, '9만송이 장미', '테스트를위한테스트를위한', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (10, '챔피언스리그 결승 정보', '손흥민 선발 !', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (11, '정찬성 vs 이소룡', '누가 이기냐?', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (12, '3대 550 ㅁㅌㅊ?', 'ㅍㅌㅊ?', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (13, '---===!@#$ Test Data', '!@#$%^&*()_+', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (14, '법사 육성 질문', 'DEX 찍었는데 망함?', '익명', '익명');
INSERT INTO board(idx, title, contents, id, name) VALUES (15, '사냥터 추천받음', '렙은 27임', '익명', '익명');