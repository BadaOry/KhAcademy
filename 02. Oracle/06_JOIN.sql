/*
    <JOIN>
        두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
        무작정 데이터를 가져오는게 아니라 
        각 테이블 간에 공통된 컬럼으로 데이터를 합쳐서
        하나의 결과 (Result Set)로 조회함
        
        1. 등가 조인 (EQUAL JOIN) / 내부 조인 (INNER JOIN)
           연결시키는 컬럼의 값이 일치하는 행들만 조인되어 조회
           
           1) 오라클 전용 구문
              [표현법]
                 SELECT 컬럼, 컬럼, 컬럼, ...
                 FROM 테이블1, 테이블2
                 WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
                 
               - FROM 절에 조회하고자 하는 테이블들을 콤마(,)로 구분하여 나열
               - WHERE 절에 매칭시킬 컬럼명에 대한 조건 제시
           2) ANSI 표준 구문
              [표현법]
                 SELECT 컬럼, 컬럼, 컬럼, ...
                 FROM 테이블1
                 JOIN 테이블2 ON(테이블1.컬럼명 = 테이블2.컬럼명);
                 
               - FROM절에 기준이 되는 테이블 기술
               - JOIN 절에 같이 조회하고자 하는 테이블 기술 후
                 매칭 시킬 컬럼에 대한 조건 기술
               - 연결에 사용하려는 컬럼명이 같은 경우,
                 ON 구문 대신 USING(컬럼명) 구문 사용
*/

-- 각 사원들의 사번, 사원명, 부서 코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 각 사원들의 사번, 사원명, 부서 코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

-- 1-1) 연결할 두  컬럼이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT테이블을 조인하여
-- 사번, 사원명, 부서 코드, 부서명 조회
-- ▶ 일치하는 값이 없는 행은 조회에서 제외 됨 
--    (DEPT_CODE가 NULL인 사원, DEPT_ID가 D3,D4,D7인 사원)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 오라클 구문
-- 1-2) 연결할 두  컬럼이 같은 경우
-- EMPLOYEE 테이블과 DEPARTMENT테이블을 조인하여
-- 사번, 사원명, 직급 코드, 직급명을 조회
-- 방법 1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME 
--                       ▲ 테이블 안써주면 AMBIGUOUS 에러 남
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블의 별칭을 이용하는 방법
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME 
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI 구문
-- 2-1) 연결할 두  컬럼이 다른 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여
-- 사번, 사원명, 직급 코드, 직급명 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
FROM EMPLOYEE E
/*INNER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID); 

-- 2-2) 연결할 두  컬럼이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여
-- 사번, 사원명, 직급 코드, 직급명 조회
-- 방법 1) USING 구문을 이용하는 방법
SELECT E.EMP_ID, E.EMP_NAME, JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE);
-- ▲ USING 의 경우 같은 컬럼이라고 인식해서 AMBIGUOUSLY 에러 발생하지 않음

-- 방법 2) 테이블의 별칭을 이용하는 방법
SELECT E.EMP_ID, E.EMP_NAME, JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 방법 3) NATURAL JOIN을 이용하는 방법
--          * 잘 안쓰니 참고만 하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB;

-- EMPLOYEE 테이블과 JOB 테이블을 조인하여
-- 직급이 대리인 사원의 사번, 사원명, 직급명, 급여 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리';

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
INNER JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

---------- 실습 문제 ----------
-- 1. DEPARTMENT 테이블과 LOCATION 테이블을 조인하여
--    부서 코드, 부서명, 지역코드, 지역명 조회
-- 오라클 구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_CODE
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI 구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_NAME
FROM DEPARTMENT D
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 2. EMPLOYEE 테이블과 DEPARTEMNT 테이블을 조인해서
--    보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND BONUS IS NOT NULL;

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서
--    인사관리부가 아닌 사람들의 사원명, 부서명, 급여 조회
-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE (E.DEPT_CODE = D.DEPT_ID) AND (D.DEPT_TITLE != '인사관리부');

--  ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID) 
WHERE (DEPT_CODE != 'D1');

-- 4. EMPLOYEE 테이블, DEPARTMENT 테이블, LOCATION 테이블을 조인해서
--    사번, 사원명, 부서명, 지구명(LOCAL_NAME) 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE (E.DEPT_CODE = D.DEPT_ID) 
       AND (D.LOCATION_ID = L.LOCAL_CODE)
       /*AND LOCAL_NAME = 'ASIA1'*/ ;

-- ANSI 구문
-- * 다중 JOIN은 순서가 굉장히 중요함
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
/*WHERE LOCAL_NAME = 'ASIA1'*/;

