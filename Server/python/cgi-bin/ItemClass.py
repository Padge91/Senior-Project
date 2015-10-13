__author__ = 'nicholaspadgett'

import json

class SimpleItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]
        self.image = ""
        self.genres = list()


    def jsonify(self):
        return self.__dict__

class FullItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]
        self.image = ""
        self.comments = list()
        self.genres = list()

    def jsonify(self):
        obj = dict()
        obj["id"] = self.id
        obj["title"] = self.title
        obj["description"] = self.description
        obj["creator"] = self.creator
        obj["genres"] = self.genres
        obj["image"] = self.image

        if self.comments is not None:
            obj["comments"] = [object.jsonify() for object in self.comments]
        return obj
