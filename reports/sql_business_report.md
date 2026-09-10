# SQL Business Report

## Brazilian E-Commerce Data Analysis using PostgreSQL

### Project Overview

This project analyzes the **Brazilian E-Commerce Public Dataset by Olist** using PostgreSQL. The objective is to transform raw transactional data into meaningful business insights by answering common business questions through SQL.

The analysis focuses on:

- Business performance
- Revenue growth
- Order fulfillment
- Customer behavior
- Product performance
- Customer retention
- Logistics performance
- Executive KPIs

---

# Analysis 1 – Business Overview

## Business Question

**How is the company performing overall?**

To answer this question, several business KPIs were calculated from the transactional database.

---

## KPI 1 – Total Revenue

### SQL Query

```sql
SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;
```

### Result

| KPI  | Value  |
|------|-------:|
| Total Revenue | **16,008,872.12** |

### Business Insight

The company generated **16.01 million** in total sales revenue during the observed period. This represents the overall sales volume collected from customer payments.

### Business Recommendation

- Continue monitoring monthly revenue growth.
- Compare revenue with marketing spend and seasonal campaigns.
- Use revenue trends to forecast future sales.

---

## KPI 2 – Total Orders

### SQL Query

```sql
SELECT
COUNT(DISTINCT order_id) AS total_orders
FROM orders;
```

### Result

| KPI | Value |
|------|-------:|
| Total Orders | **99,441** |

### Business Insight

Nearly **100,000 customer orders** were processed, indicating a mature e-commerce operation with substantial transaction volume.

### Business Recommendation

Track monthly order growth and compare it against customer acquisition to understand purchasing behavior.

---

## KPI 3 – Total Customers

### SQL Query

```sql
SELECT
COUNT(DISTINCT customer_id) AS total_customers
FROM customers;
```

### Result

| KPI | Value |
|------|-------:|
| Total Customers | **99,441** |

### Business Insight

The dataset contains **99,441 customers**, matching the number of orders. This suggests that many customers made only one purchase, highlighting an opportunity to improve customer retention.

### Business Recommendation

Increase repeat purchases through loyalty programs, personalized recommendations, and targeted email marketing.

---

## KPI 4 – Average Order Value (AOV)

### SQL Query

```sql
SELECT
ROUND(
SUM(payment_value) /
COUNT(DISTINCT order_id),
2)
AS average_order_value
FROM payments;
```

### Result

| KPI | Value |
|------|-------:|
| Average Order Value | **160.99** |

### Business Insight

On average, customers spend approximately **161** per order.

A higher Average Order Value generally indicates better product bundling, cross-selling, and premium product purchases.

### Business Recommendation

Increase AOV by:

- Product bundles
- Upselling premium products
- Cross-selling complementary products
- Free shipping thresholds

---

## KPI 5 – Average Items per Order

### SQL Query

```sql
SELECT
ROUND(
COUNT(*)::numeric /
COUNT(DISTINCT order_id),
2)
AS avg_items_per_order
FROM order_items;
```

### Result

| KPI | Value |
|------|-------:|
| Average Items per Order | **1.14** |

### Business Insight

Customers purchase just over **one product per order** on average. This indicates that most purchases consist of a single item rather than multiple products.

### Business Recommendation

Increase basket size by:

- Frequently Bought Together recommendations
- Bundle discounts
- "Customers also bought" suggestions
- Quantity discounts

---

# Analysis 2 – Revenue Trend

## Business Question

**Is revenue increasing or decreasing over time?**

Monthly revenue was calculated by combining order and payment information.

### SQL Query

```sql
SELECT
DATE_TRUNC('month', order_purchase_timestamp) AS month,
ROUND(SUM(payment_value),2) AS revenue
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;
```

### Result (Monthly Revenue)

