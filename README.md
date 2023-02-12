# SQL-Assignment

The assignemnt has 4 questions, we have written procedures to each question which holds the query to fetch the required result, and each procedure is explained as below -

### Question - 1
The above query is a SQL stored procedure. The procedure is named "get_num_of_male_and_female".
The procedure performs the following actions upon execution :
- Selects data from the "employees" table.
- Groups the data by the "Department" column.
- Counts the number of occurrences of "Male" and "Female" in the "Gender" column and returns the results as two separate columns named "Num of Male" and "Num of Female".
- Returns the department name along with the count of male and female employees in each department, with a default value of "Not Assigned" for departments that have no assigned employees.
- The results are ordered by the "Department" column in ascending order.
- The "IFNULL" function is used to handle cases where the "Department" column has a NULL value. The "UPPER" function is used to convert the values in the "Gender" column to upper case to ensure that the case-insensitive comparison between the values and the hardcoded strings "MALE" and "FEMALE" works correctly.

The "CASE WHEN" statement is used to conditionally count the number of occurrences of "Male" and "Female" in the "Gender" column.

Finally, the "DELIMITER" statement is used to change the default SQL statement delimiter, which is a semicolon, to the "&&" symbol. This is necessary because the procedure body contains semicolons, which would otherwise cause issues with execution.



