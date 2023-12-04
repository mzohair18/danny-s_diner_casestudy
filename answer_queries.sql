use case_study


#Q.1)What is the total amount each customer spent at the restaurant?
select a.customer_id,a.product_id,a.order_date,b.product_name,b.price
from sales a
join menu b
on a.product_id=b.product_id
;

select a.customer_id as customer,sum(price) as total_spent
from sales a
join menu b
on a.product_id=b.product_id
group by customer_id;
order by price;

#Q.2)How many days has each customer visited the restaurant?
select customer_id,count(distinct order_date) as no_of_days_visited
from sales a
join menu b
on a.product_id=b.product_id
group by customer_id
order by no_of_days_visited desc;

#Q.3)What was the first item from the menu purchased by each customer?

use case_study;

with final as (
select a.*,b.product_name,
rank() over (partition by customer_id order by order_date) as ranking
 from sales a
 join menu b
 on a.product_id=b.product_id)
 select * from final where ranking=1


#Q.4)What is the most purchased item on the menu and how many times was it purchased by all customers?
select b.product_name,count(*) as most_purchased_item
from sales a
 join menu b
 on a.product_id=b.product_id
 group by b.product_name
 order by count(*)

use case_study


#Q.5)Which item was the most popular for each customer?
with final as (
select a.customer_id,b.product_name,count(*) as total
 from sales a
 join menu b
 on a.product_id=b.product_id
 group by a.customer_id,b.product_name
 )
 select customer_id,product_name,total,
 rank() over (partition by customer_id order by total desc) as ranking
 from final 
 
 
 #Q.6.)Which item was purchased first by the customer after they became a member?
with final as (
select a.*,b.customer_id as customerid,b.join_date,
rank() over (partition by a.customer_id order by order_date) as ranking,
c.product_name
 from sales a
 left join members b
 on a.customer_id=b.customer_id
 join menu c
 on a.product_id=c.product_id
 where a.order_date>=b.join_date
 )
 select customer_id,ranking,product_name from final where ranking=1


#Q.7)Which item was purchased just before the customer became a member?
select a.*,b.join_date,
rank() over (partition by a.customer_id order by order_date) as ranking,
c.product_name
 from sales a
 inner join members b
 on a.customer_id=b.customer_id
 join menu c
 on a.product_id=c.product_id
 where a.order_date<=b.join_date



#Q.8)What is the total items and amount spent for each member before they became a member

select a.customer_id,count(a.product_id) as items,sum(c.price) as totalspent
 from sales a
 left join members b
 on a.customer_id=b.customer_id
 join menu c
 on a.product_id=c.product_id
 where a.order_date<b.join_date
group by a.customer_id


#Q.9)If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with final as(
select a.customer_id,a.order_date,c.product_name,c.price,
case when product_name='sushi' then 2*c.price
else c.price end as newprice
from sales a
join menu c
on a.product_id=c.product_id
) 
select customer_id,sum(newprice)*10 as points from final
group by customer_id