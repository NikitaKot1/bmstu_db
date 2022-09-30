SELECT turnover, profit, 
    profit / turnover AS koef
INTO manufKoefs
FROM manufacturer_table;