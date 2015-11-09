__author__ = 'nicholaspadgett'

from LibraryClass import *
from ItemORM import *
from userUtils import *


class LibraryORM(object):
    def get_items_from_library(self,form):
        library_id = form["library_id"]
        user_id = form["user_id"]

        check_query = "select id from libraries where id={0}".format(library_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Library not found.")

        #check if library is visible or if it is owned by user
        is_library_viewable=self.check_if_library_visible(library_id,user_id)
        if not is_library_viewable:
            raise Exception("Library is private")

        item_list = self.get_items_in_library(library_id)

        return item_list

    def get_items_in_library(self,library_id):
        query = "select item_id from library_items where library_id={0}".format(library_id)
        response = select_query(query)
        options = []

        if len(response) < 1:
                return []

        item_orm = ItemORM()
        for i in range(0, len(response)):
            options.append({"id":response[i][0]})

        results = item_orm.search_items(options, 1)
        return results

    def check_if_library_visible(self, library_id, user_id):
        query = "select user_id, visible from libraries where id={0}".format(library_id)
        response = select_query(query)
        if response[0][1] == 1:
            return True
        elif response[0][0] == user_id:
            return True
        else:
            return False

    def get_user_libraries(self, form):
        user_id = form["user_id"]
        current_user_id = form["current_user_id"]

        check_query = "select id from users where id={0}".format(user_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("User not found.")

        query = "select id,library_name, user_id, visible from libraries where user_id={0}".format(user_id)
        results = select_query(query)
        return self.get_libraries_from_response(results)

    def get_libraries_from_response(self, rows):
        results = []
        for i in range(0, len(rows)):
            if rows[i][3] == True:
                results.append(Library(rows[i]))

        return results

    def remove_item_from_library(self, form):
        item_id = form["item_id"]
        library_id = form["library_id"]
        user_id = form["user_id"]

        check_query = "select id from items where id={0}".format(item_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Item not found")

        check_query = "select id from libraries where id={0}".format(library_id)
        results = select_query(check_query)
        if len(results) < 1:
            raise Exception("Library not found")

        #make sure user owns library
        query = "select id, user_id from libraries where id={0} and user_id={1}".format(library_id, user_id)
        results = select_query(query)
        if len(results) == 0:
            raise Exception("You do not have access to modify this library")

        #remove item form library
        args = {"library_id":library_id,"item_id":item_id}
        query = "delete from library_items where library_id=%(library_id)s and item_id=%(item_id)s"
        insert_query(query, args)

        return True

    def create_library(self, form):
        session = form["session"]
        library_name = form["library_name"]
        visible = form["visible"]

        if visible == "true":
            visible = True
        else:
            visible = False

        user_id = get_user_id_from_session(form)

        existing_query = "select * from libraries where user_id={0} and library_name='{1}'".format(user_id, library_name)
        results = select_query(existing_query)
        if len(results) > 0:
            raise Exception("You already have an existing library with that name")

        query = "insert into libraries (user_id, library_name, visible) values({0}, '{1}', {2})".format(user_id,library_name,visible)
        insert_query(query)
        return True

    def add_item_to_library(self, form):
        user_id = get_user_id_from_session(form)
        library_id = form["library_id"]
        item_id = form["item_id"]

        ownership_query = "select * from libraries where id={0} and user_id={1}".format(library_id, user_id)
        results = select_query(ownership_query)
        if len(results) < 1:
            raise Exception("Library not found")

        item_query = "select id from items where id={0}".format(item_id)
        results = select_query(item_query)
        if len(results) < 1:
            raise Exception("Item not found")

        existing_query = "select * from library_items where library_id={0} and item_id={1}".format(library_id, item_id)
        results = select_query(existing_query)
        if len(results) > 0:
            raise Exception("Item already in library")

        query = "insert into library_items (library_id, item_id) values ({0}, {1})".format(library_id, item_id)
        insert_query(query)
        return True

    def update_library(self, form):
        library_name = form["new_name"]
        visibility = form["new_visibility"]

        #get user
        user_id = get_user_id_from_session(form)

        #make sure user owns library
        library_id = form["library_id"]
        query = "select library_name from libraries where id={0} and user_id={1}".format(library_id, user_id)
        results = select_query(query)
        if len(results) < 1:
            raise Exception("You do not have permission to modify this library")

        #update fields
        update_query = "update libraries set library_name='{0}', visible={1} where id={2}".format(library_name, visibility, library_id)
        insert_query(update_query)

        return True