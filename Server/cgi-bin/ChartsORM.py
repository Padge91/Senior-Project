__author__ = 'nicholaspadgett'


from ChartsClass import *
from ItemORM import *
from random import randint

class ChartsORM(object):

    #if logged in
    def get_all_charts(self, form):
        charts = []
        self.like_genres(form, charts)
        self.like_creator(form, charts)
        self.friend_recommendations(form, charts)
        self.popular(charts)
        return charts

    #if not logged in
    def get_nosession_charts(self):
        charts = []
        self.popular(charts)
        return charts

    def like_genres(self, form, charts):
        user_id = get_user_id_from_session(form)
        #get genres from libraries (or random genre if none)
        genres_query = "select item_id, genre from item_genres where item_id in (select item_id from library_items where library_id in (select id from libraries where user_id={0}))".format(user_id)
        results = select_query(genres_query)
        if len(results) < 1:
            return

        #randomly pick a genre
        index = randint(0, len(results)-1)
        genre = results[index][1]

        #pick items from that genre & type
        item_query = "select items.id, items.title, items.description, items.type from items, item_genres where items.id = item_genres.item_id and item_genres.genre = '{0}' order by rand() limit 10".format(genre)
        item_results = select_query(item_query)

        #instantiate chart with title and return it
        charts += self.instantiate_chart("Like the {0} genre...".format(genre), item_results)

    def like_creator(self, form, charts):
        user_id = get_user_id_from_session(form)
        #get creators potentially interested in
        creator_from_lib_query = "select id, type from items where id in (select item_id from library_items where library_id in (select id from libraries where user_id={0}))".format(user_id)
        item_results = select_query(creator_from_lib_query)
        if len(item_results) < 1:
            return

        random_int = randint(0, len(item_results)-1)
        item_id = item_results[random_int][0]
        item_type = item_results[random_int][1]

        #get other fields by same creator
        #OH MY GOODNESS CODE DEBT CODE DEBT CODE DEBT. I DESERVE TO BE PUNISHED
        table_query = ""
        if item_type == "Movie":
            table_query = "select director from movies where item_id={0}".format(item_id)
            creator_results = select_query(table_query)
            creator = creator_results[0][0]
            creator_query = "select items.id, items.title, items.description, items.type from items, movies where movies.director like '%{0}%' and movies.item_id = items.id order by rand() limit 10".format(creator)
            response = select_query(creator_query)
            charts += self.instantiate_chart("Movies from {0}".format(creator), response)
        elif item_type == "Book":
            table_query = "select author from books where item_id={0}".format(item_id)
            creator_results = select_query(table_query)
            creator = creator_results[0][0]
            creator_query = "select items.id, items.title, items.description, items.type from items, books where books.authors like '%{0}%' and books.item_id = items.id order by rand() limit 10".format(creator)
            response = select_query(creator_query)
            charts += self.instantiate_chart("Books from {0}".format(creator), response)
        elif item_type == "Music":
            table_query = "select artist from music where item_id={0}".format(item_id)
            creator_results = select_query(table_query)
            creator = creator_results[0][0]
            creator_query = "select items.id, items.title, items.description, items.type from items, music where music.artist like '%{0}%' and music.item_id = items.id order by rand() limit 10".format(creator)
            response = select_query(creator_query)
            charts += self.instantiate_chart("Music from {0}".format(creator), response)
        elif item_type == "Game":
            table_query = "select studio from games where item_id={0}".format(item_id)
            creator_results = select_query(table_query)
            creator = creator_results[0][0]
            creator_query = "select items.id, items.title, items.description, items.type from items, games where games.studio like '%{0}%' and games.item_id = items.id order by rand() limit 10".format(creator)
            response = select_query(creator_query)
            charts += self.instantiate_chart("Games from {0}".format(creator), response)
        elif item_type == "TV":
            table_query = "select writer from television where item_id={0}".format(item_id)
            creator_results = select_query(table_query)
            creator = creator_results[0][0]
            creator_query = "select items.id, items.title, items.description, items.type from items, television where television.writer like '%{0}%' and television.item_id = items.id order by rand() limit 10".format(creator)
            response = select_query(creator_query)
            charts += self.instantiate_chart("TV from {0}".format(creator), response)
        else:
            raise Exception("Something went wrong with the types in 'like' chart")
        #please forgive me


    def popular(self, charts):
        #get highest number of reviews on items
        comments_query = "select id, title, description, type from items where id in (select item_id from item_comments group by (item_id) asc) limit 10"
        results = select_query(comments_query)
        charts += self.instantiate_chart("Popular Items",results)

    def friend_recommendations(self, form, charts):
        user_id = get_user_id_from_session(form)
        #get items on friend libraries
        friends_query = "select id, title, description, type from items where id in (select item_id from library_items where library_id in (select id from libraries where user_id in (select friend_id from user_friends where user_id={0}))) order by rand() limit 10".format(user_id)
        results = select_query(friends_query)

        #order by review ranks
        #eventually

        charts += self.instantiate_chart("Friend Items", results)

    def instantiate_chart(self, title, rows):
        orm = ItemORM()
        items = orm.convert_rows_to_SimpleItem(rows)
        chart = [Chart(title, items)]
        return chart