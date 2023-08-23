
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
ALTER USER HR QUOTA UNLIMITED ON users;

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

-- 21. 12.45, -12.45 보다 크거나 같은 정수 중 제일 작은 수를 계산하는 SQL 문을 각각 작성하시오.
-- 결과 : 13, -12                 -- 자바에선 Math.CEIL
-- SELECT 를 사용할땐 FROM의 위치를 잡아줘야한다.
-- 가상의 위치는 dual로 사용한다.
-- : 산술 연산, 함수 결과 등을 확인해볼 수 있는 임시 테이블
-- CEIL() "천장"
-- : 지정한 값보다 크거나 같은 정수 중 제일 작은 수를 반환하는 함수
SELECT CEIL(12.45) FROM dual;
SELECT CEIL(-12.45) FROM dual;
SELECT CEIL(12.45), CEIL(-12.45) FROM dual;

-- 22. 12.55와 -12.55 보다 작거나 같은 정수 중 가장 큰 수를 계산하는 SQL 문을 각각 작성하시오.
-- 결과 : 12, -13                 -- 자바에선 Math.floor
-- FLOOR() "바닥"
-- : 지정한 값보다 작거나 같은 정수 중 가장 큰 수를 반환하는 함수
SELECT FLOOR (12.55), FLOOR (-12.55) FROM dual;

-- 23. 각 소문제에 제시된 수와 자리 수를 이용하여 반올림하는 SQL문을 작성하시오.
-- 0.54 를 소수점 아래 첫째 자리에서 반올림하시오. → 결과 : 1         - 자바에선 Math.round
-- 0.54 를 소수점 아래 둘째 자리에서 반올림하시오. → 결과 : 0.5
-- 125.67 을 일의 자리에서 반올림하시오. → 결과 : 130
-- 125.67 을 십의 자리에서 반올림하시오. → 결과 : 100
-- ROUND(값, 자리수)
-- : 지정한 값을, 해당 자리수에서 반올림하는 함수
-- a a a a a.bbbb
--  ... -2-1 0123
SELECT ROUND(0.54, 0) FROM dual;
SELECT ROUND(0.54, 1) FROM dual;
SELECT ROUND(125.67, -1) FROM dual;
SELECT ROUND(125.67, -2) FROM dual;

-- 24. 각 소문제에 제시된 두 수를 이용하여 나머지를 구하는 SQL문을 작성하시오.
-- 3을 8로 나눈 나머지를 구하시오. → 결과 : 3         - 자바에선 %
-- 30을 4로 나눈 나머지를 구하시오. → 결과 : 2
-- MOD(A, B) : A를 B로 나눈 나머지를 구하는 함수
SELECT MOD(3, 8) FROM dual;
SELECT MOD(30, 4) FROM dual;

-- 25. 각 소문제에 제시된 두 수를 이용하여 제곱수를 구하는 SQL문을 작성하시오.
-- 2의 10제곱을 구하시오. → 결과 : 1024
-- 2의 31제곱을 구하시오. → 결과 : 2147483648
-- POWER(A, B) : A의 B 제곱을 구하는 함수
SELECT POWER(2, 10) FROM dual;
SELECT POWER(2, 31) FROM dual;

-- 26. 각 소문제에 제시된 수를 이용하여 제곱근을 구하는 SQL문을 작성하시오.
-- 2의 제곱근을 구하시오. → 결과 : 1.41421...
-- 100의 제곱근을 구하시오. → 결과 : 10
-- SQRT(A) : A의 제곱근을 구하는 함수
--  * A 는 양의 정수와 실수만 사용 가능
SELECT SQRT(2) FROM dual;
SELECT SQRT(100) FROM dual;

