from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, Float, ForeignKey, Text, Numeric, CheckConstraint, Date, JSON, Time, DateTime
from sqlalchemy import PrimaryKeyConstraint
import sqlalchemy
from sqlalchemy import create_engine, select, insert, update, delete, func
from sqlalchemy.orm import Session, sessionmaker, class_mapper

import datetime

BASE = declarative_base()

class Emp(BASE):
    __tablename__ = 'emploee'
    id = Column(Integer, primary_key=True)
    fullname = Column(Text, nullable=False)
    birth = Column(Date, nullable=False)
    otdel = Column(Text, nullable=False)

class Iot(BASE):
    __tablename__ = 'iotime'
    id = Column(Integer, ForeignKey('emploee.id'), primary_key=True)
    dat = Column(Date, nullable=False)
    tim = Column(Time, nullable=False)
    typ = Column(Integer, nullable=False)
    id_rel = relationship("Emp", foreign_keys=[id])


def get1(session):
    data = session.query(Iot).join(Iot.id_rel).order_by(Emp.id).all()
    dobj = datetime.datetime.strptime("2018-12-14 09:05:00", "%Y-%m-%d %H:%M:%S")
    for row in data:
        if (row.tim < dobj.time()):
            print(row.id, row.tim)

def get3(session):
    data = session.query(Iot).join(Iot.id_rel).filter(Emp.otdel == "Бугалтерия")
    dobj = datetime.datetime.strptime("2018-12-14 08:00:00", "%Y-%m-%d %H:%M:%S")
    for row in data:
        if (row.tim < dobj.time()):
            print(row.id)

def get2(session):
    data = session.query(Iot).join(Iot.id_rel).order_by(Emp.id).all()
    dobj = datetime.datetime.strptime("2018-12-14 00:10:00", "%Y-%m-%d %H:%M:%S")
    idn = []
    tn = []
    for row in data:
        if (row.typ == 1):
            idn.append(row.id)
            tn.append(row.tim)
        if (row.typ == 2):
            for i in range(len(idn)):
                if idn[i] == row.id:
                    if (row.tim - dobj.time() > tn[i]):
                        print(row.id)
                    idn.remove(i)
                    tn.remove(i)



print("Версия SQL Alchemy:", sqlalchemy.__version__)

engine = create_engine(
    f'postgresql://postgres:postgres@localhost:5432/beer',
    pool_pre_ping=True)
try:
    engine.connect()
    print("БД под именнем  tp успешно подключена!")
except:
    print("Ошибка соединения к БД!")

Session = sessionmaker(bind=engine)
session = Session()

get1(session)
get2(session)
get3(session)