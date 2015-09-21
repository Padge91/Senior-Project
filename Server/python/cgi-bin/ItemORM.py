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
        response_object.comments = comment_orm.get_comments_on_item(response_object.id)

        return response_object

    #returns array of basic item information
    def search_items(self, query_params):
        query = self.build_query(query_params)
        rows = select_query(query)
        response_objects = self.convert_rows_to_SimpleItem(rows)
        return response_objects

    #convert rows to objects
    def convert_rows_to_SimpleItem(self,rows):
        response_objects = []
        for i in range(0,len(rows)):
            response_objects.append(SimpleItem(rows[i]))

        return response_objects

    #convert rows to objects
    def convert_row_to_FullItem(self,rows):
        return FullItem(rows[0])

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