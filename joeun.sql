-- 70.주어진 “community.dmp” 덤프파일을 ‘joeun’ 계정에 import 하는 명령어를 작성하시오.
-- joeun 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER joeun IDENTIFIED BY 123456;
ALTER USER joeun QUOTA UNLIMITED ON users;
GRANT DBA TO joeun;

-- 파일 덤프하기 import 하기    (CMD 에서 실행)
-- imp userid=관리자계정/비밀번호 file=덤프파일경로 fromuser=덤프소유계정 tosuer=임포트할계정
imp userid=system/123456 file=D:\ORACLE\community.dmp fromuser=joeun touser=joeun

DROP USER joeun cascade;

-- 71. 사용 중인 계정(‘joeun’)이 소유하고 있는 데이터를 “community2.dmp” 덤프파일로 export 하는 명령어를 작성하시오.
-- exp userid=관리자계정/비밀번호 file=덤프파일경로 log=로그파일경로
-- 생성 계정은 import 할때 fromuser 로 쓰인다.
exp userid=system/123456 file=D:\ORACLE\community2.dmp log=D:\ORACLE\community2.log

-- 72.
-- 1) MS_BOARD 테이블의 WRITER 속성의 타입을 NUBER 로 변경하시오.
ALTER TABLE MS_BOARD MODIFY WRITER NUMBER;

-- 2) MS_BOARD 테이블의 WRITER 속성에 대하여,
-- MS_USER 의 USER_NO 를 참조하도록 외래키로 지정하시오.

-- 외래키 지정
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명
-- FOREIGN KEY (외래키컬럼) REFERENCES 참조테이블(기본키);
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO);

-- 2) 외래키 : MS_FILE (BOARD_NO) -----> MS_BOARD (BOARD_NO)
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

-- 3) 외래키 : MS_REPLY (BOARD_NO) -----> MS_BOARD (BOARD_NO)
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

-- 제약조건 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- 73. MS_USER 테이블에 속성을 추가하시오.
ALTER TABLE MS_USER ADD CTZ_NO CHAR(14) NULL UNIQUE;
-- ALTER TABLE MS_USER MODIFY CTZ_NO NULL;
ALTER TABLE MS_USER ADD GENDER CHAR(6) NULL;
-- ALTER TABLE MS_USER MODIFY GENDER NULL;

COMMENT ON COLUMN MS_USER.CTZ_NO IS '주민번호'; 
COMMENT ON COLUMN MS_USER.GENDER IS '성별'; 

DESC MS_USER;

-- 74. MS_USER의 GENDER 속성이 ('여', '남', '기타;) 값만 갖도록 제약조건을 추가하시오.
-- CHECK 제약조건 추가
ALTER TABLE MS_USER ADD CONSTRAINT MS_USER_GENDER_CHECK
CHECK (gender IN ('여', '남', '기타'));

-- 75. MS_FILE 테이블에 확장자(EXT) 속성을 추가하시오.
ALTER TABLE MS_FILE ADD EXT VARCHAR(10) NULL;
COMMENT ON COLUMN MS_FILE.EXT IS '확장자';

DESC MS_FILE;

-- 76. 테이블 MS_FILE 의 FIE_NAME 속성에서 확장자를 추출하여 EXT 속성에 UPDATE 하는 SQL 문을 작성하시오.
/*
    조건
    - FILE_NAME 에서 추출한 확장자가 jpeg, jpg, gif, png 가 아니면 삭제한다.
    - FILE_NAME 에서 추출한 확장자를 EXT 속성에 UPDATE 한다.
*/
MERGE INTO MS_FILE T        -- 데상 테이블 지정   T는 테이블의 이름을 변수명 처럼 사용하는것이다.
-- 사용할 데이터의 자원을 지정
USING ( SELECT FILE_NO, FILE_NAME FROM MS_FILE ) F   -- F도 MS_FILE 을 대신할 변수명처럼 사용한다.
-- ON (update 될 조건)
ON (T,FILE_NO = F,FILE_NO)              -- T,F 위의 설명한 내용이다.둘다 MS_FILE을 나타낸다.
-- 매치조건에 만족한 경우
WHEN MATCHED THEN
    -- SUBSTR(문자열, 시작번호)
    UPDATE SET T.EXT = SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1)
    DELETE WHERE SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1)
            NOT IN ('jpeg', 'jpg', 'gif', 'png');
-- WHEN NOT MATHED THEN
-- (매치가 안 될 때)

SELECT * FROM MS_FILE;

