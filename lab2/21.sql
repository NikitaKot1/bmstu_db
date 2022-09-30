DELETE FROM buying_table
WHERE EXISTS (SELECT mark
              FROM beer_table
              WHERE mark LIKE '%Brothers Rauchbier%' AND mark = buying_table.mark);