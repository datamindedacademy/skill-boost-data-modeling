# Training Questions and Exercises

This directory contains business questions to answer using each modeling technique. The goal is to experience how each approach affects query complexity, readability, and maintainability.

## How to Use This Guide

1. Set up all three dbt projects (dimensional-modeling, data-vault-20, one-big-table) if you haven't already
2. For each question below, write SQL queries using each modeling technique
3. Compare your experience across the three approaches

## Business Questions

### Question 1: Revenue by Region
**Business Need**: What is the total revenue for each customer region, and how many orders does each region have?

**Key learning**: Introduction to all three query patterns — star schema joins, Data Vault hub/link/satellite navigation, and OBT flat queries.

**What to consider**:
- How many tables do you need to query?
- How many joins are required?
- Is the query easy to understand?

**Hints**:
- Dimensional: Use `fact_line_item` joined with `dim_customer`
- Data Vault: Join through hubs, links, and satellites to reach customer geography
- OBT: Query `obt_orders` directly

---

### Question 2: Multi-Dimensional Slice
**Business Need**: Analyze revenue by customer market segment, product brand, and order quarter for 1995. Include order count and average discount rate.

**Key learning**: How join complexity scales when slicing by multiple dimensions — star schema stays linear (1 join per dimension), Data Vault grows rapidly, OBT stays flat.

**What to consider**:
- How many dimensions are involved?
- How complex is the SQL?
- How would you add another dimension (e.g., supplier region)?

---

### Question 3: Shipping Performance
**Business Need**: Calculate the percentage of late shipments by ship mode. A shipment is late if ship_date > commit_date.

**Key learning**: What happens when your model didn't anticipate a question? The dimensional model is missing `commit_date` and must fall back to raw tables. Data Vault preserves all source attributes by default.

**What to consider**:
- Where is the shipping data located?
- Does your model have all the columns you need, or do you need to go back to the source?
- How easy is it to calculate lateness?

**Hints**:
- OBT has `delivery_status` pre-calculated
- Dimensional model may need to fall back to the raw `lineitem` table
- Data Vault's `sat_lineitem` preserves all source fields

---

### Question 4: Ad-Hoc Question (New Requirement!)
**Business Need**: The business just asked: "Show me revenue by customer region and supplier region to understand trade flows."

**Key learning**: How easily each model adapts to new, unanticipated requirements. OBT handles it trivially if the column exists — but needs a full rebuild if it doesn't. Dimensional and Data Vault require new joins but no structural changes.

**What to consider**:
- How easy is it to answer this NEW question?
- Do you need to modify your model?
- How would you add this to a dashboard?

This tests the flexibility of each approach!

---

### Question 5: Multi-Source Integration
**Business Need**: The CRM team has shared customer loyalty data. Show total revenue and order count by loyalty tier (Bronze, Silver, Gold, Platinum).

**Key learning**: How each model integrates a second data source. Data Vault's hub pattern deduplicates keys from multiple sources naturally. Dimensional modeling folds it into the existing dimension. OBT pre-joins everything during ETL.

**What to consider**:
- How does each model integrate the CRM data alongside the TPC-H order data?
- How do you handle customers that don't have CRM records?
- In the Data Vault, notice how `hub_customer` integrates keys from both sources, and each source has its own satellite (`sat_customer` for TPC-H, `sat_customer_crm` for CRM)

**Hints**:
- Dimensional: Query `dim_customer` (which now includes CRM fields) joined with `fact_line_item`. Use `is_current = true` for the current loyalty tier.
- Data Vault: Join through `hub_customer` to `sat_customer_crm`, taking the latest record per customer (highest `load_date`)
- OBT: Query `obt_orders` using `customer_current_loyalty_tier`

---

### Question 6: Slowly Changing Dimensions (SCD Type 2)
**Business Need**: Some customers changed loyalty tiers during the period. Show total revenue earned while customers were in each loyalty tier. Each order should be attributed to the tier the customer held **at the time of the order**.

**Key learning**: How each model handles historical attribute changes. OBT hides complexity in ETL (trivial to query). Dimensional modeling exposes SCD2 to the analyst (moderate complexity). Data Vault requires point-in-time joins through hub-satellite navigation (most complex query).

**What to consider**:
- How does each model handle historical attribute changes?
- Does the query naturally account for the correct tier at each point in time?
- Which model makes this easiest? Which makes it hardest?

**Hints**:
- Dimensional: `dim_customer` is an SCD Type 2 dimension with `valid_from`/`valid_to` columns. Join `fact_line_item` to `dim_customer` on `customer_id` AND `order_date BETWEEN valid_from AND valid_to`, then group by `loyalty_tier`.
- Data Vault: `sat_customer_crm` stores each tier change as a separate row with `load_date` and `valid_to`. Join through `hub_customer` to `sat_customer_crm` with a point-in-time filter on the order date.
- OBT: `customer_loyalty_tier` already contains the correct tier at order time (the date-range join was done during ETL). Just group by it.

---

## Sample Answers

Check out the `solutions` branch for sample answers to all exercises.


## Resources

- [SQL Style Guide](https://www.sqlstyle.guide/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [Data Modeling Best Practices](https://www.holistics.io/blog/data-modeling-best-practices/)
