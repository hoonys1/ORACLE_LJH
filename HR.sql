
-- ���� ����Ű : ctrl + enter
-- ���� ��ü ���� : F5
SELECT 1+1
FROM dual;

-- 1. ���� ���� ��ɾ�
-- conn ������/��й�ȣ;
conn system/123456;

-- 2. 
-- SQL �� ��/�ҹ��� ������ ����.
-- ��ɾ� Ű���� �빮��, �ĺ��ڴ� �ҹ��� �ַ� ����Ѵ�. (���� ��Ÿ�ϴ��)
SELECT user_id, username
FROM all_users
--WHERE username = 'HR';

-- ����� ���� ����
-- 11g ���� ����: � �̸����ε� ���� ���� ����
-- 12c ���� �̻�: 'c##'���ξ �ٿ��� ������ �����ϵ��� ��å�� ����
-- c## ���� ���� ����
ALTER SESSION SET '_ORACLE_SCRIPT' = TRUE;

-- CREATE USER ������ IDENTIFIED BY ��й�ȣ;
CREATE USER HR IDENTIFIED BY 123456;

-- ���̺� �����̽� ����
-- ALTER USER ������ DEFAULT TABLESPACE users;
ALTER USER HA DEFAULT TABLESPACE users;

-- ������ ����� �� �ִ� �뷮 ����
-- HR ������ ��� �뷮�� ���Ѵ�� ����
SELECT user_id, username
FROM all_users
--WHERE username = 'HR';
ALTER USER HR QUATA UNLIMIED ON users;

-- ������ ������ �ο�
-- HR ������ connect, resource ������ �ο�
-- GRANT ���Ѹ�1, ���Ѹ�2 TO ������;
GRANT connect, resource TO HR;

-- HR �⺻ ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER HR IDENTIFIED BY 123456;
ALTER USER HR DEFAULT TABLESPACE users;
ALTER USER HR QUOTA UNLIMITED ON users;
GRANT connect, resource TO HR;

-- ���� ����
-- DROP USER ������ [CASCADE]
-- HR ���� ����
DROP USER HR CASCADE;

-- ���� ��� ����
-- ALTER USER ������ ACCOUNT UNLOCK;
ALTER USER HR ACCOUNT UNLOCK;

-- HR ���� ��Ű��(������) ��������
-- 1. SQL PLUS
-- 2. HR ������ ����
-- 3. ��ɾ� �Է�
-- @[���]/hr_main.sql
-- @ : ����Ŭ�� ��ġ�� �⺻ ���
-- @?/demo/schema/human_resources/hr_main.spl
-- 4. 123456[��й�ȣ]
-- 5. users[tablespace]
-- 6. temp[temp tablespace]
-- 7. [log ���]-@?/demo/schema/log


-- 3.��
-- ���̺� EMPLOYEES �� ���̺� ������ ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.
DESC employees;

-- ���̺� EMPLOYEES ���� EMPLOYEES_ID, FFIRST_NAME (ȸ����ȣ, �̸�) �� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.
SELECT employee_id, first_name
FROM employees;

