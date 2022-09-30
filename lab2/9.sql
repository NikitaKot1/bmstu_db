SELECT full_name,
    CASE gender
        WHEN  'F' THEN 'Female'
        WHEN 'M' THEN 'Male'
        ELSE 'wtf'
    END AS full_gender
FROM consumers_table;