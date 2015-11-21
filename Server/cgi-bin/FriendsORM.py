__author__ = 'nicholaspadgett'

from Utilities import *
from userUtils import *
from UserClass import *

class FriendsORM(object):
    def search_friends(self,form):
        email = form["email_string"]
        name = form["name_string"]

        name_query = "username like '%{0}%'".format(name)
        email_query = "email like '%{0}%'".format(email)
        if email == "None":
            email = ""
        if name == "None":
            name = ""
        if email == "" and name == "":
            raise Exception("Either email or name must have a value")

        query2 = ""
        if len(email) == 0 or len(name) == 0:
            query2 = name_query + " or " + email_query
        elif len(email) > 0:
            query2 = email_query
        elif len(name) > 0:
            query2 = name_query

        query = "select id, username, email, image from users where " + query2
        results = select_query(query)
        users = self.convert_rows_to_users(results)

        return users

    def convert_rows_to_users(self, rows):
        users = []
        for row in rows:
            users.append(User(row))

        return users

    def add_friend(self, form):
        curr_user_id = get_user_id_from_session(form)
        other_user_id = form["user_id"]

        if int(curr_user_id) == int(other_user_id):
            raise Exception("You can not be a friend to yourself")

        alrdy_f_query = "select user_id, friend_id from user_friends where user_id={0} and friend_id={1}".format(curr_user_id, other_user_id)
        results = select_query(alrdy_f_query)
        if len(results) > 0:
            raise Exception("You are already friends with this user")

        query = "insert into user_friends (user_id, friend_id) values ({0},{1})".format(curr_user_id, other_user_id)
        insert_query(query)

        return True

    def remove_friend(self, form):
        curr_user_id = get_user_id_from_session(form)
        other_user_id = form["user_id"]

        query = "delete from user_friends where user_id={0} and friend_id={1}".format(curr_user_id, other_user_id)
        insert_query(query)

        return True

    def list_friends(self, form):
        view_user = form["user_id"]

        #get user ids from friends list
        get_ids_query = "select id, username, email, image from users where id in (select friend_id from user_friends where user_id={0})".format(view_user)
        results = select_query(get_ids_query)

        users = self.convert_rows_to_users(results)

        return users;

    def is_my_friend(self, form):
        user = get_user_id_from_session(form)
        friend = form["user_id"]

        query = "select user_id, friend_id from user_friends where user_id = {0} and friend_id = {1}".format(user, friend)
        results = select_query(query)
        if len(results) > 0:
            return True
        else:
            return False