--70
--joeun 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER joeun IDENTIFIED BY 123456;
ALTER USER joeun QUOTA UNLIMITED ON users;
GRANT DBA TO joeun;

--덤프 파일 import하기 (CMD 에서 실행)
--imp userid=관리자계정/비밀번호 file=[덤프파일경로] fromuser=덤프소유계정 touser=임포트할계정
imp userid=system/123456 file=D:\subin\SQL\community.dmp fromuser=joeun touser=joeun

--71
--exp userid=생셩계정/비밀번호 file=덤프파일경로 log=로그파일경로
--생성계정은 import할 때 fromuser로 쓰인다.
exp userid=joeun/123456 file=D:\subin\SQL\community2.dmp log=D:\subin\SQL\community2.log

--72
--MS_BOARD테이블의 WRITER 속성의 타입 변경
ALTER TABLE MS_BOARD MODIFY WRITER NUMBER;
--1) MS_USER의 USER_NO를 참조하는 외래키 지정
--ALTER TABLE 테이블명 ADD CONSTRINST 제약조건명
--FOREIGN KEY(외래키컬럼) REFERENCES 참조테이블(기본키);
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY(WRITER) REFERENCES MS_USER(USER_NO);

--2)외래키 : MS_FILE(BOARD_NO) > MS_BOARD(BOARD_NO)
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

--3)외래키 : MS_REPLY (BOARD_NO) > MS_BOARD (BOARD_NO)
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

--73
ALTER TABLE MS_USER ADD CTZ_NO CHAR(14) NULL UNIQUE;
ALTER TABLE MS_USER MODIFY CTZ_NO NULL;
ALTER TABLE MS_USER ADD GENDER CHAR(6) NOT NULL;
ALTER TABLE MS_USER MODIFY GENDER NULL;

COMMENT ON COLUMN MS_USER.CTZ_NO IS '주민번호';
COMMENT ON COLUMN MS_USER.GENDER IS '성명';

DESC MS_USER;

--74 체크제약조건
ALTER TABLE MS_USER ADD CONSTRAINT MS_USER_GENDER_CHECK
CHECK (gender IN ('여', '남', '기타'));

--75
ALTER TABLE MS_FILE ADD EXT VARCHAR2(10) NULL;
COMMENT ON COLUMN MS_FILE.EXT IS '확장자';

--76 테이블 MS_FILE의 FILE_NAME 속성에서 확장자를 추출하여 EXT속성에 UPDATE하는 SQL문 작성
MERGE INTO MS_FILE T        --대상 테이블 지정
--사용할 데이터의 자원을 지정
USING ( SELECT FILE_NO, FILE_NAME FROM MS_FILE) F
-- ON (update 될 조건)
ON (T.FILE_NO = F.FILE_NO)
--매치조건에 만족한 경우
WHEN MATCHED THEN
    --SUBSTR( 문자열, 시작번호)
    UPDATE SET T.EXT = SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1)
    DELETE WHERE SUBSTR(F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) +1)
            NOT IN ('jpeg', 'jpg', 'gif', 'png')
--WHEN NOT MATCHED THEN
--(매치가 안 될 때,)
;

select * from ms_file;

--파일 추가
INSERT INTO MS_FILE( FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT)
VALUES (1, 1, '강아지.png', '123', sysdate, sysdate, '---');

INSERT INTO MS_FILE( FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT)
VALUES (2, 1, 'Main.fxml', '123', sysdate, sysdate, '---');

--게시글 추가
INSERT INTO MS_BOARD( BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT, DEL_YN, DEL_DATE, REG_DATE, UPD_DATE)
VALUES (1, '제목', '내용', 1, 0, 0, 'N', NULL, sysdate, sysdate);

--유저 추가
INSERT INTO MS_USER( USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER)
VALUES (1, 'JOEUN', '123456', '김조은', TO_DATE('2020/01/01', 'YYYY/MM/DD'),
        '010-1234-1234', '부평', sysdate, sysdate, '200101-334444', '남');

select * from ms_user;
select * from ms_board;
select * from ms_file;

