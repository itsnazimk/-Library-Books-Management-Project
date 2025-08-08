#######################################
-- PROJECT - LIBRARY BOOKS MANAGEMENT
########################################

-- create databse
create database if not exists library_mngt ; 

use library_mngt ; 

-- show tables 
show tables ; 

## creating tables in database 
-- 1. table branch
create table branch(
branch_id	varchar(25) primary key ,
manager_id	varchar(25),
branch_address	varchar(50),
contact_no varchar(25) ) ; 


-- 2. table employees
DROP TABLE IF EXISTS employees; 
CREATE TABLE employees (
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id) );
            
--  3. table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE) ; 
            
--  4. table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30) ) ;             

-- 5.  table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)  ) ;
            
-- 6. table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn) ); 
            
## CRUD OPERATIONS
/* CRUD Operations
Create: Inserted sample records into the books table.
Read: Retrieved and displayed data from various tables.
Update: Updated records in the employees table.
Delete: Removed records from the members table as needed.
*/

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.' ) ; 

-- Task 2: Update an Existing Member's Address , member id = c103 change address to "125 oak St"
select * from members ; 
update members 
set member_address = "125 Oak St" 
where member_id = "c103" ;

-- recheking address 
select * from members where member_id = "c103" ;  

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status where issued_id = "is121" ; 

-- recheck
select * from issued_status where issued_id = "is121" ;

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status where issued_emp_id = "e101" ; ; 

-- Task 5: List Employees Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id  , count(*) as total_issued
from issued_status
group by 1
having total_issued > 1 ; 
/* 
JFK
WHERE Clause: Filters individual rows before any grouping or aggregation occurs. It's used to specify conditions on raw data.
HAVING Clause: Filters groups after aggregation has been performed. It's used to specify conditions on aggregated data.
*/

## Data Analysis
-- Task 6. Retrieve All Books in a Specific Category "classic":
select * from books where category = "classic"  ; 

-- Task 7: Find Total Rent by Category :
select category , sum(rental_price) as total_rent from books group by category ;  

-- Task 8 : List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;

-- Task 9 : List Employees with Their Branch Manager's Name and their branch details:
select * from employees ;
select * from branch ; 

SELECT 
  e.emp_id,
  e.emp_name,
  e.position,
  e.salary,
  e.branch_id,
  b.branch_address,
  b.contact_no,
  m.emp_name AS manager_name
FROM employees e
JOIN branch b ON e.branch_id = b.branch_id
JOIN employees m ON b.manager_id = m.emp_id;

-- Task 10. Create a Table of Books with Rental Price Above 7 as  Threshold:
create table expensiv_books as
select * from books where rental_price > 7.00 ;

-- check expensiv_book
select * from expensiv_books ; 

-- Task 11: Retrieve the List of Books Not Yet Returned
                     select * from issued_status ;
                      select * from return_status ;
                      
select ist.* , rst.return_id
from issued_status as ist
left join return_status as rst
on ist.issued_id = rst.issued_id
where rst.return_id is null;

-- ----------
## DONE
-- ----------