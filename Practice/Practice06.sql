CREATE TABLE author(
    author_id   NUMBER(10),
    author_name VARCHAR2(100),
    author_desc VARCHAR2(100),
    PRIMARY KEY (author_id)
);

CREATE TABLE book (
    book_id NUMBER(10),
    title   VARCHAR2(100) NOT NULL,
    pubs    VARCHAR2(100),
    pub_date DATE,
    author_id NUMBER(10),
    PRIMARY KEY (book_id),
    --참조키를 author_id가 갖고 있기 때문에 author table을 먼저 만들어야 한다
    CONSTRAINT book_fk FOREIGN KEY (author_id) 
    REFERENCES author(author_id)
);

CREATE SEQUENCE seq_author_id
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE seq_book_id
INCREMENT BY 1
START WITH 1;

--묵시적 방식, 해당 테이블은 작가 번호, 작가 이름, 작가설명 순으로 작성되었기 때문에
--해당 순서대로 입력한다면 별도의 지정 없이 레코드에 저장된다
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '이문열', '경북 영양');
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '박경리', '경상남도 통영');
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '유시민', '17대 국회의원');
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '기안84', '기안동에서 산 84년생');
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '강풀', '온라인 만화가 1세대');
INSERT INTO author
VALUES (seq_author_id.NEXTVAL, '김영하', '알쓸신잡');

SELECT  --확인
    *
FROM
    author;

INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '우리들의 일그러진 영웅', '다림', '19980222', 1);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '삼국지', '민음사', '20020301', 1);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '토지', '마로니에북스', '20120815', 2);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '유시민의 글쓰기 특강', '생각의길', '20150401', 3);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '패션왕', '중앙북스(books)', '20120222', 4);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '순정만화', '재미주의', '20110803', 5);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '오직두사람', '문학동네', '20170504', 6);
INSERT INTO book
VALUES (seq_book_id.NEXTVAL, '26년', '재미주의', '20120204', 5);

--다음과 같이 출력되도록 테이블을 생성하고 데이터를 입력하세요
SELECT
    *
FROM
    book bk,
    author au
WHERE bk.author_id = au.author_id;

--강풀의 author_desc 정보를 '서울 특별시'로 변경해보세요
UPDATE author
SET author_desc = '서울 특별시'
WHERE author_name = '강풀';

SELECT  --확인
    *
FROM
    author;
    
--author 테이블에서 기안84 데이터를 삭제해 보세요  삭제 안됨
DELETE FROM author
WHERE author_name = '기안84'; 
--해당 레코드의 일부(author_id)를 FK(book_fk)로 사용하고 있으므로, 삭제할 수 없다