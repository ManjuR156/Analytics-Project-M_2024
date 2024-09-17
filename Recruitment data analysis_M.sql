create database HR_recr_prtice

use HR_recr_prtice

create table Recr_data
(Position varchar(max),	full_name varchar(max),	Gender varchar(max),Salary varchar(max), Department varchar(max),	
DepartmentName varchar(max),Division varchar(max),	AssignmentCategory varchar(max),	Title varchar(max),
HiringAnalyst varchar(max),	VacancyStatus varchar(max),	VacancyDate varchar(max),	BudgetDate varchar(max),
PostingDate varchar(max),	InterviewDate varchar(max),	OfferDate varchar(max),
AcceptanceDate varchar(max),	SecurityCheckDate varchar(max),	HireDate varchar(max))

select * from Recr_data

bulk insert Recr_data
from 'E:\Manju\Learnbay\SQL\Sagar Sir Project - May\HR Recruit\Hr_recruitement.csv'
with
	(fieldterminator = ',',
	 rowterminator = '\n',
	 firstrow = 2,
	 maxerrors = 20)

select COLUMN_NAME, data_type 
from INFORMATION_SCHEMA.COLUMNS
	
alter table Recr_data
alter column salary int

select position,salary, REPLACE(salary, SUBSTRINg(salary,patindex('%[^0-9]%',salary) ,1),'') as modi_sal 
from Recr_data
where ISNUMERIC(Salary) = 0

update Recr_data set Salary = REPLACE(salary, SUBSTRINg(salary,patindex('%[^0-9]%',salary) ,1),'')
where ISNUMERIC(Salary) = 0

alter table Recr_data
alter column salary decimal

alter table recr_data
alter column VacancyDate date

alter table recr_data
alter column BudgetDate date

alter table recr_data
alter column PostingDate date

alter table recr_data
alter column InterviewDate date

alter table recr_data
alter column OfferDate date

alter table recr_data
alter column AcceptanceDate date

alter table recr_data
alter column SecurityCheckDate date

alter table recr_data
alter column HireDate date


select * from Recr_data
where full_name is null

select * from Recr_data
where HireDate is null
/* we can note that the hiredate and full name has null values for 103 records*/

/*5. Dept wise vacancies .....for each dept*/

select Department, COUNT(Position) 
from Recr_data
where VacancyStatus = 'vacant'
group by Department

		-------Which dept has the highest vacancies----
		select Department, COUNT(Position) as count_pos
		from Recr_data
		where VacancyStatus = 'vacant'
		group by Department
		order by count_pos desc


/*3. Fulltime vs part time distribution*/

with parttime_perc as (select Department, sum(case when AssignmentCategory = 'Fulltime-regular' then 1 else 0 end) as Fulltime_dist,
sum(case when AssignmentCategory = 'parttime-regular' then 1 else 0 end) as parttime_dist
from Recr_data
where VacancyStatus = 'filled'
group by Department)

select Department, Fulltime_dist, parttime_dist, ISNULL(parttime_dist*100/nullif(parttime_dist + Fulltime_dist,0),0)  as Parttime_perc
from parttime_perc


/*1. Gender wise salary gap*/

with gend_sal as (select Department, AVG(case when Gender = 'F' then Salary end) as 'Avg_sal_Fem',    
AVG(case when Gender = 'M' then Salary end) as 'Avg_sal_Male' 
from Recr_data
where VacancyStatus = 'filled'
group by Department)

select department, Avg_sal_Fem, Avg_sal_Male, Avg_sal_Male-Avg_sal_Fem as 'Salary_gap'
from gend_sal
order by Salary_gap

/*6. Avg days to hire - days taken by recr to fill position*/

---diff bw Posting date and hire date

select top 1 Department, avg(DATEDIFF(DAY, PostingDate, HireDate)) as Avg_hire_days 
from Recr_data
where VacancyStatus = 'filled'
group by Department
order by Avg_hire_days

/*7. Avg days to fill - days taken by org to fill position*/

select Department, avg(DATEDIFF(DAY, VacancyDate, HireDate)) as Avg_days_to_fill
from Recr_data
where VacancyStatus = 'filled'
group by Department
order by Avg_days_to_fill desc

/* 10. yearly hiring distribution */

select year(HireDate) as 'Year_hired', Department, COUNT(Position) as hire_count
from Recr_data
where VacancyStatus = 'filled' and Department = 'POL'
group by YEAR(HireDate), Department
order by hire_count desc

select Department, COUNT(Position) as hire_count 
from Recr_data
where VacancyStatus = 'filled' 
group by Department
order by hire_count desc

				Select COUNT(Position) as hire_count
				from Recr_data
				where VacancyStatus = 'filled' ---8998

				Select 1794+1500+1268+1186 ---5748

				select 5748*100/8998------63% 


/*11. Avg salary for every 15 years.*/

select min(hiredate) as mind,max(hiredate) as maxd 
from Recr_data
where VacancyStatus = 'filled'

			with avg_thr_sum as (select Department, sum(case when year(HireDate) between '2001' and '2015' then salary else 0 end) as Total_sum_2000_15,
			sum(case when year(HireDate) between '2001' and '2015' then 1 end) as count_2000_2015
			from Recr_data
			group by Department)

			select department, Total_sum_2000_15/count_2000_2015 as Avg_2000_15 
			from avg_thr_sum

			select * from Recr_data
			where Department = 'POL'

with avg_sal_period as (select department, sum(case when year(HireDate) between '1955' and '1970' then salary else 0 end) as Total_sal_1955_70,
count(case when year(HireDate) between '1955' and '1970' then 1 end) as count_sal_1955_70,
sum(case when year(HireDate) between '1971' and '1985' then salary else 0 end) as Total_sal_1971_85,
count(case when year(HireDate) between '1971' and '1985' then 1 end) as count_sal_1971_85,
sum(case when year(HireDate) between '1986' and '2000' then salary else 0 end) as Total_sal_1986_2000,
count(case when year(HireDate) between '1986' and '2000' then 1 end) as count_sal_1986_2000,
sum(case when year(HireDate) between '2001' and '2015' then salary else 0 end) as Total_sal_2001_2015,
count(case when year(HireDate) between '2001' and '2015' then 1 end) as count_sal_2001_2015
from Recr_data
group by Department)

select department, isnull(Total_sal_1955_70/nullif(count_sal_1955_70,0),0) as avg_sal_1955_70,  
isnull(Total_sal_1971_85/nullif(count_sal_1971_85,0),0) as avg_sal_1971_85,
isnull(Total_sal_1986_2000/nullif(count_sal_1986_2000,0),0) as avg_sal_1986_2000,
isnull(Total_sal_2001_2015/nullif(count_sal_2001_2015,0),0) as avg_sal_2001_2015
from avg_sal_period



/* Top recruiter for each dept */

with top_recr as (select Department, HiringAnalyst, COUNT(Position) as count_hire , 
ROW_NUMBER() over(partition by department order by COUNT(Position) desc) as row_num
from Recr_data
where VacancyStatus = 'filled'
group by Department, HiringAnalyst)

select Department, hiringanalyst, count_hire, row_num
from top_recr
where row_num = 1
order by count_hire

select HiringAnalyst,COUNT(Position) as count_hire 
from Recr_data
where VacancyStatus = 'filled'
group by HiringAnalyst
order by count_hire desc


select Department, COUNT(case when Gender = 'F' then 1 else 0 end) as Fem_count, COUNT(case when Gender = 'M' then 1 else 0 end) 
as Male_count 
from Recr_data
where VacancyStatus = 'filled' and Department = 'ZAH'
group by Department
