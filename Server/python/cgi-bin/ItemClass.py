__author__ = 'nicholaspadgett'

import json

class SimpleItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]
        self.genres = list()

    def jsonify(self):
        return self.__dict__

class FullItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]
        self.comments = list()
        self.genres = list()

    def jsonify(self):
        obj = dict()
        obj["id"] = self.id
        obj["title"] = self.title
        obj["description"] = self.description
        obj["creator"] = self.creator
        obj["genres"] = self.genres

        if self.comments is not None:
            obj["comments"] = json.dumps([object.jsonify() for object in self.comments])
        return obj
