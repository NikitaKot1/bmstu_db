SELECT foundation, COUNT(*) AS ManufacCount
FROM manufacturer_table
GROUP BY foundation
ORDER BY foundation;