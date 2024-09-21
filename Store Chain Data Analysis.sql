create database Placement_project_Aug24

use placement_project_aug24

/*create tables for each of the csv files*/
create table stores
(Store_ID varchar(max),	Store_Name varchar(max), Store_City varchar(max), 
Store_Location varchar(max), Store_Open_Date varchar(max))

/*bulk insert values to the created tables*/
bulk insert stores
from 'E:\Manju\Learnbay\Placement\Project BI & SQL\Sql csv\stores.csv'
with 
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from stores
----------------------------------------------

create table products
(Product_ID varchar(max), Product_Name varchar(max), Product_Category varchar(max),
Product_Cost varchar(max),	Product_Price varchar(max))

bulk insert products
from 'E:\Manju\Learnbay\Placement\Project BI & SQL\Sql csv\products.csv'
with 
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from products
-----------------------------------------

create table inventory
(Store_ID varchar(max),	Product_ID varchar(max),	Stock_On_Hand varchar(max))

bulk insert inventory
from 'E:\Manju\Learnbay\Placement\Project BI & SQL\Sql csv\inventory.csv'
with 
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from inventory
-----------------------------------

create table calendar
(Date varchar(max))

bulk insert calendar
from 'E:\Manju\Learnbay\Placement\Project BI & SQL\Sql csv\calendar.csv'
with 
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)
---------------------------------------------

create table sales
(Sale_ID varchar(max), 	Date varchar(max),	Store_ID varchar(max),
Product_ID varchar(max),	Units varchar(max))

bulk insert sales
from 'E:\Manju\Learnbay\Placement\Project BI & SQL\Sql csv\sales.csv'
with 
	(fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2,
	maxerrors = 20)

select * from sales
--------------------------------------------

select column_name,data_type 
from INFORMATION_SCHEMA.COLUMNS

select * from stores

/*change datatype of columns as per the data stored in those columns*/
alter table stores
alter column store_id int 

		select CONVERT(date, store_open_date, 105) as store_open_date from stores 

update stores set store_open_date = CONVERT(date, store_open_date, 105)

alter table stores
alter column store_open_date date

------------------------------------------

select * from products

alter table products 
alter column product_id int

		select REPLACE(product_cost,'$','') from products
		
		update products set Product_Cost = REPLACE(product_cost,'$','')

		select REPLACE(Product_Price,'$','') from products
		
		update products set Product_Price = REPLACE(Product_Price,'$','')

		
alter table products
alter column product_cost decimal(10,2)

alter table products
alter column product_price decimal(10,2)

------------------------------------

select * from inventory

alter table inventory
alter column store_id int

alter table inventory
alter column product_id int

alter table inventory
alter column stock_on_hand int

------------------------------------------

select * from calendar

alter table calendar
alter column Date date

	select CONVERT(date,[Date],105) as 'Date' from calendar

	update calendar set Date = CONVERT(date,[Date],105)

------------------------------------------
select * from sales

select * from sales
where ISNUMERIC(Sale_ID) = 0

alter table sales
alter column sale_id int

alter table sales
alter column [Date] date /*getting error*/

		select Date from sales
		where ISDATE(Date) = 0

		select Sale_ID, date, try_convert(date, Date,105) as error_date from sales
		where try_convert(date, Date,105) is null 
		/*33 rows show error i.e. for dates - '02-19-2022', '01-17-2023', '07-14-2023' */

/*correct the errors*/

 update sales set Date = '19-02-2022'
 where Date = '02-19-2022'
		
 update sales set Date = '17-01-2023'
 where Date = '01-17-2023'

 update sales set Date = '14-07-2023'
 where Date = '07-14-2023'

	select Sale_ID, date, convert(date, [Date],105) as upd_date from sales

update sales set Date = convert(date, [Date],105)

----------------------------------

alter table sales
alter column [Date] date

select column_name, data_type
from INFORMATION_SCHEMA.COLUMNS

alter table sales
alter column store_id int

alter table sales
alter column product_id int

alter table sales
alter column units int

alter table products
alter column product_name varchar(100)

