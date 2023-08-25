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
    
--21
--* dual ? : 산술 연산, 함수 결과 등을 확인해볼 수 있는 임시 테이블
-- CEIL() : 지정한 값보다 크거나 같은 정수 중 제일 작은 수를 반환하는 함수
SELECT CEIL(12.45) FROM dual;
SELECT CEIL(-12.45) FROM dual;    
SELECT CEIL(12.45), CEIL(-12.45) FROM dual;    

--22
--FLOOR() : 지정한 값보다 작거나 같은 정수 중 제일 큰 수를 반환하는 함수
SELECT FLOOR(12.55) FROM dual;
SELECT FLOOR(-12.55) FROM dual;
SELECT FLOOR(12.55), FLOOR(-12.55) FROM dual;

--23 반올림
--ROUND(값, 자리수) : 지정한 값을, 해당 자리수에서 반올림하는 함수
SELECT ROUND(0.54, 0) FROM dual; --1의자리
SELECT ROUND(0.54, 1) FROM dual; --소수점1자리
SELECT ROUND(125.67, -1) FROM dual; --10의자리
SELECT ROUND(125.67, -2) FROM dual; --100의자리

--24 나머지
--MOD(A, B) : A를 B로 나눈 나머지를 구하는 함수
SELECT MOD(3, 8) FROM dual;
SELECT MOD(30, 4) FROM dual;

--25 제곱수
--POWER(A, B) : A의 B 제곱근 구하는 함수
SELECT POWER(2, 10) FROM dual;  --2^10
SELECT POWER(2, 31) FROM dual;  --2^31

--26 제곱근
--SQRT(A) : A의 제곱근을 구하는 함수
--* A는 양의 정수와 실수만 사용 가능
SELECT SQRT(2) FROM dual;
SELECT SQRT(100) FROM dual;

--27 절삭
--TRUNC(값, 자리수)
SELECT TRUNC(527425.1234, 0) FROM dual;
SELECT TRUNC(527425.1234, 1) FROM dual;
SELECT TRUNC(527425.1234, -1) FROM dual;
SELECT TRUNC(527425.1234, -2) FROM dual;

--28 절댓값
--ABS(A) : A의 절댓값을 구하여 반환하는 함수
SELECT ABS(-20) FROM dual;
SELECT ABS(-12.456) FROM dual;

--29 문자 변환
SELECT 'AlohA WoRlD~!' AS 원문
      ,UPPER('AlohA WoRlD~!') AS 대문자
      ,LOWER('AlohA WoRlD~!') AS 소문자
      ,INITCAP('AlohA WoRlD~!') AS "첫글자만 대문자"
FROM dual;

--30
--LENGTH('문자열') : 글자 수 / LENGTHB('문자열') : 바이트 수
--영문자,숫자,공백 : 1byte / 한글 : 3byte
SELECT LENGTH('ALOHA WORLD') AS "글자 수"
      ,LENGTHB('ALOHA WORLD') AS "바이트 수"
FROM dual;

SELECT LENGTH('알로하 월드') AS "글자 수"
      ,LENGTHB('알로하 월드') AS "바이트 수"
FROM dual;

--31 문자열 병합
--CONCAT()  // ||
SELECT CONCAT('ALOHA', 'WORLD') AS "함수"
      ,'Aloha' || 'World' AS "기호"
FROM dual;

--32 문자열 분리
-- SUBSTR(문자열, 시작번호, 글자수)  // SUBSTRB >>바이트
SELECT SUBSTR('www.alohacampus.com',1,3) AS "1"
      ,SUBSTR('www.alohacampus.com',5,11) AS "2"
      ,SUBSTR('www.alohacampus.com',-3,3) AS "3"
FROM dual;

SELECT SUBSTRB('www.alohacampus.com',1,3) AS "1"
      ,SUBSTRB('www.alohacampus.com',5,11) AS "2"
      ,SUBSTRB('www.alohacampus.com',-3,3) AS "3"
FROM dual;

SELECT SUBSTR('www.알로하캠퍼스.com',1,3) AS "1"
      ,SUBSTR('www.알로하캠퍼스.com',5,6) AS "2"
      ,SUBSTR('www.알로하캠퍼스.com',-3,3) AS "3"
FROM dual;

SELECT SUBSTRB('www.알로하캠퍼스.com',1,3) AS "1"
      ,SUBSTRB('www.알로하캠퍼스.com',5,6*3) AS "2"
      ,SUBSTRB('www.알로하캠퍼스.com',-3,3) AS "3"
