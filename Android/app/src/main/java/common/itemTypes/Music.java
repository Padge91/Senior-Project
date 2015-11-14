package common.itemTypes;

import java.util.ArrayList;

import common.Comment;
import common.Item;

/**
 * Created by Tyler on 11/12/2015.
 */
public class Music extends Item {

    private String release_date;
    private String recording_company;
    private String artist;
    private String length;

    public Music() {
        super();
    }

    public Music(int user_score, String item_rating, String[] genres, double average_score,
                 String description, String title, String image_URL, int parent_id,
                 long[] child_items, String media_type, long item_id, ArrayList<Comment> comments,
                 String release_date, String recording_company, String artist, String length) {

        super(user_score, item_rating, genres, average_score, description, title, image_URL,
                parent_id, child_items, media_type, item_id, comments);

        this.release_date = release_date;
        this.recording_company = recording_company;
        this.artist = artist;
        this.length = length;
    }

    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }

    public String getRecording_company() {
        return recording_company;
    }

    public void setRecording_company(String recording_company) {
        this.recording_company = recording_company;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

}
