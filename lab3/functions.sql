

-- скалярная функция

CREATE OR REPLACE FUNCTION AvgBeerPrice() RETURNS float4 AS $$
    SELECT AVG(price) FROM beer_table;
$$ LANGUAGE SQL;

SELECT AVgBeerPrice();


-- подставляемая табличная функция

SELECT fac.id, man.id, fac.marks, man.marks, fac.country
FROM factory_table fac
JOIN manufacturer_table man ON masterr = man.id
WHERE fac.marks NOT LIKE '%Pfarrbräu%' 
        AND man.marks LIKE '%Pfarrbräu%';


CREATE OR REPLACE FUNCTION FactoriesLosers() 
    RETURNS TABLE 
            (
                idFactory       int,
                idMaster        int, 
                factoryMarks    text,
                allMarks        text,
                country         text
            )
    AS $$
        SELECT fac.id, man.id, fac.marks, man.marks, fac.country
        FROM factory_table fac
        JOIN manufacturer_table man ON masterr = man.id
        WHERE fac.marks NOT LIKE '%Pfarrbräu%' 
                AND man.marks LIKE '%Pfarrbräu%';
$$ LANGUAGE SQL;

SELECT * FROM FactoriesLosers();


-- многооператорная табличная функция

DROP FUNCTION FactoriesLosersALot();

CREATE OR REPLACE FUNCTION FactoriesLosersALot() 
    RETURNS TABLE 
            (
                idFactory       int,
                idMaster        int,
                markd           int
            )
    AS $$
    BEGIN
        RETURN QUERY SELECT fac.id, man.id, 0
        FROM factory_table fac
        JOIN manufacturer_table man ON masterr = man.id
        WHERE fac.marks NOT LIKE '%Pfarrbräu%' 
                AND man.marks LIKE '%Pfarrbräu%';

        RETURN QUERY SELECT fac.id, man.id, 1
        FROM factory_table fac
        JOIN manufacturer_table man ON masterr = man.id
        WHERE fac.marks NOT LIKE '%Drop%' 
                AND man.marks LIKE '%Drop%';
        
        RETURN QUERY SELECT fac.id, man.id, 2
        FROM factory_table fac
        JOIN manufacturer_table man ON masterr = man.id
        WHERE fac.marks NOT LIKE '%Brother%' 
                AND man.marks LIKE '%Brother%';
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM FactoriesLosersALot();

-- рекурсивная функция или функция с рекурсивным ОТВ

CREATE OR REPLACE FUNCTION MostMaxVolume()
    RETURNS TABLE
            (
                ManufactorierID     int,
                MaxFactoryID        int,
                volume              int
            )
    AS $$

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
    SELECT master, id, volume FROM most_rich_in_year;

    $$  LANGUAGE SQL
        RETURNS NULL ON NULL input;

SELECT * FROM MostMaxVolume();