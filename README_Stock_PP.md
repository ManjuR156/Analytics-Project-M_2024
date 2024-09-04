# Stock Price Prediction

## Problem Statement

This report helps the investor to understand the stock performance better. 

### Steps followed 

- Step 1 : Load data into Power BI Desktop, dataset is a xlsx file.
- Step 2 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.
- Step 3 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".
- Step 4 : It was observed that in none of the columns errors & empty values were present. 
- Step 5 : Create a calendar table using calendar function. then create a relationship between date column in 'calendar table' and date column in 'sheet1'
- Step 6 : Create a page for each of the recommended analysis i.e. Descriptive analysis, Trend analysis, Performance metrics
- Step 7 : In the Descriptive analysis page, create a slicer and select 'Name'column to filter the stock. 
- Step 8 : create a date slicer with 'relative date' style. set the anchor date as the last date of the given dataset.
- Step 9 : create a 'multi-row card' and add 'High' column 5 times into the fields and then using the dropdown select the required aggregation. Repeat this step for 
	   Low, Open and close columns.	 
- Step 10 : create a line chart and select date from calendar table and 'close' column.            

Snap of descriptive analysis,

![Descriptive analysis](https://github.com/user-attachments/assets/30113352-0b6d-48f9-97fa-e1e84073cfa3)


- Step 11 : In the Trend analysis page, create a slicer to filter the stock as we did for descriptive analysis page.
- Step 12 : create the measures m_sum_close and m_Dayvalue as shown below.

	m_sum_close = SUM(Sheet1[close])
	m_Dayvalue = MAX(Sheet1[date]) 	 

- Step 13 : create a measure to calculate rank for the given rows of data which will be paramount for the calculating moving average.
	
	m_rank = RANKX(ALLSELECTED(Sheet1), Sheet1[date], [m_Dayvalue],ASC)

- Step 14 : click on modelling ribbon and select 'new parameter' and set minimum range as 1 and maximum as 200
- Step 15 : create a measure to calculate SMA as shown in the snap

Snap of SMA measure,

![SMA](https://github.com/user-attachments/assets/a20f6f59-59f5-4d00-82fb-3b2c513ce489)


- Step 16 : create a line chart using sheet1[date] on x-axis, SMA on y-axis, and 'close' on secondary y-axis. 

Snap of Trend analysis,
![Trend analysis](https://github.com/user-attachments/assets/026635be-69b2-4747-b920-157a5fa99c10)



- Step 17 : In Performance metrics page, create a measure to retrieve the 'close' value for the previous date.

Snap of m_row-1 measure,

![row-1](https://github.com/user-attachments/assets/a8872cf2-045c-4809-b3e5-ce775fe8440c)


- Step 18 : create a measure for calculating 'daily change'
	
	m_daily_change = if([m_rank]>1,[m_sum_close] - [m_row-1], BLANK()) 


- Step 19 : create a measure for calculating 'daily returns'

	m_daily_returns = DIVIDE([m_sum_close] - [m_row-1], [m_row-1])

- Step 20 : Create measure to calculate gain and loss

	m_gain = IF([m_daily_change]>0, [m_daily_change])
	m_loss = if([m_daily_change]<0, [m_daily_change])

- Step 21 : Create a parameter similar to the one we did in 'Trend analysis' page and name it as 'Period'

- Step 22 : Create measures to calculate gain and loss

Snap of Average_gain measure,

![Avg gain](https://github.com/user-attachments/assets/ff753867-818b-4d22-8f35-2f18f5cf97df)

Snap of Average_loss measure,

![Avg loss](https://github.com/user-attachments/assets/0da39d43-d7ce-4835-8779-6d15f20db8a8)


- Step 23 : create measures to calculate RS and RSI
	
	m_RS = DIVIDE([m_average_gain],ABS([m_average_loss]))
	m_RSI = 100 - DIVIDE(100,1+[m_RS])


Snap of Performance metrics,

![Performance metrics](https://github.com/user-attachments/assets/03774fed-e993-42b8-86c6-29b003aa87a3)


# Insights

A three page report was created on Power BI Desktop & it was then published to Power BI Service.

Following inferences can be drawn from the report;

### [1] Descriptive analysis page

	a. Close price Stock ‘ADBE‘ is seems to be growing better than other stocks in last 50 days with Std dev of  9.23.
	b. Std dev value of close price in last 20 days seem to be high for AAPL and CLX showing a bearish trend.

### [2] Performance metrics page

	a. The Daily price change was very high for ADBE stock on 19th Oct 2017 with a change value of 18.7.
	b. The Daily price change is quite low for stock CHK for past 2 years hence can be considered to have no significant growth in that period.


# Recommendations

Following are the recommendations for the investors;
           
	a. Stock ‘ADBE‘ is a good stock to have in your portfolio due to its performance in last 50 days.
	b. Stock CHK should be avoided as it’s growth is mostly stagnant in last few years.
