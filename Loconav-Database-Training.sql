CREATE TABLE regions(
  region_id INT PRIMARY KEY,
  region_name varchar(25) NOT NULL UNIQUE,
);

CREATE TABLE countries(
  country_id char(2) PRIMARY KEY,
  country_name varchar(40) NOT NULL,
  region_id INT NOT NULL,
  FOREIGN KEY (region_id) 
	REFERENCES regions (region_id) 
  )


CREATE TABLE locations(
  location_id INT PRIMARY KEY,
  street_address varchar(40) NOT NULL,
  postal_code varchar(12) ,
  city varchar(30) NOT NULL,
  state_province varchar(25) ,
  country_id char(2) NOT NULL,
  FOREIGN KEY (country_id) 
	REFERENCES countries (country_id) 
)

CREATE TABLE departments(
  department_id INT PRIMARY KEY,
  department_name varchar(30) NOT NULL,
  location_id INT NOT NULL,
  FOREIGN KEY (location_id) 
	REFERENCES locations (location_id) 
)

CREATE TABLE jobs(
  job_id INT PRIMARY KEY,
  job_title varchar(35) UNIQUE NOT NULL,
  min_salary NUMERIC(8,2) NOT NULL,
  max_salary NUMERIC(8,2) NOT NULL
)

CREATE TABLE employees(
  employee_id INT PRIMARY KEY,
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(25) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone_number VARCHAR(20) UNIQUE,
  hire_date DATE NOT NULL,
  job_id INT,
  salary FLOAT NOT NULL,
  manager_id INT,
  department_id INT,
  FOREIGN KEY (manager_id) 
	REFERENCES employees (employee_id) ON DELETE SET NULL,
  FOREIGN KEY(department_id) REFERENCES departments(department_id),
  FOREIGN KEY(job_id) REFERENCES jobs(job_id)
)

CREATE TABLE dependents(
  dependent_id INT PRIMARY KEY,
  first_name varchar (50) NOT NULL,
  last_name varchar (50) NOT NULL,
  relationship varchar(25) NOT NULL,
  employee_id INT,
  FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
)

// Order of Insertion of Table in Database

==>First insert table regions->countries->locations->jobs->departments->employees->dependents

// Query

Q1. Display the last name and job title of all employees who do not have a manager

Ans. select e.last_name,j.job_title from employees e inner join jobs j on e.job_id=j.job_id where e.manager_id ISNULL;

Q2. Display the names and salaries of all employees in reverse salary order

Ans. Select concat(first_name,' ',last_name) as name ,salary from employees order by salary desc;

Q3. Display the maximum,minium and average salary employees earned (MODIFY)

Ans. SELECT MAX(salary),MIN(salary),AVG(salary) from employees;

Q4. Display the department number,depatment name,total salary payout for each department (MODIFY)

Ans. SELECT d.department_id,d.department_name,sum(salary) from employees e inner JOIN departments d
on e.department_id=d.department_id
GROUP by d.department_id,d.department_name ORDER by d.department_id;

Q5. Select the maximum salary of each department.

Ans.SELECT department_id, max(salary) FROM employees GROUP BY department_id ORDER by department_id;

Q7. Create a query that displays the name , job, department name, salary, grade for all the employees.
    Derive grade based on salary(>=50000=A,>=30000=B,<30000=C)

Ans. SELECT concat(e.first_name,' ',e.last_name) as name,e.job_id,d.department_name,
CASE 
 WHEN e.salary >=50000.00 THEN 'A'
 WHEN e.salary>=30000.00 and e.salary<50000.00 THEN 'B'
 WHEN e.salary<30000.00 then 'C'
 End Grade
 from employees e inner JOIN departments d on e.department_id=d.department_id ;

Q8. Display the average of sum of the salaries and group the result with the deparment id. 
Order the result with the department id.

Ans. select department_id,AVG(salary) from employees group by department_id ORDER by department_id;

Q9. Display the names and department name of all employees working in the same city as Southlake (MODIFY)

Ans. SELECT concat(e.first_name,' ',e.last_name) as name,d.department_name 
    from employees e inner join departments d on e.department_id=d.department_id 
    where location_id =(SELECT location_id from locations where city='Southlake')
                                                                                                
Q10. Display employee name if it's a palindrome

Ans. select concat(first_name,' ',last_name) as full_name from employees where
     concat(first_name,last_name)=REVERSE(concat(first_name,last_name));


Q11. display the employee last name and departmnet name of all employess who have an 'a' in their name.

Ans. SELECT e.last_name,d.department_name  FROM employees e INNER JOIN departments d ON 
    e.department_id = d.department_id where e.last_name LIKE'%a%' OR e.first_name LIKE '%a%';

Q12. Create a unique list of all jobs that are in department 4. Include the location of the departmnet in the output

Ans. select jb.job_id, d.location_id,d.department_name from employees e inner join jobs jb 
    on e.job_id=jb.job_id 
    INNER join departments d on e.department_id=d.department_id WHERE e.department_id=4;


Q16. Display the department number,last name and job ID for every employee in the OPERATIONS Marketing (MODIFY)

Ans. Select e.last_name,e.job_id,d.department_id from employees e inner join departments d 
    on e.department_id=d.department_id 
    where d.department_name='Marketing';

OPTIMIZED-

SELECT department_id, last_name, job_id FROM employees WHERE department_id IN
(SELECT department_id FROM departments WHERE department_name = 'Marketing')

Q17. Display the Managers with top three salaries along with their salaries and department information

Ans. SELECT employee_id , first_name, last_name, departments_id from employees WHERE
    employee_id in (SELECT DISTINCT manager_id from employees) ORDER by salary DESC LIMIT 3;

Q20. Calculate experience of the employee till date in Years and months(Example 1 year and 3 months)

Ans. SELECT first_name, extract(year FROM age(hire_date)) || ' years ' || 
    extract(month FROM age(hire_date)) || ' months' as experience FROM employees;

