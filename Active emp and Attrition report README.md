# Stock Price Prediction

## Link to problem dataset:  https://www.kaggle.com/datasets/ravindrasinghrana/employeedataset

## Problem Statement

This report helps the Management to understand the Engagement rate of Active employees and Attrition rate better. 

### Steps followed 

- Step 1 : Load the data into SQL, datasets are csv files (Employee_data, employee_engagement_survey_data, training_and_development_data) 
- Step 2 : Create a new column in 'Employee_data' table called as 'Cor_emp_status' and update values to this column through condition
	   when 'ExitDate' is not null then 'Inactive' else 'Active'. 
- Step 3 : Create a new column in 'training' table called as 'Trg_pas' and update values to this column through condition
	   when Training_Outcome = 'Passed' then 1 else 0. 
- Step 4 : Create a new column in 'Employee_data' table called as 'Perf_scor_num' and update values to this column through multiple conditions
	   when Performance_Score = 'Exceeds' then 4
	   when  Performance_Score = 'Fully Meets' then 3
	   when   Performance_score = 'Needs improvement' then 2
	   when Performance_score = 'PIP' then 1
	   else 'NA'
- Step 5 : Create a relationship between 'Employee_ID' columns of all three tables. let the primary key be in 'employee_data' table. 

	   Note: For detailed code and analysis please refer to the sql file.

- Step 6 : Load all three tables into Power BI Desktop from SQL server.
- Step 7 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.
- Step 8 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".
- Step 9 : It was observed that in none of the columns errors & empty values were present that would cause problems in analysis. 
- Step 10 : Create a calendar table using calendar function. then create a relationship between date column in 'calendar table' and 'exit_date' column in 'Employee_data'
	   also with 'startdate' column. let the relationship with 'exit_date' be active.

Snap of Relationships on Power BI,

