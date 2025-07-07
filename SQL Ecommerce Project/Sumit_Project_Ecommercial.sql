-- PART I:ANALYZING TRAFFIC SOURCES
-- 1: Overall: Number of sessions, number orders and conversion rate
select 	
count(distinct w.website_session_id) as sessions,
count(distinct o.order_id) as orders,
round((count(distinct o.order_id)/count(distinct w.website_session_id)),2) as  session_to_order_conv_rt
from website_sessions as w
left join orders as o
on w.website_session_id=o.website_session_id;
-- 2: Number of sessions and orders and conversion_rate by utm_source
select utm_source, 	
		count( distinct w.website_session_id) as sessions,
        count(distinct o.order_id) as orders,
        count(distinct o.order_id)/count( distinct w.website_session_id) as conversion_rate
from website_sessions as w
left join orders as o
on w.website_session_id=o.website_session_id
group by w.utm_source
order by sessions desc;
-- 3: Caculate conversion rate by UTM source, campaign and referring domain
select utm_source,utm_campaign,http_referer,
		count(w.website_session_id) as sessions,
        count(o.order_id) as orders,
        round((count(o.order_id)/count(w.website_session_id)),2) as  session_to_order_conv_rt,
        row_number() over(order by round((count(o.order_id)/count(w.website_session_id)),2) desc) as rank_conv_rt
from website_sessions as w
left join orders as o
on w.website_session_id=o.website_session_id
where utm_campaign is not null
group by utm_source,utm_campaign,http_referer;
-- 4: Identify the 5 weeks with the highest number of sessions each year
select * from (select year(created_at) as year_created,
		week(created_at) as week_created,
        count(distinct website_session_id) as sessions,
		row_number() over(partition by year(created_at) order by count(distinct website_session_id) ) as rank_sessions
from website_sessions
group by year(created_at) ,week(created_at)
order by  year_created desc) as t1
where t1.rank_sessions<=5;
-- Task 5: See each product (through the product_name column) often appears in orders of 1 or 2 items, 
-- to find out users' shopping trends.
select p.product_name, 
sum(case when o.items_purchased=1 then 1 else 0 end) as orders_w_1_item,
sum(case when o.items_purchased=2 then 1 else 0 end) as orders_w_2_item,
count(o.order_id) as total_orders
from orders as o
left join products as p
on o.primary_product_id=p.product_id
group by p.product_name;
-- Task 6: Number sessions, orders and conversion by device type
select device_type,
		count(w.website_session_id) as sessions,
        count(o.order_id) as orders,
        round((count(o.order_id)/count(w.website_session_id)),2) as  session_to_order_conv_rt
from website_sessions as w
left join orders as o
on w.website_session_id=o.website_session_id
group by device_type;
-- PART II: ANALYZING WEBSITE PERFORMANCE
-- 1: Total page views and sessions
select 
	count(distinct website_pageview_id) as views,
    count(distinct website_session_id) as sessions,
    count(distinct website_session_id)/count(distinct website_pageview_id) as conversion_rate
from website_pageviews;
-- 2: Total page views and sessions=> conversion_rate by url
select pageview_url,
	count(distinct website_pageview_id) as views,
    count(distinct website_session_id) as sessions,
    count(distinct website_session_id)/count(distinct website_pageview_id) as conversion_rate
from website_pageviews
group by pageview_url
order by sessions;
-- 3:Count the number of sessions where each page was the first page (landing page).
-- ("How many sessions were there where /home, /product/123, etc. was the first page the user visited?")
-- step 1: Find first pageview by website_session_id
create temporary table first_pageviews
select website_session_id,
		min(website_pageview_id) as min_pageview_id
from website_pageviews
group by website_session_id;
-- step 2: Count number sessions of each landing_page
select w.pageview_url, 
		count(distinct f.website_session_id) as sessions_hitting_landing_this_landing_page
