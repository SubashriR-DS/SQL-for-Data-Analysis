create database HRDB;
use HRDB;

CREATE TABLE EMPLOYEES (
                            EMP_ID CHAR(9) NOT NULL, 
                            F_NAME VARCHAR(15) NOT NULL,
                            L_NAME VARCHAR(15) NOT NULL,
                            SSN CHAR(9),
                            B_DATE DATE,
                            SEX CHAR,
                            ADDRESS VARCHAR(30),
                            JOB_ID CHAR(9),
                            SALARY DECIMAL(10,2),
                            MANAGER_ID CHAR(9),
                            DEP_ID CHAR(9) NOT NULL,
                            PRIMARY KEY (EMP_ID));
                            
  CREATE TABLE JOB_HISTORY (
                            EMPL_ID CHAR(9) NOT NULL, 
                            START_DATE DATE,
                            JOBS_ID CHAR(9) NOT NULL,
                            DEPT_ID CHAR(9),
                            PRIMARY KEY (EMPL_ID,JOBS_ID));
 
 CREATE TABLE JOBS (
                            JOB_IDENT CHAR(9) NOT NULL, 
                            JOB_TITLE VARCHAR(30),
                            MIN_SALARY DECIMAL(10,2),
                            MAX_SALARY DECIMAL(10,2),
                            PRIMARY KEY (JOB_IDENT));

CREATE TABLE DEPARTMENTS (
                            DEPT_ID_DEP CHAR(9) NOT NULL, 
                            DEP_NAME VARCHAR(15) ,
                            MANAGER_ID CHAR(9),
                            LOC_ID CHAR(9),
                            PRIMARY KEY (DEPT_ID_DEP));

CREATE TABLE LOCATIONS (
                            LOCT_ID CHAR(9) NOT NULL,
                            DEP_ID_LOC CHAR(9) NOT NULL,
                            PRIMARY KEY (LOCT_ID,DEP_ID_LOC));
                            
                            
		show databases;

		select * from hrdb.employees;
		select * from hrdb.jobs;
		select * from hrdb.departments;
		delete from hrdb.departments where LOC_ID in ('2','5','7');

		select * from hrdb.job_history;
		select * from hrdb.locations;



# 1.	Retrieve all employees whose address is in Elgin,IL
	select * from hrdb.employees
    where ADDRESS like '%Elgin,IL%';

# 2.	Retrieve all employees in department 5 whose salary is between 60000 and 70000.

		select * from hrdb.employees e
		where e.DEP_ID =5 and ( e.salary between 60000 and 70000);

		-- salary wise sorting the employee

		select * from hrdb.employees 
		order by salary desc limit 4;

# 3.	Retrieve a list of employees ordered by department ID.
		select * from hrdb.employees
		order by DEP_ID;

# 4.	For each department ID retrieve the number of employees in the department

		select e.DEP_ID, d.DEP_NAME ,count(*) as No_of_Person 
		from hrdb.employees e
		inner join hrdb.departments d
		on e.DEP_ID = d.DEPT_ID_DEP
		group by DEP_ID
		order by DEP_ID;

		select sex,count(*)
		from hrdb.employees
		group by sex;

		select sex,sum(salary)
		from hrdb.employees
		group by sex;

		select sex,avg(salary)
		from hrdb.employees
		group by sex;

		select sex,min(salary)
		from hrdb.employees
		group by sex;

		select sex,max(salary)
		from hrdb.employees
		group by sex;
# 5.	For each department retrieve the number of employees in the department, and the average employee salary in the department.

		select e.DEP_ID, d.DEP_NAME ,count(*) as No_of_Person ,round(avg(SALARY),2) 
		from hrdb.employees e
		inner join hrdb.departments d
		on e.DEP_ID = d.DEPT_ID_DEP
		group by DEP_ID
		order by DEP_ID;

# 6.	For each department retrieve the number of employees in the department, and the average employee salary in the department and limit the result to departments with fewer than 4 employees.

		select e.DEP_ID, d.DEP_NAME ,count(*) as No_of_Person ,round(avg(SALARY),2) 
		from hrdb.employees e
		inner join hrdb.departments d
		on e.DEP_ID = d.DEPT_ID_DEP
		group by DEP_ID
		having no_of_person<4
		order by DEP_ID;

