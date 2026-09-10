# Advanced SQL Findings

## Brazilian E-Commerce Analytics — Olist Dataset

This report documents advanced SQL analysis performed on the **Brazilian E-Commerce Public Dataset by Olist**.

The analysis uses PostgreSQL to investigate customer value, purchasing behavior, customer segmentation, customer lifetime value, acquisition trends, revenue growth, product performance, delivery performance, customer satisfaction, reusable SQL views, and an executive analytics data mart.

---

# Part 1 — RFM Analysis

RFM analysis evaluates customers using three dimensions:

- **Monetary Value** — how much the customer spends.
- **Frequency** — how often the customer orders.
- **Recency** — how recently the customer purchased.

These three metrics help identify valuable customers and support targeted marketing strategies.

---

## 1.1 Monetary Value

### Business Question

**Who spends the most money?**

### SQL Query

```sql
SELECT
    o.customer_id,
    ROUND(SUM(p.payment_value), 2) AS monetary_value
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY monetary_value DESC;
```

### Result

The query returned **99,440 customer records**.

The top customers by monetary value were:

| Rank | Customer ID | Monetary Value |
|---:|---|---:|
| 1 | `1617b1357756262bfa56ab541c47bc16` | 13,664.08 |
| 2 | `ec5b2ba62e574342386871631fafd3fc` | 7,274.88 |
| 3 | `c6e2731c5b391845f6800c97401a43a9` | 6,929.31 |
| 4 | `f48d464a0baaea338cb25f816991ab1f` | 6,922.21 |
| 5 | `3fd6777bbce08a352fddd04e4a7cc8f6` | 6,726.66 |
| 6 | `05455dfa7cd02f13d132aa7a6a9729c6` | 6,081.54 |
| 7 | `df55c14d1476a9a3467f131269c2477f` | 4,950.34 |
| 8 | `e0a2412720e9ea4f26c1ac985f6a7358` | 4,809.44 |
| 9 | `24bbf5fd2f2e1b359ee7de94defc4a15` | 4,764.34 |
| 10 | `3d979689f636322c62418b6346b1c6d2` | 4,681.78 |

The lowest values shown in the output were approximately **9.59–12.39**.

### Finding

Customer monetary value is highly uneven. The highest-spending customer generated **13,664.08**, while customers at the bottom of the output generated less than **13**.

### Insight

A relatively small group of customers has substantially higher monetary value than the majority of the customer base. These customers represent an important revenue opportunity and should receive differentiated treatment.

### Recommendation

- Create a VIP customer program.
- Offer exclusive discounts to high-value customers.
- Provide personalized product recommendations.
- Prioritize high-value customers in retention campaigns.
- Monitor monetary value periodically to identify customers whose spending is increasing or declining.

---

# 1.2 Frequency

### Business Question

**Who orders most often?**

### SQL Query

```sql
SELECT
    customer_id,
    COUNT(order_id) AS frequency
FROM orders
GROUP BY customer_id
ORDER BY frequency DESC;
```

### Result

The query returned **99,441 customer records**.

The displayed beginning and end of the result both contain customers with a frequency of **1 order**.

### Finding

The output demonstrates that a very large number of customers placed only one order.

This is important because the customer base contains many one-time purchasers rather than customers who repeatedly purchase.

### Insight

Low purchasing frequency represents a significant customer-retention opportunity. Increasing the number of customers who make a second purchase could substantially increase customer lifetime value.

### Recommendation

- Create second-purchase campaigns.
- Send personalized follow-up offers after an order.
- Provide loyalty points for repeat purchases.
- Recommend complementary products based on previous purchases.
- Measure the conversion rate from first purchase to second purchase.

---

# 1.3 Recency

### Business Question

**How recently did the customer purchase?**

### SQL Query

```sql
SELECT
    customer_id,
    MAX(order_purchase_timestamp) AS last_purchase
FROM orders
GROUP BY customer_id
ORDER BY last_purchase DESC;
```

### Result

The most recent customer purchase shown in the output occurred on:

**2018-10-17 17:30:18**

The oldest purchase shown occurred on:

**2016-09-15 12:16:38**.

### Finding

Customer purchase activity spans from September 2016 through October 2018.

The output shows that some customers purchased very recently relative to the end of the dataset, while others have not purchased since the early period of the dataset.

### Insight

Recency can be used to separate recently active customers from customers who may be at risk of becoming inactive.

### Recommendation

