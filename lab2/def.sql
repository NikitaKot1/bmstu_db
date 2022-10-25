SELECT mark
FROM buying_table
GROUP BY mark
HAVING COUNT(*) = (SELECT MAX(CN)
                   FROM (SELECT COUNT(*) AS CN
                        FROM buying_table
                        GROUP BY mark
                        ) AS OD);

SELECT MAX(CN)
FROM (SELECT COUNT(*) AS CN
        FROM buying_table
        GROUP BY mark
        ) AS OD;