alter table products
alter column product_category varchar(100) /*Column with varchar(max) datatype cannot be indexed. hence the changes*/

alter table stores
alter column store_name varchar(100)

alter table stores
alter column store_city varchar(100)

alter table stores
alter column store_location varchar(100)

-------------------------------------------------

/*Check for duplicates in all tables*/

with duplicate_st as (select *, ROW_NUMBER() 
over(partition by store_id,store_name,store_city,store_location,store_open_date order by store_id) as row_num 
from stores)

select * from duplicate_st
where row_num > 1 /*There are no duplicates in the stores table*/

---------------------------

select * from products

with duplicate_pr as (select *, ROW_NUMBER() 
over (partition by product_id, product_name, product_category, product_cost, product_price order by product_id) as row_num
from products)

select * from duplicate_pr
where row_num >1 /*There are no duplicates in the products table*/

----------------------------------
select * from inventory

with duplicate_in as (select *, ROW_NUMBER() 
over (partition by store_id, product_id, stock_on_hand order by store_id) as row_num
from inventory)

select * from duplicate_in
where row_num >1 /*no duplicates in inventory table*/

-----------------------------

select * from sales

with duplicate_sa as (select *, ROW_NUMBER() 
over (partition by sale_id, [date], store_id, product_id, units order by sale_id) as row_num
from sales)

select * from duplicate_sa
where row_num >1 /*no duplicates in sales table*/

------------------------------

/* Add constraints to columns of the tables*/

select count(*) from sales
select distinct(count(sale_id)) from sales

alter table sales
alter column sale_id int not null

alter table sales
add constraint PS001 primary key(sale_id)
	---------------

select count(*) from products
select distinct(count(Product_ID)) from products

alter table products
alter column product_id int not null

alter table products
add constraint PP001 primary key(product_id)
	----------------

select count(*) from stores
select distinct(count(store_ID)) from stores

alter table stores
alter column store_id int not null

alter table stores
add constraint PST001 primary key(store_id)
	-----------------

alter table sales
add constraint FS001 foreign key(store_id) references stores(store_id)

alter table sales
add constraint FP001 foreign key(product_id) references products(product_id)

select * from inventory

alter table inventory
add constraint FIS001 foreign key(store_id) references stores(store_id)

alter table inventory
add constraint FIP001 foreign key(product_id) references products(product_id)

/*Calendar table - add year, months, days, Quarter, Thedayofyear */


select [Date],YEAR([Date])as 'Year', MONTH([Date]) as 'Month_no', DATENAME(month,[Date]) as 'Month',
DAY([Date]) as 'Day' ,DATENAME(weekday, [Date]) as 'Weekday_name', Datepart(QUARTER, [Date]) as 'Quarter',
DATEPART(DAYOFYEAR,[Date]) as TheDayOfYear 
from calendar

alter table calendar
add Year int 

update calendar set [Year] = YEAR([Date])
---------------

select * from calendar

alter table calendar
add Month_no int 

update calendar set Month_no = MONTH([Date])
---------------

alter table calendar
add Month varchar(30) 

update calendar set [Month] = DATENAME(month,[Date])
---------------

alter table calendar
add Day int

update calendar set [DAY] = DAY([Date])
-----------------

alter table calendar
add Weekday_name varchar(30)

update calendar set Weekday_name = DATENAME(weekday, [Date])

------------------
alter table calendar
add Quarter int

update calendar set [Quarter] = Datepart(QUARTER, [Date])
---------------------

alter table calendar
add TheDayOfYear int

update calendar set TheDayOfYear = DATEPART(DAYOFYEAR,[Date])
---------------------

/*Building relationship between calendar table and sales table through constraints*/

alter table calendar
alter column [Date] date not null

alter table calendar
add constraint PC001 primary key ([Date])

alter table sales
add constraint FD002 foreign key([Date]) references calendar([Date]) 

-------------------------------------------------------

/*A1 - Production performance analysis*/

select Top 5 s.Product_ID,p.product_name, sum(Units) as Total_units ,sum(Units*p.product_price) as Total_sales
from sales s
inner join products p
on s.Product_ID = p.Product_ID
group by s.Product_ID,p.Product_Name
order by Total_sales desc /*Top 5 based on Total_sales*/


