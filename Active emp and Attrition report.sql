Create database Kaggle_HR1

use kaggle_hr1

create table Emp_data
(EmpID varchar(max),	FirstName varchar(max),	LastName varchar(max),	StartDate varchar(max),	ExitDate varchar(max),	
Title varchar(max),	Supervisor varchar(max),	ADEmail varchar(max),	BusinessUnit varchar(max),	EmployeeStatus varchar(max),
EmployeeType varchar(max),	PayZone varchar(max),	EmployeeClassificationType varchar(max),	TerminationType varchar(max),
TerminationDescription varchar(max),	DepartmentType varchar(max),	Division varchar(max),	DOB varchar(max),	State varchar(max),
JobFunctionDescription varchar(max),	GenderCode varchar(max),	LocationCode varchar(max),	RaceDesc varchar(max),	MaritalDesc varchar(max),
Performance_Score  varchar(max),	Current_Employee_Rating varchar(max))

bulk insert emp_data
from 'E:\Manju\Learnbay\SQL\Sagar Sir Project - May\From Kaggle\employee_data.csv'
with
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from Emp_data

create table Eng_survey
(Employee_ID varchar(max),	Survey_Date varchar(max),	Engagement_Score varchar(max),	Satisfaction_Score varchar(max),
Work_Life_Balance_Score varchar(max))

bulk insert eng_survey
from 'E:\Manju\Learnbay\SQL\Sagar Sir Project - May\From Kaggle\employee_engagement_survey_data.csv'
with
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from Eng_survey

create table training
(Employee_ID varchar(max),	Training_Date varchar(max),	Training_Program_Name varchar(max),	Training_Type varchar(max),
Training_Outcome varchar(max),	Location varchar(max),	Trainer varchar(max),	Training_Duration_Days varchar(max),
Training_Cost varchar(max))

bulk insert training
from 'E:\Manju\Learnbay\SQL\Sagar Sir Project - May\From Kaggle\training_and_development_data.csv'
with
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from training

select column_name, data_type
from INFORMATION_SCHEMA.COLUMNS

select distinct EmpID from  Emp_data

---- startdate, exitdate, DOB (date), Current_Emp_rating (numeric)

alter table emp_data
alter column startdate date

alter table emp_data
alter column exitdate date

select * from Emp_data
where ISDATE(ExitDate) = 0 

select * from Emp_data
where ExitDate is not null

alter table emp_data
alter column current_employee_rating smallint

alter table emp_data
alter column DOB date

	select * from Emp_data
	where ISDATE(DOB) = 0

	select DOB, convert(date,DOB,105) as conv_date 
	from Emp_data

	update emp_data set DOB = convert(date,DOB,105)

select EmployeeStatus, TerminationType 
from Emp_data
where ExitDate is not null 

			select distinct EmployeeStatus from Emp_data

			select *
			from Emp_data
			where EmployeeStatus in ('Future start', 'Active') and ExitDate is not null

			select *
			from Emp_data
			where EmployeeStatus in ('leave of absence') and ExitDate is not null

			select *
			from Emp_data
			where EmployeeStatus in ('future start') and ExitDate is not null

			select EmpID, FirstName, ExitDate,EmployeeStatus,
			case when ExitDate is not null then 'Inactive' else 'Active' end as 'Cor_emp_status' 
			from Emp_data

			alter table emp_data
			add cor_emp_status varchar(50)

			update emp_data set Cor_emp_status = case when ExitDate is not null then 'Inactive' else 'Active' end

Select * from Eng_survey

alter table eng_survey
alter column survey_date date
	
	Select * from Eng_survey
	where ISDATE(Survey_Date) = 1

	Select convert(date, Survey_Date,105) from Eng_survey

	update Eng_survey set Survey_Date = convert(date, Survey_Date,105)

alter table eng_survey
alter column engagement_score decimal(10,2) ---While calculating avg decimal datatype will be helpful for accuracy 

alter table eng_survey
alter column satisfaction_score decimal(10,2)

alter table eng_survey
alter column Work_life_balance_score decimal(10,2)


