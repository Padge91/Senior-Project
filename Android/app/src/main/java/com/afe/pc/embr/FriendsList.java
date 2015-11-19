package com.afe.pc.embr;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.android.volley.Request;

import org.json.JSONObject;

import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

public class FriendsList extends AppCompatActivity {

    public static final String PREFS_NAME = "MyPrefsFile";
    private String loggedIn_status = "";
    private String sessionID = "";
    private String username = "";
    private int userID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        unpackBundle(item_bundle);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.friends_list_layout);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_friends_list, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Libraries")) {
            Intent intent = new Intent(this, LibraryList.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Friends")) {
            Intent intent = new Intent(this, FriendsList.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Login")) {
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
        } else if (s.equals("Logout")) {
            logout();
            SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("sessionID", "");
            editor.putString("LoggedIn", "");
            editor.apply();
            Intent intent = new Intent(this, Login.class);
            intent.putExtra("logoutAttempt", true);
            startActivity(intent);
        }
        return super.onOptionsItemSelected(item);
    }

    public void unpackBundle(Bundle bundle) {
        try {
            loggedIn_status = bundle.getString("LoggedIn");
        } catch (Exception e) {
        }
        try {
            sessionID = bundle.getString("sessionID");
        } catch (Exception e) {
        }
        try {
            userID = bundle.getInt("userID");
        } catch (Exception e) {
        }
        try {
            username = bundle.getString("username");
        } catch (Exception e) {
        }
    }

    public void logout() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/Logout.py?session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {

            }
        });
    }
}
