PlatinumRx Assignment – Vijay Kumar

Section A: SQL (Hotel Management)
Q1: SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;

Q2: SELECT b.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01'
  AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

Q3: SELECT bill_id,
       SUM(item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date < '2021-11-01'
GROUP BY bill_id
HAVING SUM(item_quantity * i.item_rate) > 1000;
Q4: WITH item_orders AS (
    SELECT DATE_TRUNC('month', bill_date) AS month,
           item_id,
           SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE bill_date >= '2021-01-01'
      AND bill_date < '2022-01-01'
    GROUP BY DATE_TRUNC('month', bill_date), item_id
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rnk_desc,
           RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS rnk_asc
    FROM item_orders
)
SELECT month, item_id, total_qty, 'most_ordered' AS type
FROM ranked
WHERE rnk_desc = 1
UNION ALL
SELECT month, item_id, total_qty, 'least_ordered' AS type
FROM ranked
WHERE rnk_asc = 1;
Q5: WITH bill_values AS (
    SELECT DATE_TRUNC('month', bc.bill_date) AS month,
           b.user_id,
           SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE bc.bill_date >= '2021-01-01'
      AND bc.bill_date < '2022-01-01'
    GROUP BY DATE_TRUNC('month', bc.bill_date), b.user_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS rnk
    FROM bill_values
)
SELECT month, user_id, total_bill
FROM ranked
WHERE rnk = 2;

Section B: SQL (Clinic Management)
Q1: SELECT sales_channel,
       SUM(amount) AS total_revenue
FROM clinic_sales
WHERE datetime >= '2021-01-01'
  AND datetime < '2022-01-01'
GROUP BY sales_channel; 

Q2: SELECT uid,
       SUM(amount) AS total_value
FROM clinic_sales
WHERE datetime >= '2021-01-01'
  AND datetime < '2022-01-01'
GROUP BY uid
ORDER BY total_value DESC
LIMIT 10;

Q3: WITH revenue AS (
    SELECT DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE datetime >= '2021-01-01'
      AND datetime < '2022-01-01'
    GROUP BY DATE_TRUNC('month', datetime)
),
expenses_cte AS (
    SELECT DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS expense
    FROM expenses
    WHERE datetime >= '2021-01-01'
      AND datetime < '2022-01-01'
    GROUP BY DATE_TRUNC('month', datetime)
)
SELECT r.month,
       r.revenue,
       e.expense,
       (r.revenue - e.expense) AS profit,
       CASE
           WHEN (r.revenue - e.expense) > 0 THEN 'profitable'
           ELSE 'not-profitable'
       END AS status
FROM revenue r
JOIN expenses_cte e ON r.month = e.month;
Q4: WITH clinic_profit AS (
    SELECT c.city,
           cs.cid,
           SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
        AND DATE_TRUNC('month', cs.datetime) = DATE_TRUNC('month', e.datetime)
    WHERE DATE_TRUNC('month', cs.datetime) = '2021-09-01'
    GROUP BY c.city, cs.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, profit
FROM ranked
WHERE rnk = 1;
Q5: WITH clinic_profit AS (
    SELECT c.state,
           cs.cid,
           SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
        AND DATE_TRUNC('month', cs.datetime) = DATE_TRUNC('month', e.datetime)
    WHERE DATE_TRUNC('month', cs.datetime) = '2021-09-01'
    GROUP BY c.state, cs.cid
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, profit
FROM ranked
WHERE rnk = 2;

Section C: Spreadsheet Proficiency
Q1: Use VLOOKUP or INDEX-MATCH to map ticket_created_at from ticket.created_at using cms_id
Q2: Use Pivot Table / COUNTIFS:
- Same day: created_at = closed_at (DATE)
- Same hour: compare DATE + HOUR
Group by outlet_id

Section D: Python Proficiency
Q1: def convert_minutes(n):
    hrs = n // 60
    mins = n % 60
    if hrs == 0:
        return f"{mins} minutes"
    elif mins == 0:
        return f"{hrs} hrs"
    else:
        return f"{hrs} hrs {mins} minutes"
Q2: def remove_duplicates(s):
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result