# Hands on Build in Functions

create table PETRESCUE (
	ID INTEGER NOT NULL,
	ANIMAL VARCHAR(20),
	QUANTITY INTEGER,
	COST DECIMAL(6,2),
	RESCUEDATE DATE,
	PRIMARY KEY (ID)
	);

insert into PETRESCUE values 
	(1,'Cat',9,450.09,'2018-05-29'),
	(2,'Dog',3,666.66,'2018-06-01'),
	(3,'Dog',1,100.00,'2018-06-04'),
	(4,'Parrot',2,50.00,'2018-06-04'),
	(5,'Dog',1,75.75,'2018-06-10'),
	(6,'Hamster',6,60.60,'2018-06-11'),
	(7,'Cat',1,44.44,'2018-06-11'),
	(8,'Goldfish',24,48.48,'2018-06-14'),
	(9,'Dog',2,222.22,'2018-06-15');
    

 # Questions Aggregate Functions:
 
 select * from hrdb.petrescue;
# Query A1: Enter a function that calculates the total cost of all animal rescues in the PETRESCUE table. 
			select sum(cost) as Total_cost from petrescue;
            
# Query A2: Enter a function that displays the total cost of all animal rescues in the PETRESCUE table in a column called SUM_OF_COST. 
			select sum(cost) as SUM_OF_COST from petrescue;
            
# Query A3: Enter a function that displays the maximum quantity of animals rescued. 
			select max(quantity) as max_rescued from petrescue ;
            
#Query A4: Enter a function that displays the average cost of animals rescued. 
			select round(avg(cost)) as avg_OF_COST from petrescue;
            
# Query A5: Enter a function that displays the average cost of rescuing a dog.

			select * from hrdb.petrescue where animal ='Dog';
            
			select round(sum(cost)/sum(quantity)) as avg_cost from hrdb.petrescue
			where ANIMAL = 'dog';
			

# Questions Scalar and String Functions: 
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Query B1: Enter a function that displays the rounded cost of each rescue. 
		select round(avg(cost)) as avg_cost_animal from hrdb.petrescue;

# Query B2: Enter a function that displays the length of each animal name. 
		select id,animal,length(animal) as length_of_animal from hrdb.petrescue
		order by length_of_animal;

# Query B3: Enter a function that displays the animal name in each rescue in uppercase.
		select id,animal,upper(animal) as uppercase_animal from hrdb.petrescue
		order by uppercase_animal;
        
# Query B4: Enter a function that displays the animal name in each rescue in uppercase without duplications. 
		select distinct animal,upper(animal) as uppercase_animal from hrdb.petrescue
		order by uppercase_animal;

# Query B5: Enter a query that displays all the columns from the PETRESCUE table, where the animal(s) rescued are cats. Use cat in lower case in the query.
		 select id,lower(animal),QUANTITY,COST from hrdb.petrescue
		 where animal ='cat';

# Questions Date and Time Functions: 
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Query C1: Enter a function that displays the day of the month when cats have been rescued. 
			select *,dayofmonth(rescuedate) from hrdb.petrescue;

# Query C2: Enter a function that displays the number of rescues on the 5th month. 
			select *, monthname(rescuedate) as month
			from hrdb.petrescue
			having month ='May';
            
            select sum(QUANTITY) from hrdb.petrescue 
            where day(rescuedate) ='05';

# Query C3: Enter a function that displays the number of rescues on the 14th day of the month.
			 select *, count(*) as count from hrdb.petrescue
			 where day(rescuedate) ='14';

# Query C4: Animals rescued should see the vet within three days of arrivals. Enter a function that displays the third day from each rescue. 
			select *,date_add(rescuedate, interval 3 day) as Third_day from hrdb.petrescue;

# Query C5: Enter a function that displays the length of time the animals have been rescued; the difference between todays date and the rescue date.
			select *, datediff(curdate(),rescuedate) +'days'  as total_days from hrdb.petrescue;



   
    
    

