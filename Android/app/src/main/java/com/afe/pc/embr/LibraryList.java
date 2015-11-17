package com.afe.pc.embr;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.SearchView;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Queue;

import common.Library;
import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

public class LibraryList extends AppCompatActivity {

    public static final String PREFS_NAME = "MyPrefsFile";
    private String loggedIn_status = "";
    private String sessionID = "";
    private String username = "";
    private int userID;
    private String new_library_name = "";

    private ArrayList<Library> libraries_list = new ArrayList<>();
    private ArrayList<String> library_names = new ArrayList<>();
    private ArrayList<Integer> library_ids = new ArrayList<>();

    private EditText result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle library_bundle = getIntent().getExtras();
        unpackBundle(library_bundle);
        super.onCreate(savedInstanceState);
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        sessionID = settings.getString("sessionID", "");
        loggedIn_status = settings.getString("LoggedIn", "");
        setContentView(R.layout.library_list_layout);
        setTitle("Libraries");
        getLibraries();
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
        getMenuInflater().inflate(R.menu.menu_library_list, menu);
        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView = (SearchView) menu.findItem(R.id.menu_search_library_list).getActionView();
        if (null != searchView) {
            searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
            searchView.setIconifiedByDefault(false);
        }
        SearchView.OnQueryTextListener queryTextListener = new SearchView.OnQueryTextListener() {
            public boolean onQueryTextChange(String query) {
                getLibraries(query);
                return true;
            }
            public boolean onQueryTextSubmit(String query) {
                if(query.isEmpty())
                    getLibraries();
                else {
                    getLibraries(query);
                }
                return true;
            }
        };
        if (searchView != null)
            searchView.setOnQueryTextListener(queryTextListener);
        else
            Toast.makeText(LibraryList.this, "Search Not Available", Toast.LENGTH_SHORT).show();
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Create Library")) {
            setContentView(R.layout.create_library_layout);
            result = (EditText) findViewById(R.id.createLibrary_newLibraryName_editText);
            Button submitButton = (Button) findViewById(R.id.createLibraryLayout_submit_button);
            submitButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    new_library_name = result.getText().toString();
                    createLibrary(new_library_name);
                }
            });
            Button cancelButton = (Button) findViewById(R.id.createLibraryLayout_cancel_button);
            cancelButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    setContentView(R.layout.library_list_layout);
                    getLibraries();
                }
            });
        } else if (s.equals("Remove Library")) {
            Toast.makeText(LibraryList.this, "Option not available", Toast.LENGTH_SHORT).show();
            // remove library logic
        } else if (s.equals("Profile")) {
            Intent intent = new Intent(this, Profile.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Login") || s.equals("Logout")) {
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
        }
        return super.onOptionsItemSelected(item);
    }

    public void unpackBundle(Bundle bundle) {
        try { loggedIn_status = bundle.getString("LoggedIn"); } catch (Exception e) {}
        try { sessionID = bundle.getString("sessionID"); } catch (Exception e) {}
        try { userID = bundle.getInt("userID"); } catch (Exception e) {}
        try { username = bundle.getString("username"); } catch (Exception e) {}
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
                openLibraryViewActivity(ids.get(position), values.get(position));
            }
        });
    }

    public void getLibraries() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibrariesList.py?session=" + sessionID + "&user_id=" + Integer.toString(userID), Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        clearAll();
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
                        populate_listview(library_names, library_ids, (ListView) findViewById(R.id.libraryList_listView));
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void getLibraries(final String query) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibrariesList.py?session=" + sessionID + "&user_id=" + Integer.toString(userID), Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        clearAll();
                        JSONArray jsonArray = response.getJSONArray("response");
                        for (int i = 0; i < jsonArray.length(); i++) {
                            Library library = new Library();
                            library.setId(jsonArray.getJSONObject(i).getInt("id"));
                            library.setUser_id(jsonArray.getJSONObject(i).getInt("user_id"));
                            library.setName(jsonArray.getJSONObject(i).getString("name"));
                            String temp = library.getName();
                            if(temp.toLowerCase().contains(query.toLowerCase()))
                                libraries_list.add(library);
                        }
                        setLibrary_names();
                        setLibrary_ids();
                        populate_listview(library_names, library_ids, (ListView) findViewById(R.id.libraryList_listView));
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void createLibrary(final String library_name) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/CreateLibrary.py?session=" + sessionID + "&library_name=" + library_name + "&visible=true", Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                    Toast.makeText(LibraryList.this, "Unable to create Library", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(LibraryList.this, "Created new Library: " + library_name, Toast.LENGTH_SHORT).show();
                    setContentView(R.layout.library_list_layout);
                    getLibraries();
                }
            }
        });
    }

    public void openLibraryViewActivity(int libraryID, String libraryName) {
        Intent intent = new Intent(this, LibraryView.class);
        intent.putExtra("LoggedIn", loggedIn_status);
        intent.putExtra("sessionID", sessionID);
        intent.putExtra("userID", userID);
        intent.putExtra("libraryID", Integer.toString(libraryID));
        intent.putExtra("libraryName", libraryName);
        startActivity(intent);
    }

    public void setLibrary_names() {
        for (int i = 0; i < libraries_list.size(); i++)
            library_names.add(libraries_list.get(i).getName());
    }

    public void setLibrary_ids() {
        for (int i = 0; i < libraries_list.size(); i++)
            library_ids.add(libraries_list.get(i).getId());
    }

    public void clearAll() {
        library_names.clear();
        library_ids.clear();
        libraries_list.clear();
    }
}
