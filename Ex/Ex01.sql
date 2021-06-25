/*from절, select절*/
--모든 컬럼 조회하기
select  *       --'*'은 모든 컬럼을 선택한다
from employees;        

select * 
from departments;

--원하는 컬럼만 조회하기
select employee_id, first_name, last_name	--select는 컬럼을 선택하여 해당 값을 조회한다
from employees;								--~에서, from은 지정된 table에서 값을 불러온다

--예제)
select first_name, phone_number, hire_date, salary	--select 절에 해당 컬럼을 row에서 선택하여 투사(projection)하는 방식으로 작동한다
from employees;										--from으로 테이블의 row 값을 불러들인다

select first_name, 	--가독성을 위해, select절의 내용은 줄을 맞춰 적는다
       last_name, 
       phone_number, 
       email, 
       hire_date
from employees;

--컬럼에 별명 붙이기
select  employee_id as "empNo",   --큰따옴표로 묶어주어야 한다
        first_name as "f-name",
        salary as "급 여",
        hire_date "고용일"    --as를 사용하지 않아도 인식한다  
from employees;

--연결 연산자로 컬럼들 붙이기
select  first_name,
        last_name
from employees;

select  first_name || last_name --컬럼을 연결하여 하나의 컬럼으로 만들어 보여준다, 
from employees;                 --별명을 지정해주지 않으면 해당 컬럼 명을 연결하여 보여준다

select  first_name || ' ' || last_name  --컬럼을 병합시킬 때, 해당 병합된 컬럼의 필드 사이에 다른 단어를 넣고 싶다면
from    employees;                      --작은 따옴표를 사용하여 추가 할 수 있다

select  first_name || ' hire date is ' || hire_date as "입사일"
from    employees;

select  first_name || last_name as 이름   --별명을 붙여줄 수 있다
from employees;

--산술 연산자 사용하기
select  first_name,
        salary
from employees;

select  first_name,
        salary,
        salary*12 연봉,    --사칙연산이 통용되며, 해당 컬럼에 이름을 붙이지 않으면 기본 값으로 지정된다(salary*12)
        (salary+300) * 12   --()통한 우선 연산도 가능하다
from employees;
select  job_id*12   --해당 컬럼이 숫자로 이루어져있지 않으면, invalid number 오류가 발생한다
from employees;

--예제
select  first_name || '-' || last_name 성명,
        salary 급여,
        salary * 12 연봉,
        salary * 12 + 5000 연봉2,
        phone_number 전화번호
from employees;         
--select from 절 처리 방법은, from 절의 table(위 문구에서는 employees)에서 row 단위로 데이터를 읽어온다
--그 후에 select 절의 내용에 따라 row의 정보를 projection(투사)한다

/*where절*/
--조건절, 조건에 해당하는 정보 조회하기
select  first_name
from employees
where department_id != 10;  --where 절에서 해당 컬럼의 필드 값이 일치하는 정보를 찾기 위해서는 
                            --등호를 사용하여 필드 값을 입력해주어야 한다(비교연산자를 이용하여 범위를 지정할 수도 있다)
--예제
select  first_name || ' ' || last_name 이름,
        salary 월급
from employees
where salary >= 15000;

select  first_name || ' ' || last_name 이름,
        hire_date 입사일
from employees
where hire_date >= '07/01/01';  --날짜는 숫자가 아니므로, 작은 따옴표로 묶어주어야 한다

select  salary 연봉
from employees
where first_name = 'Lex';   --문자 역시 작은 따옴표로 묶어주어야 한다

--조건이 두개 이상일 때, 한꺼번에 조회하기
select  first_name,
        salary
from employees
where salary >= 14000
and   salary <= 17000;  -- and가 자바에서의 &&연산자와 같은 기능을 한다 
                        --필요하다면 더 많은 조건도 지정할 수 있다 
                        
--예제
select  first_name,
        salary
from employees
where   salary <= 14000
or      salary >= 17000;

select  first_name,
        hire_date
from employees
where hire_date >= '04/01/01'
and   hire_date <= '05/12/31';

--between 연산자를 이용한 특정 구간의 값 조회
select  first_name,
        salary
from employees
where salary >= 14000
and   salary <= 17000; 

--between연산자는 경계값을 포함하는 경우에만 사용할 수 있다(작은 값을 앞에, 큰 값을 뒤에 지정한다)
--느린 연산자에 속한다
select  first_name,
        salary
from employees
where salary between 14000 and 17000; 

--in 연산자
select  first_name, 
        last_name, 
        salary
from employees
where first_name in ('Neena', 'Lex', 'John');   
--여러개의 조건을 갖는 경우, in()을 통해 한 번에 조회할 수 있다. 각 조건의 구분은 ','를 사용한다
select  first_name, 
        last_name, 
        salary
from employees
where first_name = 'Neena'
or    first_name = 'Lex'
or    first_name = 'John';

--예제
select  first_name,
        salary
from    employees
where   salary in (2100, 3100, 4100, 5100);

select  first_name,
        salary
from    employees
where   salary = 2100
or      salary = 3100
or      salary = 4100
or      salary = 5100;

--like 연산자로 비슷한 것들 모두 찾기
select  first_name,
        last_name,
        salary
from employees
where   first_name like 'L%';   --first_name에 L을 포함하는 대상을 조회, 'L'만 입력시 L과 같은 것만 찾는다
                                --%의 역할은 '해당 문자 뒤의 임의의 길이의 문자열을 포함한'이다
select  first_name,
        last_name,
        salary
from employees
where   first_name like '%l';   --'%l'은 l로 끝나는 대상을 조회할 수 있다                                

select  first_name,
        last_name,
        salary
from employees
where   first_name like '_____l';   --특정 위치의 값을 찾고 싶을 때는, 문자열 길이 하나당 '_'을 입력해주면 된다

--예제
select  first_name,
        salary
from    employees
where   first_name like '%am%';

select  first_name,
        salary
from    employees
where   first_name like '_a%';

select  first_name
from    employees
where   first_name like '___a%';        

select  first_name
from    employees
where   first_name like '__a_';
