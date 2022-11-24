CREATE EXTENSION plpython3u;


CREATE OR REPLACE FUNCTION scalarCTL(a integer)
RETURNS integer
AS $$
    n = a + 6
    return n
$$
LANGUAGE plpython3u;

SELECT scalarCTL(3);