- Target recently active customers with cross-sell offers.
- Create reactivation campaigns for customers with long periods since their last purchase.
- Combine recency with frequency and monetary value to build an RFM segmentation model.
- Monitor inactive customers before they become permanently lost.

---

# Part 2 — Customer Segmentation

## Business Question

**How can customers be grouped into meaningful business segments?**

Instead of treating all customers equally, customers can be divided into groups based on their total spending.

### SQL Query

```sql
SELECT
    customer_id,
    SUM(payment_value) AS spending,
    CASE
        WHEN SUM(payment_value) >= 1000 THEN 'VIP'
        WHEN SUM(payment_value) >= 500 THEN 'Premium'
        ELSE 'Regular'
    END AS customer_segment
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY customer_id;
```

### Result

The query returned **99,440 customer records**.

Examples from the output include:

| Customer ID | Spending | Segment |
|---|---:|---|
| `09033cfedb9bab5c54a33f339fd94ad0` | 115.86 | Regular |
| `9e2652c3469d9367573a7659b60a44a1` | 215.15 | Regular |
| `42d4a2e8a460728da550948367a9f2d9` | 207.20 | Regular |
| `553116a8650fecf9e64790c28a2aa2ae` | 816.36 | Premium |
| `ee293069056334e9b2076d69f4dfc367` | 1,306.26 | VIP |
| `02385ca219b24812b4c7c65818e3b06a` | 1,020.84 | VIP |
| `daf15f1b940cc6a72ba558f093dc00dd` | 1,246.97 | VIP |
| `71583bf590a19d9a0c2073d705b73c7d` | 1,228.03 | VIP |
| `8c699d5d2606b7cbfe0e3a8bbf1a3fec` | 722.05 | Premium |
| `9708a89477034ec963ec539e031e57b8` | 688.44 | Premium |

The output contains examples from all three segments: **Regular, Premium, and VIP**.

### Finding

Customers can be divided into three spending groups:

| Segment | Spending Threshold | Business Role |
|---|---:|---|
| VIP | ≥ 1,000 | Highest-value customers |
| Premium | 500–999.99 | High-potential customers |
| Regular | < 500 | Main customer base |

### Insight

The segmentation creates a practical framework for differentiated marketing. Customers spending more than 1,000 can be treated differently from customers spending less than 500.

### Recommendation

| Segment | Recommended Action |
|---|---|
| **VIP** | Exclusive offers, priority support, early access |
| **Premium** | Loyalty rewards, upselling, personalized promotions |
| **Regular** | Email campaigns, cross-selling, second-purchase incentives |

The company should also monitor customers moving between segments over time.

---

# Part 3 — Customer Lifetime Value

## Business Question

**How much revenue does each customer generate?**

Customer Lifetime Value analysis combines customer identity, order frequency, total revenue, and average order value.

### SQL Query

```sql
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS revenue,
    ROUND(
        SUM(p.payment_value) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC;
```

### Result

The query returned **96,095 customer records**.

The highest-revenue customers in the displayed output included:

| Rank | Customer Unique ID | Total Orders | Revenue | Average Order |
|---:|---|---:|---:|---:|
| 1 | `0a0a92112bd4c708ca5fde585afaa872` | 1 | 13,664.08 | 13,664.08 |
| 2 | `46450c74a0d8c5ca9395da1daac6c120` | 3 | 9,553.02 | 3,184.34 |
| 3 | `da122df9eeddfedc1dc1f5349a1a690c` | 2 | 7,571.63 | 3,785.82 |
| 4 | `763c8b1c9c68a0229c42c9fc6f662b93` | 1 | 7,274.88 | 7,274.88 |
| 5 | `dc4802a71eae9be1dd28f5d788ceb526` | 1 | 6,929.31 | 6,929.31 |
| 6 | `459bef486812aa25204be022145caa62` | 1 | 6,922.21 | 6,922.21 |
| 7 | `ff4159b92c40ebe40454e3e6a7c35ed6` | 1 | 6,726.66 | 6,726.66 |
| 8 | `4007669dec559734d6f53e029e360987` | 1 | 6,081.54 | 6,081.54 |
| 9 | `5d0a2980b292d049061542014e8960bf` | 1 | 4,809.44 | 4,809.44 |
| 10 | `eebb5dda148d3893cdaf5b5ca3040ccb` | 1 | 4,764.34 | 4,764.34 |

The lowest values displayed were approximately **10.07–13.36**.

### Finding

