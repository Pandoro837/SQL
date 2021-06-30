/*문제1. 담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의 
이름, 매니저아이디, 커미션 비율, 월급 을 출력하세요. (45건)*/
SELECT
    first_name "이름",
    manager_id "매니저 아이디",
    commission_pct "커미션 비율",
    salary "월급"
FROM
    employees
WHERE manager_id is not null
  AND commission_pct is null
  AND salary > 3000;
  
/*문제2. 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 
이름(first_name), 급여(salary), 입사일(hire_date), 전화번호(phone_number), 
부서번호(department_id) 를 조회하세요 
-조건절비교 방법으로 작성하세요
-급여의 내림차순으로 정렬하세요
-입사일은 2001-01-13 토요일 형식으로 출력합니다.
-전화번호는 515-123-4567 형식으로 출력합니다. (11건)*/
SELECT
    first_name "이름",
    salary "급여",
    to_char(hire_date, 'yyyy-mm-dd day') "입사일",
    replace(phone_number, '.', '-')  "전화번호",
    department_id "부서번호"
FROM
    employees
WHERE (department_id, salary) 
   IN (SELECT
            department_id,
            MAX(salary)
       FROM
            employees
       GROUP BY department_id)
ORDER BY salary DESC;

/*문제3. 매니저별 담당직원들의 평균급여 최소급여 최대급여를 알아보려고 한다.
-통계대상(직원)은 2005년 이후(2005년 1월 1일 ~ 현재)의 입사자 입니다.
-매니저별 평균급여가 5000이상만 출력합니다.
-매니저별 평균급여의 내림차순으로 출력합니다.
-매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-출력내용은 매니저아이디, 매니저이름(first_name), 매니저별평균급여, 
매니저별최소급여, 매니저별최대급여 입니다. (9건)*/
SELECT
    ma.manager_id "매니저 아이디",
    em.first_name "매니저 이름",
    ma.avg_salary "매니저별 평균 급여",
    ma.min_salary "매니저별 최소 급여",
    ma.max_salary "매니저별 최대 급여"
FROM
    employees em,
    (SELECT
        manager_id,
        round(AVG(salary), 1) avg_salary,
        MIN(salary) min_salary ,
        MAX(salary) max_salary
     FROM
        employees
     WHERE hire_date >= '050101'
     GROUP BY manager_id) ma
WHERE em.employee_id = ma.manager_id
  AND ma.avg_salary >= 5000
ORDER BY ma.avg_salary DESC;

/*문제4. 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 
부서명(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)도 표시합니다. (106명)*/
SELECT
    em.employee_id "사번",
    em.first_name "이름",
    de.department_name "부서명",
    ma.first_name "매니저 이름"
FROM
    employees em LEFT OUTER JOIN departments de --부서가 없는 직원도 표시되어야 하기 때문에, em을 기준으로 잡는다
    ON em.department_id = de.department_id,
    employees ma
WHERE em.manager_id = ma.employee_id;

/*문제5. 2005년 이후 입사한 직원중에 입사일이 11번째에서 20번째의 직원의 
사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요*/
SELECT
    ehr.*
FROM
    (SELECT
        ROWNUM rn,
        eh.*
     FROM
        (SELECT
            em.employee_id "사번",
            em.first_name "이름",
            de.department_name "부서명",
            em.salary "급여",
            em.hire_date "입사일"
         FROM
            employees em 
            LEFT OUTER JOIN departments de
            ON em.department_id = de.department_id
         WHERE hire_date >= '050101'
         ORDER BY hire_date ASC) eh) ehr
WHERE ehr.rn >= 11
  AND ehr.rn <= 20;

/*문제6. 가장 늦게 입사한 직원의 이름(first_name last_name)과 
연봉(salary)과 근무하는 부서 이름(department_name)을 출력하세요*/
SELECT
    em.first_name
    || ' ' ||
    em.last_name "이름",
    em.salary "연봉",
    de.department_name "부서 이름",
    em.hire_date
FROM
    employees em, departments de
WHERE em.department_id = de.department_id
  AND em.hire_date IN (SELECT
                            MAX(hire_date)
                       FROM
                            employees);