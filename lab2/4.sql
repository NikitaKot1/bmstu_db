SELECT masterr from restaurant_table
WHERE suppliers IN (SELECT id
                    FROM manufacturer_table
                    WHERE foundation < 1410);