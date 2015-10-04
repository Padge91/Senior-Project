__author__ = 'nicholaspadgett'

#queries to get information on item
#should return an Item object
from ItemClass import *
from CommentORM import *
from DataSource import *

class ItemORM(object):

    #get everything on item, including comments
    def get_full_item(self,query_params):
        query = self.build_query(query_params)
        rows = select_query(query)
        response_object = self.convert_row_to_FullItem(rows)

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
        return response_objects

    #convert rows to objects
    def convert_rows_to_SimpleItem(self,rows):
        response_objects = []
        for i in range(0,len(rows)):
            response_objects.append(SimpleItem(rows[i]))
            response_objects[i].genres = self.get_item_genres(response_objects[i].id)

        return response_objects

    #convert rows to objects
    def convert_row_to_FullItem(self,rows):
        return FullItem(rows[0])

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

        return query