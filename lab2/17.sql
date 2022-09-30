INSERT INTO buying_table (consumer, mark, price, byuing_date)
SELECT id, mark, price, NOW()
        FROM consumers_table JOIN beer_table
        ON lovely_beer = mark;