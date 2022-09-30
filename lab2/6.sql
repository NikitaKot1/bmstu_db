SELECT * FROM manufacturer_table
WHERE profit >= ALL (SELECT profit FROM manufacturer_table);