__author__ = 'nicholaspadgett'

#queries to get information on item
#should return an Item object
from ItemClass import *
from CommentORM import *
from DataSource import *

class ItemORM(object):

    #get everything on item, including comments
    def get_full_item(self,query_params):
        query = self.build_query({"id":query_params["id"]})
        rows = select_query(query)
        if len(rows) < 1:
            raise Exception("Item not found.")

        response_object = self.convert_row_to_FullItem(rows, query_params)

        #add comments to the object
        comment_orm = CommentORM()
        response_object.genres = self.get_item_genres(response_object.id)
        response_object.comments = comment_orm.get_comments_on_item({"item_id":response_object.id})

        return response_object

    def get_item_genres(self, id):
        query = "select name from genres where id in (select genre_id from item_genres where item_id={0})".format(id)
        response_object = []
        rows = select_query(query)
        for i in range(0, len(rows)):
            response_object.append(rows[i][0])

        return response_object

    #returns array of basic item information
    def search_items(self, query_params, option=None):
    
        if option is None:
            query = self.build_query(query_params)
        else:
            query = self.build_query_or(query_params)
        rows = select_query(query)

        response_objects = self.convert_rows_to_SimpleItem(rows)
        self.add_images_to_item(response_objects)

        return response_objects


    def get_scores(self, item_id, user_id=None):
        item_query = "select item_id,AVG(review_value) from item_reviews where item_id={0}".format(item_id)

        average_score = 0
        user_score = None
        item_results = select_query(item_query)
        if len(item_results) > 0 and item_results[0][1] != None:
            average_score = item_results[0][1]

        if user_id is not None:
            user_query = "select review_value from item_reviews where item_id={0} and user_id={1}".format(item_id, user_id)
            user_results = select_query(user_query)
            if len(user_results) > 0:
                user_score = user_results[0][0]

        return {"item_score":average_score, "user_score":user_score}


    def add_images_to_item(self, objects):
        for i in range(0, len(objects)):
            #raise Exception(objects[i].id)
            query = "select image_url from item_images where item_id={0}".format(objects[i].id)
            results = select_query(query)
            if len(results) > 0:
                objects[i].image = results[0][0]

    #convert rows to objects
    def convert_rows_to_SimpleItem(self,rows):
        response_objects = []
        for i in range(0,len(rows)):
            response_objects.append(SimpleItem(rows[i]))
            response_objects[i].genres = self.get_item_genres(response_objects[i].id)

        return response_objects

    #convert rows to objects
    def convert_row_to_FullItem(self, rows, params):
        comment_orm = CommentORM()
        item = FullItem(rows[0])

        item.genres = self.get_item_genres(item.id)
        item.comments = comment_orm.get_comments_on_item({"item_id":item.id})
        score_results = self.get_scores(item.id)
        item.average_score = score_results["item_score"]
        item.user_score = self.get_user_score(params)

        self.add_images_to_item([item])

        return item

    def get_user_score(self, params):
        item_id = params["id"]
        session = params["session"]
        user_id = get_user_id_from_session_no_error(params)
        if user_id is None:
            return None

        check_query = "select id from items where id={0}".format(item_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Item not found")

        check_query = "select id from items where id={0}".format(item_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Item not found")

        query = "select review_value from item_reviews where item_id={0} and user_id={1}".format(item_id, user_id)
        response = select_query(query)
        if len(response) < 1:
            return None
        else:
            return response[0][0]


    def convert_row_to_FullItemWholeRow(self,row):
        return FullItem(row)

    def build_search_query(self, params, genres):
        query = "select id, title, description, creator from items where "
        # copy the title into creator also
        #do 'or' on title and creator
        #get id's on each item and get their genres
        #filter on genres

    #build query
    def build_query(self, query_params):
        query = "select id, title, description, creator from items where "
        iterator = 0
        for item in query_params:

            iterator += 1
            if iterator > 1:
                query += " and "

            query += " {0} like '%{1}%'".format(item, query_params[item])

        query += " limit 10"

        return query

    #build query
    def build_query_or(self, query_params):
        query = "select id, title, description, creator from items where "
        iterator = 0
        for i in query_params:

            iterator += 1
            if iterator > 1:
                query += " or "

            query += " {0} like '{1}'".format("id", i["id"])

        query += " limit 10"

        return query

    def add_score(self, query_params):
        max_score = 5

        user_id = get_user_id_from_session(query_params)
        item_id = query_params["item_id"]
        score = query_params["score"]

        check_query = "select id from items where id={0}".format(item_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Item not found")

        if int(score) < 0 or int(score) > max_score:
            raise Exception("Score must be between 0 and " + str(max_score))

        check_query = "select id from item_reviews where item_id={0} and user_id={1}".format(item_id, user_id)
        results = select_query(check_query)
        if len(results) > 0:
            return self.replace_score(query_params)
        else:
            query = "insert into item_reviews (item_id, user_id, review_value) values ({0}, {1}, {2})".format(item_id, user_id, score)
            insert_query(query)
            return True

    def replace_score(self,query_params):
        max_score = 5

        user_id = get_user_id_from_session(query_params)
        item_id = query_params["item_id"]
        score = query_params["score"]

        query = "update item_reviews set review_value={0} where item_id={1} and user_id={2}".format(score, item_id, user_id)
        insert_query(query)
        return True
