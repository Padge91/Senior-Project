__author__ = 'nicholaspadgett'

import random
from DataSource import *
import bcrypt
import uuid
from datetime import *

def get_user_id_from_session(params):
    session = params["session"]
    query = "select user_id from user_sessions where session_id='{0}'".format(session)
    args = {"session":session}
    response = select_query(query)
    if len(response) == 0:
        raise Exception("No session found")
    return response[0][0]

def logout(params):
    session = params["session"]
    remove_session(session)
    return True

def login(params):
    username = params["username"]
    password = params["password"]
    hashed_password = hash_password(username, password)
    response = login_query(username, hashed_password)
    return response

def login_query(username, password):
    query = "select password from users where username='{0}'".format(username)
    response = select_query(query)
    in_password = ""
    if len(response) == 0:
        raise Exception("Account not found")
    in_password = response[0][0];
    if password == in_password:
        return generate_session(username)
    else:
        raise Exception("Password does not match")

def remove_session(session):
    check_query = "select id from user_sessions where session_id='{0}'".format(session)
    results = select_query(check_query)
    if len(results) < 1:
        raise Exception("Already logged out.")

    query = "update user_sessions set session_id=null where session_id=%(session)s;"
    args = {"session":session}
    insert_query(query, args)

def generate_session(username):
    expire = generate_date()
    session = str(uuid.uuid4())
    query = "update user_sessions set session_id=%(session_id)s, session_exp=%(expire)s where user_id=%(user_id)s;"
    args = {"session_id":session, "user_id":get_user_id(username), "expire":expire}
    insert_query(query, args)

    return session

def generate_date():
    d = datetime.now()
    now = {"year":d.year, "month":d.month, "day":1}
    if int(now["month"]) < 12:
        now["month"] = int(now["month"])+1
    else:
        now["month"] = 1
    return datetime.strptime(str(now["day"])+"/"+str(now["month"])+"/"+str(now["year"]), "%d/%m/%Y")

def get_user_id(username):
    query = "select id from users where username='{0}'".format(username)
    response = select_query(query)
    return response[0][0]


def hash_password(username, password):
    return bcrypt.hashpw(password, str(get_salt(username)))

def get_salt(username):
    query = "select salt from users where username='{0}'".format(username)
    results = select_query(query)
    if len(results) == 0:
        raise Exception("Account not found")
    return results[0][0]

def generate_salt():
    return bcrypt.gensalt(10)

def create_account(params):
    validate_password(params["password"], params["passwordConfirm"])
    validate_username_email(params["username"], params["email"])
    id = insert_account_info(params)
    if id is None:
        raise Exception("Error saving account.")

    insert_new_account_libraries(id)

    return True

def insert_new_account_libraries(id):
    library_names = ["Viewed", "Owned", "Wishlist"]

    insert_libraries_query1 = "insert into libraries(user_id, library_name, visible) values ({0}, '{1}', {2})".format(id, library_names[0], 1)
    insert_libraries_query2 = "insert into libraries(user_id, library_name, visible) values ({0}, '{1}', {2})".format(id, library_names[1], 1)
    insert_libraries_query3 = "insert into libraries(user_id, library_name, visible) values ({0}, '{1}', {2})".format(id, library_names[2], 1)

    queries = [insert_libraries_query1, insert_libraries_query2, insert_libraries_query3]

    for i in range(0, len(queries)):
        insert_query(queries[i])


def insert_account_info(params):
    salt = generate_salt()
    hash_pw = bcrypt.hashpw(params["password"], salt)
    query = "insert into users (username, email, password, salt) values (%(username)s,%(email)s,%(password)s,%(salt)s);"
    args = {"username":params["username"], "email":params["email"], "password":hash_pw, "salt":salt}
    insert_query(query, args)

    get_id_query = "select id from users where username = '{0}'".format(params["username"])
    response = select_query(get_id_query)
    id = response[0][0]
    args={"id":id}
    query2 = "insert into user_sessions (user_id) values (%(id)s)"
    insert_query(query2, args)
    return args["id"]

def validate_username_email(username, email):
    query="select username from users where username='{0}'".format(username)
    query2 = "select email from users where email='{0}'".format(email)
    results = select_query(query)
    if len(results) > 0:
        raise Exception("Username already exists.")
    results = select_query(query2)
    if len(results) > 0:
        raise Exception("Email already exists.")


def validate_password(password, confirmPassword):
    check_passwords_same(password, confirmPassword)
    check_password_length(password)
    check_password_characters(password)

def check_passwords_same(password, confirmPassword):
    if password != confirmPassword:
        raise Exception("Passwords are not the same")

def check_password_length(password):
    if len(password) < 8:
        raise Exception("Password must be at least 8 characters long")

def check_password_characters(password):
    numbers = "0123456789"
    capitals = "ABCDEFGHIJKLMNOPQRSTUVQXYZ"
    specials = "!@#$%&?"

    required = [numbers, capitals, specials]

    for list in required:
        result = False
        for character in list:
            if character in password:
                result = True
        if result is False:
            raise Exception("Password must contain one capital letter, one special character, and one number")


