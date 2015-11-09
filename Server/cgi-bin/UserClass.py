__author__ = 'nicholaspadgett'

class User(object):
    def __init__(self,row):
        self.id = row[0]
        self.username = row[1]
        self.email = row[2]

    def jsonify(self):
        return self.__dict__
