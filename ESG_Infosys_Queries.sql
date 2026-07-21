-- =============================================
-- ESG Carbon and Energy Trend Analysis
-- Infosys Ltd | FY2022 - FY2026
-- Tool: SQLite | Table: esg_infosys
-- =============================================


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


-- Query 2: Energy intensity trend
-- Business question: Is Infosys generating more revenue per unit of energy consumed?

WITH ener_int_calc AS (
    SELECT fiscal_year, revenue_usd_mn, total_energy_gj,
        ROUND((total_energy_gj * 1.0 / revenue_usd_mn), 2) AS energy_intensity_gj
    FROM esg_infosys
),
ener_int_lag AS (
    SELECT fiscal_year, revenue_usd_mn, total_energy_gj, energy_intensity_gj,
        LAG(energy_intensity_gj, 1) OVER (ORDER BY fiscal_year) AS prev_yr_energy_intensity
    FROM ener_int_calc
)
SELECT fiscal_year, revenue_usd_mn, total_energy_gj, energy_intensity_gj, prev_yr_energy_intensity,
    CASE
        WHEN energy_intensity_gj < prev_yr_energy_intensity
            THEN 'Reduced by ' || ROUND((prev_yr_energy_intensity - energy_intensity_gj) * 100.0 / prev_yr_energy_intensity, 2) || '%'
        WHEN energy_intensity_gj > prev_yr_energy_intensity
            THEN 'Increased by ' || ROUND((energy_intensity_gj - prev_yr_energy_intensity) * 100.0 / prev_yr_energy_intensity, 2) || '%'
        ELSE 'No Change'
    END AS efficiency_trend
FROM ener_int_lag
WHERE prev_yr_energy_intensity IS NOT NULL
ORDER BY fiscal_year ASC;


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


-- Query 10: Net Zero 2030 projection
-- Business question: What Scope 1+2 reduction is needed each year from FY27-FY30 to hit the 2030 target?

WITH future AS (
    SELECT 'FY27' AS fiscal_year, 1 AS year_number
    UNION ALL
    SELECT 'FY28', 2
    UNION ALL
    SELECT 'FY29', 3
    UNION ALL
    SELECT 'FY30', 4
)
SELECT year_number, fiscal_year,
    45834 - (7283.5 * year_number) AS required_emissions,
    (45834 - (7283.5 * year_number)) - 16700 AS remaining_gap,
    ROUND((7283.5 * year_number * 100.0) / 45834, 2) AS percent_reduction
FROM future
ORDER BY year_number ASC;
