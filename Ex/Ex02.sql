--NULL
select first_name, salary, commission_pct, salary*commission_pct
from employees
where salary between 13000 and 15000;

--NULL을 이용한 필드 조회
select first_name,
        salary,
        commission_pct
from employees
where commission_pct is null;

--예제) 커미션 비율이 없는 사원의 이름, 연봉, 커미션 비율을 출력
select  first_name,
        salary,
        commission_pct
from employees
where commission_pct is not null;
--예제) 매니저 아이디가 없고, 커미션 비율이 없는 사원의 이름을 출력
select  first_name
from employees
where manager_id is null
and   commission_pct is null;

--order by
select first_name,
        salary
from employees
order by salary desc;   --내림차순

select first_name,
        salary
from employees
order by salary asc,    --오름차순
         first_name desc;    
         
--select, from, where, order by절의 위치
select department_id,
        salary,
        first_name
from employees
where salary >= 9000
order by department_id asc;

--예제) 부서번호를 오름차순으로 정렬하고 부서번호, 급여, 이름을 출력
select department_id,
        salary,
        first_name
from employees
order by department_id asc;

--예제) 급여가 10000 이상인 직원의 이름 급여를 급여가 큰직원부터 출력
select  first_name,
        salary
from employees
where salary >= 10000
order by salary desc;

--예제) 부서번호를 오름차순으로 정렬하고 부서번호가 같으면 급여가 높은 사람부터 
--부서번호 급여 이름을 출력하세요 
select  department_id,
        salary,
        first_name
from employees
order by department_id asc,
         salary desc;

/*단일행 함수*/
/*문자 함수*/
--INITCAP(컬럼명) 괄호 안의 컬럼을 첫 글자만 대문자, 나머지는 소문자로 출력한다
select  email,
        INITCAP(email),
        department_id
from employees
where   department_id = 100;

--함수를 테스트하는 목적으로 사용할 수 있는 dual이라는 가상의 테이블이 존재한다
select  INITCAP('aaaaaa')   --값을 직접 입력해주어야 한다
from dual;

--LOWER(컬럼명)/UPPER(컬럼명) 해당 컬럼의 값을 전부 소문자, 대문자로 출력한다
select  first_name,
        lower(first_name),
        upper(first_name)
from employees
where department_id = 100;

--SUBSTR(컬럼명, 시작 위치, 글자수) 주어진 문자열에서 특정길이의 문자열을 구하는 함수
--시작 위치가 양수인 경우 왼쪽 -> 오른쪽으로, 음수일 경우 오른쪽 -> 왼쪽으로 실행된다
select  first_name,
        SUBSTR(first_name,1,3),
        SUBSTR(first_name,-4,3)
from employees
where department_id = 100;

--L, RPAD(컬럼명, 자리수, '채울 문자') 좌, 우 공백에 지정한 자리수만큼 해당 문자를 입력
--문자열 + 문자의 합이 자리수가 될 때까지만 입력한다
select  first_name,
        lpad(first_name, 10, '*'),
        rpad(first_name, 10, '*')
from employees;

--REPLACE(컬럼명, 문자1, 문자2) 컬럼에서 문자1을 문자2로 교체한다
select  first_name,
        replace(first_name, 'a', '*'),  
--first_name에서, substr 2번째 위치부터 3번째 글자까지의 범위를, ***로 대채해라
--함수는 조합하여 사용할 수 있다
        replace(first_name, substr(first_name, 2, 3), '***'),
        replace(first_name, 'a', '') --공백을 입력하면 해당 글자를 지운다
from employees;

/*숫자 함수*/
--ROUND(숫자, 출력을 원하는 자릿수) 주어진 자릿수까지 표기하기 위해, 이하의 값을 반올림하는 함수
select  round(123.346, 2) "r2",
        round(123.456, 0) "r0",     -- 0을 기준으로 소숫점 전, 후를 구분한다
        round(123.456, -1) "r-1"    -- 음수는 정수 부분까지 반올림 대상에 넣는다
from dual;

--TRUNC(숫자, 출력을 원하는 자릿수) 주어진 자릿수까지 표기하기 위해, 이하의 값을 버리는 함수
select  trunc(123.346, 2) "t2",
        trunc(123.956, 0) "t0",
        trunc(123.456, -1) "t-1"
from dual;

--abs(숫자) 해당 숫자의 절대값을 출력하는 함수
select abs(-5) 
from dual;

/*날짜 함수*/
--SYSDATE() 현재 날짜를 출력해주는 함수, from에 크게 의미를 두지 않는다
select sysdate
from dual;

--MONTHS_BETWEEN(날짜1, 날짜2) 날짜 1과 날짜2의 개월 수를 출력하는 함수
select  sysdate,
        hire_date,
        months_between(sysdate, hire_date)
from employees;

select  sysdate,
        hire_date,
        trunc(months_between(sysdate, hire_date), 0)
from employees;

/*변환 함수*/
--TO_CHAR(n, fmt) 숫자를 문자로 변환한다
select  first_name,
        salary * 12,
        to_char(salary * 12, '$999,999.999') --9의 갯수만큼의 자리수까지 표기
from employees
where department_id = 110;

select  to_char(9876, '99999'), --표시할 자리수가 문자의 길이보다 짧으면, 오류가 발생한다
        to_char(9876, '099999'), --빈 자리수만큼 0으로 채워라
        to_char(9876, '$99999'),    --달러 표시를 붙여 표기한다
        to_char(9876, '99999.99'), --소숫점 자리수를 지정한다
        to_char(9876, '999,999')    --천 단위로 ,를 붙여 표기한다
from dual;

--TO_CHAR(d, fmt) 날짜를 문자로 변환한다
select  sysdate, 
        to_char(sysdate, 'yyyy'), --연도를 4자리로 표기한다
        to_char(sysdate, 'yy'),   --연도를 2자리로 표기한다
        to_char(sysdate, 'mm'),   --월을 2자리로 표기한다
        to_char(sysdate, 'mon'),  --유닉스에서는 월을 영어 3자리로, 한글에서는 MONTH와 동일
        to_char(sysdate, 'month'),--월을 뜻하는 이름 전체로 표기한다
        to_char(sysdate, 'dd'),   --일을 2자리 숫자로 표기한다
        to_char(sysdate, 'day'),  --일을 요일로 표기한다
        to_char(sysdate, 'ddth'), --몇번째 날인지 표기한다
        to_char(sysdate, 'hh'),   --하루를 12시간으로 표기한다
        to_char(sysdate, 'hh24'), --하루를 24시간으로 표기한다
        to_char(sysdate, 'mi'),   --몇분인지 표기한다
        to_char(sysdate, 'ss'),    --초를 표기한다
        to_char(sysdate, 'yyyymmdd'), --연, 월, 일 모두 표기한다
        to_char(sysdate, 'yyyy-mm-dd'),  --내부에 구분용 기호 넣으면, 인식해서 구분해준다
        to_char(sysdate, 'yyyy"년"mm"월"dd"일"'), --내부에 문자를 넣고 싶다면, 큰 따옴표로 구분해서 넣어줘야한다 
        to_char(sysdate, 'hh:mm:ss') --시, 분, 초를 표기한다
from dual;  

--nvl(조사할 컬럼명, null일 경우 치환할 값)
select  first_name,
        nvl(commission_pct, 0), --커미션 비율이 null일때, 0으로 표기
from employees
where   commission_pct is null;

--nvl2(조사할 컬럼명, null이 아닐 경우 치환할 값, null일 경우 치환할 값)
select  first_name,
        nvl2(commission_pct, 100, 0) --null일 경우 0, 아닐 경우 100
from employees;