Customer revenue varies substantially. The highest customer revenue is **13,664.08**, while many customers generate only a small amount of revenue.

The analysis also demonstrates that high lifetime revenue can come from either:

- A high-value single order, or
- Multiple purchases over time.

For example, the second-highest customer generated **9,553.02 across three orders**, with an average order value of **3,184.34**.

### Insight

Customer Lifetime Value provides a more useful view of customer importance than looking only at individual transactions. Customers who repeatedly purchase can become particularly valuable over the long term.

### Recommendation

- Identify high-CLV customers for retention programs.
- Create personalized offers for customers with high lifetime revenue.
- Encourage high-value one-time purchasers to make additional purchases.
- Use CLV together with RFM metrics for advanced customer segmentation.
- Track changes in CLV over time to measure retention effectiveness.

---

# Part 4 — Monthly New Customers

## Business Question

**How many new customers joined every month?**

New customer acquisition was calculated by identifying each customer's first purchase date and grouping those first purchases by month.

### SQL Query

```sql
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_purchase_timestamp) AS first_order
    FROM orders
    GROUP BY customer_id
)
SELECT
    DATE_TRUNC('month', first_order) AS month,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY month
ORDER BY month;
```

### Result

| Month | New Customers |
|---|---:|
| Sep 2016 | 4 |
| Oct 2016 | 324 |
| Dec 2016 | 1 |
| Jan 2017 | 800 |
| Feb 2017 | 1,780 |
| Mar 2017 | 2,682 |
| Apr 2017 | 2,404 |
| May 2017 | 3,700 |
| Jun 2017 | 3,245 |
| Jul 2017 | 4,026 |
| Aug 2017 | 4,331 |
| Sep 2017 | 4,285 |
| Oct 2017 | 4,631 |
| Nov 2017 | **7,544** |
| Dec 2017 | 5,673 |
| Jan 2018 | 7,269 |
| Feb 2018 | 6,728 |
| Mar 2018 | 7,211 |
| Apr 2018 | 6,939 |
| May 2018 | 6,873 |
| Jun 2018 | 6,167 |
| Jul 2018 | 6,292 |
| Aug 2018 | 6,512 |
| Sep 2018 | 16 |
| Oct 2018 | 4 |

### Finding

Customer acquisition increased significantly from 2017 onward.

The strongest acquisition month in the available output was **November 2017**, with **7,544 new customers**.

Customer acquisition remained strong throughout the first eight months of 2018, with more than **6,000 new customers in most months**.

The extremely low numbers in September and October 2018 indicate that the dataset likely ends partway through October rather than representing a complete month.

### Insight

The business experienced substantial customer acquisition growth between 2017 and 2018. November 2017 was particularly strong, which may indicate the impact of seasonal shopping and promotional activity.

### Recommendation

- Investigate the campaigns and promotions associated with November 2017.
- Replicate successful acquisition strategies during future peak shopping periods.
- Measure customer acquisition cost against new-customer revenue.
- Track whether newly acquired customers return for a second purchase.
- Avoid interpreting September and October 2018 as complete-month declines because the dataset ends during this period.

---

# Part 5 — Monthly Active Customers

## Business Question

**How many customers are actively purchasing each month?**

Monthly active customers help measure customer engagement and show how the active customer base changes over time.

### SQL Query

```sql
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT c.customer_unique_id) AS active_customers
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY month
ORDER BY month;
```

### Result

The query calculates the number of unique customers who placed at least one order during each month.

The analysis shows a substantial increase in active customers as the business expanded through 2017 and 2018.

### Finding

The active customer base generally increased over the observed period, reflecting the overall growth of the e-commerce platform.

The strongest activity occurred during the later months of 2017 and throughout much of 2018.

### Insight

Growing monthly active customers indicate increasing customer engagement and market reach.

However, increasing active customers does not necessarily mean strong customer retention. The business should compare monthly active customers with new customers and repeat customers to understand whether growth comes primarily from acquisition or retention.

### Recommendation

- Track Monthly Active Customers (MAC) as a recurring KPI.
- Compare active customers with new customer acquisition.
- Monitor repeat-purchase rates alongside active customers.
- Identify months where customer activity decreases and investigate possible causes.
- Develop retention campaigns to convert active one-time customers into repeat buyers.

---

# Part 6 — Revenue Growth Analysis

## Business Question

**How is monthly revenue changing over time?**

Revenue growth analysis helps determine whether the company is expanding, stagnating, or experiencing periods of decline.

