__author__ = 'nicholaspadgett'

#queries to get information on item
#should return an Item object
from ItemClass import *
from CommentORM import *
from DataSource import *

class ItemORM(object):
    types = ["Movie","TV","Game","Music","Book"]

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
        response_object.parent_id = self.get_parent_id(response_object.id)
        response_object.child_items = self.get_child_item_ids(response_object.id)
        response_object.comments = comment_orm.get_comments_on_item({"item_id":response_object.id})

        #get extra fields
        type = response_object.type
        if type == self.types[0]:
            type_query = self.add_movie_fields(response_object, query_params["id"])
        elif type == self.types[1]:
            type_query = self.add_tv_fields(response_object, query_params["id"])
        elif type == self.types[2]:
            type_query = self.add_game_fields(response_object, query_params["id"])
        elif type == self.types[3]:
            type_query = self.add_music_fields(response_object, query_params["id"])
        elif type == self.types[4]:
            type_query = self.add_book_fields(response_object, query_params["id"])

        return response_object

    def get_parent_id(self, id):
        query = "select parent_item_id from item_children where child_item_id={0}".format(id)
        results = select_query(query)
        if len(results) == 0:
            return None
        else:
            return results[0][0]

    def get_child_item_ids(self, id):
        query = "select item_children.child_item_id, items.title from item_children, items where item_children.parent_item_id={0} and items.id = item_children.child_item_id".format(id)
        results = select_query(query)
        if len(results) == 0:
            return []

        ids = []
        for item in results:
            ids.append({"id":item[0], "title":item[1]})

        return ids

    def add_movie_fields(self,object,id):
        query = "select rating, release_date, runtime_minutes, director, writer, studio, actors from movies where item_id={0}".format(id)
        results = select_query(query)
        object.rating = results[0][0]
        object.releaseDate = results[0][1]
        object.runtime = results[0][2]
        object.director = results[0][3]
        object.writer = results[0][4]
        object.studio = results[0][5]
        object.actors = results[0][6]

    def add_tv_fields(self,object,id):
        query = "select time_length, air_date, channel, actors, director, writer, rating from television where item_id={0}".format(id)
        results = select_query(query)
        object.length = results[0][0]
        object.airDate = results[0][1]
        object.channel = results[0][2]
        object.actors = results[0][3]
        object.director = results[0][4]
        object.writer = results[0][5]
        object.rating = results[0][6]

    def add_game_fields(self,object,id):
        query = "select publisher, studio, release_date, rating, game_length, multiplayer, singleplayer from games where item_id={0}".format(id)
        results = select_query(query)
        object.publisher = results[0][0]
        object.studio = results[0][1]
        object.releaseDate = results[0][2]
        object.rating = results[0][3]
        object.gameLength = results[0][4]
        object.multiplayer = bool(results[0][5])
        object.singleplayer = bool(results[0][6])

    def add_music_fields(self,object,id):
        query = "select release_date, recording_company, artist, time_length from music where item_id={0}".format(id)
        results = select_query(query)
        object.releaseDate = results[0][0]
        object.recordingCompany = results[0][1]
        object.artist = results[0][2]
        object.length = results[0][3]

    def add_book_fields(self,object,id):
        query = "select publish_date, num_pages, authors, publisher, edition from books where item_id={0}".format(id)
        results = select_query(query)
        object.publishDate = results[0][0]
        object.numPages = results[0][1]
        object.authors = results[0][2]
        object.publisher = results[0][3]
        object.edition = results[0][4]

    def get_item_genres(self, id):
        query = "select genre from item_genres where item_id={0}".format(id)
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

        average_score = None
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
            #response_objects[i].genres = self.get_item_genres(response_objects[i].id)

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
        query = "select id, title, description, type from items where "
        iterator = 0
        for item in query_params:

            iterator += 1
            if iterator > 1:
                query += " and "

            query += " {0} like '%{1}%'".format(item, query_params[item])

        #query += " limit 10"

        return query

    #build query
    def build_query_or(self, query_params):
        query = "select id, title, description, type from items where "
        iterator = 0
        for i in query_params:

            iterator += 1
            if iterator > 1:
                query += " or "

            query += " {0} like '{1}'".format("id", i["id"])

        #query += " limit 10"

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

    def add_new_item(self, item_map):
        type = item_map["type"]

        item_id=None
        item_query = "insert into items (type, title, description) values ('{0}', '{1}', '{2}')".format(item_map["type"].replace("'", "\'"), item_map["title"].replace("'", "\'"), item_map["description"].replace("'", "\'"))
        item_id = insert_query(item_query)

        type_query = None
        if type == self.types[0]:
            type_query = self.add_movie(item_map, item_id)
        elif type == self.types[1]:
            type_query = self.add_tv(item_map, item_id)
        elif type == self.types[2]:
            type_query = self.add_game(item_map, item_id)
        elif type == self.types[3]:
            type_query = self.add_music(item_map, item_id)
        elif type == self.types[4]:
            type_query = self.add_book(item_map, item_id)

        if type_query is None:
            raise Exception("Type value is not valid")

        #make common queries
        queries = []


        img_query = "insert into item_images (item_id, image_url) values ({0}, '{1}')".format(item_id, item_map["url"].replace("'", "\'"))
        queries.append(img_query)

        #get id from ^^, use for type_query
        queries.append(type_query.format(item_id))

        if item_map["parentId"] != "None":
            queries.append("insert into item_children (parent_item_id, child_item_id) values ({0}, {1})".format(item_map["parentId"].replace("'", "\'"), item_id))

        for genre in item_map["genres"]:
            queries.append("insert into item_genres (item_id, genre) values ("+str(item_id).replace("'", "\'")+",'"+str(genre).replace("'", "\'")+"')")

        #execute all the queries
        string = ""
        for query in queries:
            string += str(query)+"\n"
            insert_query(query)

        #raise Exception(string)

    def add_movie(self, fields, item_id):
        #add fields into movie
        return "insert into movies (item_id, rating, release_date, runtime_minutes, director, writer, studio, actors) values ({0},'{1}','{2}',{3},'{4}','{5}','{6}','{7}')".format(item_id, fields["rating"].replace("'", "\'"), fields["releaseDate"].replace("'", "\'"), fields["runTime"], fields["director"], fields["writer"].replace("'", "\'"), fields["studio"].replace("'", "\'"), fields["actors"].replace("'", "\'"))

    def add_tv(self, fields, item_id):
        #add fields into tv
        return "insert into television (item_id, time_length, air_date, channel, actors, director, writer, rating) values ({0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}')".format(item_id, fields["length"].replace("'", "\'"), fields["airDate"].replace("'", "\'"), fields["channel"].replace("'", "\'"), fields["actors"].replace("'", "\'"), fields["director"].replace("'", "\'"), fields["writer"].replace("'", "\'"), fields["rating"].replace("'", "\'"))

    def add_game(self, fields, item_id):
        #add fields into game
        return "insert into games (item_id, publisher, studio, release_date, rating, game_length, multiplayer, singleplayer) values ({0},'{1}','{2}','{3}','{4}',{5},{6},{7})".format(item_id, fields["publisher"].replace("'", "\'"), fields["studio"].replace("'", "\'"), fields["releaseDate"].replace("'", "\'"), fields["rating"].replace("'", "\'"), fields["length"].replace("'", "\'"), fields["multiplayer"], fields["singleplayer"])

    def add_music(self, fields, item_id):
        #add fields into music
        return "insert into music (item_id, release_date, recording_company, artist, time_length) values ({0}, '{1}','{2}','{3}','{4}')".format(item_id, fields["releaseDate"].replace("'", "\'"), fields["recordingCo"].replace("'", "\'"), fields["artist"].replace("'", "\'"), fields["length"].replace("'", "\'"))

    def add_book(self, fields, item_id):
        #add fields into book
        return "insert into books (item_id, publish_date, num_pages, authors, publisher, edition) values ({0},'{1}',{2},'{3}','{4}','{5}')".format(item_id, fields["publishDate"].replace("'", "\'"), fields["numberOfPages"], fields["authors"].replace("'", "\'"), fields["publisher"].replace("'", "\'"), fields["edition"].replace("'", "\'"))