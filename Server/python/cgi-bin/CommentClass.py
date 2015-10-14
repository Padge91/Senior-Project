__author__ = 'nicholaspadgett'

import json
from EscapeChars import *

class FullComment(object):
    def __init__(self, row):
        self.id = row[0]
        self.user_id = row[1]
        self.create_date = row[2]
        self.content = strip_tags(html_unescape(row[3]))
        self.item_id = None
        self.user_name = None
        self.user_review = None
        self.comment_rating = None
        self.child_comments = list()

    def jsonify(self):
        obj = dict()
        obj["id"] = self.id
        obj["user_id"] = self.user_id
        obj["create_date"] = str(self.create_date)
        obj["content"] = self.content
        obj["item_id"] = self.item_id
        obj["user_name"] = self.user_name
        obj["user_review"] = self.user_review
        obj["comment_rating"] = self.comment_rating

        if self.child_comments is not None:
            obj["child_comments"] = [object.jsonify() for object in self.child_comments]

        return obj

    def persist(self):
        return "sql";