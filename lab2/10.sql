SELECT id, turnover,
    CASE 
        WHEN turnover < ((SELECT AVG(turnover) FROM manufacturer_table) - 10) THEN 'poor'
        WHEN turnover > ((SELECT AVG(turnover) FROM manufacturer_table) + 10) THEN 'rich'
        ELSE 'average'
    END AS Solvency
FROM manufacturer_table;

