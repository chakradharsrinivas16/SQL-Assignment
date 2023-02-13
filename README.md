# SQL-Assignment

The assignemnt has 4 questions, we have written procedures to each question which holds the query to fetch the required result, and each procedure is explained as below -

### Question - 1
#### Table Creation - 
The below script creates a table named "employees" .
The table has four columns:

1. "emp_id" - An integer column with a maximum size of 4 digits. It cannot be NULL and must be unique across all records in the table.
2. "emp_name" - A string column with a maximum length of 30 characters.
3. "Gender" - A string column with a maximum length of 10 characters.
4. "Department" - A string column with a maximum length of 30 characters.

The "check" constraint is used to enforce data integrity by preventing invalid entries in the "Gender" column. The constraint specifies that only the values "Male" and "Female" are allowed in the "Gender" column.

```
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
```
#### Insertion into table - 
We had inserted some random data to verify the working of check constraints and to hilight its features. The below is the script to insert data into table.

```
Insert into employees 
values 
  (1, 'X', 'Female', 'Finance'), 
  (2, 'Y', 'Male', 'IT'), 
  (3, 'Z', 'Male', 'HR'), 
  (4, 'W', 'Female', 'IT');
-- Insertion of data to verify check constriant
Insert into employees 
values 
  (6, 'U', 'gm', 'IT');
-- Data insertion to highlight the Not Assigned row
Insert into employees 
values 
  (5, 'X', 'Female', null);
```
#### Procedure holding Query to find the number of male and female employees in each department - 
The query is a SQL stored procedure. The procedure is named "get_num_of_male_and_female".
The procedure performs the following actions upon execution :
- Selects data from the "employees" table.
- Groups the data by the "Department" column.
- Counts the number of occurrences of "Male" and "Female" in the "Gender" column and returns the results as two separate columns named "Num of Male" and "Num of Female".
- Returns the department name along with the count of male and female employees in each department, with a default value of "Not Assigned" for departments that have no assigned employees.
- The results are ordered by the "Department" column in ascending order.
#### Functions and Statements used -
  1. IFNULL - The "IFNULL" function is used to handle cases where the "Department" column has a NULL value. 
  2. UPPER - The "UPPER" function is used to convert the values in the "Gender" column to upper case to ensure that the case-insensitive comparison between the values and the hardcoded strings "MALE" and "FEMALE" works correctly.
  3. CASE WHEN - The "CASE WHEN" statement is used to conditionally count the number of occurrences of "Male" and "Female" in the "Gender" column.
  4. DELIMITER - The "DELIMITER" statement is used to change the default SQL statement delimiter, which is a semicolon, to the "&&" symbol. This is necessary because the procedure body contains semicolons, which would otherwise cause issues with execution.
 ```
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
 ```