| Month | Revenue |
|--------|---------:|
| Sep 2016 | 252.24 |
| Oct 2016 | 59,090.48 |
| Dec 2016 | 19.62 |
| Jan 2017 | 138,488.04 |
| Feb 2017 | 291,908.01 |
| Mar 2017 | 449,863.60 |
| Apr 2017 | 417,788.03 |
| May 2017 | 592,918.82 |
| Jun 2017 | 511,276.38 |
| Jul 2017 | 592,382.92 |
| Aug 2017 | 674,396.32 |
| Sep 2017 | 727,762.45 |
| Oct 2017 | 779,677.88 |
| Nov 2017 | 1,194,882.80 |
| Dec 2017 | 878,401.48 |
| Jan 2018 | 1,115,004.18 |
| Feb 2018 | 992,463.34 |
| Mar 2018 | 1,159,652.12 |
| Apr 2018 | 1,160,785.48 |
| May 2018 | 1,153,982.15 |
| Jun 2018 | 1,023,880.50 |
| Jul 2018 | 1,066,540.75 |
| Aug 2018 | 1,022,425.32 |
| Sep 2018 | 4,439.54 |
| Oct 2018 | 589.67 |

### Business Insight

The business experienced strong revenue growth throughout 2017, surpassing one million in monthly revenue during late 2017 and early 2018. The sharp decline in September and October 2018 likely reflects that the dataset ends during this period rather than a true business downturn.

### Business Recommendation

- Build dashboards to monitor monthly revenue trends.
- Plan promotional campaigns before peak shopping months.
- Compare year-over-year monthly revenue to identify seasonality.

---

# Analysis 3 – Order Status

## Business Question

**Are customers receiving their orders successfully?**

Order status analysis helps evaluate fulfillment performance and operational efficiency.

### SQL Query

```sql
SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
```

### Result

The query groups all orders by their fulfillment status (such as delivered, shipped, canceled, invoiced, unavailable, and processing). The uploaded output shows that **delivered** is the dominant order status, indicating that the vast majority of customer orders are successfully fulfilled.

### Business Insight

A high proportion of delivered orders reflects efficient logistics and strong operational performance. The presence of smaller numbers of canceled, unavailable, or invoiced orders highlights areas where inventory management or order processing can still be improved.

### Business Recommendation

- Reduce canceled and unavailable orders by improving inventory forecasting.
- Monitor fulfillment KPIs such as cancellation rate and delivery success rate.
- Strengthen coordination with logistics partners to maintain high delivery performance.

---

# Analysis 4 – Customer Distribution

## Business Question

**Where are most customers located?**

Understanding customer distribution helps identify the company's strongest markets and supports regional marketing, logistics, and expansion strategies.

---

## Customer Distribution by State

### SQL Query

```sql
SELECT

customer_state,

COUNT(*) AS customers

FROM customers

GROUP BY customer_state

ORDER BY customers DESC;
```

### Result

The query output shows that customers are spread across all Brazilian states, with **São Paulo (SP)** having the highest concentration of customers, followed by **Rio de Janeiro (RJ)** and **Minas Gerais (MG)**.

### Business Insight

The Southeast region dominates the customer base, indicating that this region represents the company's largest market.

### Business Recommendation

- Continue investing in marketing campaigns in high-performing states.
- Expand logistics capacity in the Southeast region.
- Identify opportunities to increase customer acquisition in lower-performing states.

---

## Top Customer Cities

### SQL Query

```sql
SELECT

customer_city,

COUNT(*) AS customers

FROM customers

GROUP BY customer_city

ORDER BY customers DESC

LIMIT 20;
```

### Result

| City | Customers |
|------|----------:|
| São Paulo | 15,540 |
| Rio de Janeiro | 6,882 |
| Belo Horizonte | 2,773 |
| Brasília | 2,131 |
| Curitiba | 1,521 |
| Campinas | 1,444 |
| Porto Alegre | 1,379 |
| Salvador | 1,245 |
| Guarulhos | 1,189 |
| São Bernardo do Campo | 938 |
| Niterói | 849 |
| Santo André | 797 |
| Osasco | 746 |
| Santos | 713 |
| Goiânia | 692 |
| São José dos Campos | 691 |
| Fortaleza | 654 |
| Sorocaba | 633 |
| Recife | 613 |
| Florianópolis | 570 |

### Business Insight

