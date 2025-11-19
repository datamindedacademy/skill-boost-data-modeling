# Training Questions and Exercises

This directory contains business questions to answer using each modeling technique. The goal is to experience how each approach affects query complexity, readability, and maintainability.

## How to Use This Guide

1. Set up all three dbt projects (dimensional-modeling, data-vault-20, one-big-table) if you haven't already
2. For each question below, write SQL queries using each modeling technique
3. Compare your experience across the three approaches

## Business Questions

### Question 1: Revenue by Region
**Business Need**: What is the total revenue for each customer region, and how many orders does each region have?

**What to consider**:
- How many tables do you need to query?
- How many joins are required?
- Is the query easy to understand?

**Hints**:
- Dimensional: Use `fact_line_item` joined with `dim_customer`
- Data Vault: Use the `bv_order_details` business vault view
- OBT: Query `obt_orders` directly

---

### Question 2: Product Performance
**Business Need**: Identify the top 20 products by revenue, showing product name, brand, type, and total revenue.

**What to consider**:
- How do you access product attributes?
- Is the aggregation straightforward?

**Hints**:
- Dimensional: Join `fact_line_item` with `dim_part`
- Data Vault: Use `bv_order_details` or join hubs/satellites
- OBT: Simple aggregation on `obt_orders`

---

### Question 3: Time-Based Analysis
**Business Need**: Show monthly revenue trends for 1995, including order count and average order value.

**What to consider**:
- How do you handle date attributes?
- Can you easily get year, month, quarter?
- How readable is the date handling?

**Hints**:
- Dimensional: May need to join with `dim_date` or extract from fact table
- Data Vault: Extract from satellite or business vault
- OBT: Pre-calculated date parts available directly

---

### Question 4: Customer Segmentation
**Business Need**: For each market segment, show total customers, total orders, total revenue, and average order value.

**What to consider**:
- How do you count distinct customers?
- Multiple levels of aggregation needed
- Is the logic clear?

---

### Question 5: Multi-Dimensional Slice
**Business Need**: Analyze revenue by customer market segment, product brand, and order quarter for 1995. Include order count and average discount rate.

**What to consider**:
- How many dimensions are involved?
- How complex is the SQL?
- How would you add another dimension (e.g., supplier region)?

---

### Question 6: Shipping Performance
**Business Need**: Calculate the percentage of late shipments by ship mode. A shipment is late if ship_date > commit_date.

**What to consider**:
- Where is the shipping data located?
- How easy is it to calculate lateness?
- Can you easily add more shipping metrics?

**Hints**:
- OBT has `delivery_status` pre-calculated
- Other models need to calculate from raw dates

---

### Question 7: Supplier Analysis
**Business Need**: For each supplier nation, show total parts supplied, total revenue, and average discount given.

**What to consider**:
- How do you access supplier attributes?
- How are supplier-part relationships modeled?

---

### Question 8: Ad-Hoc Question (New Requirement!)
**Business Need**: The business just asked: "Show me revenue by customer region and supplier region to understand trade flows."

**What to consider**:
- How easy is it to answer this NEW question?
- Do you need to modify your model?
- How would you add this to a dashboard?

This tests the flexibility of each approach!

---

## Sample Answers

See the `sample-answers/` directory for example queries for each question in each modeling technique. Try to write your own first before looking at the samples!


## Resources

- [SQL Style Guide](https://www.sqlstyle.guide/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [Data Modeling Best Practices](https://www.holistics.io/blog/data-modeling-best-practices/)
