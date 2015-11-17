package com.afe.pc.embr;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONException;
import org.json.JSONObject;

import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

public class Profile extends AppCompatActivity {

    public static final String PREFS_NAME = "MyPrefsFile";
    private String loggedIn_status = "";
    private String sessionID = "";
    private String username = "";
    private int userID;

    Button libraries;
    Button friends;
    Button recommendedItems;
    Button progress;
    ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        unpackBundle(item_bundle);
        super.onCreate(savedInstanceState);
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        sessionID = settings.getString("sessionID", "");
        loggedIn_status = settings.getString("LoggedIn", "");
        setContentView(R.layout.profile_layout);
        setTitle(username);

        listView = (ListView) findViewById(R.id.profile_updates_listView);
        String[] values = new String[]{"Update 1", "Update 2", "Update 3", "Update 4", "Update 5",
                "Update 6", "Update 7", "Update 8", "Update 9", "Update 10", "Update 11", "Update 12"};
        populate_listview(values, listView);

        libraries = (Button) findViewById(R.id.profile_libraries_button);
        libraries.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(Profile.this, libraries.getText().toString(), Toast.LENGTH_SHORT).show();
            }
        });

        friends = (Button) findViewById(R.id.profile_friends_button);
        friends.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(Profile.this, friends.getText().toString(), Toast.LENGTH_SHORT).show();
            }
        });

        recommendedItems = (Button) findViewById(R.id.profile_recommendedItems_button);
        recommendedItems.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(Profile.this, recommendedItems.getText().toString(), Toast.LENGTH_SHORT).show();
            }
        });

        progress = (Button) findViewById(R.id.profile_progress_button);
        progress.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(Profile.this, progress.getText().toString(), Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    protected void onStop(){
        super.onStop();
        if (loggedIn_status.equals("true")) {
            SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("sessionID", sessionID);
            editor.putString("LoggedIn", loggedIn_status);
            editor.apply();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_profile, menu);
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
        } else if (s.equals("Login") || s.equals("Logout")) {
            Intent intent = new Intent(this, Login.class);
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

    public void populate_listview(final String[] values, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String itemValue = (String) listView.getItemAtPosition(position);
                Toast.makeText(Profile.this, itemValue, Toast.LENGTH_SHORT).show();
            }
        });
    }

    public void getData() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetProfileInfo.py?id=" + "" + "&session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                    Toast.makeText(Profile.this, "No Response", Toast.LENGTH_SHORT).show();
                } else {
                    try {
                        response = response.getJSONObject("response");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
    }
}
