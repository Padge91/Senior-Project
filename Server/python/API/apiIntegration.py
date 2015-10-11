__author__ = 'nicholaspadgett'

import urllib2
import json
import pymysql
import time
from random import randint
from random import choice
from datetime import datetime
import traceback

#api configurations
categories = [3920, 4096]
api_key = "4zuwvptdxrh7ydc74wchxfgy"
#api_key = "w6cuj9ryxnhuzkctyywu8bkw"
number_of_users=200

#database configurations
host = 'localhost'
port=3306
user='db_user'
password='group2isthebest1!'
db='EMBR'

#dont change these
#alphabet = "ab"
alphabet = "abcdefghijklmnopqrstuvwxz1234567890"
item_ids = []
objects = []
num_items = 10
api_string = "http://api.walmartlabs.com/v1/search?apiKey={0}&query={1}&categoryId={2}&numItems="+str(num_items)
object_api_string = "http://api.walmartlabs.com/v1/items?ids={0}&apiKey={1}&richAttributes=true"
time_wait = 1
max_pages = 200
random_words = ["yo", "test", "organize", "awesome", "not lord of the rings", "pretty good", "idk", "pig latin", "guess who", "horrible", "you know it", "null pointer exception", "Coca-cola, now with zero calories!", "nice"]
format = '%Y-%m-%d %H:%M:%S'

def main():
    print "Getting unique id's"
    get_item_ids(categories, api_string)
    print "Got " + str(len(item_ids)) + " unique id's"

    print "Getting object information"
    get_item_info(item_ids)
    print "Got object information"

    print "Inserting objects into database"
    insert_objects_into_db(objects)
    print "Done"

def insert_object(cursor, object, conn):
    new_object = get_object_values(object)

    queries = []

    item_id = randint(0, 500000000)

    #query to insert item
    query1 = "insert into items (id, type, title, description, creator) values({0},{1},{2},{3}, {4})".format(item_id, conn.escape(new_object["category"]), conn.escape(new_object["name"][0:50]), conn.escape(new_object["description"]), conn.escape(new_object["brand"]))
    queries.append(query1)

    #query to insert scores
    for i in range(0, int(new_object["numReviews"])):
        user_id = randint(1,number_of_users-1)
        queries.append("insert into item_reviews (item_id, user_id, review_value) values ({0}, {1}, {2})".format(item_id, user_id, int(round(float(new_object["reviewScore"])))))
        queries.append("insert into item_images (item_id, image_url) values ({0}, {1})".format(item_id, conn.escape(new_object["image"])))

        #query to insert comments
        for i in range(0, randint(0, 5)):
            comment_id = randint(0, 90000000000)
            choices = [choice(random_words) for _ in range(10)]
            sentence = ' '.join(choices)
            queries.append("insert into comments (id, user_id, create_date, content) values ({0}, {1}, '{2}', {3})".format(comment_id, user_id, datetime.now().strftime(format), conn.escape(sentence)))
            queries.append("insert into item_comments (item_id, comment_id) values ({0}, {1})".format(item_id, comment_id))

            #query to insert comments on comments
            for i in range(0, randint(0,2)):
                index_comment_id = randint(0, 90000000000)
                choices = [choice(random_words) for _ in range(10)]
                sentence = ' '.join(choices)
                queries.append("insert into comments (id, user_id, create_date, content) values ({0}, {1}, '{2}', {3})".format(index_comment_id, randint(1,number_of_users-1), datetime.now(), conn.escape(sentence)))
                queries.append("insert into comment_parents (parent_id, child_id) values ({0}, {1})".format(comment_id, index_comment_id))

    for query in queries:
        print query
        try:
            cursor.execute(query)
            conn.commit()
        except Exception as e:
            print traceback.format_exc()
            print "Query error: " + e.message
            continue