select Top 5 s.Product_ID,p.product_name, sum(Units*p.product_price) as Total_sales,
sum(Units*p.product_cost) as Total_cost,sum(Units*(p.product_price - p.product_cost)) as Profit
from sales s
inner join products p
on s.Product_ID = p.Product_ID
group by s.Product_ID, p.product_name
order by profit desc /*Top 5 based on Profit*/


/*A2 - Store performance analysis*/

with store_perf as(select s.store_id,t.store_name, sum(Units*p.product_price) as Total_revenue,
sum(Units*(p.product_price - p.product_cost)) as Profit 
from sales s
inner join products p
on s.Product_ID = p.Product_ID
inner join stores t
on t.Store_ID = s.Store_ID
group by s.Store_ID,t.store_name)

select Store_ID,store_name, Total_revenue, 
round((Profit/Total_revenue)*100,2) as Profit_margin from store_perf
order by Store_ID

/*A3- Complex Monthly Sales Trend Analysis*/

select * from calendar

with monthly_sales as (select c.[Year], c.[Month], c.[Month_no], sum(s.units*p.product_price) as Total_sales
from sales s
inner join calendar c
on s.[date] = c.[date]
inner join products p
on s.product_id = p.product_id
group by [Year], [Month], [Month_no])

select [Year], [Month], [Month_no], Total_sales, 
round((avg(total_sales) over (order by [Year],[Month_no] rows between 2 preceding and 0 preceding)),2) as rolling_3M_avg,
Total_sales - (avg(total_sales) over (order by [Year],[Month_no] rows between 2 preceding and 0 preceding)) as significant_gd
from monthly_sales


/*A4 - Cumulative Distribution of Profit Margin */

	--------- get the list of products that have profit

Select s.Product_ID, sum(Units*(p.product_price - p.product_cost)) as Profit
from sales s
inner join products p
on p.Product_ID = s.Product_ID
group by s.Product_ID
having sum(Units*(p.product_price - p.product_cost)) < 0 /*All the products have Profit. 
															hence we will consider all of them*/

select s.product_id,p.Product_Name,p.product_category, 
round((sum(Units*(p.product_price - p.product_cost))/sum(Units*p.product_price))*100,2) as Profit_Margin,
round(CUME_DIST() over (partition by product_category 
order by (sum(Units*(p.product_price - p.product_cost))/sum(Units*p.product_price))),2) as Cumu_dist
from sales s
inner join products p
on s.Product_ID = p.Product_ID
group by s.Product_ID,p.Product_Name,p.Product_Category

create index Inx_p_nam_cat
on products(product_name, product_category)

--------------------

/*A5 - Store Inventory Turnover Analysis*/

	/*calculate Cost of Goods for each store for each year and then 	
	calculate average inventory for each year for each store*/

with Cgs as (select s.Store_ID, SUM(case when YEAR(s.date) = 2022 then units*product_cost else 0 end) as COGS_2022,
SUM(case when YEAR(s.date) = 2023 then units*product_cost else 0 end) as COGS_2023
from sales s
inner join products p
on s.Product_ID = p.product_id
group by Store_ID),

ais as (select s.Store_ID, avg(case when year(s.date) = 2022 then Stock_On_Hand else 0 end) as Avg_inv_2022,
avg(case when year(s.date) = 2023 then Stock_On_Hand else 0 end) as Avg_inv_2023
from inventory i
inner join sales s
on i.Store_ID = s.Store_ID
group by s.Store_ID)

select c.store_id, c.COGS_2022, c.COGS_2023, a.avg_inv_2022, a.avg_inv_2023,
round((case when Avg_inv_2022 = 0 then null else (COGS_2022/Avg_inv_2022) end),2) as Inv_ratio_2022,
round((case when Avg_inv_2023 = 0 then null else (COGS_2023/Avg_inv_2023) end),2) as Inv_ratio_2023
from Cgs c
inner join ais a
on c.store_id = a.store_id
order by Store_ID

-----------------------------------------