from  website_pageviews as w
left join first_pageviews as f
on w.website_session_id=f.website_session_id
group by w.pageview_url
order by sessions_hitting_landing_this_landing_page desc;
-- 4:Calculate Bounce Rate for each landing page
-- ("How many people visit a page but leave immediately (only view 1 page)?")
-- Step 1: Find the first page view in each session
create temporary table first_pageview_demo
select p.website_session_id,
		min(website_pageview_id) as min_pageview_id
from website_pageviews as p
inner join website_sessions as s
on p.website_session_id=s.website_session_id
group by p.website_session_id;
select * from first_pageview_demo;

-- step 2: Get first pageview_url (landing_page) by website_session_id
create temporary table session_w_landing_page_demo
select dm.website_session_id, 
p.pageview_url as landing_page
from first_pageview_demo as dm
left join website_pageviews as p
on dm.min_pageview_id=p.website_pageview_id;
select * from session_w_landing_page_demo;
-- step 3: Find bounced sessions
create temporary table bounced_session_only
select l.website_session_id, 
	   l.landing_page,
       count(p.website_pageview_id) as count_of_pageviews
from session_w_landing_page_demo as l
inner join website_pageviews as p
on l.website_session_id=p.website_session_id
group by l.website_session_id, 
	   l.landing_page
having count(p.website_pageview_id)=1;

-- step 4: Calculate Bounce Rate for each landing page
select lp.landing_page,
count(distinct lp.website_session_id) as sessions,
count(distinct b.website_session_id) as bounced_sessions,
count(distinct b.website_session_id)/count(distinct lp.website_session_id) as rate_bounced_sessions
from session_w_landing_page_demo as lp
left join bounced_session_only as b
on lp.website_session_id=b.website_session_id
group by lp.landing_page;


-- 5: Weekly Bounce Rate Analysis
-- Step 1: Find first view and total number of pages viewed per session 
-- => Used to determine landing page and bounce (if there is only 1 view).
create temporary table session_w_min_pv_id_and_view_count
select s.website_session_id,
min(p.website_pageview_id) as first_pageview_id,
count(p.website_pageview_id) as count_pageviews
from website_sessions as s
left join website_pageviews as p
on s.website_session_id=p.website_session_id
group by s.website_session_id;

-- step 2: Concatenate to get landing page url and the time sessions start
create temporary table session_w_counts_lander_and_created_at;
select pv.website_session_id,
		pv.first_pageview_id,
        pv.count_pageviews,
        p.created_at as session_created_at,
        p.pageview_url as landing_page
from session_w_min_pv_id_and_view_count as pv
left join website_pageviews as p
on pv.first_pageview_id=p.website_pageview_id;
select * from session_w_counts_lander_and_created_at;
-- Step 3: Weekly summary
select min(date(session_created_at)) as week_start_date,
count( distinct website_session_id) as total_sessions,
count(distinct case when count_pageviews= 1 then website_session_id else null end) as bounced_sessions,
count( distinct case when count_pageviews= 1 then website_session_id else null end)/count(website_session_id) as bounce_rate,
count(distinct case when landing_page='/home' then website_session_id else null end) as home,
count(distinct case when landing_page='/lander-1' then  website_session_id else null end) as lander
from session_w_counts_lander_and_created_at 
group by yearweek(session_created_at);
-- CONCLUSION:
-- total_sessions: number sessions of the week
-- bounced_sessions: how many sessions only viewed one page (exited immediatately)
-- bounce_rate=exit_rate=bounced/total
-- home: How many sessions started at /home.
-- lander: How many sessions started at /lander-1.

-- 6: Build and analyze a mini conversion funnel in the website purchase journey from landing page to thankyou page
-- Know how many people reach each step, and also droppoff rate
-- Step 1: select all pageview for revelant sessions
create temporary table session_level_made_it_flags
select website_session_id,
		max(product_page) as product_made_it,
        max(fuzzy_page) as fuzzy_made_it,
        max(cart_page) as cart_made_it,
        max(shipping_page) as shipping_made_it,
        max(billing_page) as billing_made_it,
        max(thankyou_page) as thankyou_made_it
