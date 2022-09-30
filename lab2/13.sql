SELECT id, masterr
FROM restaurant_table
WHERE suppliers = (SELECT id 
                   FROM manufacturer_table
                   GROUP BY id
                   HAVING profit = (SELECT MAX(BP)
                                    FROM (SELECT MAX(profit) AS BP
                                          FROM manufacturer_table
                                          GROUP BY foundation
                                          ) AS OD
                                    )
                  );