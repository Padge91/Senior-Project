__author__ = 'nicholaspadgett'

import urllib2
import json
import pymysql

#api configurations
categories = [3920, 4096]
api_key = "w6cuj9ryxnhuzkctyywu8bkw"

#database configurations
host = 'localhost'
port=3306
user='db_user'
password='group2isthebest1!'
db='EMBR'

#dont change these
alphabet = "a"
#alphabet = "abcdefghijklmnopqrstuvwxyz1234567890"
item_ids = []
objects = []
api_string = "http://api.walmartlabs.com/v1/search?apiKey={0}&query={1}&categoryId={2}"
object_api_string = "http://api.walmartlabs.com/v1/items?ids={0}&apiKey={1}"

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

def insert_object(cursor, object):
    query1 = ""
    queries = []
    for query in queries:
        cursor.execute(query)
        cursor.commit()

def insert_objects_into_db(objects):
    conn = pymysql.connect(host=host, port=port, user=user, passwd=password, db=db)
    cursor = conn.cursor()

    for object in objects:
        insert_object(cursor, object)

    cursor.close()
    conn.close()

#iteratre through item list adding in products to database
def get_item_ids(categories, api_string):
    for cat_id in categories:
        print "Starting category " + str(cat_id) + "..."
        for letter in alphabet:
            url = api_string.format(api_key, letter, cat_id)

            #get response and get num of items, then iterate_through_pages method
            response_json =  urllib2.urlopen(url).read()
            object = json.loads(response_json)
            number_of_results = int(object["totalResults"])
            print number_of_results
            iterate_through_pages(url, number_of_results)

#get item information for all items
def get_item_info(item_ids):
    for id in item_ids:
        url = object_api_string.format(id, api_key)
        response = urllib2.urlopen(url).read()
        object = json.loads(response)
        objects.append(object)

def iterate_through_pages(url, number_of_items):
    iterations = int(number_of_items / 10)+1
    for i in range(0, iterations):
        new_url = url+"&start="+str((i*10)+1)
        response_json = urllib2.urlopen(new_url).read()
        response_object = json.loads(response_json)

        #make calls to objects, add unique ids to list
        for item in response_object["items"]:
            id = item["itemId"]
            add_unique_id_to_list(id, item_ids)

def add_unique_id_to_list(id, item_ids):
    if id not in item_ids:
        item_ids.append(id)

if __name__=="__main__":
    main()