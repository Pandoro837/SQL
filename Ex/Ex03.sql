/*그룹 함수*/
select  first_name,
        round(salary, -4)
from    employees;

--단일행 함수와 복수행 함수를 함께 사용 할 경우, 오류가 발생한다
select  first_name,
        avg(salary) 
from    employees;

--그룹 함수 avg()   
select  avg(salary),            --해당 칼럼의 값의 평균을 구한다
        sum(salary)/count(*)    --기본적으로 같은 값을 갖는다
from    employees;

--null값을 갖는 컬럼에 대한 avg() 사용
--만약 일부 필드가 null 값을 갖고 있을 경우, 해당 필드는 카운트에서 제외된다
--예제) 70, null, 50의 avg()는 120/2가 된다
select  count(*),
        sum(commission_pct),
        avg(commission_pct),    --기본적으로 null값을 제외하기 때문에
        sum(commission_pct)/count(*), --다르다
        sum(commission_pct)/count(commission_pct) --같다
from    employees;

--avg(nvl(컬럼명, 0))을 입력한다면, null이 0이되어 카운트에 포함,
--예제) 70, 0, 50이 되어 120/3이 된다
select  count(*),
        sum(commission_pct),
        avg(nvl(commission_pct, 0)),    --null을 0으로 치환 하였기 때문에
        sum(commission_pct)/count(*)    --같은 결과를 갖는다
from    employees;

--그룹 함수 count()
select  count(*),               --모든 행의 갯수를 센다(null 포함)
        count(first_name),      --특정 컬럼의 행의 갯수를 센다
        count(commission_pct)   --null을 갖는 필드는 세지 않는다
from    employees;

select  count(salary)           --where 절을 이용
from    employees               --조건에 만족하는 갯수를 셀 수 있다
where   salary > 16000;

--그룹 함수 sum()
select  sum(salary),            --해당 컬럼의 값을 더해서 표현한다
        count(*)                --그룹 함수끼리는 함께 사용 할 수 있다
from    employees;

--그룹 함수 max()
select  max(salary)             --해당 컬럼에서 가장 큰 값을 출력한다
from    employees;

select  salary
from    employees
order by salary desc;           --내림차순 최상단의 값과 같다

--그룹 함수 min()
select  min(salary)             --해당 컬럼에서 가장 작은 값을 출력한다
from    employees;

select  salary
from    employees
order by salary asc;            --오름차순 최상단의 값과 같다

/*GROUP BY 절*/
select  department_id,          --그룹에 참여한 컬럼은 복수행 함수와 함께 표기 가능하다
        avg(salary)             
from    employees
group by department_id          --해당 컬럼의 같은 값들을 그룹으로 묶는다
order by department_id asc;

--사용 시 주의사항
select  department_id,      --그룹에 참여한 컬럼이나, 복수행 함수만 선택 할 수 있다
        sum(salary),        --해당 그룹(department_id가 같은 값을 갖는)의 합계
        count(*)            --해당 그룹(department_id가 같은 값을 갖는)의 갯수
from    employees
group by department_id;

--그룹을 더 세분화
select  department_id, 
        job_id,
        avg(salary)
from    employees
--기준이 둘 이상일 경우, 순차적으로 적용된다
--department_id로 나뉘어진 그룹을 job_id로 다시 쪼개어 구분한다
group by department_id, job_id;

--예제) 연봉의 합계가 20000 이상인 부서의 
--부서 번호와, 인원수, 급여합계를 출력하세요
select  department_id,
        count(*),   --*는 전체를 의미하지만, 범위를 그룹으로 지정했기 때문에
                    --count(department_id)와 같다
        sum(salary)
from    employees
--where   sum(salary) >= 20000 where 절에서는 그룹 함수를 사용할 수 없다
group by department_id
--having 절에는 그룹 함수와 group by에 참여한 컬럼만 올 수 있다
having  sum(salary) >= 20000;   

--예제와 같으면서, 부서번호가 100번인 조건을 출력
select  department_id,
        count(*),   
        sum(salary)
from    employees
group by department_id
having  sum(salary) >= 20000
and     department_id = 100;--where 절처럼 and로 여러개의 조건을 지정할 수 있다

/*CASE ~ END 문*/
select  employee_id,
        job_id,
        salary,
        --자바의 switch case 문과 유사하다
        --case when으로 컬럼과 조건을 입력하고, 해당 하는 곳에 then을 적용한다
        case when job_id = 'AC_ACCOUNT' then salary + salary * 0.1
             when job_id = 'SA_REP' then salary + salary * 0.2
             when job_id = 'ST_CLERK' then salary + salary * 0.3
        --esle는 switch case의 default와 같다
             else salary
        end as "rSalary"  --end 이후의 내용은 해당 컬럼에 붙일 별명을 지정한다 
from    employees;

/*DECODE 문*/
select  employee_id,
        job_id,
        salary,
        decode(
        --when      ~           then       ~
            job_id, 'AC_ACCOUNT', salary + salary * 0.1,
                    'SA_REP', salary + salary * 0.2,
                    'ST_CLERK', salary + salary * 0.3,        
        --else
            salary) as "rSalary"
from    employees;