COPY manufacturer_table(id, turnover, profit, foundation) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/manufacturers.csv'
DELIMITER ','
CSV HEADER;


COPY factory_table(id, volume, country, masterr) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/factories.csv'
DELIMITER ','
CSV HEADER;


COPY beer_table(mark, alko, volume, price) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/beer.csv'
DELIMITER ','
CSV HEADER;


COPY beer_manuf_table(manufacturer, mark) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/beer_manufacturers.csv'
DELIMITER ','
CSV HEADER;


COPY beer_factory_table(factory, mark) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/beer_factories.csv'
DELIMITER ','
CSV HEADER;


COPY restaurant_table(id, masterr, volume, suppliers) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/restaurants.csv'
DELIMITER ','
CSV HEADER;


COPY consumers_table(id, full_name, gender, lovely_beer, birth) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/consumers.csv'
DELIMITER ','
CSV HEADER;

COPY buying_table(id, consumer, mark, price, byuing_date) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/buyings.csv'
DELIMITER ','
CSV HEADER;

COPY distributors_table(id, marks, manufacturers, markup) 
FROM '/var/lib/postgresql/data/pgdata/csv_tables/tables/distributors.csv'
DELIMITER ','
CSV HEADER;