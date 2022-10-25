DROP TABLE IF EXISTS manufacturer_table CASCADE;
CREATE TABLE IF NOT EXISTS manufacturer_table
(
    id INT NOT NULL PRIMARY KEY,
    turnover FLOAT CHECK (turnover > 0),
    profit FLOAT CHECK (profit > 0),
    foundation INT CHECK (foundation >= 1000)
);

DROP TABLE IF EXISTS factory_table CASCADE;
CREATE TABLE IF NOT EXISTS factory_table
(
    id INT NOT NULL PRIMARY KEY,
    volume FLOAT CHECK (volume >= 1),
    country VARCHAR(64),
    masterr INT,
    FOREIGN KEY (masterr) REFERENCES manufacturer_table(id)
);

DROP TABLE IF EXISTS beer_table CASCADE;
CREATE TABLE IF NOT EXISTS beer_table
(
    mark VARCHAR(256) NOT NULL PRIMARY KEY,
    alko FLOAT CHECK (alko > 0 AND alko < 96), 
    volume FLOAT CHECK (volume > 0),
    price INT CHECK (price > 0)
);

DROP TABLE IF EXISTS beer_manuf_table CASCADE;
CREATE TABLE IF NOT EXISTS beer_manuf_table
(
    mark VARCHAR(256),
    manufacturer INT,

    FOREIGN KEY (manufacturer) REFERENCES manufacturer_table(id)
);

DROP TABLE IF EXISTS beer_factory_table CASCADE;
CREATE TABLE IF NOT EXISTS beer_factory_table
(
    mark VARCHAR(256),
    factory INT,

    FOREIGN KEY (factory) REFERENCES factory_table(id)
);

DROP TABLE IF EXISTS restaurant_table CASCADE;
CREATE TABLE IF NOT EXISTS restaurant_table
(
    id INT NOT NULL PRIMARY KEY,
    masterr VARCHAR(128),
    volume INT CHECK (volume >= 0),
    suppliers INT,
    FOREIGN KEY (suppliers) REFERENCES manufacturer_table(id)
);

DROP TABLE IF EXISTS consumers_table CASCADE;
CREATE TABLE IF NOT EXISTS consumers_table
(
    id INT NOT NULL PRIMARY KEY,
    full_name VARCHAR(128),
    gender VARCHAR CHECK (gender = 'M' OR gender = 'F'),
    lovely_beer VARCHAR(256),
    birth VARCHAR(22),
    FOREIGN KEY (lovely_beer) REFERENCES beer_table(mark)
);

DROP TABLE IF EXISTS buying_table CASCADE;
CREATE TABLE IF NOT EXISTS buying_table
(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consumer INT,
    mark VARCHAR(256),
    price INT CHECK (price > 0),
    byuing_date DATE,
    FOREIGN KEY (consumer) REFERENCES consumers_table(id),
    FOREIGN KEY (mark) REFERENCES beer_table(mark)
);

DROP TABLE IF EXISTS distributors_table CASCADE;
CREATE TABLE IF NOT EXISTS distributors_table
(
    id INT NOT NULL PRIMARY KEY,
    marks VARCHAR(1024),
    manufacturers INT,
    markup INT CHECK (markup > 0),
    FOREIGN KEY (manufacturers) REFERENCES manufacturer_table(id)
);