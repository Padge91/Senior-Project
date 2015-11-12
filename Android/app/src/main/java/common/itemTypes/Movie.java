package common.itemTypes;

import common.Item;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Movie extends Item {

    private String title;
    private String description;
    private String rating;
    private String release_date;
    private String runtime;
    private String director;
    private String writer;
    private String studio;
    private String[] actors;
    private String[] genres;
    private String imageURL;

    public Movie() {
        super();
    }

    public Movie(String title) {
        super();
        this.title = title;
    }

}