-- 27. 각 소문제에 제시된 수와 자리 수를 이용하여 해당 수를 절삭하는 SQL문을 작성하시오.
-- 527425.1234 을 소수점 아래 첫째 자리에서 절삭하시오.
-- 527425.1234 을 소수점 아래 둘째 자리에서 절삭하시오.
-- 527425.1234 을 일의 자리에서 절삭하시오.
-- 527425.1234 을 십의 자리에서 절삭하시오.
-- TRUNC(값, 자리수) : 지정한 값을, 해당 자리수에서 절삭하는 함수
-- a a a a a.bbbb
--  ... -2-1 0123
SELECT TRUNC(527425.1234, 0) FROM dual;
SELECT TRUNC(527425.1234, 1) FROM dual;
SELECT TRUNC(527425.1234, -1) FROM dual;
SELECT TRUNC(527425.1234, -2) FROM dual;

-- 28. 각 소문제에 제시된 수를 이용하여 절댓값을 구하는 SQL문을 작성하시오.
--20 의 절댓값을 구하시오.           - 자바에선 ABSOLUT
--12.456 의 절댓값을 구하시오. 
-- ABS(A) : 값 A 의 절댓값을 구하여 반환하는 함수
SELECT ABS(20) FROM dual;
SELECT ABS(-12.456) FROM dual;

-- 29. 문자열을 대문자, 소문자, 첫글자만 대문자로 변환하는 SQL문을 작성하시오.
SELECT 'ALOha WoRlD~!' AS 원문
      ,UPPER('ALOha WoRlD~!') AS 대문자
      ,LOWER('ALOha WoRlD~!') AS 소문자
      ,INITCAP('ALOha WoRlD~!') AS "첫글자만 대문자"
FROM dual;

-- 30. 문자열의 글자 수와 바이트 수를 출력하는 SQL문을 작성하시오.
-- 영문 1BYTE, 한글 3BYTE(UTF-8) 2BYTE(MS949)
-- LENGTH('문자열') : 글자 수
-- LENGTHB('문자열') : 바이트 수
SELECT LENGTH('ALOHA WORLD') AS "글자 수"
      ,LENGTHB('ALOHA WORLD') AS "바이트 수"
FROM dual;

SELECT LENGTH('알로하 월드') AS "글자 수"
      ,LENGTHB('알로하 월드') AS "바이트 수"
FROM dual;

-- 31. 각각 함수와 기호를 이용하여 두 문자열을 병합하여 출력하는 SQL문을 작성하시오.
-- CONCAT
SELECT CONCAT(CONCAT('ALOHA', 'WORLD'), '123') AS 함수
      ,'ALOHA' || 'WORLD' || '123'AS 기호
FROM dual;

-- 32. 주어진 문자열의 일부만 출력하는 SQL문을 작성하시오.
-- SUBSTR(문자열, 시작번호, 글자수)
-- 'www.alohacampus.com'
SELECT SUBSTR('www.alohacampus.com', 1, 3) AS "1"
      ,SUBSTR('www.alohacampus.com', 5, 11) AS "2"
      ,SUBSTR('www.alohacampus.com', -3, 3) AS "3"
FROM dual;

SELECT SUBSTRB('www.alohacampus.com', 1, 3) AS "1"
      ,SUBSTRB('www.alohacampus.com', 5, 11) AS "2"
      ,SUBSTRB('www.alohacampus.com', -3, 3) AS "3"
FROM dual;

-- 'www.알로하캠퍼스.com'
SELECT SUBSTR('www.알로하캠퍼스.com', 1, 3) AS "1"
      ,SUBSTR('www.알로하캠퍼스.com', 5, 6) AS "2"
      ,SUBSTR('www.알로하캠퍼스.com', -3, 3) AS "3"
FROM dual;

SELECT SUBSTRB('www.알로하캠퍼스.com', 1, 3) AS "1"
      ,SUBSTRB('www.알로하캠퍼스.com', 5, 6*3) AS "2"
      ,SUBSTRB('www.알로하캠퍼스.com', -3, 3) AS "3"
FROM dual;

