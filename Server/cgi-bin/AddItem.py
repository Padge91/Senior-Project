#!/usr/bin/python
__author__ = 'nicholaspadgett'

import cgi

from Utilities import *
from ItemORM import *
movie_fields = ["type","title", "description","rating","releaseDate","runTime","director","writer","studio","actors","genres","url", "parentId"]
book_fields = ["type","title", "description","publishDate","numberOfPages","authors","publisher","edition","genres","url", "parentId"]
game_fields = ["type","title","description","publisher","studio","releaseDate","rating","length","multiplayer","singleplayer", "genres","url", "parentId"]
music_fields = ["type","title","description","releaseDate","recordingCo","artist","genres","length","url", "parentId"]
tv_fields = ["type","title","description","length","airDate","channel","genres","actors","director","writer","rating","url", "parentId"]
types = ["Movie","TV","Game","Music","Book"]

def main():
    try:
        form = get_json_params(cgi.FieldStorage())

        #check the type coming in
        if form["type"] not in types:
            raise Exception("Type must be Movie, TV, Game, Music, or Book")

        new_form = None
        type = form["type"]
        if type == types[0]:
            new_form = get_required_parameters(form, movie_fields)
        elif type == types[1]:
            new_form = get_required_parameters(form, tv_fields)
        elif type == types[2]:
            new_form = get_required_parameters(form, game_fields)
        elif type == types[3]:
            new_form = get_required_parameters(form, music_fields)
        elif type == types[4]:
            new_form = get_required_parameters(form, book_fields)

        if new_form is None:
            raise Exception("Type value is not valid")

        #new form should now have all the fields required for a respective item
        #now add the item
        orm = ItemORM()
        orm.add_new_item(new_form)

        success_response(True)
    except Exception as e:
        failure_response(e.message)


if __name__=="__main__":
    main()