Create database Practice

Use Practice

Create table tblGender
(
Id int NOT NULL	primary key,
Gender varchar(10) not null
) 

insert into tblGender values(1,'Male')
insert into tblGender values(2,'Female')

Select *from tblGender

Create table tblPerson
(
Id int not null primary key,
PersonName varchar(50),
Email varchar(20),
GenderId int FOREIGN KEY REFERENCES tblGender(Id)  
)

alter table  tblPerson alter column Email varchar(100)  
alter table tblPerson alter column PersonName varchar(50) not null

insert into tblPerson values (1,'dhoni','dhoni_Thelegend@india.com',1)
insert into tblPerson values (2,'kohli','kohli_ChaseMaster@india.com',1)
insert into tblPerson values (3,'Rohit','rohit_TheHitman@india.com',1)

select *from tblGender
Select *from tblPerson

--adding Default constraint 
alter table tblPerson
add  constraint defaultValue_tblPerson_GenderId
default 1 for GenderId

--Dropping an existing constraint 
alter table tblPerson drop constraint defaultValue_tblPerson_GenderId

insert into tblPerson (Id,PersonName,Email)values(4,'Manish Pandey','Pandey_futureofIndia@india.com')

Select *from tblPerson 

delete from  tblGender where Id=1 

alter table tblPerson add  age int

--adding check constraint 
alter table tblPerson add constraint ageLimit_tblperson Check (age >0)


--idenity column 
create table Identity_example
(Id int identity(1,1),
 Company_Name varchar(50)
)

insert into Identity_example values ('Epam');
insert into Identity_example values ('Wipro');
 
select *from Identity_example

create table Identity_example1
(Id int identity(1,1),
 Company_Name varchar(50)
)

insert into Identity_example values('EPAM')
insert into Identity_example values('TCS')
 
--trigger to insert data to Identity_example1 when we try to insert into Identity_example

 alter trigger trForInsert on Identity_example for insert 
 as 
 begin 
  insert into Identity_example1 values ('YYYY')
 end



insert into Identity_example values ('byteridge');

select *from Identity_example
select *from Identity_example1

select SCOPE_IDENTITY()  --with in the same scope and same session  
select @@IDENTITY -- last generated  identity value with in same session and any scope 
select IDENT_CURRENT('Identity_example1') 

--adding unique key constraint 

 alter table tblPerson add constraint UniqueMail_tblPerson Unique (Email) 
 select *from tblPerson 
 update tblPerson set age=36 where PersonName='dhoni' 
 update tblPerson set age=28 where PersonName='kohli' 
 update tblPerson set age=29 where PersonName='Rohit' 
 update tblPerson set age=24 where PersonName='Manish Pandey' 

 Insert into tblPerson (Id,PersonName,GenderId,age)values(5,'Hardik pandya',1,25)
 --Tryig to update the email of hardik with dhoni's email id which violates the UNIQUE KEY constraint property 
 update tblPerson set Email='dhoni_Thelegend@india.com' where PersonName='Hardik pandya'  --gives error
 
 update tblPerson set Email='hardik_allRounder@india.com' where PersonName='Hardik pandya'  

--renaming table name  'tblPerson' to 'tblCricketers'
sp_rename 'tblPerson','tblCricketers'

select *from tblCricketers
--adding city column to the tblCricketers table
alter table tblCricketers add city varchar(20) 
--updating city column data 
update tblCricketers set city ='Ranchi' where PersonName='dhoni'
update tblCricketers set city ='Delhi' where PersonName='kohli'
update tblCricketers set city ='Mumbai' where PersonName='Rohit'
update tblCricketers set city ='Gujarath' where PersonName='Hardik pandya'
update tblCricketers set city ='Nianatal' where PersonName='Manish Pandey'


select * from tblCricketers where age in(36,28)
select * from tblCricketers where age between 28 and 36
select *from tblCricketers where PersonName LIKE '_o%i'

select *from tblCricketers  

use Practice
alter table tblCricketers add ManagerId int

update  tblCricketers set ManagerId=1 where Id =5 
update  tblCricketers set ManagerId=2 where Id =4 
update  tblCricketers set ManagerId=3 where Id =3 
update  tblCricketers set ManagerId=4 where Id =2 
update  tblCricketers set ManagerId=5 where Id =1 

--replacing null values
--using is null
SELECT *from tblCricketers
select T.PersonName as Person ,isnull(M.PersonName,'No manager') as manager from tblCricketers T
 Left join tblCricketers M
 on
  T.ManagerId = M.Id

 --using case 
SELECT *from tblCricketers
select T.PersonName as Person ,case when T.ManagerId is null then 'no Manager' else M.PersonName end as manager from tblCricketers T
 Left join tblCricketers M
 on
  T.ManagerId = M.Id


  update tblCricketers set ManagerId =null where ManagerId=5
  use Practice

  select distinct GenderId,age,city from tblCricketers


  --About COALESCE 

--It returns the first non NULL value 
use EmployeedB
select *from Employees
insert into Employees (FirstName,Gender,Salary) values('Manikanta','male',6)
insert into Employees (LastName,Gender,Salary) values('jami','male',6)
select *from Employees
select COALESCE(FirstName,LastName) as name,Gender,Salary from Employees

--About Union and Union all

-- diffrences between union and union all 
-- Union removes dulpicate rows where as union all does not 
--Union has to perform distinct sort to remove duplicates,which makes it less faster than UNION ALL
--for UNION and UNION ALL the number of coulmns,datatypes,order of columns must be same in both select statements
--Union combines rows from two or more tables where as join combines columns from two or more tables


alter procedure spGetEmployeeByGender
@Gender nvarchar(10),
@Salary int
as 
begin
Select *from Employees where Gender=@Gender and Salary>@Salary
end
exec spGetEmployeeByGender 'male',6

create procedure spGetEmployeeCount
@Gender nvarchar(10),
@EmployeeCount int output 
as 
begin
Select @EmployeeCount =Count(id) from Employees where Gender=@Gender
end 
declare @EmployeeCount int
EXEC spGetEmployeeCount 'male',@EmployeeCount out
print @EmployeeCount

sp_help spGetEmployeeCount
sp_depends spGetEmployeeCount