select * from training
where ISDATE(Training_Date) = 0

alter table training
alter column training_date date

alter table training
alter column training_duration_days smallint

alter table training
alter column training_cost decimal(10,2)


--- connect the tables

select * from Emp_data

select distinct BusinessUnit from Emp_data
select distinct Supervisor from Emp_data
select distinct DepartmentType from Emp_data

select BusinessUnit, DepartmentType from Emp_data /*We can infer that each BU has similar depts and 
Business units typically have their own goals and objectives, 
which may be different from those of the company as a whole. We will do our analysis w.r.t to each BU*/

/*1. Active headcount*/
Select BusinessUnit, sum(case when cor_emp_status = 'Active' then 1 else 0 end) as Active_headcount 
from Emp_data
group by BusinessUnit

Select * from Emp_data
where cor_emp_status = 'Active'

/*2. Emp_type dist*/
	Select distinct EmployeeType from Emp_data
			/*
			Full-Time
			Contract
			Part-Time
			*/
select BusinessUnit,sum(case when cor_emp_status = 'Active' then 1 else 0 end) as Active_headcount,
sum(case when EmployeeType = 'Full-Time' then 1 else 0 end) as 'Full-time_count',
sum(case when EmployeeType = 'Part-Time' then 1 else 0 end) as 'Part-time_count',
sum(case when EmployeeType = 'Contract' then 1 else 0 end) as 'Contract_count'
from Emp_data
where cor_emp_status = 'Active'
group by BusinessUnit
order by Active_headcount desc

/*3. Gender dist*/
select BusinessUnit,sum(case when cor_emp_status = 'Active' then 1 else 0 end) as Active_headcount,
sum(case when GenderCode = 'Male' then 1 else 0 end) as 'Male_count',
sum(case when GenderCode = 'Female' then 1 else 0 end) as 'Female_count'
from Emp_data
where cor_emp_status = 'Active'
group by BusinessUnit
order by Active_headcount desc

select * from Emp_data

/*4. Performance dist*/

select distinct Performance_Score from Emp_data

select BusinessUnit,sum(case when cor_emp_status = 'Active' then 1 else 0 end) as Active_headcount,
sum(case when Performance_Score = 'Exceeds' then 1 else 0 end) as 'Exceeds',
sum(case when Performance_Score = 'Fully meets' then 1 else 0 end) as 'Fully meets',
sum(case when Performance_Score = 'Needs improvement' then 1 else 0 end) as 'Needs improvement',
sum(case when Performance_Score = 'PIP' then 1 else 0 end) as 'PIP'
from Emp_data
where cor_emp_status = 'Active'
group by BusinessUnit
order by Active_headcount desc

------For further analysis using Eng_survey and Training tables we need to connect them using PK and FK constraints

alter table emp_data
add constraint PKKag primary key (EmpID) /*A column with Varchar(>250) cannot be constrained as PK. hence change its value (<250)*/

		alter table emp_data
		alter column empID varchar(40) not null

select distinct Employee_ID from Eng_survey

		alter table eng_survey
		alter column employee_ID varchar(40) not null

alter table eng_survey
add constraint FKKag1 foreign key (employee_ID) references emp_data(EmpID) 


select distinct Employee_ID from training

		alter table training
		alter column employee_ID varchar(40) not null

alter table training
add constraint FKKag2 foreign key (employee_ID) references emp_data(EmpID) 

---------Now the tables are connected.----

/*5. Engagement score dist*/
select * from Emp_data
select * from Eng_survey

select min(Engagement_Score),avg(Engagement_Score), max(Engagement_Score)  from Eng_survey

		select BusinessUnit, avg(engagement_score) as Avg_eng_score 
		from Emp_data Em
		inner join Eng_survey Eg
		on em.EmpID = eg.Employee_ID
		where Survey_Date between '2023-01-01' and '2023-08-05'
		group by BusinessUnit

select min(Survey_Date), max(Survey_Date) from Eng_survey