FROM dual;

--33 문자위치 구하기
--INSTR(문자열, 찾을문자, 시작번호, 순서)
SELECT INSTR('ALOHACAMPUS','A',1,1) AS "1번째"
      ,INSTR('ALOHACAMPUS','A',1,2) AS "2번째"
      ,INSTR('ALOHACAMPUS','A',1,3) AS "3번째"
FROM dual;

--34
--LPAD(문자열, 글자수, 빈공간의 값) >>왼쪽채움 //RPAD(문자열, 글자수, 빈공간의 값) >>오른쪽채움
SELECT LPAD('ALOHACAMPUS',20,'#') AS "왼쪽"
      ,RPAD('ALOHACAMPUS',20,'#') AS "오른쪽"
      ,RPAD('안녕하세요',20,'#') AS "오른쪽"
FROM dual;

--35 
--TO_CHAR(데이터, '날짜/숫자 형식') : 특정 데이터를 문자열 형식으로 변환하는 함수
SELECT first_name As 이름
      ,TO_CHAR(hire_date, 'YYYY-MM-DD (dy) HH:MI:SS') As 입사일자
FROM employees;

--36 숫자열 > 문자열
SELECT first_name  이름
      ,TO_CHAR(salary, '$999,999,999.00') 급여
FROM employees;

--37 문자형 > 날짜형
--TO_DATE(데이터) : 문자형 데이터를 날짜형 데이터로 변환하는 함수
--*해당 문자형 데이터를 날짜형으로 분석할 수 있는 형식을 지정해야함.
SELECT 20230822 AS 문자
      ,TO_DATE('20230822', 'YYYYMMDD') AS 날짜
      ,TO_DATE('2023.08.22', 'YYYY.MM.DD') AS 날짜2
      ,TO_DATE('2023/08/22', 'YYYY/MM/DD') AS 날짜3
      ,TO_DATE('2023-08-22', 'YYYY-MM-DD') AS 날짜4
FROM dual;

--38 문자형 > 숫자형
--TO_NUMBER(데이터, 형식) : 문자형 데이터를 숫자형 데이터로 변환하는 함수
SELECT '1,200,000' AS 문자
      ,TO_NUMBER('1,200,000', '999,999,999') AS 숫자
FROM dual;

--39 현재날짜
--SYSDATE : 현재 날짜/시간 정보를 가지고 있는 키워드
SELECT SYSDATE-1 As 어제
      ,SYSDATE As 오늘
      ,SYSDATE+1 As 내일
FROM dual;

--40
--MONTHS_BETWEEN(A,B) : A부터 B까지 개월 수 차이를 반환하는 함수 ( 단 A > B)
SELECT first_name As 이름
      ,TO_CHAR(hire_date, 'YYYY.MM.DD') As 입사일자
      ,TO_CHAR(SYSDATE, 'YYYY.MM.DD') As 오늘
      ,TRUNC(SYSDATE-hire_date) AS 근무일수
      ,TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) || '개월' AS 근무달수
      ,TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) || '년차' As 근속연수
FROM employees;

--41
--ADD_MONTHS(날짜, 개월 수) : 지정한 날짜로부터 해당 개월 수 후의 날짜를 반환하는 함수
SELECT sysdate 오늘
      ,ADD_MONTHS( SYSDATE, 6 ) "6개월 후"
      ,ADD_MONTHS( SYSDATE, -2 ) "2개월 전"
FROM dual;

SELECT '2023/07/25' 개강
      ,ADD_MONTHS( '2023/07/25' , 6 ) 종강
FROM dual;

--42
--NEXT_DAY(날짜, 요일) : 지정한 날짜 이후 돌아오는 요일을 반환하는 함수
--* 일 월 화 수 목 금 토
--* 1  2 3  4  5  6  7
SELECT sysdate 오늘
      ,NEXT_DAY(SYSDATE, 1) "다음 일요일"
      ,NEXT_DAY(SYSDATE, 2) "다음 월요일"
      ,NEXT_DAY(SYSDATE, 3) "다음 화요일"
      ,NEXT_DAY(SYSDATE, 4) "다음 수요일"
      ,NEXT_DAY(SYSDATE, 5) "다음 목요일"
      ,NEXT_DAY(SYSDATE, 6) "다음 금요일"
      ,NEXT_DAY(SYSDATE, 7) "다음 토요일"
from dual;

