package common.itemTypes;

import java.util.ArrayList;

import common.Comment;
import common.Item;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Movie extends Item {

    private String rating;
    private String release_date;
    private String runtime;
    private String director;
    private String writer;
    private String studio;
    private String[] actors;

    public Movie() {
        super();
    }

    public Movie(int user_score, String item_rating, String[] genres, double average_score,
                 String description, String title, String image_URL, int parent_id,
                 long[] child_items, String media_type, long item_id, ArrayList<Comment> comments,
                 String rating, String release_date, String runtime, String director,
                 String writer, String studio, String[] actors) {

        super(user_score, item_rating, genres, average_score, description, title, image_URL,
                parent_id, child_items, media_type, item_id, comments);

        this.rating = rating;
        this.release_date = release_date;
        this.runtime = runtime;
        this.director = director;
        this.writer = writer;
        this.studio = studio;
        this.actors = actors;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }

    public String getRuntime() {
        return runtime;
    }

    public void setRuntime(String runtime) {
        this.runtime = runtime;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    public String getStudio() {
        return studio;
    }

    public void setStudio(String studio) {
        this.studio = studio;
    }

    public String[] getActors() {
        return actors;
    }

    public void setActors(String[] actors) {
        this.actors = actors;
    }

}
