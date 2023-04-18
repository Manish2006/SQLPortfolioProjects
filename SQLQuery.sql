	/****** Script for SelectTopNRows command from SSMS  ******/
	SELECT count(*) as total_coulmns
	  FROM [Sample3].[dbo].[data_time_series_covid192]

	  /* how many month per year */
	  Select year(Date) as Mnt,count(distinct(Month(Date)))as countofdays FROM [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date)
	  order by year(Date) asc

	  /*start_date - end_date*/
	  Select Min(Date) as start_date,Max(Date) as end_date from [Sample3].[dbo].[data_time_series_covid192]

	  /* how many rows in each month */

	 Select year(Date) as yy,month(Date) as Mnt,count(*)as countofdays FROM [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date),month(Date)
	  order by year(Date),month(Date)

	  /*min: confirmed, deaths, recovered per month*/

	  Select year(Date) as yy,month(Date) as mm,min(Confirmed) as min_Confirmed,
	  min(Deaths) as min_Deaths, 
	  min(Recovered) as min_Recovered from [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date) ,month(Date) 
	  order by year(Date) ,month(Date)  asc

	   /*max: confirmed, deaths, recovered per month*/

	   Select year(Date) as yy,month(Date) as mm,max(Confirmed) as max_Confirmed,
	  max(Deaths) as max_Deaths, 
	  max(Recovered) as max_Recovered
	  from [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date) ,month(Date) 
	  order by year(Date) ,month(Date)  asc

	 -- The total case: confirmed, deaths, recovered per month


	   Select year(Date) as yy,month(Date) as mm,sum(Confirmed) as Total_Confirmed,
	  sum(Deaths) as Total_Deaths, 
	  sum(Recovered) as Total_Recovered
	  from [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date) ,month(Date) 
	  order by year(Date) ,month(Date)  asc

	 /********* 1.1. The central tendency: a distribution is an estimate of the “center” of a distribution of values: 
	-- MEAN
	-- MODE
	-- MEDIAN
	*********/

	---------- MEAN ----------

	   Select year(Date) as yy,month(Date) as mm,round(AVG(Confirmed),0) as Total_Confirmed,
	  round(AVG(Deaths),0) as Total_Deaths, 
	  round(AVG(Recovered),0) as Total_Recovered
	  from [Sample3].[dbo].[data_time_series_covid192]
	  group by year(Date) ,month(Date) 
	  order by year(Date) ,month(Date)  asc

	  ---------- MEDIAN ----------
	--To get the last value in the top 50 percent of rows.
	Select Top 1 Confirmed
	 from [Sample3].[dbo].[data_time_series_covid192]
	where Confirmed
	 in ( Select Top 50 Confirmed from
	 [Sample3].[dbo].[data_time_series_covid192]) 
	 order by Confirmed desc

	---------- MODE ----------
	/* What is the frequently occuring numbers of confirmed cases in each month? */
	/* we can see that February 2020 are the months which have most number of confirmed case*/

   
	   Select Top 1 year(Date) as yy,month(Date) as mm,Confirmed as max_Confirmed

	  from [Sample3].[dbo].[data_time_series_covid192] WHERE  Confirmed IS Not NULL
	  group by year(Date) ,month(Date) ,Confirmed
	  ORDER  BY COUNT(*) DESC

	  /********* 1.2. The dispersion: refers to the spread of the values around the central tendency:
	-- RANGE = max value - min value
	-- VARIANCE
	-- STANDART DEVIATION
	*********/

	-- How spread out? 
	--- confirmed case

	SELECT 
		SUM(confirmed) AS total_confirmed, 
		ROUND(AVG(confirmed), 0) AS average_confirmed,
		ROUND(VAR(confirmed),0) AS variance_confirmed,
		ROUND(STDEV(confirmed),0) AS std_confirmed
	 from [Sample3].[dbo].[data_time_series_covid192] 

	 	--- deaths

	SELECT 
		SUM(deaths) AS total_confirmed, 
		ROUND(AVG(deaths), 0) AS average_confirmed,
		ROUND(VAR(deaths),0) AS variance_confirmed,
		ROUND(STDEV(deaths),0) AS std_confirmed
	 from [Sample3].[dbo].[data_time_series_covid192] 

	 -- return a record of countries that suffer a high-risk threat to the coronavirus disease.

	with cte as (SELECT Province, SUM(deaths) death_toll,
               CASE WHEN SUM(deaths) > 1000 THEN 'high risk'
               WHEN  SUM(deaths) > 500 THEN 'middle risk'
               ELSE 'low risk' END AS risk_level
               from [Sample3].[dbo].[data_time_series_covid192]  
              -- JOIN from [Sample3].[dbo].[data_time_series_covid192]  co
              -- ON co.id = ca.country_id
               GROUP BY Province) 
			   SELECT Province, risk_level
    FROM cte WHERE risk_level = 'high risk';