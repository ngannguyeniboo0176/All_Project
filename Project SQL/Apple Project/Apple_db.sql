-- Database: amazon_sale

-- DROP DATABASE IF EXISTS amazon_sale;

CREATE DATABASE amazon_sale
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Vietnamese_Vietnam.1258'
    LC_CTYPE = 'Vietnamese_Vietnam.1258'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
create table stores
	(Store_ID varchar(5) primary key,
	Store_Name varchar(30),
	City varchar(25),
	Country varchar(25));
create table category
	(category_id varchar(10)
	,category_name varchar(25)
)	;
create table products(
Product_ID varchar(10),
Product_Name varchar(30),
Category_ID varchar(30),
Launch_Date date,
Price int
);
create table warranty
(
claim_id varchar(20),
claim_date date,
sale_id varchar(25),
repair_status varchar(20)
)
;
create table sales(
sale_id varchar(15),
sale_date date,
store_id varchar(15),
product_id varchar(20),
quantity int
);
select * from sales;
select * from category;
select * from products;
select * from warranty;
select * from stores;

--1/Find the number of stores in each country.
select country,count(distinct(store_id)) as total_stores from stores
group by country
order by total_stores desc;
--2/Calculate the total number of units sold by each store.
select store_name,sum(quantity) as total_units
from sales
join stores
on sales.store_id=stores.store_id
group by 1
order by total_units desc;
--3/Identify how many sales occurred in December 2023.
--C1:
select count(distinct sale_id) from sales
where extract(month from sale_date)=12
	and extract(year from sale_date)=2023
--C2:
select count(distinct sale_id) as total_unit_sold from sales
where to_char(sale_date,'mm-yyyy')='12-2023'

--4/Determine how many stores have never had a warranty claim filed.
select count(distinct store_id) as total_store from stores
where store_id not in 
(select distinct(s.store_id) from sales s inner join warranty w on s.sale_id=w.sale_id)

--5/Calculate the percentage of warranty claims marked as "Warranty Void".

select
    sum(case when repair_status = 'Rejected' then 1 else 0 end) AS total_rejected,
    count(*) AS total_warranty,
    round(
        sum(case when repair_status = 'Rejected' then 1 else 0 end)::numeric / count(*) * 100,
        2
    ) AS rejected_percentage
FROM warranty;

--6/Identify which store had the highest total units sold in the last year.

select s.store_id, 
st.store_name,
sum(quantity) as total_unit_sold
from sales s 
join stores st
on s.store_id=st.store_id
where sale_date>=(select current_date- interval '1 year')
group by 1,2
order by total_unit_sold desc
limit 1
--7/Count the number of unique products sold in the last year.
select count(distinct product_id) as total_unique_product
from sales 
where sale_date>=(select current_date- interval '1 year')

--8/Find the average price of products in each category.
select * from products
select * from category

select c.category_name,
round(avg(p.price),1) as avg_price
from products as p
join category as c
on p.category_id=c.category_id
group by c.category_name

--9/How many warranty claims were filed in 2024?

select count(*) from warranty
where extract(year from claim_date)=2024

--10/For each store, identify the best-selling day based on highest quantity sold.

select * from (select store_id,
to_char(sale_date,'day') as day_name,
sum(quantity) as total_quantity_sold,
rank() over(partition by store_id order by sum(quantity)) as rank_sale_by_day
from sales
group by 1,2) as t1
where t1.rank_sale_by_day=1

--11/Identify the least selling product in each country for each year based on total units sold.

select * from (select st.country,
p.product_name,
sum(s.quantity) as total_quantity_sold,
rank() over(partition by  st.country order by sum(s.quantity) asc) as rank_sale
from sales as s
join products as p
on s.product_id=p.product_id
join stores as st
on s.store_id=st.store_id
group by 1,2) as t2
where t2.rank_sale=1;
--12/Calculate how many warranty claims were filed within 180 days of a product sale.
select count(w.claim_id) from warranty as w
join sales as s
on w.sale_id=s.sale_id
where 0<=w.claim_date-s.sale_date and w.claim_date-s.sale_date<=180

--13/Determine how many warranty claims were filed for products launched in the last two years.

select * from products
select * from warranty
select * from sales;

