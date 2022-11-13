CREATE EXTENSION plpython3u;


CREATE OR REPLACE FUNCTION clr7(a integer)
RETURNS integer
AS $$
    import sys
    sys.path.append('/home/zorox/postgres/bmstu_db/lab4/CLRManager.py')
    import CLRManager
    n = CLRManager.scalar(a)
    return n
$$
LANGUAGE plpython3u;

SELECT clr7(3)



CREATE OR REPLACE FUNCTION scalarCTL(a integer)
RETURNS integer
AS $$
    n = a + 6
    return n
$$
LANGUAGE plpython3u;

SELECT scalarCTL(3);

