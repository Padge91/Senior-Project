package common;

/**
 * Created by Tyler on 10/20/2015.
 */
public class Strings {

    /**
     *
     * @param query String from search field
     * @param title String that is a possible value
     * @return true if the query String is contained
     */
    public static boolean compareString(String query, String title) {
        return title.toLowerCase().contains(query.toLowerCase());
    }

}
