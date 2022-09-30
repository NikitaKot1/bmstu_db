UPDATE beer_table
SET volume = (SELECT AVG(volume)
              FROM beer_table
              WHERE price > 300)
WHERE price > 300;