São Paulo alone has more than twice as many customers as Rio de Janeiro, making it the company's primary market. Most of the top cities are large metropolitan areas with strong purchasing power.

### Business Recommendation

- Prioritize inventory placement near major metropolitan areas.
- Launch city-specific promotions for top-performing markets.
- Develop regional campaigns to increase market penetration in emerging cities.

---

# Analysis 5 – Payment Behavior

## Business Question

**Which payment methods are most popular?**

Understanding payment behavior helps improve checkout experience and optimize payment processing costs.

---

## Payment Method Analysis

### SQL Query

```sql
SELECT

payment_type,

COUNT(*) AS transactions,

ROUND(SUM(payment_value),2) AS revenue

FROM payments

GROUP BY payment_type

ORDER BY revenue DESC;
```

### Result

The uploaded output indicates that **credit cards generate the highest number of transactions and revenue**, making them the dominant payment method. Other payment methods such as boleto, vouchers, and debit cards contribute significantly less.

### Business Insight

Customers strongly prefer paying with credit cards, suggesting they value installment options and payment convenience.

### Business Recommendation

- Continue optimizing the credit card checkout experience.
- Negotiate lower transaction fees with payment providers.
- Encourage alternative payment methods where transaction costs are lower.

---

## Payment Installments

### SQL Query

```sql
SELECT

payment_installments,

COUNT(*) AS transactions

FROM payments

GROUP BY payment_installments

ORDER BY payment_installments;
```

### Result

| Installments | Transactions |
|--------------|------------:|
| 1 | 52,546 |
| 2 | 12,413 |
| 3 | 10,461 |
| 4 | 7,098 |
| 5 | 5,239 |
| 6 | 3,920 |
| 7 | 1,626 |
| 8 | 4,268 |
| 9 | 644 |
| 10 | 5,328 |
| 11–24 | Very low transaction volume |

### Business Insight

Most customers prefer paying in a single installment. Multi-installment purchases remain common, especially between two and ten installments, indicating that financing options play an important role in customer purchasing decisions.

### Business Recommendation

- Continue offering installment plans.
- Evaluate profitability of long-term installment options.
- Promote interest-free installment campaigns for high-value products.

---

# Analysis 6 – Product Performance

## Business Question

**Which products generate the highest revenue?**

Product performance analysis identifies the company's highest-value products and helps optimize inventory and merchandising strategies.

---

## Highest Revenue Products

### SQL Query

```sql
SELECT

product_id,

COUNT(*) AS quantity_sold,

ROUND(SUM(price),2) AS revenue

FROM order_items

GROUP BY product_id

ORDER BY revenue DESC

LIMIT 20;
```

### Result

| Product ID | Quantity Sold | Revenue |
|------------|--------------:|--------:|
| bb50f2e236e5eea0100680137654686c | 195 | 63,885.00 |
| 6cdd53843498f92890544667809f1595 | 156 | 54,730.20 |
| d6160fb7873f184099d9bc95e30376af | 35 | 48,899.34 |
| d1c427060a0f73f6b889a5c7c61f2ac4 | 343 | 47,214.51 |
| 99a4788cb24856965c36a24e339b6058 | 488 | 43,025.56 |
| 3dd2a17168ec895c781a9191c1e95ad7 | 274 | 41,082.60 |
| 25c38557cf793876c5abdd5931f922db | 38 | 38,907.32 |
| 5f504b3a1c75b73d6151be81eb05bdc9 | 63 | 37,733.90 |
| 53b36df67ebb7c41585e8d54d6772e08 | 323 | 37,683.42 |
| aca2eb7d00ea1a7b8ebd4e68314663af | 527 | 37,608.90 |

### Business Insight

The highest-revenue products are not always the highest-selling products. Some premium-priced items generate substantial revenue despite lower sales volume, while certain frequently purchased products achieve high revenue through sales volume.

### Business Recommendation

- Maintain sufficient inventory for top-performing products.
- Feature high-revenue products in promotional campaigns.
- Bundle complementary products with best sellers to increase Average Order Value.

---

# Analysis 7 – Customer Lifetime Value (CLV)

## Business Question

**Who are the company's most valuable customers?**

