# Sales Data Analysis with SQL

This project demonstrates various SQL queries used to analyze a sample sales dataset. The primary goals are to gain insights into sales performance, customer segmentation, and product associations. The code provides examples of grouping, aggregating, and analyzing sales data, including RFM (Recency, Frequency, and Monetary) analysis for customer segmentation.

## Dataset

The data is sourced from a fictional table, `dbo.sales_data_sample`, which contains information such as:

- `status`: Order status
- `year_id`: Year of the sale
- `productline`: Product category
- `country`: Customer's country
- `dealsize`: Size of the deal (e.g., Small, Medium, Large)
- `territory`: Sales territory
- `month_ID`: Month of the sale
- `order_qty`, `delivery_qty`, `billed_qty`: Order quantities
- `CUSTOMERNAME`, `ORDERDATE`, `ORDERNUMBER`: Customer information and order details

## Analysis Steps

### 1. Initial Data Exploration
- **Unique Value Check**: Identify unique values in key fields (`status`, `year_id`, `productline`, `country`, `dealsize`, `territory`, and `month_ID`).
- **Sales Grouping**: Analyze total revenue across dimensions such as `PRODUCTLINE`, `YEAR_ID`, and `DEALSIZE`.

### 2. Monthly Sales Analysis
Identify the best month for sales in a specific year, focusing on 2004. Determine the revenue and frequency of sales transactions for each month.

### 3. RFM Analysis (Recency, Frequency, Monetary Value)
Segment customers based on purchase behavior:
- Calculate metrics: `Recency`, `Frequency`, and `MonetaryValue`.
- Use `NTILE` to rank customers into quartiles and categorize them into RFM segments.
- Classify customers as `Lost_Customer`, `Slipping Away`, `New_Customer`, `Potential_Customer`, `Active`, and `Loyal`.

### 4. Product Association Analysis
Analyze frequently bought together products by identifying orders containing multiple products and aggregating product codes in a comma-separated format.

### 5. Additional Analysis
- **Highest Revenue Cities**: Determine the city with the highest sales in the UK.
- **Top Product Lines in the USA**: Identify the most popular product lines in the USA by revenue.

## Usage

To run this code:

1. Ensure you have access to the `dbo.sales_data_sample` table in a compatible SQL environment.
2. Execute each query individually to retrieve insights.

## Future Enhancements
- Automate RFM segmentation to dynamically adapt to changes in customer behavior.
- Integrate additional fields for a more detailed analysis, such as seasonal trends and demographic insights.
