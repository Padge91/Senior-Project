package com.afe.pc.embr;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.support.v7.widget.SearchView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import javax.xml.namespace.QName;

import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

/*
*  Making this view be a temporary Search on start, to maintain consistency with the iOS version
*
*  Author: Tyler Davis
*  Date: 10.9.15 - 2:12AM
 */
public class Search extends AppCompatActivity {

    private boolean isLoggedIn = false;
    private boolean isFromLogin = false;
    private String loggedIn_status = "";
    private String sessionID = "";
    private String username = "";
    private int userID;
    private String[] emptyStrings = new String[]{"", "", "", "", "", "", "", "", "", "", "", ""};
    private ArrayList<String> creator = new ArrayList<>();
    private ArrayList<String> title = new ArrayList<>();
    private ArrayList<Integer> id = new ArrayList<>();
    private ArrayList<ArrayList<String>> listview_values = new ArrayList<>();
    private ArrayList<String> listview_values_temp = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle search_bundle = getIntent().getExtras();
        unpackBundle(search_bundle);
        super.onCreate(savedInstanceState);
        if (loggedIn_status.equalsIgnoreCase("true") && !sessionID.isEmpty())
            isLoggedIn = true;
        setContentView(R.layout.search_layout);
        setTitle("Item Search");
        populate_listview_on_start(appendStrings(listview_values_temp, emptyStrings), (ListView) findViewById(R.id.search_listview));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_search, menu);
        if (!isLoggedIn) {
            menu.getItem(4).setTitle("Login");
            menu.getItem(3).setVisible(false);
            menu.getItem(2).setVisible(false);
            menu.getItem(1).setVisible(false);
        }
        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView = (SearchView) menu.findItem(R.id.menu_search).getActionView();
        if (null != searchView) {
            searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
            searchView.setIconifiedByDefault(false);
        }
        SearchView.OnQueryTextListener queryTextListener = new SearchView.OnQueryTextListener() {
            public boolean onQueryTextChange(String query) {
                getData(query);
                return true;
            }
            public boolean onQueryTextSubmit(String query) {
                getData(query);
                return true;
            }
        };
        if (searchView != null)
            searchView.setOnQueryTextListener(queryTextListener);
        else
            Toast.makeText(Search.this, "Search Not Available", Toast.LENGTH_SHORT).show();
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Profile")) {
            Intent intent = new Intent(this, Profile.class);
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
        } else if (s.equals("Login") || s.equals("Logout")) {
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        if(isFromLogin)
            return;
        else
            super.onBackPressed();
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
            isFromLogin = bundle.getBoolean("isFromLogin");
        } catch (Exception e) {
        }
        try {
            username = bundle.getString("username");
        } catch (Exception e) {
        }
    }

    public void populate_listview(final ArrayList<ArrayList<String>> values, final ArrayList<Integer> ids, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.single_row, R.id.results_Title, values.get(0));
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long notUsed) {
                openItemViewActivity(ids.get(position), values.get(0).get(position));
            }
        });
    }

    public void populate_listview_on_start(ArrayList<String> values, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
    }

    public void openItemViewActivity(int itemID, String itemName) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("LoggedIn", loggedIn_status);
        intent.putExtra("sessionID", sessionID);
        intent.putExtra("userID", userID);
        intent.putExtra("username", username);
        intent.putExtra("itemID", itemID);
        intent.putExtra("itemName", itemName);
        startActivity(intent);
    }

    public ArrayList<String> appendStrings(ArrayList<String> arrayList, String[] stringArray) {
        for (int count = 0; count < stringArray.length; count++)
            arrayList.add(stringArray[count]);
        return arrayList;
    }

    public void getData(String s) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/SearchItems.py?title=" + s, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                    Toast.makeText(Search.this, "No Response", Toast.LENGTH_SHORT).show();
                } else {
                    try {
                        clearAll();
                        JSONArray jsonArray = response.getJSONArray("response");
                        for (int i = 0; i < jsonArray.length(); i++) {
                            title.add(jsonArray.getJSONObject(i).getString("title"));
                            //creator.add(jsonArray.getJSONObject(i).getString("creator"));
                            id.add(jsonArray.getJSONObject(i).getInt("id"));
                        }
                        listview_values.add(title);
                        //listview_values.add(creator);
                        populate_listview(listview_values, id, (ListView) findViewById(R.id.search_listview));
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void clearAll() {
        listview_values.clear();
        creator.clear();
        title.clear();
        id.clear();
    }
}