select BusinessUnit, DepartmentType, avg(engagement_score) as Avg_eng_score,
avg(Satisfaction_Score) as avg_satis_score, AVG(Work_Life_Balance_Score) as avg_wrk_lif_score
from Emp_data Em
inner join Eng_survey Eg
on em.EmpID = eg.Employee_ID
where Survey_Date between '2022-08-05' and '2023-08-05'
group by BusinessUnit, DepartmentType
order by Avg_eng_score, avg_satis_score, avg_wrk_lif_score /*BU - EW , Dept_type - Executive has the least avg eng score of 1*/

	/*let us consider that any avg_eng_score < 2.75 needs attention*/

select BusinessUnit, DepartmentType, avg(engagement_score) as Avg_eng_score,
avg(Satisfaction_Score) as avg_satis_score, AVG(Work_Life_Balance_Score) as avg_wrk_lif_score
from Emp_data Em
inner join Eng_survey Eg
on em.EmpID = eg.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit, DepartmentType
order by avg_wrk_lif_score  /* BU - MSC, Dept_type - Software Engg has least avg_worklife_bal score*/


select DepartmentType, jobfunctiondescription , avg(engagement_score) as Avg_eng_score
from Emp_data Em
inner join Eng_survey Eg
on em.EmpID = eg.Employee_ID
where BusinessUnit = 'BPC' and cor_emp_status = 'Active'
group by DepartmentType, jobfunctiondescription
having avg(Engagement_Score) < 2.75
order by Avg_eng_score

select * from Emp_data

/*An employee can be satisfied with a job without being engaged in the job. Employee engagement is 
much more than being content with pay and the ability to leave at 3 pm. That contentedness is merely 
job satisfaction, and though satisfaction is generally enough to retain employees,it's not enough 
to ensure productivity. 
Therefore since we have data regarding training let us understand the relationship between 
Training success rate & Engagement_score */


/*6. Training success rate/ Course completion rate*/
select * from training

select distinct Training_Outcome from training

	/* select BusinessUnit, sum(case when Training_Outcome in ('Completed', 'Passed') then 1 else 0 end) as Total_trg_completed 
		from Emp_data em
		inner join training t
		on em.EmpID = t.Employee_ID
		group by BusinessUnit */

select BusinessUnit, DepartmentType, sum(case when Training_Outcome='Passed' then 1 else 0 end) as Total_trg_completed,
count(Employee_ID) as Total_trg_conducted
from Emp_data em
inner join training t
on em.EmpID = t.Employee_ID
group by BusinessUnit, DepartmentType

select BusinessUnit, sum(case when Training_Outcome='Passed' then 1 else 0 end) as Total_trg_completed,
count(Employee_ID) as Total_trg_conducted
from Emp_data em
inner join training t
on em.EmpID = t.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit



with Trg_success as (select BusinessUnit, sum(case when Training_Outcome='Passed' then 1 else 0 end) as Total_trg_completed,
count(Employee_ID) as Total_trg_conducted
from Emp_data em
inner join training t
on em.EmpID = t.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit)

select Businessunit, Total_trg_completed, Total_trg_conducted,  round(cast(Total_trg_completed as float)*100/Total_trg_conducted,2) as Trg_Successrate
from trg_success
		-------Only BU


with Trg_successt as (select BusinessUnit,DepartmentType, sum(case when Training_Outcome='Passed' then 1 else 0 end) as Total_trg_completed,
count(Employee_ID) as Total_trg_conducted
from Emp_data em
inner join training t
on em.EmpID = t.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit,DepartmentType)

select Businessunit,Departmenttype, Total_trg_completed, Total_trg_conducted,  round(cast(Total_trg_completed as float)*100/Total_trg_conducted,2) as Trg_Successrate
from trg_successt
		------- BU and Dept_type wise data


/*6. Training costs*/

Select min(Training_Cost),Avg(Training_Cost), max(Training_Cost) from training

select BusinessUnit, Avg(Training_Cost) as Avg_cost
from Emp_data em
inner join training t
on em.EmpID = t.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit
order by Avg_cost desc

/*7. Correlation check between Trainng success rate and engagement score*/

alter table training
add trg_pas decimal(10,2)

