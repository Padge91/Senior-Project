package common;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Item {

    private String[] genres;
    private double average_score;
    private int user_score;
    private long item_id;
    private String title;
    private String creator;
    private String description;
    private String imageURI;
    private Map<Integer, Comment> comments = new HashMap<>();

    public Item() {

    }

    public Item(String[] genres, double average_score, int user_score, long item_id, String title,
                String creator, String description, String imageURI, Map<Integer, Comment> comments) {

        this.genres = genres;
        this.average_score = average_score;
        this.user_score = user_score;
        this.item_id = item_id;
        this.title = title;
        this.creator = creator;
        this.description = description;
        this.imageURI = imageURI;
        this.comments = comments;
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

    public int getUser_score() {
        return user_score;
    }

    public void setUser_score(int user_score) {
        this.user_score = user_score;
    }

    public long getItem_id() {
        return item_id;
    }

    public void setItem_id(long item_id) {
        this.item_id = item_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageURI() {
        return imageURI;
    }

    public void setImageURI(String imageURI) {
        this.imageURI = imageURI;
    }

    public Map<Integer, Comment> getComments() {
        return comments;
    }

    public void setComments(Map<Integer, Comment> comments) {
        this.comments = comments;
    }
}
