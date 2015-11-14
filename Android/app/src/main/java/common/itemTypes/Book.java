package common.itemTypes;

import java.util.ArrayList;

import common.Comment;
import common.Item;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Book extends Item {

    private String publish_date;
    private int number_of_pages;
    private String author;
    private String publisher;
    private String edition;

    public Book() {
        super();
    }

    public Book(int user_score, String item_rating, String[] genres, double average_score,
                String description, String title, String image_URL, int parent_id,
                long[] child_items, String media_type, long item_id, ArrayList<Comment> comments,
                String publish_date, int number_of_pages, String author, String publisher,
                String edition) {

        super(user_score, item_rating, genres, average_score, description, title, image_URL,
                parent_id, child_items, media_type, item_id, comments);

        this.publish_date = publish_date;
        this.number_of_pages = number_of_pages;
        this.author = author;
        this.publisher = publisher;
        this.edition = edition;
    }

    public String getPublish_date() {
        return publish_date;
    }

    public void setPublish_date(String publish_date) {
        this.publish_date = publish_date;
    }

    public int getNumber_of_pages() {
        return number_of_pages;
    }

    public void setNumber_of_pages(int number_of_pages) {
        this.number_of_pages = number_of_pages;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public String getEdition() {
        return edition;
    }

    public void setEdition(String edition) {
        this.edition = edition;
    }

}
