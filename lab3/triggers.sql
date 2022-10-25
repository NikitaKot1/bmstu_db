-- триггер INSTEAD OF
CREATE OR REPLACE FUNCTION UpdateLovelyBeer()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'consumer % % % % %;', new.id, new.consumer, new.mark, new.price, new.byuing_date;

        UPDATE consumers_table 
        SET lovely_beer = (SELECT mark
                            FROM buying_table b
                            WHERE b.consumer = new.consumer
                            GROUP BY mark
                            HAVING COUNT(*) = (SELECT MAX(CN)
                                                FROM (SELECT COUNT(*) AS CN
                                                    FROM buying_table b
                                                    WHERE b.consumer = new.consumer
                                                    GROUP BY mark
                                                    ) AS OD))
        WHERE id = new.consumer;

        INSERT INTO buying_table
        VALUES (DEFAULT, new.consumer, new.mark, new.price, new.byuing_date);

        RETURN new;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER UpdateLovely
    instead of INSERT
    ON v_buying_table
    for each row
EXECUTE PROCEDURE UpdateLovelyBeer();


create view v_buying_table as
select * from buying_table

select * from v_buying_table

INSERT INTO v_buying_table
VALUES (DEFAULT, 0, 'Drop', 77, NOW());


SELECT * FROM consumers_table
WHERE id = 0;

SELECT * FROM buying_table
WHERE consumer = 0;


-- триггер AFTER

CREATE OR REPLACE FUNCTION AterDeleteRestaurant()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'DELETED % % % % %;', old.id, old.consumer, old.mark, old.price, old.byuing_date;

        RETURN old;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER AterDeleteRestaurant
    AFTER DELETE
    ON buying_table
EXECUTE PROCEDURE AterDeleteRestaurant();

DELETE FROM buying_table
WHERE id = 900;