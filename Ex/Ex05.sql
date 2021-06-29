--EQUI JOIN --> null 포함되지 않는다
--OUTER JOIN(left, right, full) --> null 포함된다
-- (+)오라클에서는 이 기호로 대체할 수 있다
--SELF JOIN
--자기 자신과 JOIN하기 때문에, ALIAS 필수
SELECT  
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM
    employees emp,
    employees man
WHERE   emp.manager_id = man.employee_id;

/*SubQuery*/
--하나의 SQL 질의문 속에, 다른 SQL 질의문이 포함된 형태
--'Den'보다 많은 급여를 받는 직원의 이름과, 급여를 구하라
--'Den'의 급여, 11000
SELECT  
    salary
FROM
    employees
WHERE	first_name = 'Den';

--11000보다 많은 급여를 받는 사람과 급여
SELECT  
    first_name,
    salary
FROM    
    employees
WHERE   salary > 11000;

--단점) 'Den'의 급여가 바뀔 경우, 급여를 다시 구해야함

--SubQuery를 이용한 방법
--SubQuery의 결과가 하나의 Row인 경우(단일행 SubQuery)
SELECt  
    first_name,
    salary
FROM 
    employees
WHERE	salary > (SELECT  
						salary
              	  FROM    
              	  		employees
              	  WHERE   first_name = 'Den');

--예제) 급여를 가장 적게 받는 사람의 이름과 급여, 사원번호를 구하세요
--급여를 가장 적게 받는 사람의 급여, 2100
SELECT  
    MIN(salary)
FROM    
    employees;

--2100의 급여를 받는 사람의 이름과 급여, 사원 번호
SELECT  
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary = 2100;
--가장 적은 급여를 받는 사람이 변할 경우, 다시 구해야 한다

--SubQuery를 이용한 방식
SELECT  
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary = (SELECT  
						MIN(salary)
              	  FROM    
              	  		employees);
    

--예제) 평균 급여보다 적게 받는 사람의 이름, 급여, 사번을 구하세요
--평균 급여
SELECT  
    AVG(salary)
FROM    
    employees;

--평균 급여보다 적게 받는 사람의 이름, 급여, 사번 구하기
SELECT  
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary > 6461.83;
--평균 급여가 변하면 다시 구해야 한다

--SubQuery를 이용한 방식
SELECT  
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary < (SELECT  
						AVG(salary)
              	  FROM    
              	  		employees);
    
                  
/*다중행 SubQuery*/
--SubQuery의 결과가 여러 Row인 경우
--예제) 부서 번호가 110인 직원들과 같은 급여를 받는 직원의 이름, 급여, 사번을 구하세요
--부서 번호가 110인 직원들의 이름과 급여를 구한다, Shelley(12008), Willian(8300)
SELECT  
    first_name,
    salary
FROM
    employees
WHERE	department_id = 110;
--급여가 12008, 8300인 직원의 이름, 급여, 사번 구하기
SELECt
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary = 12008
   or 	salary = 8300;
    
SELECT  
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary in (12008, 8300);
    

--SubQuery(다중행)을 이용한 방식
SELECT
    first_name,
    salary,
    employee_id
FROM
    employees
WHERE	salary in (SELECT  
                    	salary
               	   FROM    
                    	employees
               	   WHERE 
                    	department_id = 110);
    
--다중행이 예상되는 SubQuery에서, in을 사용하면 
--만에하나 단일행이라도 오류가 발생하지 않는다

--예제) 각 부서별로 최고 급여를 받는 사원을 출력하세요
--각 부서별 최고 급여를 구한다
SELECT
    department_id,
    MAX(salary)
FROM
    employees
GROUP BY	department_id;

--부서와 급여가 모두 일치하는 직원의 정보를 구한다
SELECT  
    first_name
FROM    
    employees
WHERE   (department_id, salary)
   in 	(SELECT  
         	department_id,
            MAX(salary)
         FROM    
            employees
         GROUP BY	department_id);
--2가지 이상의 조건을 비교해야 할 경우, 형태를 맞춰준 후 괄호로 묶어 연결지어 줄 수 있다)

--예제) 부서 번호가 110인 직원의 급여보다 많은 급여를 받는 모든 직원의
--사번, 이름, 급여를 구하세요

--부서 번호가 110인 직원의 급여
SELECT  
    salary
FROM    
    employees
WHERE   department_id = 110;

--급여가 12008, 8300 보다 많은 직원의 사번, 이름, 급여 구하기
SELECT  
    employee_id,
    first_name,
    salary
FROM    
    employees
WHERE   salary > ANY (SELECT  
                        	salary
                  	  FROM    
                        	employees
                  	  WHERE   
                        	department_id = 110);
    