Customer Lifetime Value (CLV) measures the total revenue generated by each customer across all purchases. Identifying high-value customers helps businesses improve retention strategies and maximize long-term profitability.

---

## SQL Query

```sql
SELECT

o.customer_id,

ROUND(SUM(p.payment_value),2) AS lifetime_value

FROM orders o

JOIN payments p
ON o.order_id = p.order_id

GROUP BY o.customer_id

ORDER BY lifetime_value DESC

LIMIT 20;
```

### Result

| Customer ID | Lifetime Value |
|-------------|---------------:|
| 1617b1357756262bfa56ab541c47bc16 | 13,664.08 |
| ec5b2ba62e574342386871631fafd3fc | 7,274.88 |
| c6e2731c5b391845f6800c97401a43a9 | 6,929.31 |
| f48d464a0baaea338cb25f816991ab1f | 6,922.21 |
| 3fd6777bbce08a352fddd04e4a7cc8f6 | 6,726.66 |
| 05455dfa7cd02f13d132aa7a6a9729c6 | 6,081.54 |
| df55c14d1476a9a3467f131269c2477f | 4,950.34 |
| e0a2412720e9ea4f26c1ac985f6a7358 | 4,809.44 |
| 24bbf5fd2f2e1b359ee7de94defc4a15 | 4,764.34 |
| 3d979689f636322c62418b6346b1c6d2 | 4,681.78 |

*(Top 20 customers returned by the query.)*

---

## Business Insight

A relatively small group of customers contributes significantly more revenue than the average customer. The highest-value customer generated **13,664.08**, nearly double the spending of the second-highest customer.

This indicates that customer spending is unevenly distributed, making customer retention particularly valuable for high-spending customers.

---

## Business Recommendation

- Introduce a loyalty or VIP rewards program for top customers.
- Provide personalized product recommendations based on purchase history.
- Offer exclusive discounts and early access to new products.
- Monitor CLV regularly to identify high-value customers before they become inactive.

---

# Analysis 8 – Repeat Customers

## Business Question

**How many customers purchased more than once?**

Repeat customers are an important indicator of customer satisfaction, loyalty, and long-term business sustainability.

---

## SQL Query (Customers with Multiple Orders)

```sql
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;
```

### Result (Top Repeat Customers)

| Customer Unique ID | Total Orders |
|--------------------|------------:|
| 8d50f5eadf50201ccdcedfb9e2ac8455 | 17 |
| 3e43e6105506432c953e165fb2acf44c | 9 |
| 1b6c7548a2a1f9037c1fd3ddfed95f33 | 7 |
| 6469f99c1f9dfae7733b25662e7f1782 | 7 |
| ca77025e7201e3b30c44b472ff346268 | 7 |
| f0e310a6839dce9de1638e0fe5ab282a | 6 |
| dc813062e0fc23409cd255f7f53c7074 | 6 |
| de34b16117594161a6a89c50b289d35a | 6 |
| 12f5d6e1cbf93dafd9dcc19095df0b3d | 6 |
| 47c1a3033b8b77b3ab6e109eb4d5fdf3 | 6 |

---

## SQL Query (Total Repeat Customers)

```sql
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT c.customer_unique_id
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS repeat;
```

### Result

| KPI | Value |
|------|------:|
| Repeat Customers | **2,997** |

---

## Business Insight

Out of nearly **99,441 unique customers**, only **2,997** made more than one purchase. This indicates that repeat customers represent a relatively small proportion of the customer base, suggesting that customer retention has significant room for improvement.

---

## Business Recommendation

- Implement customer loyalty programs.
- Send personalized follow-up emails after purchases.
- Offer discount coupons for second purchases.
- Create referral incentives to encourage repeat business.
- Analyze purchasing behavior of repeat customers to identify successful retention patterns.

---

# Analysis 9 – Delivery Performance

## Business Question

**How long does it take to deliver customer orders?**

Delivery performance is one of the most important operational metrics for e-commerce businesses because it directly influences customer satisfaction and review scores.

---

## SQL Query

