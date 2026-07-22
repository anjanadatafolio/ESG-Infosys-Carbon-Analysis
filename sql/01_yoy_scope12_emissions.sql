
-- Query 1: Year-on-Year change in Scope 1+2 emissions
-- Business question: Is Infosys reducing direct emissions and by how much each year?

WITH yearly_lag AS (
    SELECT fiscal_year, scope12_total_tco2e,
        LAG(scope12_total_tco2e, 1) OVER (ORDER BY fiscal_year ASC) AS prev_yr_scope12_total_tco2e
    FROM esg_infosys
)
SELECT fiscal_year, scope12_total_tco2e, prev_yr_scope12_total_tco2e,
    CASE
        WHEN scope12_total_tco2e < prev_yr_scope12_total_tco2e
            THEN 'Reduced by ' || ROUND((prev_yr_scope12_total_tco2e - scope12_total_tco2e) * 100.0 / prev_yr_scope12_total_tco2e, 2) || '%'
        WHEN scope12_total_tco2e > prev_yr_scope12_total_tco2e
            THEN 'Increased by ' || ROUND((scope12_total_tco2e - prev_yr_scope12_total_tco2e) * 100.0 / prev_yr_scope12_total_tco2e, 2) || '%'
        ELSE 'No Change'
    END AS yoy_pct_change
FROM yearly_lag
WHERE prev_yr_scope12_total_tco2e IS NOT NULL
ORDER BY fiscal_year ASC;