-- 33. 문자열에서 특정 문자의 위치를 구하는 SQL문을 작성하시오.
-- INSTR(문자열, 찾을문자, 시작번호, 순서)
SELECT INSTR('ALOHACAMPUS', 'A', 1, 1) AS "1번째 A"
      ,INSTR('ALOHACAMPUS', 'A', 1, 2) AS "2번째 A"
      ,INSTR('ALOHACAMPUS', 'A', 1, 3) AS "3번째 A"
FROM dual;

-- 34. 대상 문자열을 왼쪽/오른쪽에 출력하고 빈공간을 특정 문자로 채우는 SQL문을 작성하시오.
-- LPAD(문자열, 글자수, 빈공간의 값) : 문자열에 지정한 칸(byte)을 확보하고, 왼쪽에 특정 문자로 채움
-- RPAD(문자열, 글자수, 빈공간의 값) : 문자열에 지정한 칸(byte)을 확보하고, 오른쪽에 특정 문자로 채움
-- R,LPAD에서는 한글을 2byte로 사용
SELECT LPAD('ALOHACAMPUS', 20, '#') AS "왼쪽"
      ,RPAD('ALOHACAMPUS', 20, '#') AS "오른쪽"
      ,RPAD('안녕하세요', 20, '#') AS "오른쪽"
      ,LENGTHB('안녕하세요') AS "바이트 수"
FROM dual;

-- 35. 테이블 EMPLOYEES 의 FIRST_NAME과 HIRE_DATE 를 검색하되 <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- TO CHAR(데이터, ' 날짜/숫자 형식') : 특정 데이터를 문자열 형식으로 변환하는 함수
SELECT first_name AS 이름
      ,TO_CHAR(hire_date, 'YYYY-MM-DD (dy) HH:MI:SS') AS 입사일자
FROM employees;

-- 36. 테이블 EMPLOYEES 의 FIRST_NAME과 SALARY 를 검색하되 <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- 숫사형 -> 문자형 TO_CHAR()
SELECT first_name AS 이름, salary AS 급여, TO_CHAR(salary, '$999,999,999.00') 급여        -- .00 은 센트
FROM employees;

-- 37. 문자형으로 주어진 데이터를 날짜형 데이터로 변환하는 SQL 문을 작성하시오.
-- 20220712 -> 22/07/12
-- TO_DATE('데이터', '날짜형식') : 문자형 데이터를 날짜형 데이터로 변환하는 함수
-- 해당 문자형 데이터를 날짜형으로 분석할  수 있는 위치와 형식을 지정해야함.
-- 문자형 -> 날짜형     YYYY.MM 이나 YYYY-MM 이나 YYYY/MM 섞어서 써도 알아볼수만 있게 쓰면 가능하다. YYYYMM 이렇게만 쓰면 2,3,4에서는 에러난다.
SELECT 20230822 AS 문자
      ,TO_DATE('20230822', 'YYYYMMDD') AS 날짜1
      ,TO_DATE('2023.08.22', 'YYYY.MM.DD') AS 날짜2
      ,TO_DATE('2023/08/22', 'YYYY/MM/DD') AS 날짜3
      ,TO_DATE('2023-08-22', 'YYYY-MM-DD') AS 날짜4
FROM dual;

-- 38. 문자형으로 주어진 데이터를 숫자형 데이터로 변환하는 SQL 문을 작성하시오.
-- TO_NUMBER(데이터, 형식) : 문자형 데이터를 숫자형 데이터로 변환하는 함수
SELECT '1,200,000' AS 문자
      ,TO_NUMBER('1,200,000', '999,999,999') AS 문자
FROM dual;

-- 39. 현재 날짜를 반환하는 SQL 문을 작성하시오.
-- SYSDATE : 현재 날짜/시간 정보를 가지고 있는 키워드
-- SYSDATE : 오늘날짜   SYSDATE-1 : 어제날짜   SYSDATE+1 : 내일날짜
SELECT sysdate FROM dual;

