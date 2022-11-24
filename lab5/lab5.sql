-- 1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
-- данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
-- проверить все режимы конструкции FOR XML

SELECT row_to_json(b) result FROM beer_table b;
SELECT row_to_json(c) result FROM consumers_table c;
SELECT row_to_json(f) result FROM factory_table f;
SELECT row_to_json(m) result FROM manufacturer_table m;
SELECT row_to_json(r) result FROM restaurant_table r;

-- 2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TABLE IF NOT EXISTS beer_copy (
    mark TEXT NOT NULL PRIMARY KEY,
    alko TEXT, 
    volume TEXT ,
    price TEXT 
);

DROP TABLE beer_copy;

-- chmod uog+w <json name>
COPY
(
    SELECT row_to_json(b) RESULT FROM beer_table b 
)
TO '/var/lib/postgresql/data/pgdata/json-tables/beer.json';

CREATE TABLE IF NOT EXISTS beer_import(beer json);

COPY beer_import FROM '/var/lib/postgresql/data/pgdata/json-tables/beer.json';

SELECT * FROM beer_import;

INSERT INTO beer_copy (mark, alko, volume, price)
SELECT beer->>'mark', beer->>'alko', beer->>'volume', beer->>'price'
FROM beer_import; 

SELECT * FROM beer_copy;

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
-- добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT
-- или UPDATE

CREATE TABLE IF NOT EXISTS beer_json
(
	DATA json
);

INSERT INTO beer_json
SELECT * FROM json_object('{mark, alko, volume, price}',
						  '{"Kozel", 6.6, 0.66, 66}');

SELECT * FROM beer_json;

CREATE TABLE IF NOT EXISTS json_table
(
	id serial PRIMARY KEY,
    mark TEXT,
	DATA json
);

insert into json_table(mark, data) values 
    ('kozzel', '{"alko": 6.6, "volume": 7.7}'::json),
    ('bear-beer', '{"alko": 7.7, "volume": 6.6}'::json);

select * from json_table;




--4. Выполнить следующие действия:
--4.1. Извлечь XML/JSON фрагмент из XML/JSON документа
CREATE TABLE IF NOT EXISTS beer_mark_alko
(
	mark TEXT,
	alko FLOAT
)

SELECT * FROM beer_import, json_populate_record(NULL::beer_mark_alko, beer);

SELECT beer->'mark' mark FROM beer_import;

SELECT beer->'alko' alko FROM beer_import;

--4.2. Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа

SELECT data->'volume' volume FROM json_table;

-- !!!4.3. Выполнить проверку существования узла или атрибута
-- jsonb

CREATE OR REPLACE FUNCTION get_json_table(u_id int)
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(data->''alko'') cnt
             FROM json_table
         ) AS count;
' LANGUAGE sql;

SELECT * FROM json_table;

SELECT get_json_table(0);
        
DROP FUNCTION node_exists CASCADE;

CREATE OR REPLACE FUNCTION node_exists(json_check jsonb, key text)
RETURNS VARCHAR 
AS $$
BEGIN
    RETURN (json_check->key);
END;
$$ LANGUAGE PLPGSQL;

SELECT node_exists('{"mark": "kozzel", "alko": 6.6}', 'mark');

--4.4. Изменить XML/JSON документ
drop table if exists json_st
CREATE TABLE json_st(doc jsonb)

insert into json_st values 
    ('{"mark": "pivo", "info":{"alko": 6.6, "price": 66}}'),
    ('{"mark": "dark beer", "info":{"alko": 7.7, "price": 77}}');

UPDATE json_st 
SET doc = doc || '{"info":{"price": 65}}'::jsonb
WHERE (doc->'info'->'price')::Int = 66;

SELECT * FROM json_st 

-- 5. Разедлить JSON документ на несколько строк по узлам
CREATE OR REPLACE PROCEDURE split_json_file()
LANGUAGE PLPGSQL
AS $$
DECLARE object_tmp TEXT;
BEGIN
    SELECT jsonb_pretty(doc)
    INTO object_tmp
    FROM json_st;
    raise notice '%', object_tmp;
END
$$;

CALL split_json_file()


-- Защита

WITH NewBer(ManufId, BeerCount) AS (
    SELECT manufacturer, COUNT(*) AS Total
    FROM beer_table b JOIN beer_manuf_table bm ON b.mark = bm.mark
    GROUP BY bm.manufacturer
)
SELECT * FROM NewBer;


CREATE TABLE IF NOT EXISTS def_table (
    manufid INT,
    beercount INT
);

DROP TABLE def_table;

-- chmod uog+w <json name>
COPY
(
    SELECT row_to_json(opa) RESULT FROM 
    (
        SELECT manufacturer, COUNT(*) AS Total
        FROM beer_table b JOIN beer_manuf_table bm ON b.mark = bm.mark
        GROUP BY bm.manufacturer
    ) AS opa
)
TO '/var/lib/postgresql/data/pgdata/json-tables/def.json';

CREATE TABLE IF NOT EXISTS def_import(beer json);

COPY def_import FROM '/var/lib/postgresql/data/pgdata/json-tables/def.json';

SELECT * FROM def_import;
