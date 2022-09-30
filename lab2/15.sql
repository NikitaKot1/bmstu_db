SELECT  masterr, AVG(volume) AS "Average Volume", COUNT(*) AS "Count of factories"
FROM factory_table F  
GROUP BY masterr
HAVING AVG(volume) > (SELECT AVG(volume)
                      FROM factory_table)
ORDER BY AVG(volume);