-- 파일추가
-- 참조 무결성 위배
-- 다른 테이블을 참조할  때 다른 테이블에 값이 없을 경우 참조하지 못하여 참조 무결성 위배에 해당한다.
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATE, REG_DATE, UPD_DATE, EXT)
VALUES(1, 1, '강아지.png', '123', sysdate, sysdate, '---');

INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATE, REG_DATE, UPD_DATE, EXT)
VALUES(2, 1, 'Main.png', '123', sysdate, sysdate, '---');

-- 게시글 추가
INSERT INTO MS_BOARD ( BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT,
                       DEL_YN, DEL_DATE, REG_DATEM, UPD_DATE)
VALUES ( 1, '제목', '내용', 1, 0, 0, 'N', NULL, sysdate, sysdate);

-- 유저 추가
INSERT INTO MS_USER(USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH,
                    TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER)
VALUES (1, 'JOEUN', '123456', '김조은', TO_DATE('2020/01/01', 'YYYY/MM/DD'),
        '010-1234-1234', '부평', sysdate, sysdate, '200101-334444', '남');

SELECT * FROM MU_USER;
SELECT * FROM MU_BOARD;
SELECT * FROM MU_FILE;

-- 77. 테이블 MS_FILE 의 EXT 속성이 (‘jpg’, ‘jpeg’, ‘gif’, ‘png’) 값을 갖도록 하는 제약조건을 추가하는 SQL문을 작성하시오.
-- 76번에 MERGE 안에 NOT IN ('jpeg', 'jpg', 'gif', 'png'); 가있지만 여기에 추가하는 이유는 ALTER 조건문은 패시브로 작용하는?거고 MERGE의 NOT IN ('jpeg', 'jpg', 'gif', 'png');는 지속적으로 사용해야만 한다.구글링 해봐 몰라.
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_EXT_CHECK
CHECK (EXT IN ('jpg', 'jpeg', 'gif', 'png'));
-- webp 확장자 (용량이 작고, 움짤도 되고, 투명도 가능하다.)
INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATE, REG_DATE, UPD_DATE, EXT)
VALUES(3, 1, 'Main.java', '123', sysdate, sysdate, 'java');

INSERT INTO MS_FILE (FILE_NO, BOARD_NO, FILE_NAME, FILE_DATE, REG_DATE, UPD_DATE, EXT)
VALUES(4, 1, '고양이.jpg', '123', sysdate, sysdate, 'jpg');

-- 78. MS_USER, MS_BOARD, MS_FILE, MS_REPLY 테이블의 모든 데이터를 삭제하는 명령어를 작성하시오.
-- TRUNCATE 는 자르는 명령어이다.순서는 REPLY -> FILE -> BOARD -> USER 순으로 해야한다.
TRUNCATE TABLE MS_USER;
TRUNCATE TABLE MS_BOARD;
TRUNCATE TABLE MS_FILE;
TRUNCATE TABLE MS_REPLY;

DELETE FROM TABLE MS_USER;
DELETE FROM TABLE MS_BOARD;
DELETE FROM TABLE MS_FILE;
DELETE FROM TABLE MS_REPLY;

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

/*
    DELETE vs TRUNCATE
    * DELETE    - 데이터 조작어 (DML)
    - 한 형 단위로 데이터를 삭제한다.
    - COMMIT, ROLLBACK 를 이용하여 변경사항을 적용하거나 되돌릴 수 있음
    
    * TRUNCATE  - 데이터 정의어 (DDL)
    - 모든 형을 삭제한다.
    -삭제된 데이터를 되돌릴 수 없다.
*/

-- 79. 테이블의 속성을 삭제하시오.
-- * MS_BOARD 테이블의 WRITER 속성을 삭제하시오.
-- * MS_FILE 테이블의 BOARD_NO 속성을 삭제하시오.
-- * MS_REPLY 테이블의 BOARD_NO 속성을 삭제하시오.
ALTER TABLE MS_BOARD DROP COLUMN WRITER;
ALTER TABLE MS_FILE DROP COLUMN BOARD_NO;
ALTER TABLE MS_REPLY DROP COLUMN BOARD_NO;

-- 80. 각 테이블에 속성들을 추가한 뒤, 외래키로 지정하시오.
-- 해당 외래키에 대하여 참조 테이블의 데이터 삭제 시,
-- 연결된 속성의 값도 삭제하는 옵션도 지정하시오.

-- 1) MS_BOARD 에 WRITER 속성 추가
ALTER TABLE MS_BOARD ADD WRITER NUMER NOT NULL;

