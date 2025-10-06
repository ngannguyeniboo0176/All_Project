
# SQL 50 - LeetCode
My Answers for https://leetcode.com/studyplan/top-sql-50/

[1757. Recyclable and Low Fat Products](https://leetcode.com/problems/recyclable-and-low-fat-products/?envType=study-plan-v2&envId=top-sql-50
)



```sql
select product_id
from Products
where low_fats = 'Y'
and recyclable = 'Y';
```

[584. Find Customer Referee](https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select name from customer 
where referee_id!=2 or referee_id is null
```
[595. Big Countries](https://leetcode.com/problems/big-countries/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select name, population, area
from world
where population>=25000000 or area >=3000000
```
[1148. Article Views I](https://leetcode.com/problems/article-views-i/?envType=study-plan-v2&envId=top-sql-50)
```slq
select distinct(author_id) as id
from views
where author_id=viewer_id
order by author_id asc
```
[1683. Invalid Tweets](https://leetcode.com/problems/invalid-tweets/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select tweet_id from Tweets
where length(content)> 15
```
[1378. Replace Employee ID With The Unique Identifier](https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select s.name,u.unique_id from
Employees as s
left join EmployeeUNI as u 
on u.id=s.id
order by u.unique_id asc
```
[1068. Product Sales Analysis I](https://leetcode.com/problems/product-sales-analysis-i/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select p.product_name,s.year,s.price
from product as p
inner join sales as s
on p.product_id=s.product_id
order by year asc
```
[1581. Customer Who Visited but Did Not Make Any Transactions]
```sql
select customer_id,
count(*) as count_no_trans 
from visits 
where visit_id not in (select distinct visit_id from transactions)
group by customer_id
order by count_no_trans desc
```
[197. Rising Temperature](https://leetcode.com/problems/rising-temperature/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as(select id,
recordDate,
temperature,
lag(temperature,1) over(order by recordDate asc) as prev_temp,
lag(recordDate,1) over(order by recordDate asc) as prev_day
from Weather
order by recordDate asc)

select id from cte
where datediff(recordDate,prev_day)=1
and temperature>prev_temp
```
[1661. Average Time of Process per Machine](https://leetcode.com/problems/average-time-of-process-per-machine/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (select machine_id,
sum(case when activity_type='start' then timestamp else 0 end) as start_time,
sum(case when activity_type='end' then timestamp else 0 end) as end_time,
count(*)/2 as no_times
from Activity
group by machine_id)

select machine_id,
round(sum(end_time-start_time)/no_times,3) as  processing_time from cte
group by machine_id
order by machine_id asc 
```
[577. Employee Bonus](https://leetcode.com/problems/employee-bonus/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select e.name,bonus
from employee as e
left join bonus as b
on e.empId=b.empId
where b.bonus<1000 or bonus is null
```
[1280. Students and Examinations](https://leetcode.com/problems/students-and-examinations/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select st.student_id,
st.student_name, 
su.subject_name,
count(ex.subject_name) as attended_exams
from students as st
join subjects as su
left join Examinations as ex
on ex.student_id=st.student_id and su.subject_name=ex.subject_name
group by st.student_id,st.student_name, su.subject_name
order by st.student_id,st.student_name, su.subject_name
```
[570. Managers with at Least 5 Direct Reports](https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select name from employee
where id in (
select managerId 
from employee
group by managerId
having count(managerId)>=5)
```
[1934. Confirmation Rate](https://leetcode.com/problems/confirmation-rate/?envType=study-plan-v2&envId=top-sql-50)
```sql
select s.user_id, 
round(sum(case when c.action='confirmed' then 1 else 0 end)/count(*),2) as confirmation_rate
from Signups as s
left join Confirmations as c
on s.user_id=c.user_id
group by s.user_id
order by confirmation_rate asc
```
[620. Not Boring Movies](https://leetcode.com/problems/not-boring-movies/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select id, movie,description,rating 
from cinema
where id %2!=0 and description<>'boring'
order by rating desc
```
[1251. Average Selling Price](https://leetcode.com/problems/average-selling-price/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select p.product_id,
ifnull(round(sum(p.price*u.units)/sum(u.units),2),0) as average_price
from prices as p
left join unitsSold as u
on u.product_id=p.product_id
and u.purchase_date between p.start_date and p.end_date 
group by p.product_id
```
[1075. Project Employees I](https://leetcode.com/problems/project-employees-i/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select p.project_id,
round(avg(e.experience_years),2) as average_years 
from Project as p
left join Employee as e
on p.employee_id=e.employee_id
group by 1
```
[1633. Percentage of Users Attended a Contest](https://leetcode.com/problems/percentage-of-users-attended-a-contest/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select contest_id, 
round(count(*)*100/(select count(user_id) from Users),2) as percentage
from register
group by contest_id
order by percentage desc,contest_id
```
[1211. Queries Quality and Percentage](https://leetcode.com/problems/queries-quality-and-percentage/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select query_name, 
round(sum(rating/position)/count(*),2) as quality,
round(sum(case when rating<3 then 1 else 0 end )*100/count(*),2) as poor_query_percentage
from queries
group by query_name
```
[1193. Monthly Transactions I](https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select substr(trans_date,1,7) as month,
country,
count(id) as trans_count,
sum(case when state='approved' then 1 else 0 end ) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end ) as approved_total_amount
from transactions
group by substr(trans_date,1,7), country
```
[1174. Immediate Food Delivery II](https://leetcode.com/problems/immediate-food-delivery-ii/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (select customer_id, min(order_date) as minx
from delivery
group by customer_id)

select
round(sum(case when cte.minx=d.customer_pref_delivery_date then 1 else 0 end)*100/count(cte.customer_id),2) as immediate_percentage  
from cte
inner join delivery as d
on cte.customer_id=d.customer_id and cte.minx=d.order_date
```
[550. Game Play Analysis IV](https://leetcode.com/problems/game-play-analysis-iv/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (
select 
player_id, 
event_date,
lead(event_date,1) over( partition by player_id order by event_date asc) as after_date,
row_number() over (partition by player_id order by event_date asc) as rn
from activity)

select 
round(sum(case when datediff(after_date,event_date)=1 then 1 else 0 end)/count(distinct player_id),2) as fraction
from cte
where rn=1
```
[2356. Number of Unique Subjects Taught by Each Teacher](https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select teacher_id, 
count(distinct subject_id) as cnt
from Teacher
group by 1
```
[1141. User Activity for the Past 30 Days I](https://leetcode.com/problems/user-activity-for-the-past-30-days-i/?envType=study-plan-v2&envId=top-sql-50)
```sql
select activity_date as day, 
count(distinct(user_id)) as active_users 
from Activity
where activity_date between "2019-06-28" and "2019-07-27"
group by activity_date
```
[1070. Product Sales Analysis III](https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50)
```sql
select product_id,year as first_year,
quantity,
price
from Sales 
where(product_id,year) in (select product_id,min(year) as year
from Sales
group by product_id)
```
[596. Classes With at Least 5 Students](https://leetcode.com/problems/classes-with-at-least-5-students/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select class from Courses
group by class
having count(class)>=5
```
[1729. Find Followers Count](https://leetcode.com/problems/find-followers-count/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select user_id,
count(*) as followers_count from Followers
group by 1
order by 1
```
[619. Biggest Single Number](https://leetcode.com/problems/biggest-single-number/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as(select num, count(*) as num1 from MyNumbers
group by num 
having count(*)=1)
select max(cte.num) as num from cte
```
[1045. Customers Who Bought All Products](https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select customer_id from customer
group by 1
having count(distinct product_key) = (select count(1) from Product);
```
[1731. The Number of Employees Which Report to Each Employee](https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
# Write your MySQL query statement below
with cte as 
(select reports_to, 
count(reports_to) as reports_count, 
round(avg(age)) as average_age  
from Employees
where reports_to is not null 
group by reports_to)
select e.employee_id,
e.name, 
cte.reports_count,
cte.average_age from Employees as e
join cte
on e.employee_id =cte.reports_to
order by e.employee_id
```
[1789. Primary Department for Each Employee](https://leetcode.com/problems/primary-department-for-each-employee/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select employee_id,department_id 
from employee 
where primary_flag = 'Y' or employee_id in 
    (select employee_id 
     from employee 
     group by employee_id
     having count(department_id) = 1)
```
[610. Triangle Judgement](https://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select x,y,z,
    case  when x+y>z and x+z>y and y+z>x then 'Yes' 
    else 'No'
    end as 'triangle'
from Triangle
```
[180. Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (
select * ,
 lag(num) over() as a, 
 lead(num) over() as b from Logs
)
select distinct(num) as ConsecutiveNums
from cte
where num=a and num=b
```
[1164. Product Price at a Given Date](https://leetcode.com/problems/product-price-at-a-given-date/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (select product_id,new_price,
change_date,
row_number() over(partition by product_id order by change_date desc) as rn
from products
where change_date<='2019-08-16')

select p.product_id,coalesce(cte.new_price,10) as price
from 
(select distinct(product_id) from products) p
left join cte
on p.product_id=cte.product_id and cte.rn=1
```
[1204. Last Person to Fit in the Bus](https://leetcode.com/problems/last-person-to-fit-in-the-bus/?envType=study-plan-v2&envId=top-sql-50)
```sql
select person_name from (select person_name,turn,
sum(weight) over(order by turn ) as total_weight
from queue
group by 1,2) t1
where t1.total_weight<=1000
order by t1.turn desc
limit 1
```
[1907. Count Salary Categories](https://leetcode.com/problems/count-salary-categories/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select * from (select "Low Salary" as category,
sum(case when income<20000 then 1 else 0 end) as accounts_count
from accounts)
union all
select * from (select "Average Salary" ,
sum(case when income between 20000 and 50000 then 1 else 0 end) as accounts_count
from accounts)
select * from (select "High Salary" ,
sum(case when income >50000 then 1 else 0 end) as accounts_count
from accounts)
```
[1978. Employees Whose Manager Left the Company](https://leetcode.com/problems/employees-whose-manager-left-the-company/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select employee_id from Employees
where salary<30000 and  manager_id not in (select distinct employee_id from Employees )
order by employee_id
```
[626. Exchange Seats](https://leetcode.com/problems/exchange-seats/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select case when id%2=1 and id+1 in (select id from seat) then id+1
            when id%2=0 then id-1
            else id
            end as id,
student
from seat
order by id
```
[1341. Movie Rating](https://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50)
```sql
select * from (select u.name as results
from movieRating as mv
inner join users as u
on mv.user_id=u.user_id
group by mv.user_id
order by count(mv.user_id) desc,u.name asc
limit 1) t1
union all 
select * from (
select m.title
from movieRating as mv
inner join movies as m
on mv.movie_id=m.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by m.title
order by avg(mv.rating) desc, m.title asc
limit 1) t2;
```
[602. Friend Requests II: Who Has the Most Friends](https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (select distinct(requester_id) as id
from RequestAccepted
union
select distinct(accepter_id)
from RequestAccepted)
select id,
(count(requester_id)+count(accepter_id))/2 as num 
from cte
left join RequestAccepted as r
on cte.id=r.requester_id or cte.id=r.accepter_id
group by id
order by num desc
limit 1
```
[585. Investments in 2016](https://leetcode.com/problems/investments-in-2016/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select round(sum(tiv_2016),2) as tiv_2016
from Insurance
where tiv_2015 in (select distinct(tiv_2015)
from Insurance
group by tiv_2015
having count(tiv_2015)>1)
and (lat,lon) in (select lat,lon from Insurance
group by lat,lon
having count(*)=1)
```
[185. Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select Department,
Employee,salary from (select d.name as Department,
e.name as Employee,salary,
dense_rank() over(partition by d.name order by salary desc) as rn
from employee as e
left join department as d
on e.departmentId=d.id) as t
where rn<=3
order by Department, Salary desc;
```
[1667. Fix Names in a Table](https://leetcode.com/problems/fix-names-in-a-table/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select user_id,concat(upper(left(name,1)),lower(substring(name,2))) as name
from Users 
order by user_id
```
[1527. Patients With a Condition](https://leetcode.com/problems/patients-with-a-condition/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select * from patients
where regexp_like(conditions, ' +DIAB1|^DIAB1')
```
[196. Delete Duplicate Emails](https://leetcode.com/problems/delete-duplicate-emails/?envType=study-plan-v2&envId=top-sql-50)
```sql
delete p1
from person p1
join person p2
on p1.email=p2.email and p1.id>p2.id
```
[176. Second Highest Salary](https://leetcode.com/problems/second-highest-salary/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
with cte as (select salary,
dense_rank() over(order by salary desc) as rn
from employee)

select 
case when max(rn)>=2 then salary 
else null end as SecondHighestSalary
from cte
where rn=2
```
[1484. Group Sold Products By The Date](https://leetcode.com/problems/group-sold-products-by-the-date/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select sell_date,
count(distinct product) as num_sold,
group_concat(distinct product) as products
from Activities
group by sell_date
```
[1327. List the Products Ordered in a Period](https://leetcode.com/problems/list-the-products-ordered-in-a-period/description/?envType=study-plan-v2&envId=top-sql-50)
```sql
select
p.product_name, 
sum(o.unit) as unit
from orders as o
left join products AS p
ON o.product_id = p.product_id
where substr(order_date,1,7)= '2020-02'
group by p.product_name
having sum(o.unit) >= 100;
```
[1517. Find Users With Valid E-Mails](https://leetcode.com/problems/find-users-with-valid-e-mails/?envType=study-plan-v2&envId=top-sql-50)
select * from users
where regexp_like(mail, '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$', 'c')


























