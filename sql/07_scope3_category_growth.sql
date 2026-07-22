
-- Query 7: Scope 3 category growth analysis FY22 vs FY26
-- Business question: Which Scope 3 category grew the most and which reduced the most?

WITH calc_22 AS (
    SELECT fiscal_year, scope3_business_travel, scope3_employee_commute, scope3_td_losses,
        scope3_upstream_leased, scope3_waste, scope3_wfh, scope3_capital_goods, scope3_purchased_goods
    FROM esg_infosys
    WHERE fiscal_year = 'FY22'
),
calc_26 AS (
    SELECT fiscal_year, scope3_business_travel, scope3_employee_commute, scope3_td_losses,
        scope3_upstream_leased, scope3_waste, scope3_wfh, scope3_capital_goods, scope3_purchased_goods
    FROM esg_infosys
    WHERE fiscal_year = 'FY26'
)
SELECT 'Business Travel' AS scope3_category,
    calc_22.scope3_business_travel AS fy22, calc_26.scope3_business_travel AS fy26,
    (calc_26.scope3_business_travel - calc_22.scope3_business_travel) AS absolute_change,
    ROUND((calc_26.scope3_business_travel - calc_22.scope3_business_travel) * 100.0 / calc_22.scope3_business_travel, 2) AS pct_change
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'Employee Commute',
    calc_22.scope3_employee_commute, calc_26.scope3_employee_commute,
    (calc_26.scope3_employee_commute - calc_22.scope3_employee_commute),
    ROUND((calc_26.scope3_employee_commute - calc_22.scope3_employee_commute) * 100.0 / calc_22.scope3_employee_commute, 2)
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'TD Losses',
    calc_22.scope3_td_losses, calc_26.scope3_td_losses,
    (calc_26.scope3_td_losses - calc_22.scope3_td_losses),
    ROUND((calc_26.scope3_td_losses - calc_22.scope3_td_losses) * 100.0 / calc_22.scope3_td_losses, 2)
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'Upstream Leased',
    calc_22.scope3_upstream_leased, calc_26.scope3_upstream_leased,
    (calc_26.scope3_upstream_leased - calc_22.scope3_upstream_leased),
    ROUND((calc_26.scope3_upstream_leased - calc_22.scope3_upstream_leased) * 100.0 / calc_22.scope3_upstream_leased, 2)
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'Waste',
    calc_22.scope3_waste, calc_26.scope3_waste,
    (calc_26.scope3_waste - calc_22.scope3_waste),
    ROUND((calc_26.scope3_waste - calc_22.scope3_waste) * 100.0 / calc_22.scope3_waste, 2)
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'Work From Home',
    calc_22.scope3_wfh, calc_26.scope3_wfh,
    (calc_26.scope3_wfh - calc_22.scope3_wfh),
    ROUND((calc_26.scope3_wfh - calc_22.scope3_wfh) * 100.0 / calc_22.scope3_wfh, 2)
FROM calc_22 CROSS JOIN calc_26
UNION ALL
SELECT 'Capital Goods',
    calc_22.scope3_capital_goods, calc_26.scope3_capital_goods,
    (calc_26.scope3_capital_goods - calc_22.scope3_capital_goods),
    ROUND((calc_26.scope3_capital_goods - calc_22.scope3_capital_goods) * 100.0 / calc_22.scope3_capital_goods, 2)
FROM calc_22 CROSS JOIN calc_26;