-- 4. EMPLOYEE_ID AS �����ȣ
-- * ���Ⱑ ������, ����ǥ ��������.(EMPLOYEES_ID ��� ��ȣ (X)) (EMPLOYEES_ID "��� ��ȣ"(O))(EMPLOYEES_ID �����ȣ(O)
-- * �ѱ� ��Ī�� �ο��Ͽ� ��ȸ
-- AS (alias) : ��µǴ� �÷��� ������ ���� ��ɾ�
SELECT employee_id AS "��� ��ȣ" -- ���Ⱑ ������, ""�� ǥ��
      ,first_name AS �̸�         -- * AS ���� ����
      ,last_name AS ��
      ,email AS �̸���
      ,phone_number AS ��ȭ��ȣ
      ,hire_date AS �Ի�����
      ,salary AS �޿�
FROM employees;

-- 
SELECT *        -- (*) [�ֽ��͸�ũ] : ��� Į�� ����
FROM employees;

-- 5.���̺� EMPLOYEES �� JOB_ID�� �ߺ��� �����͸� �����ϰ� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- �ߺ��� ������ DISTINCT    SELECT JOB_ID DISTINCT
-- DISTINCT �÷��� : �ߺ��� �����͸� �����ϰ� ��ȸ�ϴ� Ű����
SELECT DISTINCT job_id
FROM employees;

-- 6. ���̺� EMPLOYEES �� SALARY(�޿�)�� 6000�� �ʰ��ϴ� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- WHERE salary > 6000;
-- WHERE ���� : ��ȸ ������ �ۼ��ϴ� ����
SELECT *
FROM employees
WHERE salary > 6000;

-- 7.���̺� EMPLOYEES �� SALARY(�޿�)�� 10000�� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- SQL ������ ���� �񱳿����� = �ϳ��� �ᵵ �ȴ�.
SELECT *
FROM employees
WHERE salary = 10000;

-- 8. ���̺� EMPLOYEES �� ��� �Ӽ����� SALARY �� �������� �������� �����ϰ�, FIRST_NAME �� �������� �������� �����Ͽ� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- ORDER BY salary DESC, first_name ASC
-- FIRST_NAME �� �������� �������� �����Ͽ� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.
-- ���� ��ɾ�
-- ORDER BY �÷��� [ASC/DESC]
-- * ASC    : ��������
-- * DESC   : ��������
-- * (����)   : ���������� �⺻��
SELECT *
FROM employees
ORDER BY salary DESC, first_name ASC;

-- 9.���̺� EMPLOYEES �� JOB_ID�� ��FI_ACCOUNT�� �̰ų� ��IT_PROG�� �� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�. (HR ���� ���� ������) 
-- ���� ����
-- OR ���� : ~ �Ǵ�, ~�̰ų�
-- WHERE A OR B;
SELECT *
FROM employees
WHERE job_id = 'FI_ACCOUNT' OR job_id = 'IT_PROG';  -- ���� ���Ѱ� '' ���  // ��ɾ �ѿ����� ��ҹ��� ���� ���� ���� ���Ѱ��� ��ҹ��� ���� �ʼ�!!!'fi_account' (X)

-- 10.���̺� EMPLOYEES �� JOB_ID�� ��FI_ACCOUNT�� �̰ų� ��IT_PROG�� �� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�. (HR ���� ���� ������) IN Ű���带 ����Ͽ� SQL ������ �ϼ��Ͻÿ�.
-- * �÷��� IN ('A', 'B')  : OR ������ ��ü�Ͽ� ����� �� �ִ� Ű����
SELECT *
FROM employees
WHERE job_id IN ('FI_ACCOUNT', 'IT_PROG');

-- 11.���̺� EMPLOYEES �� JOB_ID�� ��FI_ACCOUNT�� �̰ų� ��IT_PROG�� �ƴ� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�. (HR ���� ���� ������)  IN Ű���带 ����Ͽ� SQL ������ �ϼ��Ͻÿ�.
-- * �÷��� NOT IN ('A', 'B')  : 'A', 'B' �� ������ ����� ��ȸ
SELECT *
FROM employees
WHERE job_id NOT IN ('FI_ACCOUNT', 'IT_PROG');

-- 12.���̺� EMPLOYEES �� JOB_ID�� ��IT_PROG�� �̸鼭 SALARY �� 6000 �̻��� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�. (HR ���� ���� ������)
-- ���� ����
-- AND ���� : ���ÿ�, ~�̸鼭, �׸���
-- WHERE A AND B;
SELECT *
FROM employees
WHERE job_id = 'IT_PROG' AND SALARY >= 6000;

-- 13. ���̺� EMPLOYEES �� FIRST_NAME �� ��S���� �����ϴ� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- * �÷��� LIKE '���ϵ�ī��';
-- % : ���� ���ڸ� ��ü
-- _ : �� ���ڸ� ��ü
SELECT *
FROM employees
WHERE first_name LIKE 'S%';

-- 14.���̺� EMPLOYEES �� FIRST_NAME �� ��s���� ������ ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE first_name LIKE '%s';

-- 15. ���̺� EMPLOYEES �� FIRST_NAME �� ��s���� ���ԵǴ� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE first_name LIKE '%s%';

-- 16. ���̺� EMPLOYEES �� FIRST_NAME �� 5������ ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE first_name LIKE '_____';

-- LENGTH(�÷���) : ���� ���� ��ȯ�ϴ� �Լ�
SELECT *
FROM employees
WHERE LENGTH(first_name) = 5;

-- 17. ���̺� EMPLOYEES �� COMMISSION_PCT�� NULL �� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
-- COMMISSION_PCT ������ ����
-- NULL Ȯ�� ��� WHERE COMMISSION_PCT = NULL; NULL�� ���� ���⶧���� ������ ���� ���� IS NULL; �� ����ؾ� �Ѵ�
SELECT *
FROM employees
WHERE commission_pct IS NULL;

-- 18. ���̺� EMPLOYEES �� COMMISSION_PCT�� NULL�� �ƴ� ����� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE commission_pct IS NOT NULL;

-- 19.���̺� EMPLOYEES �� ����� HIRE_DATE�� 04�� �̻��� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE hire_date >= '04/01/01';          -- SQL Developer ���� ������ �����͸� ��¥�� �����ͷ� �ڵ� ��ȯ���־� ��� ����
--     DATE Ÿ��     CHAR Ÿ��

-- TO_DATE() : ������ �����͸� ��¥�� �����ͷ� ��ȯ�ϴ� �Լ�
SELECT *
FROM employees
WHERE hire_date >= TO_DATE('20040101', 'YYYYMMDD');
--    DATE Ÿ��          DATE Ÿ��

-- 20. ���̺� EMPLOYEES �� ����� HIRE_DATE�� 04�⵵���� 05�⵵�� ��� �÷��� ��ȸ�ϴ� SQL ���� �ۼ��Ͻÿ�.(HR ���� ���� ������)
SELECT *
FROM employees
WHERE hire_date >= '04/01/01' AND hire_date <= '05/12/31';

-- �÷� BETWEEN A AND B;  : A ���� ũ�ų� ���� B ���� �۰ų� ���� ����(����)
SELECT *
FROM employees
WHERE hire_date BETWEEN '04/01/01' AND '05/12/31';