SELECT sysdate-1 어제, sysdate 오늘, sysdate+1 내일
FROM dual;

-- 40. 입사일자와 오늘 날짜를 계산하여 근무달수와 근속연수를 구하는 SQL 문을 작성하시오.
-- MONTHS_BETWEEN(A, B) : 날짜 A 부터 B까지 개월 수 차이를 반환하는 함수
-- (단, A > B 즉, A가 더 최근 날짜로 지정되어야 양수로 반환

SELECT first_name AS 이름
      ,TO_CHAR(hire_date, 'YYYY.MM.DD') AS 입사일자
      ,TO_CHAR(sysdate, 'YYYY.MM.DD') AS 오늘
      ,TRUNC(sysdate - hire_date , 0) 근무일수   -- TRUNC 안에 0은 생략해서 사용해도 된다.TRUNC(sysdate - hire_date)이렇게 대체 가능
      ,TRUNC(MONTHS_BETWEEN(sysdate, hire_date)) || '개월' 근무일수
      ,TRUNC(MONTHS_BETWEEN(sysdate, hire_date) /12) ||  '년수' 근속연수
FROM employees;

-- 41. 오늘 날짜와 6개월 후의 날짜를 출력하는 SQL 문을 작성하시오.
-- ADD_MONTHS(날짜, 개월 수) : 지정한 날짜로부터 해당 개월 수 후의 날짜를 반한하는 함수
SELECT sysdate 오늘
      ,ADD_MONTHS(sysdate, 6) "6개월 후"
FROM dual;

SELECT '2023/07/25' 개강
      ,ADD_MONTHS('2023/07/25', 6) 종강
FROM dual;

SELECT '2023/07/25' 개강
      ,ADD_MONTHS('2023/07/25', -2) "2달전"
FROM dual;

-- 42. 오늘 날짜와 오늘 이후 돌아오는 토요일의 날짜를 출력하는 SQL 문을 작성하시오.
-- NEXT_DAY(날짜, 요일) : 지정한 날짜 이후 돌아오는 요일을 반환하는 함수
-- 요일 (일1,월2~금6,토7) 지정해야한다.
SELECT sysdate AS 오늘
      ,NEXT_DAY(sysdate, 7) "다음 토요일"
FROM dual;

SELECT sysdate AS 오늘
      ,NEXT_DAY(sysdate, 2) "다음 월요일"
      ,NEXT_DAY(sysdate, 3) "다음 화요일"
      ,NEXT_DAY(sysdate, 4) "다음 수요일"
      ,NEXT_DAY(sysdate, 5) "다음 목요일"
      ,NEXT_DAY(sysdate, 6) "다음 금요일"
      ,NEXT_DAY(sysdate, 7) "다음 토요일"
      ,NEXT_DAY(sysdate, 1) "다음 일요일"
FROM dual;

-- 43. 오늘 날짜와 월초, 월말 일자를 구하는 SQL 문을 작성하시오.
-- LAST_DAY(날짜) : 지정한 날짜와 동일한 월의 일자를 반환하는 함수
-- 날짜 : XXXXX.YYYYY     이건 1970년 01월01일 00시00분00초00ms -> 2023년08월22일
-- 지난 일자를 정수로 계산, 시간정보는 소수부분으로 계산
-- XXXXX.YYYYY 날짜 데이터를 월 단위로 절삭하면, 월초를 구할 수 있다.
SELECT TRUNC( sysdate, 'MM' ) 월초
      ,sysdate AS 오늘
      ,LAST_DAY( sysdate ) 월말
FROM dual;

-- 44. 테이블 EMPLOYEES 의 COMMISSION_PCT 를 중복없이 검색하되, NULL 이면 0으로 조회하고 내림차순으로 정렬하는 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- DISTINCT : 중복없이 검색   --ORDERBY : 내림차순  
-- ORDER BY  DISTINCT
-- SELECT 문 실행 순서
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY
-- NVL(값, 대체할 값) : 해당 값이 NULL 이면 지정된 값으로 변환하는 함수

-- 1단계
SELECT DISTINCT commission_pct
FROM employees;

-- 2단계
SELECT DISTINCT NVL(commission_pct, 0)
FROM employees;


-- 3단계
-- SELECT 문 실행 순서
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
SELECT DISTINCT NVL(commission_pct, 0) "커미션(%)"
FROM employees
ORDER BY NVL(commission_pct, 0) DESC;

-- 4단계
-- 조회한 컬럼의 별칭으로 ORDER BY 절에서 사용할 수 있다. ex)"커미션(%)"
SELECT DISTINCT NVL(commission_pct, 0) AS "커미션(%)"
FROM employees
ORDER BY "커미션(%)" DESC;

