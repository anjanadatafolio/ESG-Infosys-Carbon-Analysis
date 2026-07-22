

-- Query 8: Scope 3 breakdown for FY26
-- Business question: Which Scope 3 category contributes most to total Scope 3 in FY26?

WITH calc AS (
    SELECT fiscal_year, scope3_business_travel, scope3_employee_commute, scope3_td_losses,
        scope3_upstream_leased, scope3_waste, scope3_wfh, scope3_capital_goods,
        scope3_purchased_goods, scope3_total_tco2e
    FROM esg_infosys
    WHERE fiscal_year = 'FY26'
)
SELECT 'Business Travel' AS scope3_category,
    scope3_business_travel AS fy26_emissions,
    ROUND(scope3_business_travel * 100.0 / scope3_total_tco2e, 2) AS pct_of_tot_scope3
FROM calc
UNION ALL
SELECT 'Employee Commute', scope3_employee_commute,
    ROUND(scope3_employee_commute * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'TD Losses', scope3_td_losses,
    ROUND(scope3_td_losses * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'Upstream Leased', scope3_upstream_leased,
    ROUND(scope3_upstream_leased * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'Waste', scope3_waste,
    ROUND(scope3_waste * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'Work From Home', scope3_wfh,
    ROUND(scope3_wfh * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'Capital Goods', scope3_capital_goods,
    ROUND(scope3_capital_goods * 100.0 / scope3_total_tco2e, 2) FROM calc
UNION ALL
SELECT 'Purchased Goods', scope3_purchased_goods,
    ROUND(scope3_purchased_goods * 100.0 / scope3_total_tco2e, 2) FROM calc
ORDER BY pct_of_tot_scope3 DESC;


