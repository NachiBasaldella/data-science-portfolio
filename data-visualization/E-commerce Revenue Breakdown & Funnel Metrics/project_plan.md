# 🧩 Project Plan — E-commerce Revenue Dashboard

## 1. Background
This dashboard is the visualization layer of my SQL project: **E-commerce Revenue Breakdown & Funnel Metrics**.  
The main goal was to bring pre-computed KPIs and SQL insights to life using **Power BI**, focusing on data storytelling and clarity.

---

## 2. Objectives
- Consolidate business KPIs (Revenue, AOV, Delivered Rate, Cancellation Rate).
- Visualize order funnel progression.
- Identify top categories and regional sales patterns.
- Measure delivery performance vs. customer satisfaction.

---

## 3. Data Preparation
- Source: [Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Cleaned and loaded with Python (Pandas).
- SQL used for metric calculation and aggregation.
- Exported five main CSVs for visualization:
  - KPIs summary  
  - Revenue by state  
  - Payment mix  
  - Top categories  
  - Delivery and review metrics

---

## 4. Power BI Workflow
1. Imported all CSVs into Power BI.
2. Verified data types and relationships (order_id, state, category).
3. Created DAX measures for KPIs:
   - `Total Revenue = SUM(order_payments[payment_value])`
   - `AOV = DIVIDE([Total Revenue], DISTINCTCOUNT(order_id))`
   - `Delivered Rate = DIVIDE([Delivered Orders], [Total Orders])`
4. Designed the layout using KPI cards, bar charts, funnel, and maps.
5. Created a custom *Order Status Sort* column for the funnel (Created → Delivered).
6. Enhanced visuals with data labels, colors, and tooltips.

---

## 5. Challenges & Solutions
| Challenge | Solution |
|------------|-----------|
| Map visual not rendering | Enabled Bing Map option + created custom “State, Brazil” column |
| Funnel out of order | Added `Order Status Sort` or `DimOrderStatus` table |
| Scatter for reviews unreadable | Replaced with trendline and correlation metrics |
| CSVs too large for GitHub | Uploaded aggregated summaries only |

---

## 6. Key Insights & Impact
- Delivered rate above **96%** indicates strong fulfillment reliability.
- Credit card payments drive **78%** of all revenue.
- Revenue heavily concentrated in **SP, RJ, and MG**.
- Lower review scores linked to higher delivery times.
- Funnel conversion shows healthy pipeline from creation to delivery.

---

## 7. Next Steps
- Develop a forecasting page for future revenue prediction.
- Publish an interactive version on Power BI Service for sharing.

---

## 8. Files in this project
| File | Description |
|------|--------------|
| `E-commerce Revenue Dashboard.pbix` | Power BI dashboard |
| `E-commerce Revenue Dashboard.pdf` | Exported static version for portfolio |
| `/data/*.csv` | Source datasets |
| `/screenshots/*.png` | Dashboard images |
| `README.md` | High-level overview |
| `project_plan.md` | This detailed plan |

---

## 9. Credits
Dataset: **Olist Brazilian E-Commerce Public Dataset (Kaggle)**  
Developed and designed by **[Nazaret Basaldella]**, 2025.
