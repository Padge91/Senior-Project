package common;

import java.util.ArrayList;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Item {

    private int user_score;
    private String item_rating;
    private String[] genres;
    private double average_score;
    private String description;
    private String title;
    private String image_URL;
    private int parent_id;
    private long[] child_items;
    private String media_type;
    private long item_id;
    private ArrayList<Comment> comments = new ArrayList<>();

    public Item() {

    }

    public Item(int user_score, String item_rating, String[] genres, double average_score,
                String description, String title, String image_URL, int parent_id,
                long[] child_items, String media_type, long item_id, ArrayList<Comment> comments) {

        this.user_score = user_score;
        this.item_rating = item_rating;
        this.genres = genres;
        this.average_score = average_score;
        this.description = description;
        this.title = title;
        this.image_URL = image_URL;
        this.parent_id = parent_id;
        this.child_items = child_items;
        this.media_type = media_type;
        this.item_id = item_id;
        this.comments = comments;
    }

    public int getUser_score() {
        return user_score;
    }

    public void setUser_score(int user_score) {
        this.user_score = user_score;
    }

    public String getItem_rating() {
        return item_rating;
    }

    public void setItem_rating(String item_rating) {
        this.item_rating = item_rating;
    }

    public String[] getGenres() {
        return genres;
    }

    public void setGenres(String[] genres) {
        this.genres = genres;
    }

    public double getAverage_score() {
        return average_score;
    }

    public void setAverage_score(double average_score) {
        this.average_score = average_score;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage_URL() {
        return image_URL;
    }

    public void setImage_URL(String image_URL) {
        this.image_URL = image_URL;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }

    public long[] getChild_items() {
        return child_items;
    }

    public void setChild_items(long[] child_items) {
        this.child_items = child_items;
    }

    public String getMedia_type() {
        return media_type;
    }

    public void setMedia_type(String media_type) {
        this.media_type = media_type;
    }

    public long getItem_id() {
        return item_id;
    }

    public void setItem_id(long item_id) {
        this.item_id = item_id;
    }

    public ArrayList<Comment> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Comment> comments) {
        this.comments = comments;
    }
}