### SQL Query

```sql
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY month)
        )
        /
        NULLIF(
            LAG(revenue) OVER (ORDER BY month),
            0
        )
        * 100,
        2
    ) AS revenue_growth_pct
FROM monthly_revenue
ORDER BY month;
```

### Result

The query produces monthly revenue together with the percentage change compared with the previous month.

The revenue trend shows strong growth from 2017 into 2018, with monthly revenue reaching more than **1 million** during several months in 2018.

The final months in the dataset show a sharp decrease because the available 2018 data ends partway through the period.

### Finding

Revenue demonstrates a strong overall upward trend during the main observation period.

The largest revenue levels occur during late 2017 and the first half of 2018.

The apparent decline near the end of the dataset should not automatically be interpreted as a business collapse because the final months contain incomplete data.

### Insight

The company experienced substantial revenue growth as the platform expanded its customer base and transaction volume.

The month-over-month growth calculation also provides a useful way to identify unusually strong or weak periods.

### Recommendation

- Monitor month-over-month revenue growth.
- Investigate major positive and negative changes.
- Use historical growth patterns for revenue forecasting.
- Prepare inventory and logistics capacity before high-revenue periods.
- Treat partial final months separately when evaluating performance.

---

# Part 7 — Product Ranking Using Window Functions

## Business Question

**Which products generate the highest revenue within their categories?**

Ranking products within categories allows management to identify category leaders rather than looking only at overall product revenue.

### SQL Query

```sql
WITH product_revenue AS (
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        oi.product_id
)
SELECT
    product_category_name,
    product_id,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (
        PARTITION BY product_category_name
        ORDER BY revenue DESC
    ) AS product_rank
FROM product_revenue
ORDER BY
    product_category_name,
    product_rank;
```

### Result

The query ranks products separately within each product category according to their revenue.

Products are assigned a rank beginning with **1** for the highest-revenue product within each category.

### Finding

Product performance differs considerably across categories. A product that is highly successful within one category cannot necessarily be compared directly with products from another category.

The window function makes it possible to identify category-specific leaders.

### Insight

Category-level ranking provides more actionable information than a simple global ranking.

For example, category managers can determine which products are responsible for the strongest sales performance within their individual categories.

### Recommendation

- Keep high-ranking products consistently available.
- Promote category-leading products.
- Use category rankings to guide inventory allocation.
- Investigate low-ranking products for pricing, quality, or demand issues.
- Combine product rankings with customer reviews to identify products that are both popular and highly rated.

---

# Part 8 — Top Products by Category

## Business Question

**What are the top-performing products in each product category?**

This analysis extends product ranking by identifying the highest-performing products within each category.

### SQL Query

```sql
WITH product_sales AS (
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        oi.product_id
),
ranked_products AS (
    SELECT
        product_category_name,
        product_id,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY product_category_name
            ORDER BY revenue DESC
        ) AS rn
    FROM product_sales
)
SELECT
    product_category_name,
    product_id,
    ROUND(revenue, 2) AS revenue
FROM ranked_products
WHERE rn <= 3
ORDER BY
    product_category_name,
    revenue DESC;
```

### Result

The query returns the **top three revenue-generating products within each product category**.

The result allows each category to be analyzed independently and prevents the largest categories from dominating the analysis.

### Finding

Each product category has a small group of products that contributes disproportionately to category revenue.

### Insight

A category's overall performance may depend heavily on a limited number of products. Maintaining availability of these products is therefore important for protecting category-level revenue.

### Recommendation

- Maintain safety stock for category-leading products.
- Feature top products prominently on the marketplace.
- Use category leaders in advertising campaigns.
- Analyze whether top products can be bundled with lower-performing products.
- Monitor product ranking regularly because rankings can change over time.

---

# Part 9 — Customer Ranking by Revenue

## Business Question

**Which customers rank highest based on their total spending?**

Ranking customers makes it easier to identify the most valuable customers and prioritize retention activities.

### SQL Query

```sql
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS customer_rank
FROM customer_revenue
ORDER BY customer_rank;
```

### Result

Customers are ranked from highest to lowest according to total revenue generated.

The highest-ranking customer generated approximately **13,664.08** in revenue.

### Finding

Customer revenue is highly concentrated, with a small number of customers generating substantially more revenue than the majority.

### Insight

Ranking customers allows the company to identify its most financially important relationships.

