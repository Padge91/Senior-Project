__author__ = 'nicholaspadgett'

from DataSource import *
from CommentClass import *

#issues
#test user review

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
        return response_objects

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
        query = "select item_comments.comment_id from item_comments, comment_parents where item_comments.{0} = {1} and comment_parents.parent_id = item_comments.comment_id".format(item, query_params[item])
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