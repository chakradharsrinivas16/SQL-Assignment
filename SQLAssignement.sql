-- Creation of Schema
CREATE SCHEMA `Sqlassignment`;
-- Using the created schema
USE `Sqlassignment`;
-- Question - 1
-- Creation of Table 
create table if not exists employees ( 
  emp_id integer(4) not null unique, 
  -- As employee id cannot be null and need to be unique
  emp_name varchar(30), 
  Gender varchar(10), 
  Department varchar(30), 
  -- Check constraint for preventing invalid enetries
  check(
    Gender in ("Male", "Female")
  )
);
-- Insertion of given data
Insert into employees values 
  (1, 'X', 'Female', 'Finance'), 
  (2, 'Y', 'Male', 'IT'), 
  (3, 'Z', 'Male', 'HR'), 
  (4, 'W', 'Female', 'IT');
-- Insertion of data to verify check constriant
Insert into employees values (6, 'U', 'gm', 'IT');
-- Data insertion to highlight the Not Assigned row
Insert into employees values (5, 'X', 'Female', null);

-- Procedure holding Query to find the number of male and female employees in each department

DELIMITER &&  
CREATE PROCEDURE get_num_of_male_and_female ()
BEGIN  
SELECT 
  IFNULL(Department, 'Not Assigned') as Department, 
  COUNT(
    CASE WHEN UPPER(Gender)= 'MALE' THEN 1 END
  ) AS 'Num of Male', 
  COUNT(
    CASE WHEN UPPER(Gender)= 'FEMALE' THEN 1 END
  ) AS 'Num of Female' 
FROM 
  employees 
GROUP BY 
  Department 
order by 
  Department;
END &&  
DELIMITER ;    
-- Question - 2
-- Creation of Table 
create table if not exists employeesalaries (
  emp_name varchar(30) not null, 
  -- Name cannot be null
  Jan Float(10, 2) Not null default 0, 
  -- Salary cannot be null, and its default value is zero
  Feb Float(10, 2) Not null default 0, 
  March Float(10, 2) Not null default 0, 
  check(
    Jan >= 0 
    and Feb >= 0 
    and March >= 0
  )
);
-- Check constraint to prevent salary from being negative
-- Insertion of given data
Insert into employeesalaries 
values 
  ('X', 5200, 9093, 3832), 
  ('Y', 9023, 8942, 4000), 
  ('Z', 9834, 8197, 9903), 
  ('W', 3244, 4321, 0293);
-- Insertion of data to verify not null constriant
Insert into employeesalaries values ('V', 100, 100, null);
-- Insertion of data to verify check constriant
Insert into employeesalaries values ('V', 100,-100, null);
-- Procedure holding Query to find the max amount from the rows with month name
DELIMITER &&  
CREATE PROCEDURE max_amount_from_rows_with_month_name()  
BEGIN  
select 
  emp_name as Name, 
  value, 
  case when idx = 1 then 'Jan' when idx = 2 then 'Feb' when idx = 3 then 'Mar' end as Month 
from 
  (
    select 
      emp_name, 
      greatest(Jan, Feb, March) as value, 
      field(
        greatest(Jan, Feb, March), 
        Jan, 
        Feb, 
        March
      ) as idx 
    from 
      employeesalaries
  ) emps;
END &&  
DELIMITER ;  
-- Question - 3
-- Creation of Table 
create table if not exists test (
  candidate_id integer(4) not null unique, 
  -- As candidate id cannot be null and need to be unique
  marks float(10, 2) default 0
);
-- Insertion of given data
Insert into test 
values 
  (1, 98), 
  (2, 78), 
  (3, 87), 
  (4, 98), 
  (5, 78);
-- Procedure holding Query to rank them in proper order.
DELIMITER &&  
CREATE PROCEDURE rank_in_order ()  
BEGIN  
SELECT 
  Marks, 
  dense_rank() OVER (
    order by 
      marks desc
  ) as 'Rank', 
  GROUP_CONCAT(Candidate_id) as Candidate_id 
FROM 
  test 
GROUP BY 
  marks;
END &&  
DELIMITER ;  
-- Question - 4
-- Creation of Table 
create table if not exists mailids (
  candidate_id integer(4) not null unique, 
  -- As candidate id cannot be null and need to be unique
  mail varchar(30) not null
);
-- Insertion of given data
Insert into mailids 
values 
  (45, 'abc@gmail.com'), 
  (23, 'def@yahoo.com'), 
  (34, 'abc@gmail.com'), 
  (21, 'bcf@gmail.com'), 
  (94, 'def@yahoo.com');
-- Procedure holding Query to keep the value that has smallest id and delete all the other rows having same value.
DELIMITER &&  
CREATE PROCEDURE Delete_rows_with_same_value_except_smallest_id ()  
BEGIN  
DELETE FROM 
  mailids 
WHERE 
  candidate_id in (
    Select 
      tempcandidate_id 
    from 
      (
        select 
          Distinct a.candidate_id as tempcandidate_id 
        from 
          mailids a 
          inner join mailids b 
        where 
          a.mail = b.mail 
          and a.candidate_id > b.candidate_id
      ) as c
  ); 
-- Display the table after deletion
SELECT 
  * 
FROM 
  Sqlassignment.mailids 
order by 
  candidate_id DESC;
END &&  
DELIMITER ;  

-- Calling procedures
-- Question - 1
CALL get_num_of_male_and_female ();
-- Question - 2
CALL max_amount_from_rows_with_month_name();  
-- Question - 3
CALL rank_in_order();
-- Question - 4
CALL Delete_rows_with_same_value_except_smallest_id ();