The ranking can be combined with customer recency and purchase frequency to create a more complete customer-value framework.

### Recommendation

- Create VIP treatment for the highest-ranked customers.
- Offer personalized recommendations.
- Monitor changes in customer ranking.
- Develop retention campaigns for high-value customers showing declining activity.
- Combine customer ranking with RFM segmentation.

---

# Part 10 — Running Revenue / Cumulative Revenue

## Business Question

**How does cumulative revenue grow over time?**

Cumulative revenue shows how much total revenue has been generated up to each point in time.

### SQL Query

```sql
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;
```

### Result

The query returns two measures for every month:

- Monthly revenue
- Cumulative revenue

The cumulative value increases as additional monthly revenue is added to the total.

### Finding

Cumulative revenue demonstrates the strong long-term growth of the business across the dataset period.

As monthly sales increased through 2017 and 2018, cumulative revenue accelerated accordingly.

### Insight

Cumulative revenue is particularly useful for management because it provides a long-term view of business performance rather than focusing only on individual months.

### Recommendation

- Use cumulative revenue in executive dashboards.
- Compare actual cumulative revenue against annual targets.
- Monitor the rate at which cumulative revenue is increasing.
- Combine cumulative revenue with customer acquisition and order growth metrics.

---

# Part 11 — Advanced Customer Spending Analysis

## Business Question

**How are customers distributed according to their spending level?**

Customer spending distribution helps identify the size of different customer-value groups.

### SQL Query

```sql
SELECT
    customer_id,
    SUM(payment_value) AS total_spending,
    CASE
        WHEN SUM(payment_value) >= 1000 THEN 'VIP'
        WHEN SUM(payment_value) >= 500 THEN 'Premium'
        ELSE 'Regular'
    END AS customer_segment
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY customer_id
ORDER BY total_spending DESC;
```

### Result

Customers are divided into three spending segments:

| Segment | Spending |
|---|---:|
| VIP | ≥ 1,000 |
| Premium | 500–999.99 |
| Regular | < 500 |

The output contains customers belonging to all three segments.

### Finding

Most customers fall into the Regular segment, while a smaller group qualifies as Premium or VIP based on total spending.

### Insight

The segmentation demonstrates that customer value is not evenly distributed. Treating every customer identically would therefore result in missed opportunities for targeted marketing.

### Recommendation

Use differentiated strategies:

- **VIP:** Retention and exclusive benefits.
- **Premium:** Upselling and loyalty incentives.
- **Regular:** Acquisition-to-retention campaigns and second-purchase offers.

The company should periodically recalculate segments so that customers can move between categories as their purchasing behavior changes.

---

# Summary

The first four parts of the advanced SQL analysis demonstrate how customer-level data can be transformed into actionable marketing intelligence. The advanced SQL analysis from Part 5 to 11 focuses on **customer activity, revenue growth, and analytical ranking**.


### Key Findings

1. **Customer monetary value varies significantly**, with the highest customer generating 13,664.08.
2. **Purchase frequency is generally low**, with the displayed frequency results dominated by customers with one order.
3. **Customer recency spans a broad period**, from September 2016 through October 2018.
4. **Customer segmentation** provides three actionable groups: Regular, Premium, and VIP.
5. **Customer Lifetime Value varies substantially**, highlighting the importance of retaining high-value customers.
6. **New customer acquisition accelerated significantly during 2017 and 2018**, reaching a peak of 7,544 new customers in November 2017.
7. The combination of **Recency, Frequency, and Monetary Value** provides a strong foundation for an RFM-based customer strategy.
8. Monthly active customer activity increased as the marketplace expanded.
9. Revenue showed strong growth through 2017 and into 2018.
10. Window functions allow products to be ranked within their individual categories.
11. Category-level product rankings provide more actionable information than global rankings.
12. Customer revenue rankings identify a relatively small group of high-value customers.
13. Cumulative revenue provides a clear view of long-term business growth.
14. Spending-based customer segmentation enables differentiated marketing strategies.

### Overall Business Implication

These findings can be used to build targeted marketing campaigns, improve customer retention, increase customer lifetime value, and prioritize high-value customer relationships.The analysis demonstrates how advanced SQL techniques such as **CTEs, CASE expressions, window functions, ranking, aggregation, and cumulative calculations** can transform transactional data into practical business intelligence.

These techniques can support:

- Customer retention
- Revenue forecasting
- Product management
- Inventory planning
- Personalized marketing
- Executive reporting
