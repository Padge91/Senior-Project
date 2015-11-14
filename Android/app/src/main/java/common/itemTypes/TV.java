package common.itemTypes;

import java.util.ArrayList;

import common.Comment;
import common.Item;

/**
 * Created by Tyler on 11/12/2015.
 */
public class TV extends Item {

    private String air_date;
    private String directors;
    private String runtime;
    private String[] actors;
    private String writers;
    private String channel;

    public TV() {
        super();
    }

    public TV(int user_score, String item_rating, String[] genres, double average_score,
              String description, String title, String image_URL, int parent_id,
              long[] child_items, String media_type, long item_id, ArrayList<Comment> comments,
              String air_date, String directors, String runtime, String[] actors, String writers,
              String channel) {

        super(user_score, item_rating, genres, average_score, description, title, image_URL,
                parent_id, child_items, media_type, item_id, comments);

        this.air_date = air_date;
        this.directors = directors;
        this.runtime = runtime;
        this.actors = actors;
        this.writers = writers;
        this.channel = channel;
    }

    public String getAir_date() {
        return air_date;
    }

    public void setAir_date(String air_date) {
        this.air_date = air_date;
    }

    public String getDirectors() {
        return directors;
    }

    public void setDirectors(String directors) {
        this.directors = directors;
    }

    public String getRuntime() {
        return runtime;
    }

    public void setRuntime(String runtime) {
        this.runtime = runtime;
    }

    public String[] getActors() {
        return actors;
    }

    public void setActors(String[] actors) {
        this.actors = actors;
    }

    public String getWriters() {
        return writers;
    }

    public void setWriters(String writers) {
        this.writers = writers;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }
}