--77 테이블 MS_FILE의 EXT 속성이 ('jpg', 'jpeg', 'gif', png')값을 갖도록 하는 제약조건 추가
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_EXT_CHECK
CHECK( EXT IN('jpg', 'jpeg', 'gif', 'png'));

INSERT INTO MS_FILE( FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT)
VALUES (3, 1, 'Main.fxml', '123', sysdate, sysdate, 'java');

INSERT INTO MS_FILE( FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT)
VALUES (4, 1, '고양이.jpg', '123', sysdate, sysdate, 'jpg');

--78 테이블의 행 삭제 ( 참조하고 있는 테이블부터 삭제해야함)
TRUNCATE TABLE MS_USER;  --내부에 있는 데이터 삭제 //DROP TABLE은 구조 자체 삭제
TRUNCATE TABLE MS_BOARD;
TRUNCATE TABLE MS_FILE;
TRUNCATE TABLE MS_REPLY;

DELETE FROM MS_USER;
DELETE FROM MS_BOARD;
DELETE FROM MS_FILE;
DELETE FROM MS_REPLY;

SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;
/*
    DELETE vs TRUNCATE
    * DELETE    - 데이터 조작어(DML)
    -한 행 단위로 데이터를 삭제한다.
    -COMMIT, ROLLBACK을 이용하여 변경사항을 적용하거나 되돌릴 수 있다.
    
    *TRUNCATE   - 데이터 정의어(DDL)
    -모든 행을 삭제한다.
    -삭제한 데이터를 되돌릴 수 없다.
*/

--79 테이블 속성 삭제
ALTER TABLE MS_BOARD DROP COLUMN WRITER;
ALTER TABLE MS_FILE DROP COLUMN BOARD_NO;
ALTER TABLE MS_REPLY DROP COLUMN BOARD_NO;

--80 참조테이블 삭제 시, 연결된 속성의 값도 삭제하는 제약조건 추가
--1) MS_BOARD에 WRITER 속성 추가
ALTER TABLE MS_BOARD ADD WRITER NUMBER NOT NULL;
-- WRITER 속성을 외래키로 지정
-- +참조테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_BOARD
ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO)
ON DELETE CASCADE;
-- ON DELET [NO ACTION, RESTRICT, CASCADE, SET NULL]
-- * RESTRICT : 자식 테이블의 데이터가 존재하면, 삭제 안함
-- * CASCADE : 자식 테이블의 데이터도 함께 삭제
-- * SET NULL : 자식 테이블의 데이터를 NULL로 변경

--2) MS_FILE테이블에 BOARD_NO 추가
ALTER TABLE MS_FILE ADD BOARD_NO NUMBER NOT NULL;

ALTER TABLE MS_FILE
ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

--3) MS_REPLY테이블에 BOARD_NO 속성 추가 
ALTER TABLE MS_REPLY ADD BOARD_NO NUMBER NOT NULL;

ALTER TABLE MS_REPLY
ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE;

--회원탈퇴
DELETE FROM MS_USER WHERE USER_NO = 1;
--ON DELETE CASCADE 옵션으로 외래키 지정 지, MS_USER데이터를 삭제하면, MS_BOARD의 참조된 데이터도 연쇄적으로 삭제한다.
--MS_USER 데이터를 삭제되면, MS_FILR, MS_REPLY 에 참조된 데이터도 연쇄적으로 삭제된다.

--외래키 제약조건 정리
ALTER TABLE 테이블면
ADD CONSTRAINT 제약조건명 FOREIGN KEY(외래키 속성)
REFERENCES 참조테이블(참조 속성);

--옵션
-- ON UPDATE            -- 참조 테이블 수정 시,
-- * CASCADE           : 자식 데이터 수정
-- * SET NULL          : 자식 데이터는 NULL
-- * SET DEFAULT       : 자식 데이터는 기본값
-- * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION         : 아무런 행위도 취하지 않음(생략)

-- ON DELETE
-- * CASCADE           : 자식 데이터 삭제
-- * SET NULL          : 자식 데이터는 NULL
-- * SET DEFAULT       : 자식 데이터 기본값
-- * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
-- * NO ACTION         : 아무런 행위도 취하지 않음(생략)

--81 서브쿼리
/*
    > 서브 쿼리 (Sub Query; 하위 질의)
    : SQL 문 내부에 사용하는 SELECT 문
    * 메인쿼리 : 서브쿼리를 사용하는 최종적인 SELECT문
    
    * 서브쿼리 종류
    - 스칼라 서브쿼리 : SELECT 절에서 사용하는 서브쿼리
    - 인라인 뷰 : FROM 절에서 사용하는 서브쿼리
    - 서브 쿼리 : WHERE 절에서 사용하는 서브쿼리
*/
--파일 임포트 (cmd로 실행)
imp userid=system/123456 file=D:\subin\SQL\joeun.dmp fromuser=joeun touser=joeun

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM job;

SELECT emp_id 사원번호
      ,emp_name 직원명
      ,(SELECT dept_title FROM department d WHERE d.dept_id = e.dept_code) 부서명
      ,(SELECT job_name FROM job j WHERE j.job_code = e.job_code) 직급명
FROM employee e;

--82
--1)부서별로 최고급여를 조회
SELECT dept_code
      ,MAX(salary) MAX_SAL
      ,MIN(salary) MIN_SAL
      ,AVG(salary) AVG_SAL
