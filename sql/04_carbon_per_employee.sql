
-- Query 4: Carbon footprint per employee
-- Business question: What is the carbon footprint per employee and which scope contributes most?

WITH car_footprint AS (
    SELECT fiscal_year, headcount, scope1_tco2e, scope2_market_tco2e, scope3_total_tco2e, scope123_total_tco2e,
        ROUND((scope1_tco2e * 1.0 / headcount), 2) AS scope1_per_employee,
        ROUND((scope2_market_tco2e * 1.0 / headcount), 2) AS scope2_per_employee,
        ROUND((scope3_total_tco2e * 1.0 / headcount), 2) AS scope3_per_employee,
        ROUND((scope123_total_tco2e * 1.0 / headcount), 2) AS total_per_employee
    FROM esg_infosys
)
SELECT fiscal_year, headcount, scope1_tco2e, scope2_market_tco2e, scope3_total_tco2e, scope123_total_tco2e,
    scope1_per_employee, scope2_per_employee, scope3_per_employee, total_per_employee,
    ROUND((scope1_per_employee * 1.0 / total_per_employee) * 100.0, 2) AS scope1_contribution_percent,
    ROUND((scope2_per_employee * 1.0 / total_per_employee) * 100.0, 2) AS scope2_contribution_percent,
    ROUND((scope3_per_employee * 1.0 / total_per_employee) * 100.0, 2) AS scope3_contribution_percent
FROM car_footprint
ORDER BY fiscal_year ASC;

