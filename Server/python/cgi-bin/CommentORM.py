__author__ = 'nicholaspadgett'

from DataSource import *
from CommentClass import *
from userUtils import *
import datetime

class CommentORM(object):

    def get_comments_on_item(self,params):
        response_objects = []

        query = self.build_comment_ids_query(params)
        rows = select_query(query)

        for i in range(0, len(rows)):
            new_query = self.build_comments_query({"id":rows[i][0]})
            new_rows = select_query(new_query)

            response_objects += self.convert_rows_to_FullComment(new_rows)

        #have list of objects, now need to fill in extra properties for each object
        self.build_comment_objects(response_objects, params["item_id"])
        self.order_by_date(response_objects)
        return response_objects

    def order_by_date(self, objects):
        objects.sort(key=lambda x:x.create_date, reverse=True)

    def build_comment_objects(self, response_objects, item_id):
        for comment in response_objects:
            comment.user_name = self.add_username_to_comment(comment.user_id)
            comment.item_id = item_id
            comment.user_review = self.add_user_review_to_comment(comment.user_id, comment.item_id)
            comment.comment_rating = self.add_rating_to_comment(comment.id)
            comment.child_comments = self.get_child_comments(comment.id, item_id)

    def get_child_comments(self, comment_id, item_id):
        response_objects = []
        #get list of comment id whose parents are comment id param
        query = "select child_id from comment_parents where parent_id={0}".format(comment_id)
        rows = select_query(query)

        for i in range(0, len(rows)):
            new_query = self.build_comments_query({"id":rows[i][0]})
            new_rows = select_query(new_query)

            response_objects += self.convert_rows_to_FullComment(new_rows)

        self.build_comment_objects(response_objects, item_id)
        return response_objects


    def add_user_review_to_comment(self, user_id, item_id):
        query = "select review_value from item_reviews where item_id={0} and user_id={1}".format(item_id, user_id)
        rows = select_query(query)

        if len(rows) > 0:
            return rows[0][0]
        else:
            return None

    def add_rating_to_comment(self, comment_id):
        query = "select SUM(rating) as sum, COUNT(rating) as count from comment_ratings where comment_id={0} group by rating".format(comment_id)
        rows = select_query(query)

        if len(rows) > 0:
            pos = int(rows[0][0])
            count = int(rows[0][1])
            neg = 0 - (count - pos)

            return pos+neg
        else:
            return 0

    def add_username_to_comment(self, user_id):
        query = "select username from users where id={0}".format(user_id)
        rows = select_query(query)

        return rows[0][0]

    #create full comment object
    def convert_rows_to_FullComment(self, rows):
        response_objects = []
        for i in range(0,len(rows)):
            response_objects.append(FullComment(rows[i]))

        return response_objects

    #build query
    def build_comment_ids_query(self, query_params):
        item = "item_id"
        query = "select comment_id from item_comments where item_id={0}".format(query_params[item])
        #raise Exception(query)
        return query

     #build query
    def build_comments_query(self, query_params):
        query = "select id, user_id, create_date, content from comments where "
        iterator = 0
        for item in query_params:

            iterator += 1
            if iterator > 1:
                query += " and "

            query += " {0} like '%{1}%'".format(item, query_params[item])

        return query

    def add_comment(self, form):
        format = '%Y-%m-%d %H:%M:%S'
        parent_type = form["parent_type"]
        parent_id = form["parent_id"]
        user_id = get_user_id_from_session(form)
        content = form["content"]

        check_query=""
        if parent_type=="comment":
            check_query = "select id from comments where id={0}".format(parent_id)
        elif parent_type=="item":
            check_query = "select id from items where id={0}".format(parent_id)
        else:
            raise Exception("parent_type must be either 'comment' or 'item'")

        response = select_query(check_query)
        if len(response) < 1:
            raise Exception("Parent object not found")

        query = "insert into comments (user_id, create_date, content) values ({0}, '{1}', '{2}')".format(user_id, datetime.datetime.now().strftime(format), content)
        insert_query(query)

        get_id_query = "select id from comments where user_id={0} and create_date='{1}' and content='{2}'".format(user_id, datetime.datetime.now().strftime(format), content)
        results = select_query(get_id_query)
        if len(results) < 1:
            raise Exception("Error saving comment.")
        comment_id = results[0][0]

        parent_query = ""
        if parent_type == "comment":
            parent_query = "insert into comment_parents (parent_id, child_id) values ({0}, {1})".format(parent_id, comment_id)
        elif parent_type == "item":
            parent_query = "insert into item_comments (item_id, comment_id) values ({0}, {1})".format(parent_id, comment_id)
        else:
            raise Exception("parent_type must be either 'comment' or 'item'")

        insert_query(parent_query)
        return True

    def rate_comment(self, form):
        user_id = get_user_id_from_session(form)
        comment_id = form["comment_id"]
        rating = form["rating"]

        if rating == "true":
            rating = True
        elif rating == "false":
            rating = False
        else:
            raise Exception("Rating field must be either 'true' or 'false'")

        item_query = "select id from comments where id={0}".format(comment_id)
        results = select_query(item_query)
        if len(results) < 1:
            raise Exception("Comment not found")

        get_rating_query = "select id from comment_ratings where user_id={0} and comment_id={1}".format(user_id, comment_id)
        results = select_query(get_rating_query)
        new_query = ""
        if len(results) > 0:
            local_id = results[0][0]
            #do update
            new_query="update comment_ratings set rating={0} where user_id={1} and comment_id={2}".format(rating, user_id, comment_id)
        else:
            #do insert
            new_query="insert into comment_ratings (user_id, comment_id, rating) values ({0}, {1}, {2})".format(user_id, comment_id, rating)

        insert_query(new_query)
        return True