-- 45. 테이블 EMPLOYEES 의 FIRST_NAME, SALARY, COMMISSION_PCT 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오. (HR 계정 샘플 데이터)
-- <조건> * 최종급여 = 급여 + (급여x커미션) * 최종급여를 기준으로 내림차순 정렬
-- * NVL(값, 대체할 값) : 해당 값이 NULL 이면 지정된 값으로 변환하는 함수
-- * NVL2(값, NULL 아닐때 값, NULL 일 때 값)
SELECT first_name AS 이름
      ,salary AS 급여
      ,NVL(commission_pct, 0) AS 커미션
      ,salary + (salary*NVL(commission_pct, 0)) AS "커미션 포함급여"
      ,NVL2(commission_pct, salary + salary*commission_pct, salary) AS "최종급여1"
      --                        NULL 아닌경우,              NULL일경우
FROM employees
ORDER BY "최종급여1" DESC;

-- 46. 테이블 EMPLOYEES 의 FIRST_NAME, DEPARTMENT_ID 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- DEPARTMENTS 가 암호화 되는것이다.
-- CODE <-> DECODE 코드는 암호화 디코드는 복구화 
-- DECODE(컬럼명, 조건값1, 반환값1, 조건값2, 조건값2, ... )
-- : 지정한 칼럼의 값이 조건값에 일치하면 바로 뒤의 반한값을 출력하는 함수
-- JAVA 에서 switch문과 비슷하다
SELECT first_name 이름
      ,DECODE(department_id, 10, 'Administration',
                             20, 'Marketing',
                             30, 'Purchasing',
                             40, 'Human Resources',
                             50, 'Shipping',
                             60, 'IT',
                             70, 'Public Relations',
                             80, 'Sales',
                             90, 'Executive',
                             100, 'Finance'
      ) 부서
FROM employees;

-- 47. 테이블 EMPLOYEES 의 FIRST_NAME, DEPARTMENT_ID 속성을 이용하여 <예시>와 같이 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- ctrl + shift + D : 한줄복사
-- CASE 문 : 조건식을 만족할 때, 출력할 값을 지정하는 구문
-- CASE
--      WHEN 조건식1 THEN 반환값1
--      WHEN 조건식2 THEN 반환값2
--      WHEN 조건식3 THEN 반환값3
-- END
SELECT first_name 이름
      ,CASE WHEN department_id = 10 THEN 'Administration'
            WHEN department_id = 20 THEN 'Marketing'
            WHEN department_id = 30 THEN 'Purchasing'
            WHEN department_id = 40 THEN 'Human Resources'
            WHEN department_id = 50 THEN 'Shipping'
            WHEN department_id = 60 THEN 'IT'
            WHEN department_id = 70 THEN 'Public Relations'
            WHEN department_id = 80 THEN 'Sales'
            WHEN department_id = 90 THEN 'Executive'
            WHEN department_id = 100 THEN 'Finance'
       END 부서
FROM employees;

