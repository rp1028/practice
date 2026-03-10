-- 1. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT 
    e.emp_id, e.emp_name, d.dept_title
FROM
    employee e
JOIN 
    department d ON e.dept_code = d.dept_id
WHERE 
    e.emp_name LIKE '%형%';


-- 2. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT 
    e.emp_name, j.job_name, e.dept_code, d.dept_title
FROM 
    employee e
JOIN 
    job j ON e.job_code = j.job_code
JOIN 
    department d ON e.dept_code = d.dept_id
WHERE 
    d.dept_title LIKE '해외영업%';


-- 3. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT e.emp_name, e.bonus, d.dept_title, l.local_name
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
JOIN location l ON d.location_id = l.local_code
WHERE e.bonus IS NOT NULL;


-- 4. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
SELECT e.emp_name, j.job_name, d.dept_title, l.local_name
FROM employee e
JOIN job j ON e.job_code = j.job_code
JOIN department d ON e.dept_code = d.dept_id
JOIN location l ON d.location_id = l.local_code
WHERE e.dept_code = 'd2';


-- 5. 등급별 최소급여보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
SELECT e.emp_name, j.job_name, e.salary, 
       (e.salary * (1 + IFNULL(e.bonus, 0)) * 12) AS "연봉"
FROM employee e
JOIN job j ON e.job_code = j.job_code
JOIN sal_grade s ON e.sal_level = s.sal_level
WHERE e.salary > s.min_sal;


-- 6. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT e.emp_name, d.dept_title, l.local_name, n.national_name
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
JOIN location l ON d.location_id = l.local_code
JOIN national n ON l.national_code = n.national_code
WHERE n.national_code IN ('ko', 'jp');


-- 7. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
SELECT e.emp_name, j.job_name, e.salary
FROM employee e
JOIN job j ON e.job_code = j.job_code
WHERE e.bonus IS NULL 
  AND j.job_code IN ('j4', 'j7');


-- 8. 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
SELECT e.emp_id, e.emp_name, j.job_name, d.dept_title, l.local_name, e.salary
FROM employee e
JOIN job j ON e.job_code = j.job_code
JOIN department d ON e.dept_code = d.dept_id
JOIN location l ON d.location_id = l.local_code
WHERE j.job_name = '대리' 
  AND l.local_name LIKE 'asia%';


-- 9. 각 부서별 평균 급여와 직원 수를 조회하시오.
SELECT d.dept_title, FLOOR(AVG(e.salary)) AS "평균급여", COUNT(*) AS "직원수"
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
WHERE e.salary IS NOT NULL
GROUP BY d.dept_title
ORDER BY 평균급여 DESC;


-- 10. 보너스를 받는 직원들의 연봉 총합이 1억 원을 초과하는 부서 조회
SELECT d.dept_title, SUM(e.salary * (1 + e.bonus) * 12) AS "연봉총합"
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
WHERE e.bonus IS NOT NULL
GROUP BY d.dept_title
HAVING 연봉총합 > 100000000;


-- 11. 국내 근무자 중 전체 평균 급여 이상을 받는 직원 조회 (서브쿼리 사용)
SELECT e.emp_name, e.salary, d.dept_title
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
JOIN location l ON d.location_id = l.local_code
WHERE l.local_name = 'asia1'
  AND e.salary >= (SELECT AVG(salary) FROM employee);


-- 12. 모든 부서명과 해당 부서에 소속된 직원 수 조회 (직원 없는 부서 포함)
SELECT d.dept_title, COUNT(e.emp_id) AS "직원수"
FROM department d
LEFT JOIN employee e ON d.dept_id = e.dept_code
GROUP BY d.dept_title;


-- 13. 차장(J4) 이상 직급과 사원(J7) 직급의 급여 합계 비교 (SET OPERATOR 사용)
SELECT '차장 이상' AS "구분", SUM(salary) AS "급여합계"
FROM employee
WHERE job_code IN ('j1', 'j2', 'j3', 'j4')
UNION ALL
SELECT '사원' AS "구분", SUM(salary) AS "급여합계"
FROM employee
WHERE job_code = 'j7';