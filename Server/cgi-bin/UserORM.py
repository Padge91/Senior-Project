__author__ = 'nicholaspadgett'

from userUtils import *
from UserClass import *
from CommentORM import *

class UserORM(object):

    def update_password(self, form):
        user_id = get_user_id_from_session(form)
        new_password = form["newPassword"]
        new_password_confirm = form["newPasswordConfirm"]
        current_password = form["currentPassword"]

        username_query = "select username, password from users where id={0}".format(user_id)
        results = select_query(username_query)
        username = results[0][0]
        password = results[0][1]

        hashed_password = hash_password(username, current_password)
        if password != hashed_password:
            raise Exception("Incorrect Password")

        validate_password(new_password, new_password_confirm)

        new_pw_query = "update users set password='{0}' where id={1}".format(hash_password(username, new_password), user_id)
        insert_query(new_pw_query)
        return True

    def update_email(self, form):
        user_id = get_user_id_from_session(form)
        new_email = form["new_email"]

        check_query = "select id from users where id<>{0} and email='{1}'".format(user_id, new_email)
        results = select_query(check_query)
        if len(results) > 0:
            raise Exception("Email is already taken")

        email_query = "update users set email='{0}' where id={1}".format(new_email, user_id)
        insert_query(email_query)
        return True

    def update_username(self, form):
        user_id = get_user_id_from_session(form)
        new_username = form["username"]

        check_query = "select id from users where id<>{0} and username='{1}'".format(user_id, new_username)
        results = select_query(check_query)
        if len(results) > 0:
            raise Exception("Username is already taken")

        email_query = "update users set username='{0}' where id={1}".format(new_username, user_id)
        insert_query(email_query)
        return True

    def get_current_user_info(self, form):
        user_id = get_user_id_from_session(form)

        user_query = "select id, username, email from users where id={0}".format(user_id)
        results = select_query(user_query)

        user = User(results[0])
        return user

    def get_user_info(self, form):
        user_id = form["user_id"]

        query = "select id, username, email from users where id={0}".format(user_id)
        results = select_query(query)
        user = User(results[0])
        return user

    def get_updates(self, form):
        user_id = get_user_id_from_session(form)
        updates = []

        #get comment replies, order by date
        orm = CommentORM()
        orm.get_replies(user_id, updates)
        return updates