--43
--LAST_DAY(날짜) : 지정한 날짜와 동일한 월의 월말 일자를 반환하는 함수
--날짜 : XXXXX.YYYYY
--1970년 01월 01일 00시 00분 00초 00ms > 2023년 08월 22일...
--지난 일자를 정수로 계산, 시간정보는 소수부분으로 계산
--xxxxx.yyyyy 날짜 데이터를 월 단위로 절삭하면, 월초를 구할 수 있다.
SELECT sysdate 오늘
      ,LAST_DAY(SYSDATE) "월말"
      ,TRUNC(SYSDATE,'MM') "월초"
FROM DUAL;

--44
--DISTINCT > 중복제거 / NVL(데이터, 대체문자) > 빈곳 대체 / ORDER BY...DESC >내림차순
SELECT DISTINCT(NVL(commission_pct, 0)) "커미션(%)"
FROM employees
ORDER BY NVL(commission_pct, 0) DESC;

SELECT DISTINCT(NVL(commission_pct, 0)) AS "커미션(%)"
FROM employees
ORDER BY "커미션(%)" DESC;   --SELECT문에서 별칭이 지정되어서 그거를 끌어다 쓸 수 있음
     
--**실행 순서**
--1.FROM    2.WHERE    3.GROUP BY     4.HAVING
--5.SELECT  6.ORDER BY

--45
--NVL2(값, NULL 아닐 때 값, NULL 일 때 값)
SELECT first_name 이름
      ,salary 급여
      ,NVL(commission_pct,0) 커미션
      ,salary + (salary *NVL(commission_pct,0)) 최종급여1
      ,NVL2(commission_pct, salary + salary*commission_pct, salary) 최종급여2
FROM employees
ORDER BY 최종급여2 DESC;

--46
--DEPARTMENTS 테이블을 참조하여, 사원의 이름과 부서명을 출력하시오.
--DECODE(컬럼명, 조건값1, 반환값1, 조건값2, 반환값2...)
--: 지정한 컬럼의 값이 조건값에 일치하면 바로 뒤의 반환값을 출력하는 함수

SELECT first_name 이름
      ,DECODE( department_id, 10, 'Administration',
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

--47
--CASE : 조건식을 만족할 때, 츨력할 값을 지정하는 구문
--CASE
--      WHEN 조건식1 THEN 반환값1
--      WHEN 조건식2 THEN 반환값2
--END
--한줄 복사 : CTRL + SHIFT + D
SELECT first_name 이름
    , CASE WHEN department_id = 10 THEN 'Administration'
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

--48
--COUNT(컬럼명) : 컬럼을 지정하여 NULL을 제외한 데이터 개수를 반환하는 함수
--* NULL이 없는 데이터라면 어떤 컬럼을 지정하더라도 개수가 같기 때문에,
-- 일반적으로, COUNT(*)으로 개수를 구한다.
SELECT COUNT(*) 사원수
      ,COUNT(commission_pct) 커미션받는사원수
      ,COUNT(department_id) 부서가있는사원수
FROM employees;

--49 최대,최소
SELECT MAX(salary) 최대
      ,MIN(salary) 최소
FROM employees;

--50 합계,평균
SELECT SUM(salary) 합계
      ,ROUND(AVG(salary),2) 평균
FROM employees;

--51 표준편차, 분산
SELECT ROUND(STDDEV(salary),2) 표준편차
      ,ROUND(VARIANCE(salary),2) 분산
FROM employees;

--52 MS_STUDENT 테이블 생성
--* 테이블 생성
/*
    CREATE TABLE 테이블명 (
        컬럼명1    타입  [DEFAULT 기본값]    [NOT NULL/NULL] [제약조건],
        컬럼명2    타입  [DEFAULT 기본값]    [NOT NULL/NULL] [제약조건],
        컬럼명3    타입  [DEFAULT 기본값]    [NOT NULL/NULL] [제약조건],
        ...
    );
*/    
CREATE TABLE MS_STUDENT (
    ST_NO       NUMBER          NOT NULL    PRIMARY KEY
    ,NAME       VARCHAR2(20)    NOT NULL
    ,CTZ_NO     CHAR(14)        NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL    UNIQUE
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,DEPT_NO    NUMBER          NOT NULL
    ,MJ_NO      NUMBER          NOT NULL
    ,REG_DATE   DATE        DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE        DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
);

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.CTZ_NO IS '주민등록번호';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.DEPT_NO IS '학부번호';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

DROP TABLE MS_STUDENT;

--53~65 8/22 오후수업 > 조퇴(상담)



--66~69 과제

--70~ joeun.sql 에서 진행(joeun계정 사용)













