SELECT man.id AS manId
FROM  manufacturer_table man JOIN
        (SELECT id, suppliers
        FROM restaurant_table) AS sup ON sup.suppliers = man.id;