__author__ = 'nicholaspadgett'

from EscapeChars import *

class SimpleItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.image = "http://52.88.5.108/notfound.png"
        self.type = row[3]

    def jsonify(self):
        return self.__dict__

class FullItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = strip_tags(html_unescape(row[1]))
        self.description = strip_tags(html_unescape(row[2]))
        self.type = row[3]
        self.image = "http://52.88.5.108/notfound.png"
        self.comments = list()
        self.genres = list()
        self.average_score = 0
        self.user_score = None

    def jsonify(self):
        obj = self.__dict__

        if self.comments is not None:
            obj["comments"] = [object.jsonify() for object in self.comments]
        return obj