FROM employee
GROUP BY dept_code;
--2)부서별 최고급여 조회결과를 서브쿼리(인라인뷰)로 지정
SELECT emp_id 사원번호
      ,emp_name 직원명
      ,dept_title 부서명
      ,salary 급여
      ,max_sal 최대급여
      ,min_sal 최저급여
      ,ROUND(avg_sal,2) 평균급여
FROM employee e, department d,
    (SELECT dept_code
            ,MAX(salary) MAX_SAL
            ,MIN(salary) MIN_SAL
            ,AVG(salary) AVG_SAL
     FROM employee
     GROUP BY dept_code) t
WHERE e.dept_code = d.dept_id
  AND e.salary = t.max_sal;

--83
SELECT dept_code
FROM employee
WHERE emp_name = '이태림';

SELECT emp_id 사원번호 
      ,emp_name 직원명
      ,email 이메일
      ,phone 전화번호  
FROM employee
WHERE dept_code =
(SELECT dept_code
FROM employee
WHERE emp_name = '이태림')
;

--84
--1)서브쿼리 사용
SELECT dept_id 부서번호
      ,dept_title 부서명
      ,location_id 지역ID
FROM department
WHERE dept_id IN
(SELECT DISTINCT dept_code
FROM employee
WHERE dept_code IS NOT NULL)
ORDER BY dept_id ASC;

--사원이 있는 부서 뽑아내기 (서브쿼리)
SELECT DISTINCT dept_code
FROM employee
WHERE dept_code IS NOT NULL;

--2)EXISTS 사용
SELECT dept_id 부서번호
      ,dept_title 부서명
      ,location_id 지역ID
FROM department d
WHERE EXISTS
(SELECT * FROM employee e
WHERE e.dept_code = d.dept_id)
ORDER BY dept_id ASC;

--85
SELECT dept_id 부서번호
      ,dept_title 부서명
      ,location_id 지역ID
FROM department
WHERE dept_id NOT IN
(SELECT DISTINCT dept_code
FROM employee
WHERE dept_code IS NOT NULL)
ORDER BY dept_id ASC;

SELECT dept_id 부서번호
      ,dept_title 부서명
      ,location_id 지역ID
FROM department d
WHERE NOT EXISTS
(SELECT * FROM employee e
WHERE e.dept_code = d.dept_id)
ORDER BY dept_id ASC;

--86
SELECT MAX(salary)
FROM employee
WHERE dept_code = 'D1';

SELECT emp_id 사원번호
      ,emp_name 직원명
      ,dept_code 부서번호
      ,dept_title 부서명
      ,TO_CHAR(salary, '999,999,999') 급여
FROM employee e, department d
WHERE e.dept_code = d.dept_id 
AND salary >
(SELECT MAX(salary)
FROM employee
WHERE dept_code = 'D1');

--87
--ANY : 조건이 만족하는 값이 하나라도 있으면 결과를 출력하는 연산자
SELECT emp_id 사원번호
      ,emp_name 직원명
      ,dept_code 부서번호
      ,dept_title 부서명
      ,TO_CHAR(salary, '999,999,999') 급여
FROM employee e, department d
WHERE e.dept_code = d.dept_id 
AND salary > 
ANY(SELECT salary  
    FROM employee
    WHERE dept_code = 'D9');

--ALL : 모든 조건을 만족할 때, 결과를 출력하는 연산자
SELECT emp_id 사원번호
      ,emp_name 직원명
      ,dept_code 부서번호
      ,dept_title 부서명
      ,TO_CHAR(salary, '999,999,999') 급여
FROM employee e, department d
WHERE e.dept_code = d.dept_id 
AND salary > 
ALL(SELECT salary  
    FROM employee
    WHERE dept_code = 'D1');

--88 테이블1 LEFT JOIN 테이블2 ON 조건
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,NVL(d.dept_id, '(없음)') 부서번호
      ,NVL(d.dept_title, '(없음)') 부서명
FROM employee e LEFT JOIN department d
                ON (e.dept_code = d.dept_id);

--89 RIGHT JOIN
SELECT NVL(e.emp_id, '(없음)') 사원번호
      ,NVL(e.emp_name, '(없음)') 직원명
      ,NVL(d.dept_id, '(없음)') 부서번호
      ,NVL(d.dept_title, '(없음)') 부서명
FROM employee e RIGHT JOIN department d
                ON (e.dept_code = d.dept_id);
                
--90 FULL JOIN
SELECT NVL(e.emp_id, '(없음)') 사원번호
      ,NVL(e.emp_name, '(없음)') 직원명
      ,NVL(d.dept_id, '(없음)') 부서번호
      ,NVL(d.dept_title, '(없음)') 부서명
