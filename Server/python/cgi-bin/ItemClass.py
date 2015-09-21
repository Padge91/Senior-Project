__author__ = 'nicholaspadgett'

class SimpleItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]

class FullItem(object):
    def __init__(self, row):
        self.id = row[0]
        self.title = row[1]
        self.description = row[2]
        self.creator = row[3]
        self.comments = []