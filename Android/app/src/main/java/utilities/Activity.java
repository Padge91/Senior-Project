package utilities;

import android.content.Intent;
import android.view.MenuItem;

import com.afe.pc.embr.LibraryList;
import com.afe.pc.embr.Login;
import com.afe.pc.embr.Profile;
import com.afe.pc.embr.RecommendedItems;
import com.afe.pc.embr.Search;

/**
 * Created by Tyler on 11/12/2015.
 */
public class Activity {

    public void handleMenu() {

    }

    public static Intent putExtraForMenuItem(MenuItem item, String loggedIn_status, String sessionID,
                                             int userID, String username, Intent intent) {

        String s = item.getTitle().toString();
        if (s.equals("Profile")) {
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            return intent;
        } else if (s.equals("Search")) {
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            return intent;
        } else if (s.equals("Libraries")) {
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            return intent;
        } else if (s.equals("Recommended Items")) {
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            return intent;
        } else {
            return intent;
        }
    }

    public void unpackBundle() {


    }
}