-- 48. 다음 <예시> 와 같이 테이블 EMPLOYEES 의 사원 수를 구하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- COUNT( 컬럼명 ) : 컬럼을 지정하여 NULL을 제외한 데이터 개수를 반환하는 함수
-- * NULL 이 없는 데이터라면 어떤 컬럼을 지정하더라도 개수가 같기 때문에, 일반적으로 , COUNT(*) 로 개수를 구한다.
SELECT COUNT(*) 사원수
      ,COUNT(commission_pct) 커미션받는사원수
      ,COUNT(department_id) 부서가있는사원수
FROM employees;

-- 49. 테이블 EMPLOYEES 의 최고급여, 최저급여를 구하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- MAX, MIN
SELECT MAX(salary) 최고급여
      ,MIN(salary) 최소급여
FROM employees;

-- 50. 테이블 EMPLOYEES 의 급여합계, 급여평균을 구하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
-- SUM(), AVG()
SELECT SUM(salary) 급여합계
      ,ROUND(AVG(salary), 2) 급여평균
FROM employees;

-- 51. 테이블 EMPLOYEES 의 급여표준편자와 급여분산을 구하는 SQL 문을 작성하시오.(HR 계정 샘플 데이터)
--STDDEV(),VARIANCE()
SELECT ROUND(STDDEV(salary), 2) 급여표준편차
      ,ROUND(VARIANCE(salary), 2) 급여분산
FROM employees;

-- 52. TABLE 기술서를 참고하여 MS_STUDENT 테이블을 생성하는 SQL 문을 작성하시오.
-- * 테이블  생성
/*
   CREATE TABLE 테이블명(
        컬럼명1    타입  [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
        컬럼명2    타입  [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
        컬럼명3    타입  [DEFAULT 기본값]   [NOT NULL/NULL] [제약조건],
        ...
    );
*/
CREATE TABLE MS_STUDENT (
    ST_NO       NUMBER          NOT NULL    PRIMARY KEY
   ,NAME        VARCHAR2(20)    NOT NULL
   ,CTZ_NO      CHAR(14)        NOT NULL
   ,EMAIL       VARCHAR2(100)   NOT NULL    UNIQUE
   ,ADDRESS     VARCHAR2(1000)  NULL
   ,DEPT_NO     NUMBER          NOT NULL
   ,MJ_NO       NUMBER          NOT NULL
   ,REG_DATE    DATE    DEFAULT sysdate    NOT NULL
   ,UPD_DATE    DATE    DEFAULT sysdate    NOT NULL
   ,ETC         VARCHAR2(1000)  DEFAULT '없음'    NULL
);

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT,CTZ_NO IS '주민등록번호';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.DEPT_NO IS '학부번호';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

DROP TABLE MS_STUDENT;

-- 53. MS_STUDENT 테이블에 속성을 추가하는 SQL 문을 작성하시오.
-- 테이블에 속성 추가
-- ALTER TABLE 테이블명 ADD 컬럼명 타입 DEFAULT 기본값 [NOT NULL];
ALTER TABLE MS_STUDENT ADD GENDER CHAR(6) DEFAULT '기타' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';

ALTER TABLE MS_STUDENT ADD STATUS VARCHAR2(10) DEFAULT '대기' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';

ALTER TABLE MS_STUDENT ADD ADM_DATE DATE NOT NULL;
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';

ALTER TABLE MS_STUDENT ADD GRD_DATE DATE NOT NULL;
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';

DESC MS_STUDENT;

-- 테이블 속성 삭제
-- ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE MS_STUDENT DROP COLUMN GENDER;
ALTER TABLE MS_STUDENT DROP COLUMN STATUS;
ALTER TABLE MS_STUDENT DROP COLUMN ADM_DATE;
ALTER TABLE MS_STUDENT DROP COLUMN GRD_DATE;

DESC MS_STUDENT;