```sql
SELECT
ROUND(
AVG(
EXTRACT(EPOCH FROM (
order_delivered_customer_date -
order_purchase_timestamp
)) / 86400
),
2
) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
```

### Result

| KPI | Value |
|------|------:|
| Average Delivery Time | **12.56 Days** |

The raw interval returned by PostgreSQL is:

**12 days 13:24:31.879068**

---

## Business Insight

The average delivery time of **12.56 days** indicates that customers generally wait nearly two weeks to receive their orders.

Considering Brazil's large geographic area and nationwide shipping network, this delivery performance is reasonable. However, reducing delivery times could significantly improve customer satisfaction and increase positive reviews.

---

## Business Recommendation

- Optimize warehouse placement closer to high-demand regions.
- Strengthen partnerships with logistics providers.
- Continuously monitor carrier performance.
- Prioritize faster shipping for repeat and high-value customers.
- Use predictive analytics to anticipate delivery delays during peak seasons.

---

# Analysis 10 – Customer Reviews

## Business Question

**How satisfied are customers with their shopping experience?**

Customer reviews provide valuable feedback on product quality, delivery performance, and overall shopping experience. Analyzing review scores helps identify strengths and opportunities for service improvement.

---

## Average Review Score

### SQL Query

```sql
SELECT

AVG(review_score)

FROM reviews;
```

### Result

| KPI | Value |
|------|------:|
| Average Review Score | **4.09 / 5.00** |

---

## Review Score Distribution

### SQL Query

```sql
SELECT

review_score,

COUNT(*)

FROM reviews

GROUP BY review_score

ORDER BY review_score;
```

### Result

| Review Score | Number of Reviews |
|--------------|-----------------:|
| 1 | 11,424 |
| 2 | 3,151 |
| 3 | 8,284 |
| 4 | 19,242 |
| 5 | 57,728 |

*(Values obtained from the uploaded SQL output.)*

---

## Business Insight

The average customer rating of **4.09 out of 5** indicates a generally positive shopping experience. More than half of all reviews received the maximum score of **5**, demonstrating strong customer satisfaction.

However, approximately **11,000 one-star reviews** indicate that a notable number of customers experienced significant issues, likely related to delivery delays, damaged products, incorrect items, or customer service.

---

## Business Recommendation

- Investigate common reasons behind one- and two-star reviews.
- Improve delivery communication and shipment tracking.
- Reduce product quality issues through stronger supplier quality control.
- Follow up with dissatisfied customers to improve retention.
- Use customer review analytics to identify recurring operational problems.

---

# Analysis 11 – Revenue by State

## Business Question

**Which Brazilian states generate the highest revenue?**

Understanding regional revenue distribution helps prioritize marketing investments, logistics infrastructure, and expansion strategies.

---

## SQL Query

```sql
SELECT

c.customer_state,

ROUND(

SUM(p.payment_value),

2

) AS revenue

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN payments p
ON o.order_id = p.order_id

GROUP BY customer_state

ORDER BY revenue DESC;
```

### Result

| State | Revenue |
|--------|---------:|
| SP | Highest Revenue |
| RJ | Second Highest |
| MG | Third Highest |
| RS | Top Performing |
| PR | Top Performing |

*The uploaded SQL output shows São Paulo (SP) as the largest revenue-generating state, followed by Rio de Janeiro (RJ) and Minas Gerais (MG).*

---

## Business Insight

Revenue is heavily concentrated in Brazil's Southeast region, which aligns with the customer distribution analysis. These states represent the company's primary markets and should remain strategic priorities for future growth.

---

## Business Recommendation

- Increase inventory capacity in top-performing states.
- Open additional fulfillment centers near high-demand regions.
- Develop localized marketing campaigns for major metropolitan areas.
- Identify lower-performing regions with growth potential and targeted promotions.

---

# Analysis 12 – Executive KPI Dashboard

## Business Question

**What are the key business performance indicators in a single executive summary?**

The Executive KPI Dashboard combines the most important metrics into a concise overview suitable for business leaders.

---

## SQL Query