-- 5. 사번, 사원명, 부서명, 지구명), 국가명 조회 조회
-- 오라클 구문 (오리 버전)
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, L.NATIONAL_CODE
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE (E.DEPT_CODE = D.DEPT_ID)
       AND (D.LOCATION_ID = L.LOCAL_CODE);
       
-- 오라클 구문 (강사님 버전)
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE,
       L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE (E.DEPT_CODE = D.DEPT_ID)
       AND (D.LOCATION_ID = L.LOCAL_CODE)
       AND (L.NATIONAL_CODE = N.NATIONAL_CODE);

-- ANSI 구문 (오리 버전)
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, L.NATIONAL_CODE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- ASNI 구문 (강사님 버전)
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE,
       L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

-- 6. 사번, 사원명, 부서명, 지구명(LOCAL_NAME), 국가명, 급여 등급  조회 
--    * NON EQUAL JOIN 후 실습 진행
-- 오라클 구문
SELECT E.EMP_ID, 
       E.EMP_NAME,
       D.DEPT_TITLE,
       L.LOCAL_NAME,
       N.NATIONAL_NAME,
       S.SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE (E.DEPT_CODE = D.DEPT_ID)
       AND (D.LOCATION_ID = L.LOCAL_CODE)
       AND (L.NATIONAL_CODE = N.NATIONAL_CODE)
       AND (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- ANSI 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역명",
       N.NATIONAL_NAME AS "국가명",
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
INNER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);


-----------------------------------------------------------
/*
        2. 외부 조인 (OUTER JOIN)
           테이블 간의 JOIN시,
           일치하지 않는 행도 포함시켜 조회가 가능
           단, 반드시 기준이 되는 테이블(컬럼)을 지정해야 함 (LEFT / RIGHT / (+))
*/ 
-- OUTER JOIN과 비교할 INNER JOIN 구해놓기
-- ▼ 부서가 지정되지 않은 사원 2명에 대한 정보가 조회되지 않음
--    또한, 부서가 지정되어 있어도 DEPARTMENT에 부서 정보가 없으면 조회되지 않음
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;
                 
-- 1) LEFT (OUTER) JOIN : 두 테이블 중 왼쪽에 기술된 테이블의 컬럼을 기준으로 JOIN 진행
-- ANSI 구문
-- 부서 코드가 없던 사원 (이오리, 하동운)의 정보가 나오게 됨
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E
LEFT /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;
                 
-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);


-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블의 컬럼을 기준으로 JOIN 진행
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E
RIGHT /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있음
--                        단, 오라클 구문은 지원하지 않음
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
FROM EMPLOYEE E
FULL /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 오라클 구문 : 에러 발생
--SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, (E.SALARY * 12)
--FROM EMPLOYEE E, DEPARTMENT D
--WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

/*
        3. 카테시안곱 (CARTESIAN PRODUCT) / 교차 조인 (CROSS JOIN)
           - 조인되는 모든 테이블의 각 행들이 서로 모두 매핑된 데이터 검색 (곱집합)
           - 테이블의 행들이 모두 곱해진 행들의 조합이 출력
             ▷ 방대한 데이터 출력 ▷ 과부화 위험
*/

-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME;

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME;

/*
        4. 비등가 조인 (NON EQUAL JOIN)
           JOIN 조건이 등호(=)를 사용하지 않는 조인문
           지정한 컬럼 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행동을 연결
           (= 이외의 비교연산자 >, <, >=, <=, BETWEEN AND, IN, NOT IN 등 사용)
           ANSI 구문으로는 JOIN ON 구문으로만 사용 가능 (USING 사용 불가)
*/

-- EMPLOYEE 테이블과 SAL_GRADE 테이블을 비등가 조인하여
-- 사원명, 급여, 급여 등급 조회
-- ANSI 구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL, /*S.MIN_SAL, S.MAX_SAL*/
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
-- EMPLOYEE 테이블에서 SALARY가 SAL_GRADE테이블에서
-- S1의 MIN_SAL ~ MAX_SAL 사이인지 확인 후 맞으면 리턴
-- 다르다면 S2, S3... 비교해가면서 리턴

-- 오라클 구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

/*
        5. 자체 조인 (SELF JOIN)
           같은 테이블을 다시 한번 조인하는 경우에 사용
*/

SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- EMPLOYEE 테이블을 SELF JOIN 하여 
-- 사번, 사원 이름, 부서 코드, 사수 사번, 사수 이름 조회
-- ANSI 구문
SELECT E1.EMP_ID AS "사번",
       E1.EMP_NAME AS "사원 이름",
       E1.DEPT_CODE AS "부서 코드",
       E1.MANAGER_ID AS "사수 사번",
       E2.EMP_NAME AS "사수 이름"
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

