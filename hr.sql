--Ŀ�� ���� ����Ű : ctrl+enter
--���� ��ä ���� : F5
SELECT 1+1
FROM dual;

--1. ���� ���� ��ɾ�
--conn ������/��й�ȣ;
conn system/123456;

--2. 
--SQL�� ��/�ҹ��� ������ ����.
--��ɾ� Ű���� �빮��, �ĺ��ڴ� �ҹ��ڷ� �ַ� ����Ѵ�.(���� ��Ÿ�ϴ��)
SELECT user_id, username
FROM all_users
WHERE username = "HR"
;
--HR���� ����
--CREATE USER ������ IDENTIFIED BY ��й�ȣ;

--11g���� ���� : � �̸����ε� ���� ���� ����
--12c���� �̻� : 'c##' ���ξ �ٿ��� ������ �����ϵ��� ��å�� ����

--c##���� ���� �����ϱ�
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER HR IDENTIFIED BY 123456;

--���̺� �����̽� ����
--ALTER USER ������ DEFAULT TABLESPACE users;
ALTER USER HR DEFAULT TABLESPACE users;

--������ ����� �� �մ� �뷮 ����
--HR ������ ��� �뷮�� ���Ѵ�� ����
--ALTER USER ������ QUOTA UNLIMITED ON ���̺����̽�;
ALTER USER HR QUOTA UNLIMITED ON users;

--������ ������ �ο�
--HR ������ connect, resource ������ �ο�
--GRANT ���Ѹ�1, ���Ѹ�2 TO ������;
GRANT connect, resource TO HR;

--���� ����
--DROP USER ������ [CASCADE];
DROP USER HR CASCADE;

--���� ��� ����
--ALTER USER ������ ACCOUNT UNLOCK;
ALTER USER HR ACCOUNT UNLOCK;

--HR ���� ��Ű��(������)��������
--1. SQLPLUS  2. HR������ ���� 3. ��ɾ� �Է�
--@[���]/hr_main.sql
--@? : ����Ŭ�� ��ġ�� �⺻ ���
--@?/demo/schema/human_resources/hr_main.sql
--4. 123456(��й�ȣ)   5. users[tablespace]    6. temp[temp tablespace]
--7. [log ���] - @?/demo/schema/log

--3.
--���̺� EMPLOYEES�� ���̺� ������ ��ȸ�ϴ� SQL���� �ۼ��Ͻÿ�.
DESC employees;

--���̺� employees���� employee_id, first_name�� ��ȸ�ϴ� sql���� �ۼ��Ͻÿ�.
--*������̺��� �����ȣ��, �̸��� ��ȸ
SELECT employee_id, first_name
FROM employees;

--���Ⱑ ������, ����ǥ ��������,
--AS ���� ���� // AS(alias) : ��µǴ� �÷��� ������ ���� ��ɾ�
--4. �ѱ� ��Ī�� �ο��Ͽ� ��ȸ
SELECT employee_id AS "��� ��ȣ",  --���� ������ " " ǥ��
       first_name AS �̸�,
       last_name ��,                --AS ���� ����
       email �̸���,
       phone_number ��ȭ��ȣ,
       hire_date �Ի�����,
       salary �޿�
FROM employees;
--
SELECT *            --(*) [�ֽ��͸�ũ] : ��� �÷� ����
FROM employees;

--5. ���̺� EMPLOYEES�� JOB_ID�� �ߺ��� �����͸� �����ϰ� ��ȸ�ϴ� SQL���� �ۼ��Ͻÿ�.
--* DISTINCT�÷��� : �ߺ��� �����͸� �����ϰ� ��ȸ�ϴ� Ű����
SELECT DISTINCT job_id
FROM employees;

--6. WHERE ���� : ��ȸ ������ �ۼ��ϴ� ����
SELECT *
FROM employees
WHERE salary > 6000;

--7.
SELECT * FROM employees
WHERE salary = 10000;

--8. ORDER BY salary DESC(��������) // first_name ASC(��������)
-- �����ؼ� ���� ���������� �⺻��
SELECT * FROM employees
order by salary DESC, first_name asc;

--9. OR���ǿ��� : WHERE A OR B;
SELECT * FROM employees
WHERE job_id = 'FI_ACCOUNT'
    OR job_id = 'IT_PROG';
--10. OR���ǿ��� : WHERE �÷��� IN('A', 'B');
SELECT * FROM employees
WHERE job_id in('FI_ACCOUNT', 'IT_PROG');

--11. A�� B�� �ƴ� ������ ��ȸ : WHERE �÷��� NOT IN('A', 'B');
SELECT * FROM employees
WHERE job_id NOT IN ('FI_ACCOUNT', 'IT_PROG');

--12. AND���ǿ��� : WHERE A AND B
SELECT * FROM employees
WHERE job_id = 'IT_PROG'
    AND salary >= 6000;
    
--�÷��� LIKE '���ϵ�ī��';  // % : �������� ��ü / _ : �� ���ڸ� ��ü
--13. S�� ����
SELECT * FROM employees
WHERE first_name LIKE 'S%';

--14. s�� ��
SELECT * FROM employees
WHERE first_name LIKE '%s';

--15. s�� ����
SELECT * FROM employees
WHERE first_name LIKE '%s%';

--16. FIRST_NAME�� 5���� (����� 5��)
SELECT * FROM employees
WHERE first_name LIKE '_____';
-- LENGTH(�÷���) : ���� ���� ��ȯ�ϴ� �Լ�
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
WHERE hire_date >= '04/01/01';  --SQL Developer���� ������ �����͸� ��¥�� �����ͷ� �ڵ� ��ȯ
--TO_DATE() : ������ �����͸� ��¥�� �����ͷ� ��ȯ�ϴ� �Լ�
SELECT * FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD');

--20.
SELECT * FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD')
    AND hire_date <= TO_DATE('20051231', 'YYYYMMDD');
-- �÷� BETWEEN A AND B; : A���� ũ�ų� ���� B���� �۰ų� ���� ����(����)
SELECT * FROM employees
WHERE hire_date BETWEEN TO_DATE('20040101', 'YYYYMMDD')
    AND TO_DATE('20051231', 'YYYYMMDD');
    
