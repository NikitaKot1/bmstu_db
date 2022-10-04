WITH RECURSIVE most_rich_in_year(id, master, volume, post_master) as (
    SELECT id, masterr, volume, 1
    FROM factory_table
    WHERE volume = (SELECT MAX(volume)
                    FROM factory_table
                    WHERE masterr = 0)
        AND masterr = 0
    UNION ALL
    SELECT fac.id, fac.masterr,
    fac.volume, mriy.post_master + 1
    FROM factory_table fac INNER JOIN most_rich_in_year as mriy 
    ON fac.masterr = mriy.post_master
    WHERE fac.volume = (SELECT MAX(volume)
                        FROM factory_table
                        WHERE masterr = fac.masterr)
)
SELECT * FROM most_rich_in_year;