-- 오라클 구문
SELECT E1.EMP_ID AS "사번",
       E1.EMP_NAME AS "사원 이름",
       E1.DEPT_CODE AS "부서 코드",
       E1.MANAGER_ID AS "사수 사번",
       E2.EMP_NAME AS "사수 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+); -- LEFT OUTER JOIN 추가 (사수없는애들도 조회)

-------------------------종합 실습 문제-------------------------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT * FROM LOCATION;

-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 사원명, 직급명, 부서명, 근무지역, 급여를 조회하세요.
-- ANSI 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지",
       TO_CHAR(E.SALARY, 'L999,999,999') AS "급여"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE J.JOB_NAME = '대리'
      AND L.LOCAL_NAME LIKE 'ASIA%';
      
-- 오라클 구문

-- 2. 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요.
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       E.EMP_NO AS "주민번호",
       D.DEPT_TITLE AS "부서명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID) 
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SUBSTR(E.EMP_NO, 8, 1) = '2'
      AND E.EMP_NO LIKE '7%'
      AND E.EMP_NAME LIKE '전%'; 
      
-- 오라클 구문

-- 3. 보너스를 받는 직원들의 사원명, 보너스, 연봉, 부서명, 근무지역을 조회하세요.
--    단, 부서 코드가 없는 사원도 출력될 수 있게 Outer JOIN 사용
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       NVL(E.BONUS, 0) AS "보너스",
       TO_CHAR(E.SALARY * 12, 'L999,9999,999') AS "연봉",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT OUTER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
-- ▲ LEFT OUTER JOIN 한 번 더 해줘야 함
WHERE E.BONUS IS NOT NULL;

-- 오라클 구문

-- 4. 한국과 일본에서 근무하는 직원들의 사원명, 부서명, 근무지역, 근무 국가를 조회하세요.
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역",
       N.NATIONAL_NAME AS "근무 국가"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME IN('한국','일본');

-- 오라클 구문

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회하세요.
--    단, 부서 배치가 안된 사원들의 평균도 같이 나오게끔 해주세요^^
-- ANSI 구문
SELECT NVL(D.DEPT_TITLE, '부서없음') AS "부서명",
       TO_CHAR(ROUND(AVG(E.SALARY)), 'L999,999,999') AS "평균 급여"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY D.DEPT_TITLE
ORDER BY D.DEPT_TITLE;

-- 오라클 구문

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회하시오.
-- ANSI 구문
SELECT D.DEPT_TITLE AS "부서명",
       TO_CHAR(SUM(E.SALARY), 'L999,999,999') AS "급여의 합"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID) 
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000
ORDER BY D.DEPT_TITLE;

-- 오라클 구문

-- 7. 사번, 사원명, 직급명, 급여 등급, 구분을 조회 (NON EQUAL JOIN 후에 실습 진행)
--    이때 구분에 해당하는 값은 아래와 같이 조회 되도록 하시오.
--    급여 등급이 S1, S2인 경우 '고급'
--    급여 등급이 S3, S4인 경우 '중급'
--    급여 등급이 S5, S6인 경우 '초급'
-- ANSI 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명", 
       S.SAL_LEVEL AS "급여 등급",
       CASE WHEN S.SAL_LEVEL IN ('S1', 'S2') THEN '고급' 
            WHEN S.SAL_LEVEL IN ('S3', 'S4') THEN '중급' 
            WHEN S.SAL_LEVEL IN ('S5', 'S6') THEN '초급' 
       END AS "구분"      
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- 오라클 구문

-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       E.SALARY AS "급여"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.BONUS IS NULL
      AND E.JOB_CODE IN ('J4', 'J7');

-- 오라클 구문

-- 9. 부서가 있는 직원들의 사원명, 직급명, 부서명, 근무 지역을 조회하시오.
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE E.DEPT_CODE IS NOT NULL;

-- 10. 해외영업팀에 근무하는 직원들의 사원명, 직급명, 부서 코드, 부서명을 조회하시오
-- ANSI 구문
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       E.DEPT_CODE AS "부서 코드",
       D.DEPT_TITLE AS "부서명"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE) 
WHERE DEPT_TITLE LIKE '해외영업%';

-- 오라클 구문


-- 11. 이름에 '형'자가 들어있는 직원들의 사번, 사원명, 직급명을 조회하시오.
-- ANSI 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_NAME LIKE '%형%';

-- 오라클 구문

