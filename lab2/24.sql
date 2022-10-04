SELECT *, 
        MAX(volume) OVER (ORDER BY masterr)
FROM factory_table;