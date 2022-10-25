

-- хранимая процедура без параметров или с параметрами

CREATE OR REPLACE PROCEDURE KillWimps()
    LANGUAGE SQL
AS $$
    DELETE FROM restaurant_table
    WHERE volume < 2000;
$$;

CALL KillWimps();


-- рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ

CREATE OR REPLACE PROCEDURE RiseOfPrice(n int)
    LANGUAGE plpgsql
AS $$
    BEGIN
        IF (n < 228) THEN
            UPDATE beer_table SET price = price + 10 WHERE id = n;
            CALL RiseOfPrice(n + 1);
        END IF;
    END;
$$;


-- хранимая функция с курсором

CREATE OR REPLACE PROCEDURE SaleBeer(alkofor float4)
    LANGUAGE plpgsql
AS $$
    DECLARE 
        curs CURSOR FOR SELECT *
                        FROM beer_table
                        WHERE alko > alkofor;
    BEGIN
        UPDATE beer_table SET price = price - 5 WHERE current OF curs;
        CLOSE curs;
    END;
$$;

-- хранимая процедура доступа к метаданным

CREATE OR REPLACE PROCEDURE TableInfo()
    LANGUAGE plpgsql
AS $$
    BEGIN
        CREATE TABLE IF NOT EXISTS column_info AS
        SELECT * FROM information_schema.columns WHERE table_schema = 'public';
    END;
$$;

CALL TableInfo();
SELECT * FROM column_info;