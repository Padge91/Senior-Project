package common;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Book extends Item {

    private int page_count;
    // other values specific to books

    public Book() {
        super();
    }

    public Book(int page_count) {
        super();
        this.page_count = page_count;
    }

    public int getPage_count() {
        return page_count;
    }

    public void setPage_count(int page_count) {
        this.page_count = page_count;
    }
}