from (select s.website_session_id,
		p.pageview_url,
        case when p.pageview_url='/products' then 1 else 0 end as product_page,
        case when p.pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as fuzzy_page,
        case when p.pageview_url='/cart' then 1 else 0 end as cart_page,
        case when p.pageview_url='/shipping' then 1 else 0 end as shipping_page,
        case when p.pageview_url='/billing' then 1 else 0 end as billing_page,
        case when p.pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions as s
left join website_pageviews as p
on s.website_session_id=p.website_session_id
) as pageview_level
group by website_session_id;
-- Step 2: identify each revelant pageviews as specific funnel step
select * from session_level_made_it_flags
where thankyou_made_it=1;
-- Step 3: create the session level conversion funnel view
select count(distinct website_session_id) as sessions,
count(distinct case when product_made_it=1 then website_session_id else null end) as to_product,
count(distinct case when fuzzy_made_it=1 then website_session_id else null end) as to_fuzzy,
count(distinct case when cart_made_it=1 then website_session_id else null end) as to_cart,
count(distinct case when shipping_made_it=1 then website_session_id else null end) as to_shipping,
count(distinct case when billing_made_it=1 then website_session_id else null end) as to_billing,
count(distinct case when thankyou_made_it=1 then website_session_id else null end) as to_thankyou
from session_level_made_it_flags;
-- Step 4: aggregate the data to assess the  funnel peformance
select
count(distinct case when product_made_it=1 then website_session_id else null end)/count(distinct website_session_id) as lander_click_rt,
count(distinct case when fuzzy_made_it=1 then website_session_id else null end)/count(distinct case when product_made_it=1 then website_session_id else null end) as product_click_rt,
count(distinct case when cart_made_it=1 then website_session_id else null end)/count(distinct case when fuzzy_made_it=1 then website_session_id else null end) as fuzzy_click_rt,
count(distinct case when shipping_made_it=1 then website_session_id else null end)/count(distinct case when cart_made_it=1 then website_session_id else null end) as cart_click_rt,
count(distinct case when billing_made_it=1 then website_session_id else null end)/count(distinct case when shipping_made_it=1 then website_session_id else null end) as shipping_rt,
count(distinct case when thankyou_made_it=1 then website_session_id else null end)/count(distinct case when billing_made_it=1 then website_session_id else null end) as billing_click_rt
from session_level_made_it_flags;


-- PART III) CHANNEL PORTFOLIO ANALYSIS
-- 1: Calculate conversion rate by device type (device_type) and marketing campaign (utm_campaign), 
-- specifically for two campaigns: 'brand' and 'nonbrand'.
select device_type,utm_campaign,
count(distinct s.website_session_id ) as sessions,
count(distinct o.order_id) as orders,
count(distinct o.order_id)/count(distinct s.website_session_id ) as conversion_rate
from website_sessions  as s
left join orders as o
on s.website_session_id=o.website_session_id
where utm_campaign in ('brand','nonbrand')
group by 1,2;
-- 2: analyze weekly sessions, segmented by traffic source (utm_source) and device (device_type), 
-- for nonbrand campaigns only, with the goal of comparing gsearch and bsearch on each device (desktop and mobile).
select min(date(s.created_at)) as week_start_date,
count(distinct case when s.utm_source='gsearch' and device_type='desktop' then s.website_session_id end) as g_dtop_sessions,
count(distinct case when s.utm_source='bsearch' and device_type='desktop' then s.website_session_id end) as b_dtop_sessions,
count(distinct case when s.utm_source='bsearch' and device_type='desktop' then s.website_session_id end)/
count(distinct case when s.utm_source='gsearch' and device_type='desktop' then s.website_session_id end) as b_pct_of_g_dtop,
count(distinct case when s.utm_source='gsearch' and device_type='mobile' then s.website_session_id end) as g_mobi_sessions,
count(distinct case when s.utm_source='bsearch' and device_type='mobile' then s.website_session_id end) as b_mobi_sessions,
count(distinct case when s.utm_source='bsearch' and device_type='mobile' then s.website_session_id end)/
count(distinct case when s.utm_source='gsearch' and device_type='mobile' then s.website_session_id end) as b_pct_of_g_mobi
from website_sessions  as s
left join orders as o
on s.website_session_id=o.website_session_id
where utm_campaign ='nonbrand'
group by yearweek(s.created_at);
-- 3.Monthly performance analysis report of traffic channels (website traffic sources).
-- “In each month, how many people come from each channel (paid brand, paid non-brand, direct, organic)? 
-- And what percentage of these channels are paid non-brand?”
select year(created_at) as yr,
	month(created_at) as mo,
    count(case when channel_group='paid_nonbrand' then  website_session_id else null end) as nonbrand,
    count(case when channel_group='paid_brand' then  website_session_id else null end) as brand,
     count(case when channel_group='paid_brand' then  website_session_id else null end)
    /count(case when channel_group='paid_nonbrand' then  website_session_id else null end) as brand_pct_of_nonbrand,
    count(case when channel_group='direct_type_in' then  website_session_id else null end) as direct,
    count(case when channel_group='direct_type_in' then  website_session_id else null end)
    /count(case when channel_group='paid_nonbrand' then  website_session_id else null end) as direct_pct_of_nonbrand,
    count(case when channel_group='organic_search' then  website_session_id else null end) as organic,
    count(case when channel_group='organic_search' then  website_session_id else null end)
    /count(case when channel_group='paid_nonbrand' then  website_session_id else null end) as organic_pct_of_nonbrand
