CREATE OR REPLACE FUNCTION more_money(old_price int, new_price int)
RETURNS void
AS $$
    plan = plpy.prepare("UPDATE beer_table set price = $1 where price = $2", ["INT", "INT"])
    plpy.execute(plan, [new_price, old_price])
$$ LANGUAGE plpython3u;

SELECT * FROM more_money(70, 65);

SELECT * FROM beer_table
WHERE price = 65;