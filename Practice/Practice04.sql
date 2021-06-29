/*문제1. 평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요. (56건)*/
SELECT
    COUNT(*) "직원수"
FROM
    employees
WHERE salary < (SELECT
                    AVG(salary)
                FROM  
                    employees);
/*문제2. 평균급여 이상, 최대급여 이하의 월급을 받는 사원의 
직원번호(employee_id), 이름(first_name), 급여(salary), 
평균급여, 최대급여를 급여의 오름차순으로 정렬하여 출력하세요 (51건)*/
SELECT
    emp.employee_id "직원 번호",
    emp.first_name "이름",
    emp.salary "급여",
    am.av "평균 급여",
    am.ma "최대 급여"
FROM
    employees emp,
    (SELECT
        AVG(salary) av,
        MAX(salary) ma
     FROM
        employees) am
WHERE salary BETWEEN am.av
  AND am.ma
ORDER BY emp.salary asc;

/*문제3. 직원중 Steven(first_name) king(last_name)이 소속된 
부서(departments)가 있는 곳의 주소를 알아보려고 한다.
도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 
도시명(city), 주(state_province), 나라아이디(country_id) 를 출력하세요 (1건)*/
SELECT
    lo.location_id "도시 아이디",
    lo.street_address "거리명",
    lo.postal_code "우편번호",
    lo.city "도시명",
    lo.state_province "주",
    lo.country_id "나라 아이디"
FROM
    employees em LEFT JOIN departments de 
    ON em.department_id = de.department_id
    LEFT JOIN locations lo
    ON de.location_id = lo.location_id
WHERE first_name = 'Steven'
  AND last_name = 'King';

SELECT
    location_id "도시 아이디",
    street_address "거리명",
    postal_code "우편번호",
    city "도시명",
    state_province "주",
    country_id "나라 아이디"
FROM
    locations
WHERE location_id = (SELECT
                        location_id
                     FROM
                        departments
                     WHERE department_id = (SELECT
                                                department_id
                                            FROM
                                                employees
                                            WHERE first_name = 'Steven'
                                              AND last_name = 'King'));

/*문제4. job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,
이름,급여를 급여의 내림차순으로 출력하세요  -ANY연산자 사용 (74건)*/
SELECT
    employee_id "사번",
    first_name "이름",
    salary "급여"
FROM
    employees
WHERE salary < ANY(SELECT
                        salary
                   FROM
                        employees
                   WHERE job_id = 'ST_MAN')
ORDER BY salary DESC;

/*문제5. 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 
이름(first_name)과 급여(salary) 부서번호(department_id)를 조회하세요 
단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다. 
조건절비교, 테이블조인 2가지 방법으로 작성하세요 (11건)*/
--조건절 비교
SELECT
    employee_id "사번",
    first_name "이름",
    salary "급여",
    department_id "부서번호"
FROM
    employees
WHERE (department_id, salary) IN (SELECT
                                    department_id,
                                    MAX(salary)
                                  FROM
                                    employees
                                  GROUP BY department_id)
ORDER BY salary DESC;
--테이블 조인
SELECT
    em.employee_id "사번",
    em.first_name "이름",
    em.salary "급여",
    em.department_id "부서번호"
FROM
    employees em,(SELECT
                    department_id,
                    MAX(salary) salary
                  FROM
                    employees
                  GROUP BY department_id)dm
WHERE em.department_id = dm.department_id
  AND em.salary = dm.salary
ORDER BY em.salary DESC;  

/*문제6. 각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다. 
연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오 (19건)*/
SELECT
    js.job_title "업무",
    ss.sum_salary "급여 총합"
FROM
    jobs js, (SELECT
                    job_id,
                    SUM(salary) sum_salary
              FROM
                    employees
              GROUP BY job_id) ss
WHERE js.job_id = ss.job_id
ORDER BY ss.sum_salary DESC;

/*문제7. 자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 
직원번호(employee_id), 이름(first_name)과 급여(salary)을 조회하세요 (38건)*/
SELECT
    em.employee_id "사번",
    em.first_name "이름",
    em.salary "급여"
FROM
    employees em, (SELECT
                        department_id,
                        AVG(salary) salary
                   FROM
                        employees
                   GROUP BY department_id) avs
WHERE em.department_id = avs.department_id
  AND em.salary > avs.salary;

/*문제8. 입사일이 11번째에서 15번째인 직원의
사번, 이름, 급여, 입사일을 입사일 순서로 출력하세요*/
SELECT
    employee_id,
    first_name,
    salary,
    hire_date
FROM
    employees
ORDER BY hire_date asc;

SELECT
    ROWNUM,
    oh.hire_date
FROM
    (SELECT
        hire_date
     FROM
        employees
     ORDER BY hire_date asc) oh;
SELECT
    ohr.*
FROM
    (SELECT
        ROWNUM rn,
        oh.*
     FROM
        (SELECT
            employee_id "사번",
            first_name "이름",
            salary "급여",
            hire_date "고용일"
         FROM
            employees
         ORDER BY hire_date asc) oh) ohr
WHERE   ohr.rn >= 11
  AND   ohr.rn <= 15;