select p.product_name,
count(w.claim_id) as total_claim,
count(s.sale_id) as total_sold
from sales as s
left join warranty as w
on s.sale_id=w.sale_id
join products as p
on p.product_id=s.product_id
where p.launch_date >= current_date -interval '2years'
group by 1
order by p.product_name


--14/List the months in the last three years where sales exceeded 5,000 units in the USA.

select 
to_char(sale_date,'yyyy-mm') as month_year,
sum(quantity) as total_qty_sold
from sales as s
left join stores as st
on s.store_id=st.store_id
where sale_date>=current_date - interval '3years'
and st.country='United States'
group by 1
having sum(quantity)>5000


--15/Identify the product category with the most warranty claims filed in the last two years.
select c.category_name,
count(w.claim_date) as count_claim
from warranty as w
join sales as s
on w.sale_id=s.sale_id
join products as p
on s.product_id=p.product_id
join category as c
ON c.category_id = p.category_id
where w.claim_date>=current_date-interval '2years'
group by 1

--16/Determine the percentage chance of receiving warranty claims after each purchase for each country.

select st.country,
count(w.claim_id) as total_claim,
sum(s.quantity) as total_sales,
round((count(w.claim_id)::numeric/sum(s.quantity)::numeric)*100,2) as percentage_of_risk
from sales as s
join stores as st
on s.store_id=st.store_id
left join warranty as w
on w.sale_id=s.sale_id
group by 1
order by st.country
--17/Analyze the year-by-year growth ratio for each store.
select * from products
select * from stores;

with yearly_sales as (
select st.store_name,
extract(year from sale_date) as year_of_sale,
sum(p.price*s.quantity) as total_revenue
from sales as s
left join products as p
on s.product_id=p.product_id
join stores as st
on s.store_id=st.store_id
group by 1,2),

growth_ration as (
select store_name,  year_of_sale,
lag(total_revenue,1) over(partition by store_name order by year_of_sale) as last_year_sale,
total_revenue as current_year_sale
from yearly_sales
)

select
store_name,
year_of_sale,
last_year_sale,
current_year_sale,
round((current_year_sale - last_year_sale)::numeric/last_year_sale::numeric * 100,2) as growth_ratio_YOY
from growth_ration
where last_year_sale is not null;

--18.Calculate the correlation between product price and warranty claims for products sold in the tast five years, segmented by price range.
select * from products
select * from warranty
select 
case when p.price<500 then 'Low cost'
	when p.price between 500 and 1000 then 'Moderate cost'
	else 'High cost' end as Price_segment,
count(w.claim_id) as total_warranty
from products as p
left join sales as s
on p.product_id=s.product_id
left join warranty as w
on w.sale_id=s.sale_id
where claim_date>=current_date -interval '5years'
group by 1;

--19.Identify the store with the highest percentage of "Completed" claims relative to total claims filed

select st.store_id,
sum(case when w.repair_status='Completed' then 1 else 0 end) as total_completed,
count(w.claim_id) as total_repaired,
round(sum(case when w.repair_status='Completed' then 1 else 0 end)*100::numeric/count(w.claim_id)::numeric,2)
from stores as st
left join sales as s
on st.store_id=s.store_id
left join warranty as w
on s.sale_id=w.sale_id
group by st.store_id
order by 4 desc

--20.Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.

with monthly_year_sale as (select store_id, 
extract(year from sale_date) as year_sale,
extract(month from sale_date) as month_sale,
sum(s.quantity*p.price) as total_revenue
from sales as s
join products as p
on s.product_id=p.product_id
group by 1,2,3
order by 1,2,3)

select store_id,
year_sale,
month_sale,
total_revenue,
sum(total_revenue) over(partition by store_id order by year_sale, month_sale asc) as running_total
from monthly_year_sale 
--21/Analyze product sales trends over time, segmented into key periods: 
--from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
select * from products;
select p.product_name,
case 
when s.sale_date between p.launch_date and p.launch_date + interval '6 month' then '0-6 month'
when s.sale_date between p.launch_date +interval '6 month' and p.launch_date+interval '12 month' then '6-12 month'
when s.sale_date between p.launch_date +interval'12month' and p.launch_date+interval '18 month' then '12-18 month'
else '18+' end as period_launch,
sum(s.quantity) as total_unit_sold
from sales as s
join products as p
on s.product_id=p.product_id
group by 1,2
order by 1,3