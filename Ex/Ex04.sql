select  *
from    employees;

select  *
from    departments;

--EQUI join
select  employee_id,
        first_name,
      --department_id 두개의 테이블에 모두 존재하기 때문에, 값이 일치하더라도
      --불러오는데 오류가 발생한다
        em.department_id    --어디서 불러올지 지정해야한다
from    employees em, departments de
where   em.department_id = de.department_id;
--where 절로 join한 결과, 106건이 나온다(null값을 가진 키는 누락된다)

--예제) 테이블이 두개 이상일 때의 EQUI join
select  first_name,
        em.department_id,
        de.department_name
from employees em, jobs js, departments de
where   em.department_id = de.department_id
and     em.job_id = js.job_id;

/*OUTER JOIN*/
--left outer join   일반적인 EQUI 조인은 null을 제외한다
select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em left outer join departments de
--left outer ~ on을 이용하면, 왼쪽의 테이블을 기준으로(null을 포함) join 한다
on      em.department_id = de.department_id;

select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em, departments de
where   em.department_id = de.department_id(+);
--오라클에서는 left outer ~ on을, null을 포함하고 싶은 
--'반대'쪽에 (+)를 사용하여 표현할 수 있다

--right outer join 기본적인 작동방식은 left와 같으나, 오른쪽을 기준으로 잡는다
select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em right outer join departments de
on      em.department_id = de.department_id;

--이와 같이 표현할 수도 있다
select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em, departments de
where   em.department_id(+) = de.department_id;

--right join을 left join으로 바꾸기
select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    departments de left outer join employees em --서로 좌, 우를 바꿔주면 된다
on      em.department_id = de.department_id;

select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em, departments de
where   de.department_id = em.department_id(+);    

--full outer join
--양쪽 모두에서 최소 한 번은(null을 포함한) 출력한다
select  em.employee_id,
        em.first_name,
        em.department_id,
        de.department_name
from    employees em full outer join departments de
on      em.department_id = de.department_id;

select  employee_id,
        first_name,
        em.department_id   
from    employees em, departments de
where   em.department_id(+) = de.department_id(+);  
--full outer는 (+)를 사용할 수 없다

/*self join*/
select  em.employee_id,
        em.first_name,
        em.manager_id,
        
        ma.employee_id,
        ma.first_name
from    employees em, employees ma  --자기 자신을 불러오기 위해 다른 별명을 지어준다
where   em.manager_id = ma.employee_id; --비교할 컬럼을 정확하게 입력하는 것이 중요

--예제) 잘못된 join
select  *
from    employees em, locations lo
where   em.salary = lo.location_id; 
--같은 값을 갖고 있는 컬럼을 비교는 해주지만, 둘 사이에는 아무런 연관이 없다
                                    

