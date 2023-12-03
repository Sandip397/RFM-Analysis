select * from  dbo.sales_data_sample 

--checking unique values

select distinct status from dbo.sales_data_sample 
select distinct year_id from dbo.sales_data_sample 
select distinct productline from dbo.sales_data_sample 
select distinct country from dbo.sales_data_sample 
select distinct dealsize from dbo.sales_data_sample 
select distinct territory from dbo.sales_data_sample 

select distinct month_ID from dbo.sales_data_sample 
where year_id = 2003

--Analysis
--Let's start grouping by sales by productline

SELECT  PRODUCTLINE, SUM(sales) Revenue
FROM dbo.sales_data_sample 
GROUP BY PRODUCTLINE
ORDER BY 2 DESC

SELECT YEAR_ID, SUM(sales) Revenue
FROM dbo.sales_data_sample 
GROUP BY YEAR_ID
ORDER BY 2 DESC

SELECT DEALSIZE, SUM(sales) Revenue
FROM dbo.sales_data_sample 
GROUP BY DEALSIZE
ORDER BY 2 DESC

--What was the best month for sales in a specific year? How much was earned that month?
SELECT MONTH_ID, SUM(sales) Revenue, count(ORDERNUMBER)  Frequency
FROM dbo.sales_data_sample
WHERE YEAR_ID = 2004
GROUP BY MONTH_ID
ORDER BY 2 DESC

--November seems to be the month, what product do they sell in November, Class I believe
SELECT MONTH_ID,PRODUCTLINE, SUM(sales) Revenue,  count(ORDERNUMBER)  
FROM dbo.sales_data_sample
WHERE YEAR_ID = 2004 AND MONTH_ID = 10
GROUP BY MONTH_ID,PRODUCTLINE
ORDER BY 3 DESC

--Who is our  best customer (this could be best answer with RFM)

DROP TABLE IF EXISTS #rfm;

WITH rfm as 
(
   SELECT
		CUSTOMERNAME,
		SUM(sales) MoneteryValue,
		AVG(sales) AvgMonetaryValue,
		COUNT(ORDERNUMBER) Frequency,
		MAX(ORDERDATE) last_order_date,
		(SELECT MAX(ORDERDATE) FROM dbo.sales_data_sample) Max_order_date,
		DATEDIFF (DD, max(ORDERDATE), (SELECT MAX(ORDERDATE) FROM dbo.sales_data_sample)) Recency
   FROM dbo.sales_data_sample
   GROUP BY CUSTOMERNAME
 ),
 rfm_calc as
 (
   SELECT r.*,
		NTILE(4) OVER (ORDER BY Recency desc) rfm_recency,
		NTILE(4) OVER (ORDER BY Frequency) rfm_frequency,
		NTILE(4) OVER (ORDER BY MoneteryValue) rfm_monetary
  FROM rfm r		 
 )

 SELECT
 c.*,rfm_recency+ rfm_frequency+rfm_monetary as rfm_cell,
 CAST( rfm_recency as varchar) + CAST(rfm_frequency as varchar)+ CAST(rfm_monetary as varchar)rfm_cell_string
 INTO #rfm
 FROM rfm_calc c

 SELECT
    CUSTOMERNAME, rfm_recency, rfm_frequency, rfm_monetary,
	CASE 
	   WHEN rfm_cell_string IN (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) THEN 'Lost_Customer'
	   WHEN rfm_cell_string IN (133, 134, 143, 244, 334, 343, 344, 144) THEN 'slipping away, cannot lose'
	   WHEN rfm_cell_string IN (311, 411, 331) THEN 'New_customer'
	   WHEN rfm_cell_string IN (222, 223, 233, 322) THEN 'Potential_customer'
	   WHEN rfm_cell_string IN (323, 333,321, 422, 332, 432) THEN 'Active'
	   WHEN rfm_cell_string IN (433, 434, 443, 444) THEN 'loyal'
   END rfm_segement
 FROM #rfm

 --What product are sold often sold together?
 --SELECT * FROM dbo.sales_data_sample WHERE ORDERNUMBER =10411
SELECT  DISTINCT ORDERNUMBER , STUFF(
	( SELECT 
	 ','+ PRODUCTCODE
	 FROM dbo.sales_data_sample p
	 WHERE  ORDERNUMBER IN
		 (
			 SELECT 
			  ORDERNUMBER
			 FROM
				 (
					SELECT
					ORDERNUMBER,
					COUNT(*) rn
					FROM  dbo.sales_data_sample 
					WHERE STATUS ='Shipped'
					GROUP BY ORDERNUMBER
				  ) m
			  WHERE rn=2
		  )
		  AND p.ORDERNUMBER = s.ORDERNUMBER
		  FOR XML PATH (''))
		  ,1,1,'') PRODUCTCODES
FROM dbo.sales_data_sample s
ORDER BY 2 DESC

---EXTRAs----
--What city has the highest number of sales in a specific country
SELECT city, SUM (sales) Revenue
FROM [PortfolioDB].[dbo].[sales_data_sample]
WHERE country = 'UK'
GROUP BY  city
ORDER BY 2 desc



---What is the best product in United States?
SELECT country, YEAR_ID, PRODUCTLINE, SUM(sales) Revenue
FROM [PortfolioDB].[dbo].[sales_data_sample]
WHERE country = 'USA'
GROUP BY  country, YEAR_ID, PRODUCTLINE
ORDER BY 4 desc