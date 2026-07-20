WITH future AS(
SELECT 'FY27' AS fiscal_year, 1 AS year_number
UNION ALL
SELECT 'FY28', 2
UNION ALL
SELECT 'FY29', 3
UNION ALL
SELECT 'FY30', 4
)
SELECT year_number, fiscal_year,
45834-(7283.5 * year_number) AS required_emissions,
(45834-(7283.5 * year_number))-16700 AS remaining_gap,
ROUND((7283.5 * year_number * 100.0) / 45834, 2) AS percent_reduction
FROM future
ORDER BY year_number ASC;