from (select website_session_id,created_at,
	case 
		when utm_source is null and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then  'organic_search'
        when utm_campaign='brand' then 'paid_brand'
        when utm_campaign='nonbrand' then 'paid_nonbrand'
        when utm_source is null and http_referer is null then 'direct_type_in'
        end as channel_group
from  website_sessions) as website_w_channel_group
group by year(created_at), month(created_at);
-- 4.BUSINESS PATTERNS & SEASONALITY: Analyze the average number of sessions by hour of the day and day of the week  to answer 
-- the question: what hour and on which day of the week does the website experience the highest traffic (measured by sessions)
select 	hr,
        round(avg(case when wkday=0 then web_sessions else null end),1) as monday,
        round(avg(case when wkday=1 then web_sessions else null end),1) as tuesday,
        round(avg(case when wkday=2 then web_sessions else null end),1) as wednesday,
        round(avg(case when wkday=3 then web_sessions else null end),1) as thursday,
        round(avg(case when wkday=4 then web_sessions else null end),1) as friday,
        round(avg(case when wkday=5 then web_sessions else null end),1) as saturday,
        round(avg(case when wkday=6 then web_sessions else null end),1) as sunday
from (select date(created_at),
		weekday(created_at) as wkday,
        hour(created_at) as hr,
        count(distinct website_session_id) as web_sessions
from website_sessions
group by 1,2,3) as daily_hourly_sessions
group by hr;
--  5:Product-level performance analysis.
select p.product_name,
count(o.order_id) as total_orders,
sum(price_usd) as revenue,
sum(price_usd-cogs_usd) as margin,
avg(price_usd) as avo
from orders as o
left join products as p
on o.primary_product_id=p.product_id
group by p.product_name;
-- 6: After users view a product page, how many proceed to the shopping cart, 
-- shipping page, billing page, and finally the thank you page (order completion)? 
-- And what is the conversion rate between steps for each product?
-- Step 1: Create temporary table session_seeing_product_page
create temporary table session_seeing_product_page
select website_session_id, 
	website_pageview_id, 
	pageview_url as product_page_seen
from website_pageviews
where created_at <"2013-04-10" and 
	  created_at >"2013-01-06" and
      pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear');
