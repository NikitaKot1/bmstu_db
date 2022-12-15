from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, Float, ForeignKey, Text, Numeric, CheckConstraint, Date, JSON
from sqlalchemy import PrimaryKeyConstraint

BASE = declarative_base()

class Beer(BASE):
    __tablename__ = 'beer_table'
    mark = Column(Text, primary_key=True)
    alko = Column(Float, nullable=False)
    volume = Column(Float, nullable=False)
    price = Column(Integer, nullable=False)

class Manufacturer(BASE):
    __tablename__ = 'manufacturer_table'
    id = Column(Integer, primary_key=True)
    turnover = Column(Float, nullable=False)
    profit = Column(Float, nullable=False)
    foundation = Column(Integer, nullable=False)

class Factory(BASE):
    __tablename__ = 'factory_table'
    id = Column(Integer, primary_key=True)
    volume = Column(Float, nullable=False)
    country = Column(Text, nullable=False)
    masterr = Column(Integer, ForeignKey('manufacturer_table.id'))

class Consumer(BASE):
    __tablename__ = 'consumers_table'
    id = Column(Integer, primary_key=True)
    full_name = Column(Text, nullable=False)
    gender = Column(Text, nullable=False)
    lovely_beer = Column(Text, ForeignKey('beer_table.mark'))
    birth = Column(Text, nullable=False)

class Buying(BASE):
    __tablename__ = 'buying_table'
    id = Column(Integer, primary_key=True)
    consumer = Column(Integer, ForeignKey('consumers_table.id'))
    mark = Column(Text, ForeignKey('beer_table.mark'))
    price = Column(Integer, nullable=False)
    byuing_date = Column(Date, nullable=False)

class BeerManuf(BASE):
    __tablename__ = 'beer_manuf_table'
    mark = Column(Text, ForeignKey('beer_table.mark'), primary_key=True)
    manufacturer = Column(Integer, ForeignKey('manufacturer_table.id'), primary_key=True)

class BeerFacory(BASE):
    __tablename__ = 'beer_factory_table'
    mark = Column(Text, ForeignKey('beer_table.mark'), primary_key=True)
    factory = Column(Integer, ForeignKey('factory_table.id'), primary_key=True)

    factory_rel = relationship("Factory", foreign_keys=[factory])
