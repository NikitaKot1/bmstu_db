WITH NewBer(ManufId, BeerCount) AS (
    SELECT manufacturer, COUNT(*) AS Total
    FROM beer_table
    GROUP BY manufacturer
)
SELECT * FROM NewBer;