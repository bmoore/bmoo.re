from sqlalchemy import Column, Integer, String
from models import Base

class Post(Base):
    __tablename__ = 'post'
    id = Column(Integer, primary_key=True)
    title = Column(String)
    body = Column(String)

    def __init__(self, title, body):
        self.title = title
        self.body = body

    def __repr__(self):
        return "<Post '%s'>" % self.title

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
