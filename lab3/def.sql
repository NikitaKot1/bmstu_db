-- выбрать марку пива, все заводы, которые ее производят должны быть закрыты

CREATE OR REPLACE PROCEDURE DeleteFucForBeer(markd text)
    LANGUAGE SQL
$$ AS
    BEGIN
        DELETE FROM factory_table
        WHERE EXISTS (SELECT mark FROM factory_table join beer_factory_table
                        ON beer_factory_table.factory = factory_table.id
                        WHERE markd = beer_factory_table.mark);
    END;
$$;


EXECUTE format('SELECT marks FROM factory_table'
'WHERE marks LIKE  "\%$1,\%";') USING 4;

SELECT marks FROM factory_table
WHERE marks LIKE  '%Drop,%';


SELECT mark FROM factory_table join beer_factory_table
ON beer_factory_table.factory = factory_table.id
WHERE mark = beer_factory_table.mark;