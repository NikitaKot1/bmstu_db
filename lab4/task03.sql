CREATE OR REPLACE FUNCTION beerFromMan(a integer)
RETURNS TABLE
(
    mark VARCHAR(256),
    alko FLOAT,
    volume FLOAT,
    price INT
)
AS $$
    buf = plpy.execute(f" \
    SELECT b.mark, b.alko, b.volume, b.price, bm.manufacturer \
    FROM beer_table b JOIN beer_manuf_table bm ON b.mark = bm.mark")
    result_ = []
    for i in buf:
        if i["manufacturer"] == a:
            result_.append(i)
    return result_
$$
LANGUAGE plpython3u;


SELECT beerFromMan(60);

SELECT b.mark, b.alko, b.volume, b.price , bm.manufacturer
    FROM beer_table b JOIN beer_manuf_table bm ON b.mark = bm.mark