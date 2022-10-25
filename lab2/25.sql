SELECT masterr, 
        MAX(volume) OVER (ORDER BY masterr)
FROM factory_table
WHERE factory_table.id IN (SELECT id
                            FROM (SELECT id,
                                    ROW_NUMBER() OVER w as rnum
                                FROM factory_table
                                WINDOW w AS (
                                    PARTITION BY masterr
                                    ORDER BY id)   
                                   ) t 
                            WHERE t.rnum = 1);