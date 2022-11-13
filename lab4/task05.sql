CREATE VIEW cons_view AS
SELECT * FROM consumers_table;

CREATE OR REPLACE FUNCTION delete_consumer()
RETURNS TRIGGER
AS $$
    plpy.execute(f"\
    RAISE MESSAGE 'Он не заслужил такой судьбы, судьбы без пива...';    ")
$$
LANGUAGE plpython3u;

CREATE TRIGGER delete_consumer_trigger
INSTEAD OF DELETE ON cons_view
FOR EACH ROW
EXECUTE PROCEDURE delete_consumer();

DELETE FROM cons_view
WHERE id = 3;

SELECT * FROM cons_view;
