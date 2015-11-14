package common;

import java.util.ArrayList;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Comment {

    private String create_date;
    private String content;
    private ArrayList<Comment> child_comments;
    private int user_score;
    private long item_id;
    private int user_id;
    private int comment_rating;
    private String user_name;
    private long comment_id;

    public Comment() {

    }

    public String getCreate_date() {
        return create_date;
    }

    public void setCreate_date(String create_date) {
        this.create_date = create_date;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public ArrayList<Comment> getChild_comments() {
        return child_comments;
    }

    public void setChild_comments(ArrayList<Comment> child_comments) {
        this.child_comments = child_comments;
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

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getComment_rating() {
        return comment_rating;
    }

    public void setComment_rating(int comment_rating) {
        this.comment_rating = comment_rating;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public long getComment_id() {
        return comment_id;
    }

    public void setComment_id(long comment_id) {
        this.comment_id = comment_id;
    }

}
