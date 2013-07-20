from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

engine = create_engine('postgres://bmoore:bmoore@localhost:5432/bmoore', echo=True)

Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

Base = declarative_base()
