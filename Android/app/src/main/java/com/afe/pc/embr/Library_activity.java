package com.afe.pc.embr;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import common.Library;
import utilities.HttpConnect;
import utilities.HttpResult;

public class Library_activity extends AppCompatActivity {

    private boolean isLoggedIn = false;
    private String loggedIn_status = "";
    private String sessionID = "";
    private int userID;

    private ArrayList<Library> libraries_list = new ArrayList<>();
    private ArrayList<String> library_names = new ArrayList<>();
    private ArrayList<Integer> library_ids = new ArrayList<>();

    private EditText result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle library_bundle = getIntent().getExtras();
        unpackBundle(library_bundle);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.library_layout);
        getLibraries();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_library, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Create Library")) {
            result = (EditText) findViewById(R.id.createLibrary_newLibraryName_editText);
            result.bringToFront();
            String new_library_name = result.getText().toString();
            createLibrary(new_library_name);
        } else if (s.equals("Remove Library")) {
            // remove library logic

        } else if (s.equals("Profile")) {
            Intent intent = new Intent(this, Profile.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
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
        getUserID();
    }

    public void populate_listview(final ArrayList<String> values, final ArrayList<Integer> ids, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long notUsed) {
                int id = ids.get(position);
                openLibraryActivity(id);
            }
        });
    }

    public void getLibraries() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibrariesList.py?session=" + sessionID + "&user_id=2"/* + Integer.toString(userID)*/, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        JSONArray jsonArray = response.getJSONArray("response");
                        for (int i = 0; i < jsonArray.length(); i++) {
                            Library library = new Library();
                            library.setId(jsonArray.getJSONObject(i).getInt("id"));
                            library.setUser_id(jsonArray.getJSONObject(i).getInt("user_id"));
                            library.setName(jsonArray.getJSONObject(i).getString("name"));
                            libraries_list.add(library);
                        }
                        setLibrary_names();
                        setLibrary_ids();
                        populate_listview(library_names, library_ids, (ListView) findViewById(R.id.library_listView));
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void createLibrary(final String library_name) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibrariesList.py?session=" + sessionID + "&library_name=" + library_name + "&visible=true", Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    Toast.makeText(Library_activity.this, "Created new Library: " + library_name, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    public void getUserID() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetUserIdFromSession.py?session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        userID = response.getInt("response");
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void openLibraryActivity(int libraryID) {
        Intent intent = new Intent(this, Library_activity.class);
        intent.putExtra("LoggedIn", loggedIn_status);
        intent.putExtra("sessionID", sessionID);
        intent.putExtra("libraryID", libraryID);
        startActivity(intent);
    }

    public void openItemViewActivity(String s) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("Book Title", s);
        intent.putExtra("Book Author", "J. R. R. Tolkien");
        intent.putExtra("Book Picture", "fellowship");
        startActivity(intent);
    }

    public void setLibrary_names() {
        for(int i = 0; i < libraries_list.size(); i++)
            library_names.add(libraries_list.get(i).getName());
    }

    public void setLibrary_ids() {
        for(int i = 0; i < libraries_list.size(); i++)
            library_ids.add(libraries_list.get(i).getId());
    }
}
