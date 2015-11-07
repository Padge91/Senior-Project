package common;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Comment {

    private int comment_rating;
    private int comment_id;
    private int item_id;
    private int user_id;
    private int user_review;
    private String user_name;
    private String content;
    private Comment sub_comment;

    public Comment() {

    }

    public Comment(int comment_rating, int comment_id, int item_id, int user_id,
                   int user_review, String user_name, String content) {

        this.comment_rating = comment_rating;
        this.comment_id = comment_id;
        this.item_id = item_id;
        this.user_id = user_id;
        this.user_review = user_review;
        this.user_name = user_name;
        this.content = content;
    }

    public int getComment_rating() {
        return comment_rating;
    }

    public void setComment_rating(int comment_rating) {
        this.comment_rating = comment_rating;
    }

    public int getComment_id() {
        return comment_id;
    }

    public void setComment_id(int comment_id) {
        this.comment_id = comment_id;
    }

    public int getItem_id() {
        return item_id;
    }

    public void setItem_id(int item_id) {
        this.item_id = item_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getUser_review() {
        return user_review;
    }

    public void setUser_review(int user_review) {
        this.user_review = user_review;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Comment getSub_Comment() {
        return sub_comment;
    }

    public void setSub_comment(Comment sub_comment) {
        this.sub_comment = sub_comment;
    }
}
