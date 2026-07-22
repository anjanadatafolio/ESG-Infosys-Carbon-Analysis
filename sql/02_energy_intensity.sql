
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

