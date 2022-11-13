CREATE TYPE beer_t AS
(
    alko FLOAT,
    volume FLOAT,
    price INT
);


CREATE OR REPLACE FUNCTION get_beer_t(price INT)
RETURNS beer_t
AS $$
    plan = plpy.prepare("       \
    SELECT alko, volume, price  \
    FROM beer_table             \
    WHERE price = $1;", ["INT"])
    run = plpy.execute(plan, [price])

    if (run.nrows()):
        return (run[0])
$$ LANGUAGE plpython3u;

SELECT * FROM get_beer_t(200)