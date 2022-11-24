-- gavrilovajm@bmstu.ru

-- ВАР 3 (4)

DROP TABLE IF EXISTS emplee CASCADE;
CREATE TABLE IF NOT EXISTS emplee
(
    id INT NOT NULL PRIMARY KEY,
    full_name TEXT,
    born_year INT,
    stajj INT,
    phone TEXT,
    idPost INT,
    FOREIGN KEY (idPost) REFERENCES post(id)
);

DROP TABLE IF EXISTS shift CASCADE;
CREATE TABLE IF NOT EXISTS shift
(
    id INT NOT NULL PRIMARY KEY,
    shift_date DATE,
    working_hours TEXT
);

DROP TABLE IF EXISTS post CASCADE;
CREATE TABLE IF NOT EXISTS post
(
    id INT NOT NULL PRIMARY KEY,
    name TEXT,
    adress TEXT
);

DROP TABLE IF EXISTS emp_shift CASCADE;
CREATE TABLE IF NOT EXISTS emp_shift
(
    idEmp INT,
    idShift INT,
    FOREIGN KEY (idEmp) REFERENCES emplee(id),
    FOREIGN KEY (idShift) REFERENCES shift(id)
);


INSERT INTO shift VALUES (1, NOW(), '8:00-20:00');
INSERT INTO shift VALUES (2, NOW(), '7:00-22:00');
INSERT INTO shift VALUES (3, NOW(), '8:00-15:00');
INSERT INTO shift VALUES (4, NOW(), '9:00-20:00');
INSERT INTO shift VALUES (6, NOW(), '0:00-20:00');
INSERT INTO shift VALUES (5, NOW(), '8:00-7:00');
INSERT INTO shift VALUES (7, NOW(), '10:00-20:00');
INSERT INTO shift VALUES (8, NOW(), '8:00-23:00');
INSERT INTO shift VALUES (9, NOW(), '4:00-16:00');
INSERT INTO shift VALUES (10, NOW(), '8:00-21:00');

SELECT * FROM shift;

INSERT INTO post VALUES (1, 'post1', '8:00-20:00');
INSERT INTO post VALUES (2, 'post2', '7:00-22:00');
INSERT INTO post VALUES (3, 'post3', '8:00-15:00');
INSERT INTO post VALUES (4, 'post4', '9:00-20:00');
INSERT INTO post VALUES (5, 'post5', '0:00-20:00');
INSERT INTO post VALUES (6, 'post6', '8:00-7:00');
INSERT INTO post VALUES (7, 'post7', '10:00-20:00');
INSERT INTO post VALUES (8, 'post8', '8:00-23:00');
INSERT INTO post VALUES (9, 'post9', '4:00-16:00');
INSERT INTO post VALUES (10, 'post10', '8:00-21:00');

SELECT * FROM post;

INSERT INTO emplee VALUES (1, 'ira',2000, 4, '000000000', 2);
INSERT INTO emplee VALUES (2, 'ivan', 2002, 4, '123456789', 1);
INSERT INTO emplee VALUES (3, 'neket', 1967, 4, '987654321', 1);
INSERT INTO emplee VALUES (4, 'olga', 2010, 6, '01010101010', 2);
INSERT INTO emplee VALUES (5, 'ivan vasilevix', 1990, 6, '02020202020', 3);
INSERT INTO emplee VALUES (6, 'osterix', 1500, 120, '23223232323', 5);
INSERT INTO emplee VALUES (7, 'obelix', 2002, 5, '33322233223', 5);
INSERT INTO emplee VALUES (8, 'pantific salivan', 2002, 4, '99999999', 8);
INSERT INTO emplee VALUES (9, 'aposxerox', 1999, 1, '880005553535', 3);
INSERT INTO emplee VALUES (10, 'prosto horoshii chelovek', 1999, 1, '890000000', 10);

SELECT * FROM emplee;

INSERT INTO emp_shift VALUES (1, 2);
INSERT INTO emp_shift VALUES (2, 7);
INSERT INTO emp_shift VALUES (3, 7);
INSERT INTO emp_shift VALUES (4, 5);
INSERT INTO emp_shift VALUES (5, 7);
INSERT INTO emp_shift VALUES (6, 3);
INSERT INTO emp_shift VALUES (7, 5);
INSERT INTO emp_shift VALUES (8, 8);
INSERT INTO emp_shift VALUES (9, 10);
INSERT INTO emp_shift VALUES (10, 9);
INSERT INTO emp_shift VALUES (7, 9);

SELECT * FROM emp_shift;


-- TASK 2

--запрос определяет среди сотрудников их статус и выводит id сотрудников и, соотв, их статус

SELECT id, stajj,
    CASE 
        WHEN stajj < 3 THEN 'junior'
        WHEN stajj > 6 THEN 'senior'
        ELSE 'middle'
    END AS persp
FROM emplee;

-- поставить на дежурство №10 самого молоденького
UPDATE emp_shift
SET idEmp = (
            SELECT id FROM emplee
            WHERE born_year = (SELECT MAX(born_year) FROM emplee))
WHERE idShift = 10;

SELECT id FROM emplee
WHERE born_year = (SELECT MAX(born_year) FROM emplee)

-- найти все посты где сотрудников несколько человек (хотя бы 2) и кол-во сотрудников
SELECT es.idShift, COUNT(*) FROM 
emplee e JOIN emp_shift es ON e.id = es.idEmp
GROUP BY es.idShift
HAVING COUNT(*) > 1;

--- TASK 3



--создаем процедуру для триггера, она по сути ничего не делает
CREATE OR REPLACE FUNCTION new_empl()
RETURNS TRIGGER AS
$$
    BEGIN
        RAISE NOTICE 'hellow fellow!';
    END;
$$ LANGUAGE 'plpgsql';

--create ddl
CREATE TRIGGER ddl_empl
AFTER INSERT ON emplee
FOR EACH ROW EXECUTE PROCEDURE new_empl();


CREATE OR REPLACE PROCEDURE destoroy(
    n OUT INT
)
LANGUAGE 'plpgsql'
AS $$
    DECLARE rec RECORD;
    BEGIN
        n := 0;
        FOR rec IN SELECT * FROM pg_trigger WHERE tgtype = 5 LOOP
            EXECUTE 'drop trigger ' || rec.tgname || ' on ' || rec.tgrelid::regclass;
            n := n + 1;
        END LOOP;
    END;
$$;

CALL destoroy(0);

SELECT * from pg_trigger