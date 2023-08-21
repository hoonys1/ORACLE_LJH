
-- 실행 단축키 : ctrl + enter
-- 문서 전체 실행 : F5
SELECT 1+1
FROM dual;

-- 1. 계정 접속 명령어
-- conn 계정명/비밀번호;
conn system/123456;

-- 2. 
-- SQL 은 대/소문자 구분이 없다.
-- 명령어 키워드 대문자, 식별자는 소문자 주로 사용한다. (각자 스타일대로)
SELECT user_id, username
FROM all_users
--WHERE username = 'HR';

-- 사용자 계정 생성
-- 11g 버전 이하: 어떤 이름으로도 계정 생성 가능
-- 12c 버전 이상: 'c##'접두어를 붙여서 계정을 생성하도록 정책을 정함
-- c## 없이 계정 생성
ALTER SESSION SET '_ORACLE_SCRIPT' = TRUE;

-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER HR IDENTIFIED BY 123456;

-- 테이블 스페이스 변경
-- ALTER USER 계정명 DEFAULT TABLESPACE users;
ALTER USER HA DEFAULT TABLESPACE users;

-- 계정이 사용할 수 있는 용량 설정
-- HR 계정의 사용 용량을 무한대로 지정
SELECT user_id, username
FROM all_users
--WHERE username = 'HR';
ALTER USER HR QUATA UNLIMIED ON users;

-- 계정에 권한을 부여
-- HR 계정에 connect, resource 권한을 부여
-- GRANT 권한명1, 권한명2 TO 계정명;
GRANT connect, resource TO HR;

-- HR 기본 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER HR IDENTIFIED BY 123456;
ALTER USER HR DEFAULT TABLESPACE users;
ALTER USER HR QUOTA UNLIMITED ON users;
GRANT connect, resource TO HR;

-- 계정 삭제
-- DROP USER 계정명 [CASCADE]
-- HR 계정 삭제
DROP USER HR CASCADE;

-- 계정 잠금 해제
-- ALTER USER 계정명 ACCOUNT UNLOCK;
ALTER USER HR ACCOUNT UNLOCK;

-- HR 샘플 스키마(데이터) 가져오기
-- 1. SQL PLUS
-- 2. HR 계정을 접속
-- 3. 명령어 입력
-- @[경로]/hr_main.sql
-- @ : 오라클이 설치된 기본 경로
-- @?/demo/schema/human_resources/hr_main.spl
-- 4. 123456[비밀번호]
-- 5. users[tablespace]
-- 6. temp[temp tablespace]
-- 7. [log 경로]-@?/demo/schema/log


-- 3.번
-- 테이블 EMPLOYEES 의 테이블 구조를 조회하는 SQL 문을 작성하시오.
DESC employees;

-- 테이블 EMPLOYEES 에서 EMPLOYEES_ID, FFIRST_NAME (회원번호, 이름) 를 조회하는 SQL 문을 작성하시오.
SELECT employee_id, first_name
FROM employees;

-- 4. EMPLOYEE_ID AS 사원번호
-- * 띄어쓰기가 없으면, 따옴표 생략가능.(EMPLOYEES_ID 사원 번호 (X)) (EMPLOYEES_ID "사원 번호"(O))(EMPLOYEES_ID 사원번호(O)
-- * 한글 별칭을 부여하여 조회
-- AS (alias) : 출력되는 컬럼명에 별명을 짓는 명령어
SELECT employee_id AS "사원 번호" -- 띄어쓰기가 있으면, ""로 표기
      ,first_name AS 이름         -- * AS 생략 가능
      ,last_name AS 성
      ,email AS 이메일
      ,phone_number AS 전화번호
      ,hire_date AS 입사일자
      ,salary AS 급여
FROM employees;

-- 
SELECT *        -- (*) [애스터리크] : 모든 칼럼 지정
FROM employees;

-- 5.테이블 EMPLOYEES 의 JOB_ID를 중복된 데이터를 제거하고 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- 중복된 데이터 DISTINCT    SELECT JOB_ID DISTINCT
-- DISTINCT 컬럼명 : 중복된 데이터를 제거하고 조회하는 키워드
SELECT DISTINCT job_id
FROM employees;

-- 6. 테이블 EMPLOYEES 의 SALARY(급여)가 6000을 초과하는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- WHERE salary > 6000;
-- WHERE 조건 : 조회 조건을 작성하는 구문
SELECT *
FROM employees
WHERE salary > 6000;

-- 7.테이블 EMPLOYEES 의 SALARY(급여)가 10000인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- SQL 에서는 같은 비교연산을 = 하나만 써도 된다.
SELECT *
FROM employees
WHERE salary = 10000;

-- 8. 테이블 EMPLOYEES 의 모든 속성들을 SALARY 를 기준으로 내림차순 정렬하고, FIRST_NAME 을 기준으로 오름차순 정렬하여 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- ORDER BY salary DESC, first_name ASC
-- FIRST_NAME 을 기준으로 오름차순 정렬하여 조회하는 SQL 문을 작성하시오.
-- 정렬 명령어
-- ORDER BY 컬럼명 [ASC/DESC]
-- * ASC    : 오름차순
-- * DESC   : 내림차순
-- * (생략)   : 오름차순이 기본값
SELECT *
FROM employees
ORDER BY salary DESC, first_name ASC;

-- 9.테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터) 
-- 조건 연산
-- OR 연산 : ~ 또는, ~이거나
-- WHERE A OR B;
SELECT *
FROM employees
WHERE job_id = 'FI_ACCOUNT' OR job_id = 'IT_PROG';  -- 값에 대한건 '' 사용  // 명령어에 한에서만 대소문자 구분 없고 값에 대한건은 대소문자 구분 필수!!!'fi_account' (X)

