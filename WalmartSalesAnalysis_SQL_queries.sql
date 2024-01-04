-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT time, 
CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	 WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
     ELSE 'Evening' END AS time_of_day
     FROM sales;
     
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(100);

UPDATE sales SET time_of_day = 
	(CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		 WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         ELSE 'Evening' END);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);



-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT(city) FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch FROM sales;


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------


-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;

-- What is the most selling product line?
SELECT product_line, SUM(Quantity) AS Total_Quantity FROM sales
	GROUP BY product_line
    ORDER BY Total_Quantity DESC
    LIMIT 1;

-- What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue FROM sales
	GROUP BY month_name
    ORDER BY total_revenue DESC ;
    
-- What month had the largest COGS?
SELECT month_name, SUM(cogs) AS Cost_of_Good_Solds FROM sales
	GROUP BY month_name
    ORDER BY Cost_of_Good_Solds DESC 
    LIMIT 1;
    
-- What product line had the largest revenue?
SELECT product_line, SUM(total) AS Revenue FROM sales
	GROUP BY product_line
    ORDER BY Revenue DESC 
    LIMIT 1;

-- What is the city with the largest revenue?
SELECT city,branch, SUM(total) AS Revenue FROM sales
	GROUP BY city,branch
    ORDER BY Revenue DESC 
    LIMIT 1;

-- What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS VAT FROM sales
	GROUP BY product_line
    ORDER BY VAT DESC 
    LIMIT 1;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT product_line,
		CASE WHEN total < (SELECT AVG(total) FROM sales) THEN 'Bad'
        ELSE 'Good' END AS Comment_for_sales
FROM sales;


-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS total_products_sold FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT product_line, gender, COUNT(gender) AS total_cnt
FROM sales
GROUP BY product_line, gender
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating 
FROM sales
GROUP BY product_line
ORDER BY avg_rating;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS total_cnt
FROM sales
GROUP BY customer_type
ORDER BY total_cnt DESC;

-- Which customer type buys the most in terms of Revenue?
SELECT customer_type, SUM(total) AS total_Revenue
FROM sales
GROUP BY customer_type
ORDER BY total_Revenue DESC ;

-- What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS total_cnt 
FROM sales
GROUP BY gender
ORDER BY total_cnt DESC;

-- What is the gender distribution per branch?
SELECT branch,gender, COUNT(gender) AS total_cnt 
FROM sales
GROUP BY branch,gender
ORDER BY branch;

-- Which time of the day do customers give most ratings and also what is the avg rating for that time of day?
SELECT time_of_day, COUNT(rating) AS total_cnt, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY total_cnt DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT branch,time_of_day, COUNT(rating) AS total_cnt
FROM sales
GROUP BY branch,time_of_day
ORDER BY total_cnt DESC;

-- In the morning, the branches receive the fewest ratings, while in the evening, they receive the most.

-- Which day for the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Monday and Friday are the top best days for good ratings

-- Which day of the week has the best average ratings per branch?
SELECT day_name,branch , AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name,branch
ORDER BY avg_rating DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(invoice_ID) AS Number_of_sales
FROM sales
GROUP BY time_of_day
ORDER BY Number_of_sales DESC;

-- Evening time experience the most sales

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city collects the highest tax/VAT ?
SELECT city, ROUND(SUM(VAT),2) AS total_tax
FROM sales
GROUP BY city
ORDER BY total_tax DESC;

-- Naypyitaw =$5265.18 collects the highest tax.

-- Which customer type pays the most in VAT?
SELECT customer_type, ROUND(SUM(VAT),2) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;

-- The customer-type member contributes the highest total amount in taxes.

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------