update training set Trg_pas = case when Training_Outcome = 'Passed' then 1 else 0 end

select * from training

declare @avg_eng_scr as float,
		@avg_trg_pas as float,
		@avg_wrk_lf_bal as float
		
	select @avg_eng_scr = avg(Engagement_Score),
			@avg_wrk_lf_bal = avg(Work_Life_Balance_Score),
		   @avg_trg_pas = SUM(case when Training_Outcome ='Passed' then 1 else 0 end)/COUNT(t.Employee_ID)	   
	from Eng_survey eg
	inner join training t
	on Eg.Employee_ID = t.Employee_ID
	inner join Emp_data em
	on t.Employee_ID = em.EmpID
	where cor_emp_status = 'Active'
	
	select sum((Engagement_Score - @avg_eng_scr)*(trg_pas - @avg_trg_pas)) /
	sqrt(sum(power((Engagement_Score - @avg_eng_scr),2))*sum(power((trg_pas - @avg_trg_pas),2)))
	from Eng_survey eg
	inner join training t
	on eg.Employee_ID = t.Employee_ID
	inner join Emp_data em
	on t.Employee_ID = em.EmpID
	where cor_emp_status = 'Active'

	select sum((Work_Life_Balance_Score - @avg_wrk_lf_bal)*(trg_pas - @avg_trg_pas)) /
	sqrt(sum(power((Work_Life_Balance_Score - @avg_wrk_lf_bal),2))*sum(power((trg_pas - @avg_trg_pas),2)))
	from Eng_survey eg
	inner join training t
	on eg.Employee_ID = t.Employee_ID
	inner join Emp_data em
	on t.Employee_ID = em.EmpID
	where cor_emp_status = 'Active'


/*7. Engagement rate*/

Select * from Eng_survey

with Eng_rate as (select BusinessUnit, sum(case when Engagement_Score >= 3 then 1 else 0 end) as Engaged_emp_count,
count(eg.Employee_ID) as Total_hdcount
from Emp_data em
inner join Eng_survey eg
on em.EmpID = eg.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit)

select businessunit,round(cast(Engaged_emp_count as float)*100/Total_hdcount,2) as Engage_rate
from eng_rate


select BusinessUnit, sum(case when Engagement_Score >= 3 then 1 else 0 end) 
from Emp_data em
inner join Eng_survey eg
on em.EmpID = eg.Employee_ID
where cor_emp_status = 'Active'
group by BusinessUnit



/* 8. Performance score and engagement and Training_pas*/

alter table emp_data
add Perf_scor_num smallint

update Emp_data set Perf_scor_num  = case when Performance_Score = 'Exceeds' then 4
											when  Performance_Score = 'Fully Meets' then 3
											when   Performance_score = 'Needs improvement' then 2
											  when Performance_score = 'PIP' then 1
											   else 'NA' end
											   
select * from Emp_data
select * from training

select PayZone, avg(cast(Perf_scor_num as float)) as Avg_perfor_score,
avg(cast(engagement_score as float)) as Avg_eng_score, SUM(trg_pas)*100/count(t.Employee_ID) as avg_pass
,avg(cast(Work_Life_Balance_Score as float)) as Avg_work_lif_bal_scr,
avg(cast(Satisfaction_Score as float)) as Avg_sat_score
from Emp_data em
inner join Eng_survey eg
on em.EmpID = eg.Employee_ID
inner join training t
on eg.Employee_ID = t.Employee_ID
where cor_emp_status = 'Active' and EmployeeType = 'Full-time'
group by PayZone
order by Avg_eng_score desc

select PayZone, avg(cast(Perf_scor_num as float)) as Avg_perfor_score,
avg(cast(engagement_score as float)) as Avg_eng_score, SUM(trg_pas)*100/count(t.Employee_ID) as avg_pass
,avg(cast(Work_Life_Balance_Score as float)) as Avg_work_lif_bal_scr,
avg(cast(Satisfaction_Score as float)) as Avg_sat_score
from Emp_data em
inner join Eng_survey eg
on em.EmpID = eg.Employee_ID
inner join training t
on eg.Employee_ID = t.Employee_ID
where cor_emp_status = 'Active' and EmployeeType = 'Part-time'
group by PayZone
order by Avg_eng_score desc