-- WRITER 속성을 외래키로 지정
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_BOARD
ADD CONSTRAINT MS_BOARD_WRITER_FX
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO)
ON DELETE CASCADE;
-- ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
-- * RESTRICT   : 자식 테이블의 데이터가 존재하면, 삭제 안함
-- * CASCADE    : 자식 테이블의 데이터도 함께 삭제
-- * SET NULL   : 자식 테이블의 데이터를 NULL 로 변경

-- 2) MS_FILE 에 BOARD_NO 속성 추가
ALTER TABLE MS_FILE
-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ADD CONSTRAINT MS_FILE_BOARD_NO_FX
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

-- 3) MS_REPLY 에 BOARD_NO 속성 추가
ALTER TABLE MS_REPLY
-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정 
ADD CONSTRAINT MS_REPLY_BOARD_NO_FX
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

-- 회원탈퇴 (회원번호 : 1)
DELETE FROM MS_USER WHERE USER_NO -1;

-- ON DELETE CASCADE 옵션으로 외래키 지정 시, MS_USER 데이터를 삭제하면, MS_BOARD 의 참조된 데이터도 연쇄적으로 삭제된다.

-- MS_USER 데이터를 삭제되면, MS_FILE, MS_REPLY 에 참조된 데이터도 연쇄적으로 삭제된다.

-- 외래키 제약조건 정리
ALTER TABLE 데이터명
ADD CONSTRAINT 제약조건명 FOREIGN KEY (외래키 속성)
REFERENCES 참조테이블(참조 속성);

-- 옵션
-- ON UPDATE                -- 참조 테이블 수정 시,
-- * CASCADE                : 자식 데이터 수정
-- * SET NULL               : 자식 데이터는 NULL
-- * SET DEFAULT            : 자식 데이터는 기본값
-- * RESTRICT               : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION              : 아무런 행위도 취하지 않는다.(기본값)

-- ON DELETE                
-- * CASCADE                : 자식 데이터 삭제
-- * SET NULL               : 자식 데이터는 NULL
-- * SET DEFAULT            : 자식 데이터는 기본값
-- * RESTRICT               : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION              : 아무런 행위도 취하지 않는다.(기본값)

-- joeun 덤프파일 임포트
DROP USER joeun CASCADE;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER joeun IDENTIFIED BY 123456;
ALTER USER joeun QUOTA UNLIMITED ON users;
GRANT DBA TO joeun;

imp userid=system/123456 file=D:\ORACLE\joeun.dmp fromuser=joeun touser=joeun

/*
    - 서브쿼리 (Sub Query;  하위 질의)
    : SQL 문 내부에 사용하는 SELECT 문
    * 메인쿼리 : 서브쿼리를 사용하는 최종적인 SELECT 문
    
    *서브쿼리 종류
    - 스칼라 서브쿼리  : SELECT 절에서 사용하는 서브쿼리
    - 인라인 뷰       : FROM 절에서 사용하는 서브쿼리
    - 서브쿼리        : WHERE 절에서 사용하는 서브쿼리
*/

-- 81. EMPLOYEE, DEPARTMENT, JOB 테이블을 사용하여 스칼라 서브쿼리로 출력결과와 같이 조회하시오.

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM job;

SELECT emp_id 사원번호
      ,emp_name 직원명
      ,(SELECT dept_title FROM department d WHERE d.dept_id = employee.dept_code) 부서명
      ,(SELECT job_name FROM job j WHERE j.job_code = employee.job_code ) 직급명
FROM employee;

-- 82. 출력결과를 참고하여, 인라인 뷰를 이용해 부서별로 최고급여를 받는 직원을 조회하시오.
-- 1. 부서별로 최고급여를 조회
SELECT dept_code
      ,MAX(salary)MAX_SAL
      ,MIN(salary)MIN_SAL
      ,AVG(salary)AVG_SAL
FROM employee
GROUP BY dept_code;

-- 2. 부서별 최고급여 조회결과를 서브쿼리(인라인 뷰)로 지정
-- FROM 절 안에서도 서브쿼리를 사용할수 있다.(인라인 뷰)
SELECT emp_id 사원번호
      ,emp_name 직원명
      ,dept_title 부서명
      ,salary 급여
      ,max_sal 최대급여
      ,min_sal 최저급여
      ,ROUND(avg_sal, 2) 평균급여
FROM employee e, department d,
    (SELECT dept_code
           ,MAX(salary) MAX_SAL
           ,MIN(salary) MIN_SAL
           ,AVG(salary) AVG_SAL
    FROM employee
    GROUP BY dept_code) t
WHERE e.dept_code = d.dept_id
AND e.salary = t.max_sal;


















