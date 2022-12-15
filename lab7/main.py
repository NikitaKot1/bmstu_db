import sqlalchemy
from sqlalchemy import create_engine, select, insert, update, delete, func
from sqlalchemy.orm import Session, sessionmaker, class_mapper

from json import dumps, load

from models import Beer, Manufacturer, Factory, Consumer, Buying, BeerFacory, BeerManuf


# LINQ to Object
# 1. Вывести список всех марок пива
def get_name_beer(session):
    data = session.query(Beer).all()
    for row in data:
        print(row.mark)


# 2. Вывести все заводы, производящие пиво Brothers Schumacher
def get_some_factory(session):
    data = session.query(BeerFacory).join(BeerFacory.factory_rel).order_by(Factory.id).all()
    for row in data:
        if (row.mark == "Brothers Schumacher"):
            print(row.factory)


# 3. Вывести средную цену пива
def get_avg_price(session):
    data = session.query(func.avg(Beer.price).label("avg"))
    for row in data:
        print(row.avg)


# 4. Вывести количество марок у каждого производителя
def get_count_beer(session):
    data = session.query(
        Manufacturer.id.label("manuf"),
        func.count(BeerManuf.mark).label("marks")
    ).join(BeerManuf).group_by(Manufacturer.id).order_by(Manufacturer.id).all()
    for row in data:
        print((row.manuf, row.marks))


# 5. Вывести производителя и его пешки-заводы
def get_man_fac(session):
    data = session.query(
        Manufacturer.id,
        Factory.id,
    ).filter(
        Manufacturer.id == Factory.masterr,
    )
    for row in data:
        print(row)


# LINQ to JSON
# 1. Запись в Json

def serialize_all(model):

    columns = [c.key for c in class_mapper(model.__class__).columns]
    return dict((c, getattr(model, c)) for c in columns)


def beer_to_json(session):
    serialized_labels = [
        serialize_all(label)
        for label in session.query(Beer).all()
    ]

    for dt in serialized_labels:
        dt["mark"] = str(dt["mark"])

    with open('beer.json', 'w') as f:
        f.write(dumps(serialized_labels, indent=4))


def read_json():
    with open('beer.json') as f:
        patient = load(f)

    for p in patient:
        print(p)

    # LINQ to SQL


# 1. Однотабличный запрос на выборку. (Марку пива)
def select_mark_beers(session):
    res = session.execute("""
        SELECT mark
        FROM beer_table
    """)

    for g in res:
        print(g)


# 2. Многотабличный запрос на выборку. (Вывести марки производителя и его пешки-заводы)

def select_manuf_fac(session):
    res = session.execute("""
        SELECT m.id, f.id
        FROM manufacturer_table m
        JOIN factory_table f ON m.id = f.masterr
    """)
    for pl in res:
        print(pl)


# 3. Добавление данных в таблицу  insert into beer
def insert_into_beer(session):
    try:
        mark = input("Марка: ")
        session.execute(
            insert(Beer).values(
                mark=mark
            )
        )
        session.commit()
        print("Данные успешно добавлены!")
    except:
        print("error input data")
        return


# Обновление данных update beer
def select_beer_all(session):
    data = session.query(Beer).all()
    for d in data:
        print(d.mark, d.alko, d.volume, d.price)


# Обновление данных update tp.games
def update_beer(session):
    mark = input("Марка: ")
    alko = float(input("Содержание алкоголя: "))
    volume = float(input("Объем: "))
    price = int(input("Цена: "))

    exists = session.query(
        session.query(Beer).filter(Beer.mark == mark).exists()
    ).scalar()

    if not exists:
        print("Такого пива нет!")
        return

    session.execute(
        update(Beer).where(Beer.mark == mark).values(alko=alko, volume=volume, price=price)
    )
    session.commit()
    print("Данные успешно измененны!")


# Удаление данных delete tp.games
def delete_beer(session):
    mark = input("Марка: ")

    exists = session.query(
        session.query(Beer).filter(Beer.mark == mark).exists()
    ).scalar()

    if not exists:
        print("Такого пива нет!")
        return

    session.execute(
        delete(Beer).where(Beer.mark == mark)
    )
    session.commit()
    print("Данные успешно удалены!")


# 4. Вызов функци
def call_func(session):
    data = session.execute(f"SELECT current_timestamp").all()
    for row in data:
        print(row)



MSG = "Меню\n\n" \
      "--------- LINQ_to_Object -------------- \n" \
      "5 запросов созданные для проверки LINQ\n" \
      "1. Вывести список всех марок пива\n" \
      "2. Вывести все заводы, производящие пиво Brothers Schumacher \n" \
      "3. Вывести средную цену пива \n" \
      "4. Вывести количество марок у каждого производителя \n" \
      "5. Вывести производителя и его пешки-заводы \n" \
      "\n--------- LINQ_to_JSON -------------- \n" \
      "6. Запись в JSON документ. \n" \
      "7. Чтение из JSON документа. \n" \
      "8. Обновление JSON документа. \n" \
      "--------- LINQ_to_SQL -------------- \n" \
      "\nСоздать классы сущностей, которые моделируют таблицы Вашей базы данных\n" \
      "9. Однотабличный запрос на выборку. (Марку пива)\n" \
      "10. Многотабличный запрос на выборку. (Вывести марки производителя и его пешки-заводы)\n" \
      "Три запроса на добавление, изменение и удаление данных в базе данных\n" \
      "11. Добавление данных в таблицу  insert into beer\n" \
      "12. Обновление данных update beer\n" \
      "13. Удаление данных delete beer\n" \
      "14. Select * from beer\n" \
      "\nПолучение доступа к данным, выполняя только хранимую процедуру\n" \
      "15. Вызов функции\n" \
      "\n0. Выход \n\n" \
      "Выбор: "


def input_command():
    try:
        command = int(input(MSG))
        print()
    except:
        command = -1

    if command < 0 or command > 15:
        print("\nОжидался ввод целого числа от 0 до 15")

    return command


def main():
    print("Версия SQL Alchemy:", sqlalchemy.__version__)

    engine = create_engine(
        f'postgresql://postgres:postgres@localhost:5432/beer',
        pool_pre_ping=True)
    try:
        engine.connect()
        print("БД под именнем  tp успешно подключена!")
    except:
        print("Ошибка соединения к БД!")
        return

    Session = sessionmaker(bind=engine)
    session = Session()
    command = -1

    while command != 0:
        command = input_command()

        if command == 1:
            get_name_beer(session)
        elif command == 2:
            get_some_factory(session)
        elif command == 3:
            get_avg_price(session)
        elif command == 4:
            get_count_beer(session)
        elif command == 5:
            get_man_fac(session)
        elif command == 6:
            beer_to_json(session)
        elif command == 7:
            read_json()
        elif command == 8:
            print()
        elif command == 9:
            select_mark_beers(session)
        elif command == 10:
            select_manuf_fac(session)
        elif command == 11:
            insert_into_beer(session)
        elif command == 12:
            update_beer(session)
        elif command == 13:
            delete_beer(session)
        elif command == 14:
            select_beer_all(session)
        elif command == 15:
            call_func(session)
        else:
            continue


if __name__ == "__main__":
    main()