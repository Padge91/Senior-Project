package com.afe.pc.embr;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import common.Library;
import utilities.HttpConnect;
import utilities.HttpResult;

public class LibraryView extends AppCompatActivity {

    private String loggedIn_status = "";
    private String sessionID = "";
    private String libraryID = "";
    private String libraryName = "";
    private String username = "";
    private int userID;

    private ArrayList<String> creator = new ArrayList<>();
    private ArrayList<String> title = new ArrayList<>();
    private ArrayList<Integer> id = new ArrayList<>();

    private ArrayList<String> item_names = new ArrayList<>();
    private ArrayList<Integer> item_ids = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle search_bundle = getIntent().getExtras();
        unpackBundle(search_bundle);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.library_view_layout);
        setTitle(libraryName);
        getItems();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_library_view, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Profile")) {
            Intent intent = new Intent(this, Profile.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            startActivity(intent);
        } else if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            startActivity(intent);
        } else if (s.equals("Libraries")) {
            Intent intent = new Intent(this, LibraryList.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("username", username);
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
            libraryID = bundle.getString("libraryID");
        } catch (Exception e) {
        }
        try {
            libraryName = bundle.getString("libraryName");
        } catch (Exception e) {
        }
        try {
            username = bundle.getString("username");
        } catch (Exception e) {
        }
    }

    public void populate_listview(final ArrayList<String> values, final ArrayList<Integer> ids, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.single_row, R.id.results_Title, values);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long notUsed) {
                int id = ids.get(position);
                openItemViewActivity(id);
            }
        });
    }

    public void openItemViewActivity(int itemID) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("LoggedIn", loggedIn_status);
        intent.putExtra("sessionID", sessionID);
        intent.putExtra("userID", userID);
        intent.putExtra("itemID", itemID);
        startActivity(intent);
    }

    public void getItems() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibraryItems.py?session=" + sessionID + "&library_id=" + libraryID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                    Toast.makeText(LibraryView.this, "No Response", Toast.LENGTH_SHORT).show();
                } else {
                    try {
                        JSONArray jsonArray = response.getJSONArray("response");
                        for (int i = 0; i < jsonArray.length(); i++) {
                            item_names.add(jsonArray.getJSONObject(i).getString("title"));
                            item_ids.add(jsonArray.getJSONObject(i).getInt("id"));
                        }
                        populate_listview(item_names, item_ids, (ListView) findViewById(R.id.libraryView_listView));
                    } catch (Exception e) {
                    }
                }
            }
        });
    }
}