-- 10.테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터) IN 키워드를 사용하여 SQL 쿼리를 완성하시오.
-- * 컬럼명 IN ('A', 'B')  : OR 연산을 대체하여 사용할 수 있는 키워드
SELECT *
FROM employees
WHERE job_id IN ('FI_ACCOUNT', 'IT_PROG');

-- 11.테이블 EMPLOYEES 의 JOB_ID가 ‘FI_ACCOUNT’ 이거나 ‘IT_PROG’ 아닌 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)  IN 키워드를 사용하여 SQL 쿼리를 완성하시오.
-- * 컬럼명 NOT IN ('A', 'B')  : 'A', 'B' 를 제외한 결과를 조회
SELECT *
FROM employees
WHERE job_id NOT IN ('FI_ACCOUNT', 'IT_PROG');

-- 12.테이블 EMPLOYEES 의 JOB_ID가 ‘IT_PROG’ 이면서 SALARY 가 6000 이상인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- 조건 연산
-- AND 연산 : 동시에, ~이면서, 그리고
-- WHERE A AND B;
SELECT *
FROM employees
WHERE job_id = 'IT_PROG' AND SALARY >= 6000;

-- 13. 테이블 EMPLOYEES 의 FIRST_NAME 이 ‘S’로 시작하는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- * 컬럼명 LIKE '와일드카드';
-- % : 여러 문자를 대체
-- _ : 한 문자를 대체
SELECT *
FROM employees
WHERE first_name LIKE 'S%';

-- 14.테이블 EMPLOYEES 의 FIRST_NAME 이 ‘s’로 끝나는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE first_name LIKE '%s';

-- 15. 테이블 EMPLOYEES 의 FIRST_NAME 에 ‘s’가 포함되는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE first_name LIKE '%s%';

-- 16. 테이블 EMPLOYEES 의 FIRST_NAME 이 5글자인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE first_name LIKE '_____';

-- LENGTH(컬럼명) : 글자 수를 반환하는 함수
SELECT *
FROM employees
WHERE LENGTH(first_name) = 5;

-- 17. 테이블 EMPLOYEES 의 COMMISSION_PCT가 NULL 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- COMMISSION_PCT 성과급 비율
-- NULL 확인 방법 WHERE COMMISSION_PCT = NULL; NULL은 값이 없기때문에 저렇게 쓸수 없고 IS NULL; 로 사용해야 한다
SELECT *
FROM employees
WHERE commission_pct IS NULL;

-- 18. 테이블 EMPLOYEES 의 COMMISSION_PCT가 NULL이 아닌 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE commission_pct IS NOT NULL;

-- 19.테이블 EMPLOYEES 의 사원의 HIRE_DATE가 04년 이상인 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE hire_date >= '04/01/01';          -- SQL Developer 에서 문자형 데이터를 날짜형 데이터로 자동 변환해주어 사용 가능
--     DATE 타입     CHAR 타입

-- TO_DATE() : 문자형 데이터를 날짜형 데이터로 변환하는 함수
SELECT *
FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD');
--    DATE 타입          DATE 타입

-- 20. 테이블 EMPLOYEES 의 사원의 HIRE_DATE가 04년도부터 05년도인 모든 컬럼을 조회하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
SELECT *
FROM employees
WHERE hire_date >= '04/01/01' AND hire_date <= '05/12/31';

-- 컬럼 BETWEEN A AND B;  : A 보다 크거나 같고 B 보다 작거나 같은 조건(사이)
SELECT *
FROM employees
WHERE hire_date BETWEEN '04/01/01' AND '05/12/31';