FROM employee e FULL JOIN department d
                ON (e.dept_code = d.dept_id);

--91 사원번호, 직원명, 부서번호, 지역명, 국가명, 급여, 입사일자 출력
-- 지역명 : LOCATION.local_name
-- 국가명 : NATIONAL.national_name
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_id 부서번호
      ,d.dept_title 부서명
      ,l.local_name 지역명
      ,e.salary 급여
      ,e.hire_date 입사일자
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    LEFT JOIN location l ON d.location_id = l.local_code
    LEFT JOIN national n ON l.national_code = n.national_code;
    
--92
--1) manager_id 컬럼이 NULL이 아닌 사원을 중복없이 조회
SELECT DISTINCT manager_id
FROM employee
WHERE manager_id IS NOT NULL;
--2) employee, department, job 테이블을 조인하여 조회
SELECT *
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code;
--3) emp_id가 매니저 사원번호인 경우만을 조회
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,'매니저' 구분
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code
WHERE emp_id IN (SELECT DISTINCT manager_id
FROM employee
WHERE manager_id IS NOT NULL);

--93
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,'사원' 구분
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code
WHERE emp_id NOT IN (SELECT DISTINCT manager_id
FROM employee
WHERE manager_id IS NOT NULL);

--94 UNION 사용
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,'매니저' 구분
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code
WHERE emp_id IN (SELECT DISTINCT manager_id
FROM employee
WHERE manager_id IS NOT NULL)
UNION 
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,'사원' 구분
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code
WHERE emp_id NOT IN (SELECT DISTINCT manager_id
FROM employee
WHERE manager_id IS NOT NULL);

--95 CASE 사용
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,CASE
            WHEN emp_id IN (SELECT DISTINCT manager_id
                                FROM employee
                                WHERE manager_id IS NOT NULL)
                 THEN '매니저'
            ELSE '사원'
            END 구분
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j ON e.job_code = j.job_code;

--96
SELECT e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,CASE WHEN emp_id IN (SELECT DISTINCT manager_id
                                FROM employee
                                WHERE manager_id IS NOT NULL)
                 THEN '매니저'
            ELSE '사원'
            END 구분
      ,CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','3') THEN '남성'
            WHEN SUBSTR(e.emp_no,8,1) IN ('2','4') THEN '여성'
            END 성별
      ,TO_CHAR(sysdate, 'YYYY')
       - TO_NUMBER
            (CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '19'
                  WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '20'
             END 
            || (SUBSTR(e.emp_no,1,2)) )+1 현재나이
      ,TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(
                     CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '19'
                          WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '20'
                     END || SUBSTR(emp_no,1,6))) / 12) 만나이
      ,RPAD(SUBSTR(e.emp_no,1,8),14,'*') 주민등록번호
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j USING(job_code);
--join 테이블 on 컬럼명=컬럼명
--join 테이블 using(컬럼명) >> 컬럼명이 같을 때, using으로 사용 가능

--만 나이
SELECT emp_name
      ,TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(
                     CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '19'
                          WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '20'
                     END || SUBSTR(emp_no,1,6))) / 12) 만나이
FROM employee e;

--97
SELECT ROWNUM 순번
      ,e.emp_id 사원번호
      ,e.emp_name 직원명
      ,d.dept_title 부서명
      ,j.job_name 직급
      ,CASE WHEN emp_id IN (SELECT DISTINCT manager_id
                                FROM employee
                                WHERE manager_id IS NOT NULL)
                 THEN '매니저'
            ELSE '사원'
            END 구분
      ,CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','3') THEN '남성'
            WHEN SUBSTR(e.emp_no,8,1) IN ('2','4') THEN '여성'
            END 성별
      ,TO_CHAR(sysdate, 'YYYY')
       - TO_NUMBER
            (CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '19'
                  WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '20'
             END 
            || (SUBSTR(e.emp_no,1,2)) )+1 현재나이
      ,TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(
                     CASE WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '19'
                          WHEN SUBSTR(e.emp_no,8,1) IN ('1','2') THEN '20'
                     END || SUBSTR(emp_no,1,6))) / 12) 만나이
      ,TRUNC(MONTHS_BETWEEN(sysdate, hire_date) / 12) 근속년수
      ,RPAD(SUBSTR(e.emp_no,1,8),14,'*') 주민등록번호
      ,TO_CHAR(e.hire_date, 'YYYY.MM.DD') 입사일자
      --연봉 : (급여 + (급여*보너스))*12
      ,TO_CHAR((salary + NVL(salary*bonus, 0))*12, '999,999,999,999') 연봉
FROM employee e
    LEFT JOIN department d ON e.dept_code = d.dept_id
    JOIN job j USING(job_code);