#### Test run -
![image](https://user-images.githubusercontent.com/123494344/218332255-2dbba1e3-6927-4fd0-8dcf-b10e60a83c93.png)


### Question - 2
#### Table Creation - 
The below script creates a table named "employeesalaries".

The table has four columns:

1. "emp_name" - A string column with a maximum length of 30 characters, and it cannot be NULL.
2. "Jan" - A floating-point column with a maximum precision of 10 digits and 2 decimal places, and it cannot be NULL. The default value for this column is 0.
3. "Feb" - A floating-point column with a maximum precision of 10 digits and 2 decimal places, and it cannot be NULL. The default value for this column is 0.
4. "March" - A floating-point column with a maximum precision of 10 digits and 2 decimal places, and it cannot be NULL. The default value for this column is 0.

The "check" constraint is used to enforce data integrity by preventing invalid entries in the salary columns. The constraint specifies that the salary in all three months (Jan, Feb, and March) must be greater than or equal to 0.

```
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
```
#### Insertion into table - 
We had inserted some random data to verify the working of check constraints. The below is the script to insert data into table.
```
-- Insertion of given data
Insert into employeesalaries 
values 
  ('X', 5200, 9093, 3832), 
  ('Y', 9023, 8942, 4000), 
  ('Z', 9834, 8197, 9903), 
  ('W', 3244, 4321, 0293);
-- Insertion of data to verify not null constriant
Insert into employeesalaries 
values 
  ('V', 100, 100, null);
-- Insertion of data to verify check constriant
Insert into employeesalaries 
values 
  ('V', 100,-100, null);
```
#### Procedure holding Query to find the max amount from the rows with month name -

The query is a SQL stored procedure. The procedure is named "max_amount_from_rows_with_month_name".
The procedure performs the following actions upon execution:
- Selects data from a table named "employeesalaries" and Finds the maximum value from the columns "Jan", "Feb", and "March" and stores it in the "value" column.
- Determines the month corresponding to the maximum value using the "field" function, which returns the index of a value in a list of values, and stores the result in the "idx" column.
- Uses a "CASE WHEN" statement to convert the "idx" column into the month name (Jan, Feb, or Mar) and returns the result in the "Month" column.

#### Functions and Statements used -

1. Greatest -  The "greatest" function is used to determine the maximum value from the columns "Jan", "Feb", and "March". 
2. Field - The "field" function is used to determine the position of the maximum value in the list.
3. DELIMITER - The "DELIMITER" statement is used to change the default SQL statement delimiter, which is a semicolon, to the "&&" symbol. This is necessary because the procedure body contains semicolons, which would otherwise cause issues with execution.

```
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
```
#### Test run -
![image](https://user-images.githubusercontent.com/123494344/218332280-76b2c40b-a49b-4ea3-9ba6-85947acd1d84.png)

### Question - 3
#### Table Creation - 
The below script creates a table named "test" .

The table has two columns:

1. "candidate_id" - An integer column with a maximum length of 4 digits, and it cannot be NULL. The column is also marked as unique, meaning that no two rows can have the same value for this column.
2. "marks" - A floating-point column with a maximum precision of 10 digits and 2 decimal places. The default value for this column is 0.

This table can be used to store information about test scores for candidates, where each candidate is identified by a unique candidate ID and their marks are stored in the "marks" column.

```
create table if not exists test (
  candidate_id integer(4) not null unique, 
  -- As candidate id cannot be null and need to be unique
  marks float(10, 2) default 0
);
```
#### Insertion into table - 
We had inserted below data into table.
```
Insert into test 
values 
  (1, 98), 
  (2, 78), 
  (3, 87), 
  (4, 98), 
  (5, 78);
```
#### Procedure holding Query to rank them in proper order - 
The query is a  SQL procedure named "rank_in_order".
The procedure holds a query that calculates the rank of each candidate based on their marks. 
The query performs the following action upon execution : 

1. The query selects three columns: "Marks", "Rank", and "Candidate_id".
2. The dense_rank() calculates the rank of each candidate based on their marks. 
3. The query groups the data by marks, so that the same marks are grouped together.
4. The "GROUP_CONCAT()" function concatenates the candidate IDs for each group.

#### Functions and Statements used -
1. dense_rank() - The "dense_rank()" function is used to calculate the rank of each candidate based on their marks, 
2. GROUP_CONCAT() - The "GROUP_CONCAT()" function is used to concatenate the candidate IDs of all candidates with the same marks into a single string.

```
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
```
#### Test run -
![image](https://user-images.githubusercontent.com/123494344/218332305-78c04e23-568e-4f8d-841a-5061b6558c55.png)

### Question - 4

#### Table Creation - 
The below script creates a table named "mailids" .

The table has two columns:
1. "candidate_id" - An integer column with a maximum length of 4 digits, and it cannot be NULL.
2. "mail" - A string column with a maximum length of 30 characters, and it cannot be NULL.

This table can be used to store information about the email addresses of candidates, where each candidate is identified by a unique candidate ID and their email addresses are stored in the "mail" column.

```
create table if not exists mailids (
  candidate_id integer(4) not null, 
  -- As candidate id cannot be null and need to be unique
  mail varchar(30) not null
);
```
#### Insertion into table - 
We had inserted below data into table.
```
Insert into mailids 
values 
  (45, 'abc@gmail.com'), 
  (23, 'def@yahoo.com'), 
  (34, 'abc@gmail.com'), 
  (21, 'bcf@gmail.com'), 
  (94, 'def@yahoo.com');
```
#### Procedure holding Query to keep the value that has smallest id and delete all the other rows having same value - 

The query below is a stored procedure named "Delete_rows_with_same_value_except_smallest_id". 
The query performs the below actions upon execution

1. It deletes all rows from the "mailids" table where the candidate IDs have duplicate email addresses, and the candidate IDs are greater than the smallest candidate IDs with the same email addresses.
2. The inner join operation in the subquery is used to find all the duplicates in the "mail" column of the "mailids" table. The subquery returns the candidate IDs with duplicate email addresses, and the DELETE statement deletes all these rows except the ones with the smallest candidate IDs.
3. It displays the remaining rows in the "mailids" table, ordered by the candidate IDs in descending order.

```
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
```
#### Test run -
![image](https://user-images.githubusercontent.com/123494344/218390935-6a718b60-1eac-40e0-9a3a-71fdca2151f7.png)

As we said earlier we have created procedure for every question and as procedure calls are quick and efficient as stored procedures are compiled once and stored in executable form.Hence the response is quick. The executable code is automatically cached, hence lowers the memory requirements. Since the same piece of code is used again and again so, it results in higher productivity. Two or more sql statements can grouped and can be ran in a single call(used in Question - 4).

The below is snippet for calling the afore mentioned procedures -

```
-- Calling procedures
-- Question - 1
CALL get_num_of_male_and_female ();
-- Question - 2
CALL max_amount_from_rows_with_month_name();  
-- Question - 3
CALL rank_in_order();
-- Question - 4
CALL Delete_rows_with_same_value_except_smallest_id ();
```
