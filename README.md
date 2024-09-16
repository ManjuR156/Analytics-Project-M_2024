# Recruitment data analysis

## Problem Statement

This report helps to gain insights about recruitment of employees with respect to each department. 

### Steps followed 

- Step 1 : Load the data into SQL, dataset is csv file (HR_recruitment.csv) 
- Step 2 : Clean the data by removing anamolies from the columns of the table.
- Step 3 : Load the table into Power BI Desktop from SQL server. 
- Step 4 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.
- Step 5 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".
- Step 6 : Add new column from the 'add column' ribbon that will provide the hiring year and name the column as 'Hire_year' 
- Step 7 : Add conditional column using 'add column' ribbon, name the column as 'year_clust' and give the below conditions 
	if [Hire_year] <= 1970 then "1955__70" 
	else if [Hire_year] <= 1985 then "1971__85" 
	else if [Hire_year] <= 2000 then "1986__2000" 
	else if [Hire_year] <= 2015 then "2001__2015" 
	else null
- Step 8 : Click on 'Close & Apply' in the home ribbon.
- Step 9 : Create a calendar table using calendar function then create a relationship between 
	   date column in 'calendar table' and 'Hiredate' column in 'Recr_data' table 

Snap of Relationship on Power BI,

![Date Relationship](https://github.com/user-attachments/assets/820fcfef-cfa3-45d8-9e76-d255f2f9ba1f)


- Step 10 : Go to report view
- Step 11 : Create a slicer and select 'Department'column to filter the Departments
 
- Step 12 : Create a measure to count Positions

	cnt_pos = COUNT(Recr_data[Position])		


- Step 13 : Create a measure to calculate 'no_of_vacancy'

	no_of_vacancy = if(CALCULATE([cnt_pos], Recr_data[VacancyStatus] = "vacant") <> blank(), CALCULATE([cnt_pos], Recr_data[VacancyStatus] = "vacant"),0)  

Snap of no_of_vacancy,

![no_of vaca](https://github.com/user-attachments/assets/36270b12-b971-4062-ae65-6b56d7797caa)


- Step 14 : Create a measure to calculate 'Average hire days'

	Avg_hire_days_c = AVERAGEX(FILTER(Recr_data, Recr_data[VacancyStatus] = "Filled"), DATEDIFF(Recr_data[PostingDate],Recr_data[HireDate],DAY))  

Snap of Avg_hire_days_c,

![avg days to hire](https://github.com/user-attachments/assets/0d9aa22a-67a2-453e-9550-00a7a0f09a71)


- Step 14 : Create a measure to calculate 'Average fill days'

	Avg_fill_days_c = AVERAGEX(FILTER(Recr_data, Recr_data[VacancyStatus] = "Filled"), DATEDIFF(Recr_data[VacancyDate], Recr_data[HireDate],DAY))  

Snap of Avg_fill_days_c,

![avg days to fill](https://github.com/user-attachments/assets/62d340bf-7441-4c52-a429-2ced139720c1)


- Step 15 : Create a measure to count the filled position

	cnt_filled_pos = CALCULATE([cnt_pos], Recr_data[VacancyStatus] = "Filled")


- Step 16 : Create a Donut chart using AssignmentCategory column as legend and 'cnt_filled_pos' measure. 

Snap of Full-time vs Part-time,

![Full vs part](https://github.com/user-attachments/assets/b7026c39-c93c-4f51-92a1-f9a3f3f7f770)


- Step 17 : Create a measure to calculate sum of salary

	Total_sal = SUM(Recr_data[Salary])


- Step 18 : Create a measure to calculate sum of salary by gender

	Gender_sal = AVERAGEX(FILTER(Recr_data, Recr_data[VacancyStatus]="Filled") ,[Total_sal])


- Step 19 : create a Funnel chart using Gender column and 'Gender_sal' measure. 

Snap of Salary gap by gender,

![Salary gap](https://github.com/user-attachments/assets/4644b819-2ced-43f5-a956-9bd07e221675)


- Step 20 : create a Line chart to find Total expenses over the year_clust using Year_clust column and 'Total_sal' measure. 

Snap of Total expenses over the years,

![Total expenses](https://github.com/user-attachments/assets/93d95797-0562-4b10-94b8-b21f4847407f)


- Step 21 : create a Line chart to find Year-wise positions hired using Date column from calendar table and 'cnt_filled_pos' measure. 

Snap of Year-wise positions hired,

![year wise pos](https://github.com/user-attachments/assets/19d47076-bf35-41de-a742-a4ca5b7fdefa)


- Step 22 : create a Line chart to find positions hired by year and gender using Date column from calendar table, 
	   'Gender' column as Legend and 'cnt_filled_pos' measure. 

Snap of Positions hired by year and gender,

![Positions hire by year and gender](https://github.com/user-attachments/assets/1b5af76f-dd88-4b2d-b270-812a777d18c4)


- Step 23 : create a measure to count hired positions that can be used in ranking the hiring analyst in next step

	Total_hire_count = DISTINCTCOUNT(Recr_data[Position])


- Step 24 : create a measure to rank hiring analyst based on Total_hire_count 
	
	Rank_tab = RANKX(ALLSELECTED(Recr_data[Department],Recr_data[HiringAnalyst]), [Total_hire_count],,DESC,Dense)


- Step 25 : create a table using 'HiringAnalyst' column and add filter on the visual 
	    using 'Rank_tab' measure with less than 2 condition 

Snap of Top Hiring Analyst,

![Top-hiring](https://github.com/user-attachments/assets/309cae3b-88fd-4a62-a993-761ffbb791a2)


Snap of Final report, 

![Report](https://github.com/user-attachments/assets/54c20948-b535-4878-9acc-9981296178e7)


# Insights and Recommendations

A single page report was created on Power BI Desktop 

Following inferences can be drawn from the report;

### [1]  Page 1

	a. Total vacancies across all Departments - 103
	b. The dataset consists of details from 1st Jan 1955 to 30th Jan 2015. (60 years data)
	c. Highest vacancies can be seen in POL department - 41
	d. Departments IGR and BOA do not have Male employees.
	e. Department ZAH has highest salary gap (Male_sal - Female_sal) i.e.84088.
	    (Compensation benchmarking can be done to check the reason)
	f. There are 10 Departments out of 38 where average salary of Female is greater than male.
	g. Department DHS has the highest average_days_to_hire and also has the 
	   highest average_days_to_fill therefore, it needs attention.
	h. Out of the Total employees hired, 63% of employees belong to these 4 departments POL, HHS, FRS, DOT.