![Relationships](https://github.com/user-attachments/assets/b5fedbac-27c7-4671-961c-2df713a317c3)


- Step 11 : Create a page for each of the recommended analysis i.e. Active employee report and Attrition rate
- Step 12 : In the Active employee report page, create a slicer and select 'BusinessUnit'column to filter the BusinessUnit. 
- Step 13 : Create a measure to count employee_IDs

	Cnt_emp = COUNT(Emp_data[EmpID])		

- Step 14 : Create a measure to calculate active count

	Active_count = CALCULATE([Cnt_emp], Emp_data[cor_emp_status] = "Active")

Snap of Active count,

![Active count](https://github.com/user-attachments/assets/8de27b97-a596-4845-84e1-465fbb31bbb0)


- Step 15 : Create a measure to calculate engaged count

	Engaged_cnt = CALCULATE([Cnt_emp], FILTER(VALUES(Emp_data), And(Emp_data[cor_emp_status] = "Active",RELATED(Eng_survey[Engagement_Score])>=3)))


- Step 16 : Create a measure to calculate Engagement rate            

	Engagement_rate = (DIVIDE([Engaged_cnt],[Active_count]))

Snap of Engagement_rate,

![Engagement rate](https://github.com/user-attachments/assets/d462e076-6966-4953-b5a0-68f607c04a76)


- Step 17 : Create a measure to calculate the sum of the training cost

	Total_Trg_cost = SUM(training[Training_Cost])

- Step 18 : Create a measure to calculate Average training cost

	Avg_trg_cost = DIVIDE(CALCULATE([Total_Trg_cost], FILTER(VALUES(training), RELATED(Emp_data[cor_emp_status])="Active")),[Active_count])

Snap of Average training cost,

![Average Training cost](https://github.com/user-attachments/assets/7a367547-ce45-48a7-8956-a44c01549edf)



- Step 19 : Create a measure to calculate Course completion count

Snap of Course completion count,

![Course completion count](https://github.com/user-attachments/assets/e9ef6930-34b7-4709-8a6c-ae04e10e8c8b)


- Step 20 : Create a measure to calculate Course completion rate

	Course_Compl_rate = DIVIDE([Course_comp_cnt],[Active_count])


Snap of Course Completion rate,

![Course completion rate](https://github.com/user-attachments/assets/955bb7bd-2be2-4c10-96cb-063b415a905e)


- Step 21 : Create a measure to calculate Work life balance rate active

Snap of Work life balance rate active,

![Work_life balance rate active](https://github.com/user-attachments/assets/9a147ff6-61df-471e-a591-f5b116a663d8)


- Step 22 : create a table using Training_Program_Name column and 'Course completion rate' measure. 

Snap of Training program wise completion rate,

![Training program wise completion rate](https://github.com/user-attachments/assets/2f31ccee-0675-45c7-940d-a0d361802d27)


- Step 23 : create a stacked column chart using RaceDesc column and 'Course completion rate' measure. 

Snap of Course completion rate by race,

![Course completion rate by race](https://github.com/user-attachments/assets/63d6a663-676a-4a3e-9ad0-24e418d94802)


- Step 24 : create a Pie chart using EmployeeType column and 'Active count' measure. 

Snap of Employee Type distribution,

![Employee_type distribution](https://github.com/user-attachments/assets/3df34fc5-dbc8-49d0-a54d-d5104e0d2d33)


- Step 25 : create a Donut chart using GenderCode column and 'Active count' measure. 

Snap of Gender distribution,

![Gender dist](https://github.com/user-attachments/assets/ad80c331-1b8b-4548-96c4-140c6bd51fda)


- Step 26 : create a Line and stacked column chart using DepartmentType column on x-axis,  'Engagement_rate' measure on column y-axis and 
	   'Work-life balance rate active' measure on line y-axis. 

Snap of Engagement rate and Work-life balance rate,

![Eng and work](https://github.com/user-attachments/assets/42baa000-2703-4a39-ae40-36d91b302e4a)


- Step 27 : create a Line and stacked column chart using DepartmentType column on x-axis,  'Engagement_rate' measure on column y-axis and 
	   'Course completion rate' measure on line y-axis. 

Snap of Engagement rate and Course completion rate,

![Eng and course comp](https://github.com/user-attachments/assets/32ea7bfa-c6d3-4e5a-8816-3068246fb5f1)


Snap of Active employee report page, 

![Active emp rep](https://github.com/user-attachments/assets/fd31369c-7dd0-466b-83d9-d2a880b2a4de)


- Step 28 : In Attrition report page, create a slicer and select 'BusinessUnit'column to filter the BusinessUnit. 

- Step 29 : create a measure to count Inactive employees 
	
	Inactive_count = CALCULATE([Cnt_emp], Emp_data[cor_emp_status] = "Inactive")

- Step 30 : create a Donut chart using RaceDesc column and 'Inactive_count' measure.

Snap of Attrition by race,

![Attrition by race](https://github.com/user-attachments/assets/d97e0f51-24bb-466a-acae-f1457e048156)


- Step 31 : Create a measure to calculate work life balance rate for inactive.

Snap of work_life_balance_rate_inactive,

![Work_life balance rate inactive](https://github.com/user-attachments/assets/91d5d1ff-877e-4f5d-8a92-15438de958bb)


- Step 32 : create a stacked column chart using DepartmentType column and 'work_life_balance_rate_inactive' measure. 

Snap of work life balance rate by Department,

![work inactive](https://github.com/user-attachments/assets/ff51ea99-95f3-4af2-a540-f0ff01364dad)


- Step 33 : Create a measure to calculate satisfaction rate for inactive.

Snap of satisfaction_rate_inactive,

![satisfaction measure](https://github.com/user-attachments/assets/61edc5aa-84a1-4b5f-bca7-382c87a6f076)


- Step 34 : create a stacked column chart using DepartmentType column and 'satisfaction_rate_inactive' measure. 

Snap of satisfaction_rate_inactive by Department,

![satisfaction rate](https://github.com/user-attachments/assets/23449968-8f26-4d6e-85fe-06ff274b6401)


- Step 35 : create a calculated column in 'employee_data' table called as 'Termination_type_mod' to categorize them into voluntary and involuntary.

Snap of 'Termination_type_mod' by Department,

![Termination_type_mod](https://github.com/user-attachments/assets/95f2833d-2380-42d2-a299-4ed4c606ba45)


- Step 36 : Create a line chart with 'Date' from calendar on x-axis, 'Inactive_count' measure on y-axis and 'Termination_type_mod' as legend

Snap of 'Termination Type' by Department,

![Termination type](https://github.com/user-attachments/assets/68f7dda4-6f02-43fe-889e-5f7010e893f0)



- Step 37 : To calculate the attrition rate, create series of measures as shown below 

Snap of 'exit_cnt_curr_year',

![Exit cnt curr year](https://github.com/user-attachments/assets/b9e67890-a879-4d97-9cd3-f3f533ad03e0)


Snap of 'cnt_with_use_rel',

![cnt with use rel](https://github.com/user-attachments/assets/25654252-15ed-428d-ac54-32ba866ba3b2)


Snap of 'Cumu_cnt_with_use_rel',

![cumu cnt with use rel](https://github.com/user-attachments/assets/1a967409-a95b-44c5-9962-d828d12056e9)


Snap of 'cumu_exit_cnt',

![cumu exit cnt](https://github.com/user-attachments/assets/d6831739-2867-4e99-8ab1-0163fce64186)


Snap of 'closing_hd_cnt',

![closing hd cnt](https://github.com/user-attachments/assets/f896a94f-72a0-449c-bad9-08563eec9a62)


Snap of 'open_hd_cnt',

![Open hd cnt](https://github.com/user-attachments/assets/9561f3d6-f31a-423a-8d67-0267c53cb4f9)


Snap of 'Denom_attr_rate',

![denomin attr](https://github.com/user-attachments/assets/ab898b13-cd6c-463a-83dc-60716a8b31e7)


Snap of 'Attrition rate',

![Attrition rate](https://github.com/user-attachments/assets/a0a7c2eb-427c-44cf-b532-df7c1b3d0461)



- Step 38 : Create a line chart with 'Date' from calendar on x-axis and 'Attrtion_rate' measure on y-axis 

Snap of 'Attrition_rate' by Year,

![Attr chart](https://github.com/user-attachments/assets/1819adfc-d7b5-4880-ad20-7b860fcea27e)


- Step 39 : Create a calculated column 'Good_or_poor' in 'Employee_data' table for inactive employees.

	Good_&_Poor = IF(Emp_data[Performance_Score] = "Fully Meets" || Emp_data[Performance_Score] = "Exceeds", "Good", "Poor")

- Step 40 : create a measure to count poor performers

Snap of 'Attrition_by_poor_performers',

![Attriti_by poor perf](https://github.com/user-attachments/assets/44d13865-22e5-4185-8bd2-b9e14c749b0c)
 

Snap of 'Poor Performers' using a card,

![Poor performers](https://github.com/user-attachments/assets/1776910b-a341-42c9-984e-48f312c532d6)
 

- Step 41 : create a measure to count good performers

Snap of 'Attrition_by_good_performers',

![Attrit by good per](https://github.com/user-attachments/assets/81f59b37-7679-4cd6-8e59-34ec9b5a464d)
 

Snap of 'Good Performers' using a card,

![Good performers](https://github.com/user-attachments/assets/5a549014-0eeb-4bfa-82de-76692a2d7faa)
 


Snap of Attrition report page, 

![Attrtion page](https://github.com/user-attachments/assets/f27a8a1c-cce2-4143-9667-c4bd2117b9cc)



# Insights and Recommendations

A two page report was created on Power BI Desktop 

Following inferences can be drawn from the report;

### [1] Active employee report page

	a. Total Active employees across all Business units (BU) – 1467
	b. BU – MSC has highest engagement rate of 63% and BU – EW has lowest engagement rate of 54%
	c. BU – CCDR has highest Course-completion rate of 29% and BU- BPC has lowest rate of 22%
	d. When we consider the overall course completion rate with respect Race description, employees from 
	   Hispanic race seem to have lower course completion rate. Hence need attention.

	e. The Correlation coefficient value for Engagement rate and Course- completion rate was found to 
	   be –0.010 and the Correlation coefficient value for Engagement rate and Work life balance was found 
	   to be -0.012. Due to weak coefficient value, we can conclude that the lower engagement rate is not 
	   related to Course completion rate or Work-life balance. Therefore, other factors that impact the 
	   engagement rate must be checked to improve the overall engagement rating.


### [2] Attrition report page

	a. Total In-Active employees across all Business units (BU) – 1533
	b. Employees from Asian race are the highest to leave the organization in 2023 voluntarily.
	c. SVG – BU has the highest attrition rate for 2023.
	d. SVG and BPC are the top BUs to lose High performing employees in 2023.
	e. Admin offices department has the lowest satisfaction rate in all the Employee type categories (Full-time, Part-time, Contract) 
	f. Among the Part-time employees leaving the organization, the Software Engineering Department has 
	   the lowest Work-life balance rate of 52.4%    
