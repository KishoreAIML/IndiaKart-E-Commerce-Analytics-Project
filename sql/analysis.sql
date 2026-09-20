USE IndiaKart_E_Commerce_Database;

select * from orders;

EXEC sp_help 'orders';

-- 1. Monthly Revenue Trend (GMV)

select 
	FORMAT(order_date,'yyyy-MM') as year_month,
	COUNT(*) AS total_orders,
	SUM(total_amount) as gross_revenue_inr,
	SUM(gst_amount) as total_gst_amount,
	SUM(discount_amount) as total_discount_amount,
	AVG(final_amount) as avg_final_amount
	
from orders
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY FORMAT(order_date,'yyyy-MM') desc;

-- 2. Category-wise Sales Performance

select * from order_items;

select
	count(distinct oi.order_id) as total_orders,
	SUM(oi.quantity) as units_sold,
	SUM(oi.total_price) AS total_revenue,
	ROUND(100 * SUM(oi.total_price) / (select sum(total_price) from order_items),2) AS revenue_share_pct,
	SUM(oi.gst_amount) as total_gst_collected,
	AVG(oi.unit_price) as avg_unit_price

from order_items oi
join orders o
	ON oi.order_id = o.order_id
where o.status <> 'Cancelled';

-- 3. Customer Segment Analysis (RFM-style)

select * from customers;

select
	c.segment,
	COUNT(c.customer_id) as total_customers,
	AVG(c.total_orders) as avg_orders,
	AVG(c.total_spent) as avg_life_time_value,
	SUM(c.total_spent) as total_revenue_inr,
	ROUND(AVG(c.age),1) as avg_age
from customers c
GROUP BY c.segment
order by total_revenue_inr desc;

-- 5. Return Rate by Category

select * from returns;
select * from order_items;

select 
	oi.category,
	COUNT(DISTINCT r.return_id) as total_returns,
	COUNT(DISTINCT oi.order_id) as total_orders,
	ROUND(100 * count(distinct r.return_id) / count(distinct oi.order_id),2) as return_rate
from returns r
right join order_items oi
	on r.order_id = oi.order_id
group by oi.category
order by return_rate desc;

-- 7. State-wise Revenue Map

select 
	r.state,
	count(distinct r.customer_id) as total_customers,
	count(distinct r.order_id) as total_orders,
	sum(r.final_amount) as total_revenue,
	avg(r.final_amount) as aov_inr
from orders r
group by r.state
order by total_revenue;

-- 8. Inventory Health Check

select * from inventory;

select
	i.warehouse_location,
	i.status,
	count(*) as total_products,
	sum(i.quantity_available) as total_quantity_available,
	sum(i.total_inventory_value) as total_inventory_inr

from inventory i
group by i.warehouse_location,i.status
order by i.warehouse_location,i.status;

-- 9. Supplier Performance

select * from suppliers;
select * from products;

select
	s.supplier_id,
	s.supplier_name,
	s.category,
	count(p.product_id) as total_products_supplied,
	s.rating as supplier_rating,
	avg(p.rating) as avg_product_rating,
	s.payment_terms_days


from suppliers s
join products p
	 ON s.supplier_id = p.supplier_id
group by s.supplier_id,s.supplier_name, s.category, s.rating, s.payment_terms_days
order by avg_product_rating;