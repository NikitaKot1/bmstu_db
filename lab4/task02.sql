CREATE OR REPLACE FUNCTION avgCTL(a integer, b integer)
RETURNS float
AS $$
    n = (a + b) / 2
    return n
$$
LANGUAGE plpython3u;


SELECT avgCTL(3, 6);