select PayZone, avg(cast(Perf_scor_num as float)) as Avg_perfor_score,
avg(cast(engagement_score as float)) as Avg_eng_score, SUM(trg_pas)*100/count(t.Employee_ID) as avg_pass
,avg(cast(Work_Life_Balance_Score as float)) as Avg_work_lif_bal_scr,
avg(cast(Satisfaction_Score as float)) as Avg_sat_score
from Emp_data em
inner join Eng_survey eg
on em.EmpID = eg.Employee_ID
inner join training t
on eg.Employee_ID = t.Employee_ID
where cor_emp_status = 'Active' and EmployeeType = 'Contract'
group by PayZone
order by Avg_eng_score desc

		-------- Zone A has least Avg_eng_score and Zone B has least avg_trg_pass, therefore Zone A has to work on Engagement
		----------Zone B has to work on passing trainings.

/* 9. Attrition rate yearwise */ 

select * from Emp_data

select min(StartDate), max(StartDate), DATEDIFF(YEAR, min(startdate),max(StartDate))
from Emp_data

select min(ExitDate), max(ExitDate), DATEDIFF(YEAR, min(ExitDate),max(ExitDate))
from Emp_data

				select count(case when StartDate < '2019-01-01' then EmpID end)-  
				count(case when ExitDate between '2018-11-19' and '2018-12-31' then EmpID end) 
				from Emp_data ------251 is the head count at the beginning of year 2019

				select count(case when ExitDate between '2019-01-01' and '2019-12-31' then EmpID end) as Resign_cnt,
				count(case when StartDate between '2019-01-01' and '2019-12-31' then EmpID end)+251-count(case when ExitDate between '2019-01-01' and '2019-12-31' then EmpID end)
				from Emp_data


declare @Start_cnt as float,
		 @End_cnt_19 as float,
		 @End_cnt_20 as float,
		 @End_cnt_21 as float,
		 @End_cnt_22 as float,
		 @End_cnt_23 as float

	Select  @Start_cnt=   count(case when StartDate < '2019-01-01' then EmpID end)-  
							count(case when ExitDate between '2018-11-19' and '2018-12-31' then EmpID end),
			@End_cnt_19 = @Start_cnt+count(case when StartDate between '2019-01-01' and '2019-12-31' then EmpID end)
							-count(case when ExitDate between '2019-01-01' and '2019-12-31' then EmpID end),
			@End_cnt_20 = @End_cnt_19+count(case when StartDate between '2020-01-01' and '2020-12-31' then EmpID end)
							-count(case when ExitDate between '2020-01-01' and '2020-12-31' then EmpID end),
			@End_cnt_21 = @End_cnt_20+count(case when StartDate between '2021-01-01' and '2021-12-31' then EmpID end)
							-count(case when ExitDate between '2021-01-01' and '2021-12-31' then EmpID end),
		    @End_cnt_22 = @End_cnt_21+count(case when StartDate between '2022-01-01' and '2022-12-31' then EmpID end)
							-count(case when ExitDate between '2022-01-01' and '2022-12-31' then EmpID end),
			@End_cnt_23 = @End_cnt_22+count(case when StartDate between '2023-01-01' and '2023-12-31' then EmpID end)
							-count(case when ExitDate between '2023-01-01' and '2023-12-31' then EmpID end)
			from Emp_data
			where BusinessUnit = 'MSC'

Select  @Start_cnt*100/(@Start_cnt+@End_cnt_19)/2 as Attrition_rate_19, 
@End_cnt_19*100/(@End_cnt_19+@End_cnt_20)/2 as Attrition_rate_20,
@End_cnt_20*100/(@End_cnt_20+@End_cnt_21)/2 as Attrition_rate_21,
@End_cnt_21*100/(@End_cnt_21+@End_cnt_22)/2 as Attrition_rate_22,
@End_cnt_22*100/(@End_cnt_22+@End_cnt_23)/2 as Attrition_rate_23