-- 54. MS_STUDENT 테이블의 주민번호 속성을 생년월일 속성으로 수정하는 SQL 문을 작성하시오.
-- CTZ_NO -> BIRTH 컬럼명을 바꾸고 CHAR -> NUMBER 타입으로 변경 설명도 주민등록번호에서 생년월일로 변경
ALTER TABLE MS_STUDENT RENAME COLUMN CTZ_NO TO BIRTH;
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE;
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일'

-- 속성 변경 - 타입 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE;
-- 속성 변경 - NULL 여부 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH NULL;
-- 속성 변경 - DEFAULT 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH DEFAULT sysdate;

-- 동시에 적용 가능
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE DEFAULT sysdate NOT NULL;

-- 55. MS_STUDENT 테이블의 학부번호 속성을 삭제하는 SQL 문을 작성하시오.
-- ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE MS_STUDENT DROP COLUMN DEPT_NO;

-- 56. MS_STUDENT 테이블을 삭제하는 SQL 문을 작성하시오.
DROP TABLE MS_STUDENT;

-- 57. TABLE 기술서를 참고하여 MS_STUDENT 테이블을 생성하는 SQL 문을 작성하시오.
CREATE TABLE MS_STUDENT (
     ST_NO      NUMBER          NOT NULL   PRIMARY KEY
    ,NAME       VARCHAR2(20)    NOT NULL
    ,BIRTH      DATE            NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,MJ_NO      VARCHAR2(10)    NOT NULL
    ,GENDER     CHAR(6)         DEFAULT '기타'    NOT NULL
    ,STATUS     VARCHAR2(10)    DEFAULT '대기'    NOT NULL
    ,ADM_DATE   DATE    NULL
    ,GRD_DATE   DATE    NULL
    ,REG_DATE   DATE    DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE    DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
);

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

-- 58. MS_STUDENT 테이블에 데이터를 삽입하는 SQL 문을 작성하시오.
-- INSERT INTO BOARD (TITLE, WRITER, CONTENT)       VALUES(1, 2, 3);
INSERT INTO MS_STUDENT (ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, GENDER, STATUS, 
                        ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC)
VALUES('20180001', '최서아', '991005', 'csa@univ.ac.kr', '서울', 'I01',
       '여', '재학', '2018/03/01', NULL, sysdate, sysdate, NULL);
       
INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210001', '박서준', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'psj@univ.ac.kr', '서울', 'B02',
         '남', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210002', '김아윤', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'kay@univ.ac.kr', '인천', 'S01',
         '여', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20160001', '정수안', TO_DATE('1997/02/10', 'YYYY/MM/DD'), 'jsa@univ.ac.kr', '경남', 'J01',
         '여', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20150010', '윤도현', TO_DATE('1996/03/11', 'YYYY/MM/DD'), 'ydh@univ.ac.kr', '제주', 'K01',
         '남', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20130007', '안아람', TO_DATE('1994/11/24', 'YYYY/MM/DD'), 'aar@univ.ac.kr', '경기', 'Y01',
         '여', '재학', TO_DATE('2013/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, '영상예술 특기자' );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20110002', '한성호', TO_DATE('1992/10/07', 'YYYY/MM/DD'), 'hsh@univ.ac.kr', '서울', 'E03',
         '남', '재학', TO_DATE('2015/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

SELECT * FROM MS_STUDENT;

-- 59. MS_STUDENT 테이블에 데이터를 수정하는 SQL 문을 작성하시오.
-- UPDATE MS_STUDENT SET 주소 = '서울', 재적 = '휴학'
/*
  UPDATE 테이블명
     SET 컬럼1 = 변경할 값,
         컬럼2 = 변경할 값,
         ...
   WGERE 조건;
*/
UPDATE MS_STUDENT
   SET address = '서울',
   status = '휴학'
WHERE st_no = '20160001';

UPDATE MS_STUDENT
   SET address = '서울',
   status = '졸업',
   grd_date = '20200220',
   upd_date = sysdate,
   etc = '수석'
WHERE st_no = '20150010';

UPDATE MS_STUDENT
   SET status = '졸업',
   grd_date = '20200220',
   upd_date = sysdate
WHERE st_no = '20130007';

UPDATE MS_STUDENT
   SET status = '퇴학',
   upd_date = sysdate,
   etc = '자진 퇴학'
WHERE st_no = '20110002';

SELECT * FROM MS_STUDENT;

-- 60. MS_STUDENT 테이블에 데이터를 삭제하는 SQL 문을 작성하시오.
-- DELETE FROM 테이블명 WHERE 컬럼값
DELETE FROM MS_STUDENT
WHERE ST_NO = '20110002';

-- 61. MS_STUDENT 테이블의 모든 속성을 조회하는 SQL 문을 작성하시오.
SELECT * FROM MS_STUDENT;

-- 62. MS_STUDENT 테이블의 모든 속성을 조회하여 MS_STUDENT_BACK 테이블을 생성하는 SQL 문을 작성하시오.
-- 백업 테이블 만들기 (SELECT 다음에 * 대신 백업으로 만들려고 하는 컬럼명을 입력하여 만들수 있다.예)SELECT ST_NO FROM MS_STUDENT_BACK;)
CREATE TABLE MS_STUDENT_BACK
AS SELECT * FROM MS_STUDENT;

SELECT * FROM MS_STUDENT_BACK;

-- 63. MS_STUDENT 테이블의 튜플을 삭제하는 SQL 문을 작성하시오.
DELETE FROM MS_STUDENT;

SELECT * FROM MS_STUDENT;

-- 64. MS_STUDENT_BACK 테이블의 모든 속성을 조회하여 MS_STUDENT 테이블에 삽입하는 SQL 문을 작성하시오.
-- INSERT 
INSERT INTO MS_STUDENT
SELECT * FROM MS_STUDENT_BACK;

SELECT * FROM MS_STUDENT;

-- 65. MS_STUDENT 테이블의 성별 속성이 (‘여’, ‘남‘, ‘기타‘ ) 값만 입력가능하도록 하는 제약조건을 추가하시오.
ALTER TABLE MS_STUDENT
ADD CONSTRAINT MS_STD_GENDER_CHECK
CHECK (gender IN('여', '남', '기타'));

UPDATE MS_STUDENT
    SET GENDER = '???';
-- 제약조건 - 기본 키, - 고유 키, - CHECK 3가지가 있다.
-- CHECK 제약조건 : 지정한 값만 입력/수정 가능하도록 제한하는 조건
-- 지정한 값이 아닌 다른 값을 입력/수정하는 경우, "체크 제약조건(HR.MS_STD_GENDER_CHECK)이 위배되었습니다" 에러 발생
-- 기본키 (PRIMARY KEY) : 중복 불가(유일성), NULL 불가(필수입력)
-- * 해당 테이블의 데이터를 고유하게 구분할 수 있는 속성으로 지정
-- 고유키 (UNIQUE KEY) : 중복 불가, NULL 허용
-- * 중복되지 않아야할 데이터(ID, 주민번호, 이메일, ...)

-- 66. TABLE 기술서를 참고하여 MS_USER 테이블을 생성하는 SQL 문을 작성하시오.
CREATE TABLE MS_USER (
     USER_NO    NUMBER          NOT NULL   PRIMARY KEY
    ,NAME       VARCHAR2(20)    NOT NULL
    ,BIRTH      DATE            NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,MJ_NO      VARCHAR2(10)    NOT NULL
    ,GENDER     CHAR(6)         DEFAULT '기타'    NOT NULL
    ,STATUS     VARCHAR2(10)    DEFAULT '대기'    NOT NULL
    ,ADM_DATE   DATE    NULL
    ,GRD_DATE   DATE    NULL
    ,REG_DATE   DATE    DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE    DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
);

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';




