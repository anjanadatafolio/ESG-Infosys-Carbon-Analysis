
-- Query 3: Renewable energy adoption trend
-- Business question: What percentage of total electricity came from renewable sources each year?

WITH renewable_lag AS (
    SELECT fiscal_year, renewable_electricity_kwh, total_electricity_kwh, renewable_pct,
        LAG(renewable_pct, 1) OVER (ORDER BY fiscal_year ASC) AS prev_yr_renewable
    FROM esg_infosys
)
SELECT fiscal_year, renewable_electricity_kwh, total_electricity_kwh, renewable_pct, prev_yr_renewable,
    CASE
        WHEN renewable_pct < prev_yr_renewable
            THEN 'Reduced by ' || ROUND((prev_yr_renewable - renewable_pct) * 100.0 / prev_yr_renewable, 2) || '%'
        WHEN renewable_pct > prev_yr_renewable
            THEN 'Increased by ' || ROUND((renewable_pct - prev_yr_renewable) * 100.0 / prev_yr_renewable, 2) || '%'
        ELSE 'No Change'
    END AS renewable_trend
FROM renewable_lag
WHERE prev_yr_renewable IS NOT NULL
ORDER BY fiscal_year ASC;