```sql
SELECT

(SELECT ROUND(SUM(payment_value),2) FROM payments) AS revenue,

(SELECT COUNT(*) FROM orders) AS orders,

(SELECT COUNT(*) FROM customers) AS customers,

(SELECT ROUND(AVG(payment_value),2) FROM payments) AS avg_payment;
```

### Result

| KPI | Value |
|------|-------:|
| Total Revenue | **16,008,872.12** |
| Total Orders | **99,441** |
| Total Customers | **99,441** |
| Average Payment | **154.10** |

---

## Business Insight

The executive dashboard provides a concise snapshot of overall business performance:

- Over **16 million** in total revenue generated.
- Nearly **100,000 completed orders**.
- A customer base of almost **100,000 unique customers**.
- An average payment value of approximately **154** per transaction.

These KPIs indicate a healthy and established e-commerce business with consistent customer demand and substantial transaction volume.

---

## Business Recommendation

Business leaders should monitor these KPIs monthly and integrate them into interactive dashboards using Power BI or Tableau. Regular KPI reviews can support data-driven decision-making and enable proactive responses to changing business conditions.

---

# Executive Summary

The SQL analysis of the **Brazilian E-Commerce Public Dataset by Olist** provides valuable insights into customer behavior, sales performance, logistics, and operational efficiency.

### Key Findings

| Business Area | Key Insight |
|---------------|-------------|
| Revenue | Generated over **16 million** in total sales revenue. |
| Customers | Approximately **99,441** customers placed orders during the analysis period. |
| Orders | Nearly **100,000** orders were successfully processed. |
| Average Order Value | Customers spend approximately **160.99** per order. |
| Revenue Trend | Revenue experienced significant growth throughout 2017 and early 2018. |
| Customer Geography | São Paulo dominates both customer count and revenue. |
| Payment Behavior | Credit cards are the preferred payment method. |
| Product Performance | A small number of products generate a substantial share of total revenue. |
| Customer Loyalty | Only **2,997** customers made repeat purchases, highlighting opportunities for retention. |
| Delivery Performance | Average delivery time is **12.56 days**. |
| Customer Satisfaction | Average review score is **4.09 / 5**, indicating generally positive customer experiences. |

---

# Overall Business Recommendations

Based on the SQL analysis, the following strategic recommendations are proposed:

### 1. Improve Customer Retention

- Launch customer loyalty programs.
- Offer personalized product recommendations.
- Encourage repeat purchases through targeted promotions.

---

### 2. Increase Average Order Value

- Introduce product bundles.
- Promote complementary products.
- Implement free-shipping thresholds.

---

### 3. Enhance Logistics Performance

- Reduce delivery times by optimizing warehouse locations.
- Strengthen partnerships with logistics providers.
- Monitor carrier performance using delivery KPIs.

---

### 4. Optimize Regional Strategy

- Continue investing in high-performing states such as São Paulo, Rio de Janeiro, and Minas Gerais.
- Expand marketing efforts into emerging regions with growth potential.

---

### 5. Improve Customer Satisfaction

- Analyze low-rated reviews to identify recurring issues.
- Enhance customer support responsiveness.
- Improve supplier quality management.

---

### 6. Develop Interactive Business Dashboards

Transform the SQL analyses into Power BI dashboards featuring:

- Revenue trends
- Customer segmentation
- Geographic sales analysis
- Product performance
- Delivery performance
- Executive KPI dashboard

These dashboards will enable real-time monitoring and support informed business decisions.

---

# Conclusion

This project demonstrates how SQL can be used to transform raw transactional data into actionable business intelligence. Through a series of analytical queries, key performance indicators were calculated to evaluate sales performance, customer behavior, product success, payment preferences, logistics efficiency, and customer satisfaction.

The findings reveal a growing e-commerce business with strong revenue generation, high customer satisfaction, and efficient order fulfillment. At the same time, the analysis highlights opportunities to improve customer retention, optimize delivery operations, and increase average order value.

By leveraging SQL for business analysis, organizations can uncover meaningful insights that support strategic planning, operational improvements, and data-driven decision-making. This project serves as a practical example of applying PostgreSQL to solve real-world business problems using the **Brazilian E-Commerce Public Dataset by Olist**.