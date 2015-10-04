__author__ = 'nicholaspadgett'

import json

class Library(object):
    def __init__(self, row):
        self.id = row[0]
        self.name = row[1]
        self.user_id = row[2]

    def jsonify(self):
        return self.__dict__