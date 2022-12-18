-- задание 1
DROP TABLE IF EXISTS emploee CASCADE;
CREATE TABLE IF NOT EXISTS emploee
(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fullname TEXT NOT NULL,
    birth DATE,
    otdel TEXT NOT NULL
);


DROP TABLE IF EXISTS iotime CASCADE;
CREATE TABLE IF NOT EXISTS iotime
(
    id INT NOT NULL,
    dat DATE,
    day TEXT NOT NULL,
    tim TIME,
    typ INT NOT NULL,
    FOREIGN KEY (id) REFERENCES emploee(id)
);


INSERT INTO emploee VALUES (DEFAULT, 'Иван Иванов Иванович', CAST('1990/09/25' AS DATE), 'ИТ');
INSERT INTO emploee VALUES (DEFAULT, 'Петр Петров Петрович', CAST('1987/11/12' AS DATE), 'Бугалтерия');
INSERT INTO emploee VALUES (DEFAULT, 'Чул Чулов Чулович', CAST('1987/11/12' AS DATE), 'Бугалтерия');



INSERT INTO iotime VALUES (1, CAST('2018/12/14' AS DATE), 'Суббота', CAST('9:00' AS TIME), 1);
INSERT INTO iotime VALUES (1, CAST('2018/12/14' AS DATE), 'Суббота', CAST('9:20' AS TIME), 2);
INSERT INTO iotime VALUES (1, CAST('2018/12/14' AS DATE), 'Суббота', CAST('9:25' AS TIME), 1);
INSERT INTO iotime VALUES (2, CAST('2018/12/14' AS DATE), 'Суббота', CAST('9:05' AS TIME), 1);

SELECT * FROM emploee
SELECT * FROM iotime


DROP FUNCTION NotToday(tod DATE);

CREATE OR REPLACE FUNCTION NotToday(tod DATE) 
    RETURNS TABLE 
            (
                fullname TEXT,
                otdel TEXT
            )
    AS $$
    BEGIN
        RETURN QUERY SELECT e.fullname, e.otdel
            FROM emploee e
            WHERE id NOT IN (SELECT e.id
                            FROM iotime i 
                            WHERE i.id = e.id
                            AND dat = tod AND typ = 1);
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM NotToday(CAST('2018/12/14' AS DATE));

--черновик
SELECT fullname, otdel
FROM emploee e
WHERE e.id NOT IN (SELECT e.id
        FROM iotime i 
        WHERE i.id = e.id
        AND dat = CAST('2018/12/14' AS DATE) AND typ = 1);



-- Задание 2
--- Отопзданее -- позднее 9:00
---Ситрудники, опоздавшие менее, чем на 5 минут

SELECT e.id, fullname, otdel
FROM emploee e
JOIN iotime i ON e.id = i.id
WHERE i.tim = (SELECT MIN(tim) FROM iotime
                WHERE tim < CAST('9:00' AS TIME) + INTERVAL '5 minutes'
                GROUP BY id
                HAVING id = e.id);


-- выходили более чем на 10 минут ща раз


SELECT e.id, fullname, otdel
FROM emploee e JOIN iotime i on e.id = i.id
WHERE i.typ = 1 AND e.id in (SELECT e.id
                            FROM emploee e1 JOIN iotime i1 on e1.id = i1.id
                            WHERE i1.typ = 2 AND i.tim > i.tim + INTERVAL '10 minutes'
                            AND e1.id = e.id)

--  бугалтеры раньше 8 приходят :/

SELECT e.id, fullname, otdel
FROM emploee e
JOIN iotime i ON e.id = i.id
WHERE e.otdel = 'Бугалтерия' AND i.tim = (SELECT MIN(tim) FROM iotime
                WHERE tim < CAST('8:00' AS TIME)
                GROUP BY id
                HAVING id = e.id);