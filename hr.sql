--커서 실행 단축키 : ctrl+enter
--문서 전채 실행 : F5
SELECT 1+1
FROM dual;

--1. 계정 접속 명령어
--conn 계정명/비밀번호;
conn system/123456;

--2. 
--SQL은 대/소문자 구분이 없다.
--명령어 키워드 대문자, 식별자는 소문자로 주로 사용한다.(각자 스타일대로)
SELECT user_id, username
FROM all_users
WHERE username = "HR"
;
--HR계정 생성
--CREATE USER 계정명 IDENTIFIED BY 비밀번호;

--11g버전 이하 : 어떤 이름으로도 계정 생성 가능
--12c버전 이상 : 'c##' 접두어를 붙여서 계정을 설정하도록 정책을 정함

--c##없이 계정 생성하기
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER HR IDENTIFIED BY 123456;

--테이블 스페이스 변경
--ALTER USER 계정명 DEFAULT TABLESPACE users;
ALTER USER HR DEFAULT TABLESPACE users;

--계정이 사용할 수 잇는 용량 설정
--HR 계정의 사용 용량을 무한대로 지정
--ALTER USER 계정명 QUOTA UNLIMITED ON 테이블스페이스;
ALTER USER HR QUOTA UNLIMITED ON users;

--계정에 권한을 부여
--HR 계정에 connect, resource 권한을 부여
--GRANT 권한명1, 권한명2 TO 계정명;
GRANT connect, resource TO HR;

--계정 삭제
--DROP USER 계정명 [CASCADE];
DROP USER HR CASCADE;

--계정 잠금 해제
--ALTER USER 계정명 ACCOUNT UNLOCK;
ALTER USER HR ACCOUNT UNLOCK;

--HR 샘플 스키마(데이터)가져오기
--1. SQLPLUS  2. HR계정을 접속 3. 명령어 입력
--@[경로]/hr_main.sql
--@? : 오라클이 설치된 기본 경로
--@?/demo/schema/human_resources/hr_main.sql
--4. 123456(비밀번호)   5. users[tablespace]    6. temp[temp tablespace]
--7. [log 경로] - @?/demo/schema/log

--3.
--테이블 EMPLOYEES의 테이블 구조를 조회하는 SQL문을 작성하시오.
DESC employees;

--테이블 employees에서 employee_id, first_name을 조회하는 sql문을 작성하시오.
--*사원테이블의 사원번호와, 이름을 조회
SELECT employee_id, first_name
FROM employees;

--띄어쓰기가 없으면, 따옴표 생략가능,
--AS 생략 가능 // AS(alias) : 출력되는 컬럼명에 별명을 짓는 명령어
--4. 한글 별칭을 부여하여 조회
SELECT employee_id AS "사원 번호",  --띄어쓰기 있으면 " " 표기
       first_name AS 이름,
       last_name 성,                --AS 생략 가능
       email 이메일,
       phone_number 전화번호,
       hire_date 입사일자,
       salary 급여
FROM employees;
--
SELECT *            --(*) [애스터리크] : 모든 컬럼 지정
FROM employees;

--5. 테이블 EMPLOYEES의 JOB_ID를 중복된 데이터를 제거하고 조회하는 SQL문을 작성하시오.
--* DISTINCT컬럼명 : 중복된 데이터를 제거하고 조회하는 키워드
SELECT DISTINCT job_id
FROM employees;

--6. WHERE 조건 : 조회 조건을 작성하는 구문
SELECT *
FROM employees
WHERE salary > 6000;

--7.
SELECT * FROM employees
WHERE salary = 10000;

--8. ORDER BY salary DESC(내림차순) // first_name ASC(오름차순)
-- 생략해서 쓰면 오름차순이 기본값
SELECT * FROM employees
order by salary DESC, first_name asc;

--9. OR조건연산 : WHERE A OR B;
SELECT * FROM employees
WHERE job_id = 'FI_ACCOUNT'
    OR job_id = 'IT_PROG';
--10. OR조건연산 : WHERE 컬럼명 IN('A', 'B');
SELECT * FROM employees
WHERE job_id in('FI_ACCOUNT', 'IT_PROG');

--11. A와 B가 아닌 나머지 조회 : WHERE 컬럼명 NOT IN('A', 'B');
SELECT * FROM employees
WHERE job_id NOT IN ('FI_ACCOUNT', 'IT_PROG');

--12. AND조건연산 : WHERE A AND B
SELECT * FROM employees
WHERE job_id = 'IT_PROG'
    AND salary >= 6000;
    
--컬럼명 LIKE '와일드카드';  // % : 여러문자 대체 / _ : 한 문자를 대체
--13. S로 시작
SELECT * FROM employees
WHERE first_name LIKE 'S%';

--14. s로 끝
SELECT * FROM employees
WHERE first_name LIKE '%s';

--15. s를 포함
SELECT * FROM employees
WHERE first_name LIKE '%s%';

--16. FIRST_NAME이 5글자 (언더바 5개)
SELECT * FROM employees
WHERE first_name LIKE '_____';
-- LENGTH(컬럼명) : 글자 수를 반환하는 함수
SELECT * FROM employees
WHERE LENGTH(first_name) = 5;

--17. 
SELECT * FROM employees
WHERE commission_pct IS NULL;

--18.
SELECT * FROM employees
WHERE commission_pct IS NOT NULL;

--19.
SELECT * FROM employees
WHERE hire_date >= '04/01/01';  --SQL Developer에서 문자형 데이터를 날짜형 데이터로 자동 변환
--TO_DATE() : 문자형 데이터를 날짜형 데이터로 변환하는 함수
SELECT * FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD');

--20.
SELECT * FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD')
    AND hire_date <= TO_DATE('20051231', 'YYYYMMDD');
-- 컬럼 BETWEEN A AND B; : A보다 크거나 같고 B보다 작거나 같은 조건(사이)
SELECT * FROM employees
WHERE hire_date BETWEEN TO_DATE('20040101', 'YYYYMMDD')
    AND TO_DATE('20051231', 'YYYYMMDD');
    
