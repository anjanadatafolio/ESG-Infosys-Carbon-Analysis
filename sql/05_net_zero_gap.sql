

-- Query 5: Net Zero target gap analysis
-- Business question: How far is Infosys from its 2030 Scope 1+2 target of 16,700 tCO2e?

WITH gap_calc AS (
    SELECT fiscal_year, scope12_total_tco2e,
        16700 AS target_2030,
        (scope12_total_tco2e - 16700) AS target_gap
    FROM esg_infosys
)
SELECT fiscal_year, scope12_total_tco2e, target_2030, target_gap,
    ROUND((target_gap * 1.0 / scope12_total_tco2e) * 100.0, 2) AS gap_percent
FROM gap_calc
ORDER BY fiscal_year ASC;


