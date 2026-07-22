
-- Query 6: Water consumption efficiency
-- Business question: How has water consumed per employee changed over the years?

WITH water_calc AS (
    SELECT fiscal_year, water_kl, headcount,
        ROUND((water_kl * 1.0 / headcount), 2) AS water_per_employee
    FROM esg_infosys
),
water_lag AS (
    SELECT fiscal_year, water_kl, headcount, water_per_employee,
        LAG(water_per_employee, 1) OVER (ORDER BY fiscal_year ASC) AS prev_yr_wpe
    FROM water_calc
)
SELECT fiscal_year, water_kl, headcount, water_per_employee, prev_yr_wpe,
    CASE
        WHEN water_per_employee < prev_yr_wpe
            THEN 'Reduced by ' || ROUND((prev_yr_wpe - water_per_employee) * 100.0 / prev_yr_wpe, 2) || '%'
        WHEN water_per_employee > prev_yr_wpe
            THEN 'Increased by ' || ROUND((water_per_employee - prev_yr_wpe) * 100.0 / prev_yr_wpe, 2) || '%'
        ELSE 'No Change'
    END AS water_consumption_trend
FROM water_lag
WHERE prev_yr_wpe IS NOT NULL
ORDER BY fiscal_year ASC;