--ANY는 SubQuery의 값을 or 형태로 비교해준다                  
SELECT  
    employee_id,
    first_name,
    salary
FROM    
    employees
WHERE   
    salary > ALL (SELECT  
                        salary
                  FROM    
                        employees
                  WHERE   
                        department_id = 110);
--ALL은 SubQuery의 값을 and 형태로 비교해준다
    
--예제) 각 부서별로 최고 급여를 받는 사원을 구하세요
SELECT  
    department_id,
    MAX(salary)
FROM    
    employees
GROUP BY    department_id;

--부서 번호, 급여가 모두 일치하는 사원 구하기
SELECT  
    first_name
FROM    
    employees
WHERE	(department_id, salary)   
   IN 	(SELECT  
         		department_id,
                MAX(salary)
         FROM    
	            employees
         GROUP BY    
	            department_id);
--부서 번호가 null인 직원이 제외된다
SELECT  
    first_name
FROM    
    employees
WHERE   (nvl(department_id, 0), salary) 
   IN   (SELECT  
            nvl(department_id, 0),
            MAX(salary)
         FROM    
            employees
         GROUP BY    department_id);
--nvl을 사용하여 표현 해주는 방법도 있다

--JOIN을 이용하는 방법
--각 부서별 최고 급여 테이블 s
SELECT  
    department_id,
    MAX(salary)
FROM    
    employees
GROUP BY    department_id;

--직원 테이블 e와 JOIN
SELECT  
    e.employee_id,
    e.first_name,
    e.salary
FROM    
    employees e, (SELECT    
                        department_id,
                        MAX(salary) salary
                  FROM    
                        employees
                  GROUP BY    department_id) s
WHERE   e.department_id = s.department_id
  and   e.salary = s.salary;
  
/*ROWRUM*/
--예제) 급여를 가장 많이 받는 5명의 사원의 이름을 구하세요
--ROWNUM이 정렬 이전에 붙기 때문에, 정렬 시 섞이게 된다
SELECT
    ROWNUM,
    employee_id,
    first_name,
    salary
FROM
    employees
WHERE   ROWNUM >= 1
  AND   ROWNUM <= 5
ORDER BY salary DESC;
    
--1. 정렬을 하고 ROWNUM을 부여한다
SELECT
    ROWNUM,
    employee_id,
    first_name,
    salary
FROM
    (SELECT
        *
     FROM
        employees
     ORDER BY salary DESC)  --이미 정렬된 테이블을 가져온다
WHERE   ROWNUM >= 1 --1이 아닌 다른 수로 시작하면 오류가 발생한다
  AND   ROWNUM <= 5;
--ROWNUM이 붙은 이후 WHERE 절에서 판단하는데 ROWNUM이 1이라서 시작 되지 않는다

--정렬된 1.에 ROWNUM을 붙이고, 그 후에 WHERE 절을 실행한다
SELECT  
    ort.rn,
    ort.employee_id,
    ort.first_name,
    ort.salary
FROM    
    (SELECT  
        ROWNUM rn,
        ot.employee_id,
        ot.first_name,
        ot.salary
     FROM
        (SELECT
            employee_id,
            first_name,
            salary
         FROM
            employees
         ORDER BY salary DESC) ot
    ) ort
WHERE   ort.rn >= 2
  AND   ort.rn <=5;    

/*예제) 07년에 입사한 사원 중, 급여가 가장 많은 순서대로 3~7번째 사원의 
이름, 급여, 입사일을 구하시오*/
--07년에 입사한 사원의 급여 순 이름, 급여, 입사일
SELECT
    first_name,
    salary,
    hire_date
FROM
    employees
WHERE   hire_date < '080101'
  AND   hire_date > '061231'
ORDER BY salary DESC;
--07년에 입사한 사원의 급여 순 이름, 급여, 입사일 + 급여 순 ROWNUM
SELECT
    ROWNUM,
    os.first_name,
    os.salary,
    os.hire_date
FROM
    (SELECT
        first_name,
        salary,
        hire_date
     FROM
        employees
     WHERE   hire_date < '080101'
       AND   hire_date > '061231'
     ORDER BY salary DESC) os;

--
SELECT
    *
FROM
    (SELECT
         ROWNUM rn,
         os.first_name,
         os.salary,
         os.hire_date
     FROM
        (SELECT
            first_name,
            salary,
            hire_date
         FROM
            employees
         WHERE   hire_date < '080101'
           AND   hire_date > '061231'
         ORDER BY salary DESC) os
    ) osn
WHERE   osn.rn >= 3
  AND   osn.rn <= 7;
