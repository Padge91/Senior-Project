package common.itemTypes;

import java.util.ArrayList;

import common.Comment;
import common.Item;

/**
 * Created by Tyler on 11/12/2015.
 */
public class Game extends Item {

    private String publisher;
    private String developer_studio;
    private String release_date;
    private String rating;
    private int average_length_of_play;
    private boolean is_multiplayer;
    private boolean is_singleplayer;

    public Game() {
        super();
    }

    public Game(int user_score, String item_rating, String[] genres, double average_score,
                String description, String title, String image_URL, int parent_id,
                long[] child_items, String media_type, long item_id, ArrayList<Comment> comments,
                String publisher, String developer_studio, String release_date, String rating,
                int average_length_of_play, boolean is_multiplayer, boolean is_singleplayer) {

        super(user_score, item_rating, genres, average_score, description, title, image_URL,
                parent_id, child_items, media_type, item_id, comments);

        this.publisher = publisher;
        this.developer_studio = developer_studio;
        this.release_date = release_date;
        this.rating = rating;
        this.average_length_of_play = average_length_of_play;
        this.is_multiplayer = is_multiplayer;
        this.is_singleplayer = is_singleplayer;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public String getDeveloper_studio() {
        return developer_studio;
    }

    public void setDeveloper_studio(String developer_studio) {
        this.developer_studio = developer_studio;
    }

    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public int getAverage_length_of_play() {
        return average_length_of_play;
    }

    public void setAverage_length_of_play(int average_length_of_play) {
        this.average_length_of_play = average_length_of_play;
    }

    public boolean is_multiplayer() {
        return is_multiplayer;
    }

    public void setIs_multiplayer(boolean is_multiplayer) {
        this.is_multiplayer = is_multiplayer;
    }

    public boolean is_singleplayer() {
        return is_singleplayer;
    }

    public void setIs_singleplayer(boolean is_singleplayer) {
        this.is_singleplayer = is_singleplayer;
    }
}