select * from session_seeing_product_page;
--  Step 2: Check the next pageviews after seeing the product
select sp.website_pageview_id as sp,pg.website_pageview_id,pg.pageview_url,product_page_seen
from session_seeing_product_page as sp
left join website_pageviews as pg
on sp.website_session_id=pg.website_session_id
and sp.website_pageview_id<pg.website_pageview_id;
-- Step 3:  Create a flag to see what steps the user has gone through in the purchase process after viewing the product:
-- cart_made_it = 1 if they entered /cart
-- shipping_made_it = 1 if they entered /shipping
-- billing_made_it = 1 if they entered /billing-2-
-- thank_you_made_it = 1 if they entered /thank-you-for-your-order
create temporary table session_product_level_made_it_flags
select website_session_id,
		case when product_page_seen='/the-original-mr-fuzzy' then "mr_fuzzy"
			when product_page_seen='/the-forever-love-bear' then "love_bear" 
		else "check_logic" end as product_seen,
        max(cart_page) as cart_made_it,
        max(shipping_page) as shipping_made_it,
        max(billing_page) as billing_made_it,
        max(thank_you_page) as thank_you_made_it
from 
(select sp.website_session_id,product_page_seen,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when  pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when  pageview_url='/billing-2' then 1 else 0 end as billing_page,
case when  pageview_url='/thank-you-for-your-order' then 1 else 0 end as thank_you_page 
from  session_seeing_product_page as sp
left join website_pageviews as pg
on sp.website_session_id=pg.website_session_id
and sp.website_pageview_id<pg.website_pageview_id) as pageview_level
group by website_session_id,
case when product_page_seen='/the-original-mr-fuzzy' then "mr_fuzzy"
			when product_page_seen='/the-forever-love-bear' then "love_bear" 
		else "check_logic" end;
-- Step 4. Calculate the number of sessions and the number of passes through each step
select product_seen,
count(distinct website_session_id) as sessions,
count(distinct case when cart_made_it=1 then website_session_id else null end) as to_cart,
count(distinct case when shipping_made_it=1 then website_session_id else null end) as to_shipping,
count(distinct case when billing_made_it=1 then website_session_id else null end) as to_billing,
count(distinct case when thank_you_made_it=1 then website_session_id else null end) as to_thank_you
from session_product_level_made_it_flags
group by 1;
select product_seen,
count(distinct case when cart_made_it=1 then website_session_id else null end)/count(distinct website_session_id) as product_page_click_rt,
count(distinct case when shipping_made_it=1 then website_session_id else null end)
/count(distinct case when cart_made_it=1 then website_session_id else null end) as shipping_click_rt,
count(distinct case when billing_made_it=1 then website_session_id else null end)
/count(distinct case when shipping_made_it=1 then website_session_id else null end) as billing_click_rt,
count(distinct case when thank_you_made_it=1 then website_session_id else null end) 
/count(distinct case when billing_made_it=1 then website_session_id else null end) as thank_you_rt
from session_product_level_made_it_flags
group by 1;
-- V) USER BEHAVIOR
-- 1. How long does it take for users to return to your site after their first visit?
-- Which traffic sources bring in the most returning users?
-- Step 1: Create table sessions_w_repeats_for_time_diff
create temporary table sesions_w_repeats_for_time_diff
select  new_sessions.user_id,
new_sessions.website_session_id as new_session_id,
s.website_session_id as repeat_session_id,
new_sessions.created_at as new_session_created_at,
s.created_at as repeat_session_created_at
from 
(select user_id, 
website_session_id,
created_at
from website_sessions
where created_at<"2014-11-03"
and created_at>="2014-01-01"
and is_repeat_session=0) as new_sessions
left join website_sessions as s
on new_sessions.user_id=s.user_id
and s.is_repeat_session=1
and new_sessions.website_session_id<s.website_session_id
and s.created_at<"2014-11-03"
and s.created_at>="2014-01-01";
-- Step 2: Calculate the day gap between the first session and the first returning session
select avg(day_first_to_second_session),
min(day_first_to_second_session),
max(day_first_to_second_session)
from
(select user_id,
datediff( second_session_created_at,new_session_created_at) as day_first_to_second_session
from (select user_id,
new_session_id,
new_session_created_at,
min(repeat_session_id) as second_session_id,
min(repeat_session_created_at) as second_session_created_at
from sesions_w_repeats_for_time_diff
where repeat_session_id is not null
group by 1,2,3) as first_second) as user_first_to_second;
