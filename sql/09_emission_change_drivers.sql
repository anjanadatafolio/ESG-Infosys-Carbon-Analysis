
-- Query 9: Emission change drivers by scope
-- Business question: What percentage of total emission change each year was driven by Scope 3 vs Scope 1+2?

WITH yearly_lag AS (
    SELECT fiscal_year, scope12_total_tco2e, scope3_total_tco2e, scope123_total_tco2e,
        LAG(scope12_total_tco2e, 1) OVER (ORDER BY fiscal_year ASC) AS prev_scope12_total,
        LAG(scope3_total_tco2e, 1) OVER (ORDER BY fiscal_year ASC) AS prev_scope3_total,
        LAG(scope123_total_tco2e, 1) OVER (ORDER BY fiscal_year ASC) AS prev_scope123_total
    FROM esg_infosys
),
absolute_calc AS (
    SELECT fiscal_year,
        scope12_total_tco2e, prev_scope12_total,
        scope12_total_tco2e - prev_scope12_total AS scope12_change,
        scope3_total_tco2e, prev_scope3_total,
        scope3_total_tco2e - prev_scope3_total AS scope3_change,
        scope123_total_tco2e, prev_scope123_total,
        scope123_total_tco2e - prev_scope123_total AS scope123_total_change
    FROM yearly_lag
)
SELECT fiscal_year,
    scope12_total_tco2e, scope12_change,
    scope3_total_tco2e, scope3_change,
    scope123_total_tco2e, scope123_total_change,
    ROUND((scope12_change * 1.0 / scope123_total_change) * 100.0, 2) AS scope12_change_prcnt,
    ROUND((scope3_change * 1.0 / scope123_total_change) * 100.0, 2) AS scope3_change_prcnt
FROM absolute_calc
ORDER BY fiscal_year ASC;


