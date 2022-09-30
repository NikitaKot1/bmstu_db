SELECT id,
        (SELECT AVG(turnover)
        FROM manufacturer_table) AS avgturn
FROM factory_table;
