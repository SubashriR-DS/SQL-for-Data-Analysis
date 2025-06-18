create database windowsFn;
use windowsFn;


CREATE TABLE employees (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(20),
    salary INT
);

INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);

# --------------- 1.  OVER () adding into the Aggregate Function ----------------------------
 -- 1
SELECT emp_no, department, salary, AVG(salary) OVER()  as avg_sal_overall FROM employees;
 -- 2
 SELECT 
    emp_no, 
    department, 
    salary, 
    MIN(salary) OVER() as min_sal_overall,
    MAX(salary) OVER() as max_sal_overall
FROM employees;

-- 3  wrong
SELECT 
    emp_no, 
    department, 
    salary,
    MIN(salary), 
    MAX(salary)
FROM
    employees;


# ---------------- 2.  PARTITION BY()     --------------------------------------------------

-- 1.
	SELECT 
		emp_no, 
		department, 
		salary, 
		AVG(salary) OVER(PARTITION BY department) AS dept_avg,
		AVG(salary) OVER() AS company_avg 
FROM employees;

-- 2.
	SELECT 
		emp_no, 
		department, 
		salary, 
        Count(*) OVER(PARTITION BY department) AS dept_Counts,
        Count(*) OVER() AS  WholeEmployee
	FROM employees;
    
-- 3.
	SELECT 
		emp_no, 
		department, 
		salary, 
		SUM(salary) OVER(PARTITION BY department) AS dept_payroll,
		SUM(salary) OVER() AS total_payroll
FROM employees;

# ---------------------     3. ORDER BY with Windows    ---------------------------------

-- 1. 
SELECT 
    emp_no, 
    department, 
    salary, 
    SUM(salary) OVER(PARTITION BY department ORDER BY salary) AS rolling_dept_salary,
    SUM(salary) OVER(PARTITION BY department) AS total_dept_salary
FROM employees;

-- 2. 
	SELECT 
    emp_no, 
    department, 
    salary, 
    MIN(salary) OVER(PARTITION BY department ORDER BY salary DESC) as rolling_min
FROM employees;

# ------------ 4. Rank 
SELECT 
    emp_no, 
    department, 
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY SALARY DESC) as dept_row_number,
    RANK() OVER(PARTITION BY department ORDER BY SALARY DESC) as dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) as overall_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as overall_dense_rank,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as overall_num
FROM employees ORDER BY overall_rank;

#  ------------------              5. First Value CODE        ----------------------------
SELECT 
    emp_no, 
    department, 
    salary,
    FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) as highest_paid_dept,
    FIRST_VALUE(emp_no) OVER(ORDER BY salary DESC) as highest_paid_overall
FROM employees;


#  ------------------           6.   LEAD Value CODE

SELECT 
    emp_no, 
    department, 
    salary,
    salary - LEAD(salary) OVER(ORDER BY salary DESC) as salary_diff
FROM employees;

 #  ------------------           7.   LAG Value CODE
SELECT 
    emp_no, 
    department, 
    salary,
    salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_diff
FROM employees;


CREATE TABLE sales (
id INT PRIMARY KEY,
salesperson VARCHAR(50), region VARCHAR(50), sales_amount DECIMAL(10, 2)
);

INSERT INTO sales (id, salesperson, region, sales_amount) VALUES (1, 'Alice', 'North', 5000),
(2, 'Bob', 'South', 7000),
(3, 'Charlie', 'East', 7000),
(4, 'Dave', 'West', 6000),
(5, 'Eve', 'North', 8000),
(6, 'Frank', 'South', 5000),
(7, 'Grace', 'East', 7000),
(8, 'Heidi', 'West', 6000),
(9, 'Ivan', 'North', 8000),
(10, 'Judy', 'South', 9000);

# 1.	What is the difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` functions?
# `Rank()` When the rank became tied with gap the rank
# `DENSE_RANK()` without gap for the Tied rank
# `ROW_NUMBER()` is continuus values and its unique without considering the Duplicates

# 2.	Write a query to assign row numbers to each row in the `sales` table.
        
        select id, 
		Salesperson, region, 
        Sales_amount,
        row_number() over ()
        from Sales;

# 3.	Write a query to rank salespeople based on their sales amounts in descending order.
        select id, 
		Salesperson, region, 
        Sales_amount,
        rank() over (order by  Sales_amount DESC) as Rank_By_salesAmount
        from Sales;
      
# 4.	Write a query to dense rank salespeople based on their sales amounts in descending order.
        Select id, Salesperson,region,Sales_amount,
        dense_rank() over(order by Sales_amount DESC) as DenseRak_By_SalesAmount
        from Sales;

# 5.	Write a query to find the salesperson(s) with the highest sales amount in each region.

		Select id, SAlesperson, region,Sales_amount,
        dense_rank() over (partition by region order by SAles_amount desc) as Highest_Rank_inEachRegion
        from Sales;
        -- sub query
        select * from (Select id, SAlesperson, region,Sales_amount,
        dense_rank() over (partition by region order by SAles_amount desc) as Highest_Rank_inEachRegion
        from Sales) t1 
        where Highest_Rank_inEachRegion =1 
        order by Sales_amount desc;

# 6.	Write a query to rank salespeople based on their sales amounts within each region.

		Select id, SAlesperson, region,Sales_amount,
        rank() over (partition by region order by Sales_amount DESC) as rank_Based_Region
        from Sales;
        
# 7.	Write a query to dense rank salespeople based on their sales amounts within each region.

		Select id, SAlesperson, region,Sales_amount,
        dense_rank() over (partition by region order by Sales_amount DESC) as rank_Based_Region
        from Sales;
        
# 8.	Write a query to assign row numbers to salespeople within each region.

		Select id, SAlesperson, region,Sales_amount,
		row_number() over (partition by region order by Sales_amount DESC) as rank_Based_Region
        from Sales;
        
# 9.	What happens if two salespeople have the same sales amount when using the `RANK()` function

	 -- It skips the next number and folow the same 
		