def get_object_values(object):
    review_num_dict = {"name":"numReviews", "default":0, "fields":["numReviews"]}
    review_score_dict = {"name":"reviewScore","default":0, "fields":["customerRating"]}
    brand_dict = {"name":"brand", "default":"Not Specified", "fields":["director", "Director", "author", "Author", "Artist", "artist","brandName"]}
    description_dict = {"name":"description","default":None, "fields":["shortDescription","longDescription"]}
    images_dict = {"name":"image","default":None, "fields":["largeImage", "mediumImage","thumbnailImage"]}
    name_dict = {"name":"name","default":None, "fields":["name"]}
    category_dict = {"name":"category","default":"Not Specified", "fields":["categoryPath"]}
    #needs genres

    dicts = [review_num_dict, review_score_dict, brand_dict, description_dict, images_dict, name_dict, category_dict]
    object_dict = dict()
    for dictionary in dicts:
        for attempt_field in dictionary["fields"]:
            if "richAttributes" in object:
                if attempt_field in object["richAttributes"]:
                    object_dict[dictionary["name"]] = object["richAttributes"][attempt_field]
                    break;
                elif attempt_field in object:
                    object_dict[dictionary["name"]] = object[attempt_field]
                    break;
                else:
                    object_dict[dictionary["name"]] = dictionary["default"]
            else:
                if attempt_field in object:
                    object_dict[dictionary["name"]] = object[attempt_field]
                    break;
                else:
                    object_dict[dictionary["name"]] = dictionary["default"]



    return object_dict



def insert_objects_into_db(objects):
    conn = pymysql.connect(host=host, port=port, user=user, passwd=password, db=db)
    cursor = conn.cursor()

    for object in objects:
        insert_object(cursor, object["items"][0], conn)

    conn.commit()
    cursor.close()
    conn.close()

#iteratre through item list adding in products to database
def get_item_ids(categories, api_string):
    for cat_id in categories:
        print "Starting category " + str(cat_id) + "..."
        for letter in alphabet:
            print "Starting letter " + str(letter) + "..."
            url = api_string.format(api_key, letter, cat_id)

            #get response and get num of items, then iterate_through_pages method
            response_json =  make_request(url)
            if response_json is None:
                continue
            time.sleep(time_wait)

            object = json.loads(response_json)
            number_of_results = int(object["totalResults"])
            if number_of_results > max_pages:
                number_of_results = max_pages

            print "Letter " + str(letter) + " has " + str(number_of_results) + " results..."
            iterate_through_pages(url, number_of_results)

#get item information for all items
def get_item_info(item_ids):
    for id in item_ids:
        url = object_api_string.format(id, api_key)
        response = make_request(url)
        if response is None:
                continue
        time.sleep(time_wait);
        object = json.loads(response)
        if not check_type(object["items"][0]):
            continue
        objects.append(object)
        print "Added object to list"

def check_type(object):
    film_words = ["film", "Film", "Movie", "movie"]
    tv_words = ["TV", "tv", "Tv", "television"]
    book_words = ["book", "Book"]
    if "categoryPath" in object:
        object_category = object["categoryPath"]
    else:
        object=category="Not Specified"
    return_val = False
    if "OLD STUFF" in object_category:
        return return_val
    for word in film_words:
        if word in object_category:
            return_val = "Film"
    for word in tv_words:
        if word in object_category:
            return_val = "TV"
    for word in book_words:
        if word in object_category:
            return_val = "Book"

    object["categoryPath"] = return_val

    return return_val


def iterate_through_pages(url, number_of_items):
    iterations = int(number_of_items / num_items)+1
    for i in range(0, iterations):
        new_url = url+"&start="+str((i*num_items)+1)
        response_json = make_request(url)
        if response_json is None:
                continue
        time.sleep(time_wait)
        print "Page Number " + str(i+1) + "/" + str(iterations)
        response_object = json.loads(response_json)

        #make calls to objects, add unique ids to list
        if "items" in response_object:
            for item in response_object["items"]:
                id = item["itemId"]
                add_unique_id_to_list(id, item_ids)

def add_unique_id_to_list(id, item_ids):
    if id not in item_ids:
        item_ids.append(id)

def make_request(url):
    try:
        response = urllib2.urlopen(url).read()
        return response
    #exception attempts same block of code because sometimes we get a 502 error, which breaks the system
    #this exception will usually work around it
    except Exception as e:
        try:
            response = urllib2.urlopen(url).read()
            return response
        except Exception as e:
            return None

if __name__=="__main__":
    main()