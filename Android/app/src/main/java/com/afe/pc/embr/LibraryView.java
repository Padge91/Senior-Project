package com.afe.pc.embr;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

public class LibraryView extends AppCompatActivity {

    public static final String PREFS_NAME = "MyPrefsFile";
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
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Search")) {
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

    public void logout() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/Logout.py?session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {

            }
        });
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
                String itemName = values.get(position);
                openItemViewActivity(id, itemName);
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long notUsed) {
                int id = ids.get(position);
                String itemName = values.get(position);
                removeItemDialogBox(itemName, id);
                return true;
            }
        });
    }

    public void openItemViewActivity(int itemID, String itemName) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("LoggedIn", loggedIn_status);
        intent.putExtra("sessionID", sessionID);
        intent.putExtra("userID", userID);
        intent.putExtra("itemID", itemID);
        intent.putExtra("itemName", itemName);
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
                        clearAll();
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

    public void removeItem(int id) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/RemoveItemFromLibrary.py?session=" + sessionID + "&library_id=" + libraryID + "&item_id=" + id, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                    Toast.makeText(LibraryView.this, "No Response", Toast.LENGTH_SHORT).show();
                }
                else
                    getItems();
            }
        });
    }

    public void removeItemDialogBox(String itemName, final int itemID) {
        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this, AlertDialog.THEME_HOLO_LIGHT);
        LayoutInflater inflater = this.getLayoutInflater();
        final View dialogView = inflater.inflate(R.layout.remove_item_layout, null);
        dialogBuilder.setView(dialogView);
        dialogBuilder.setMessage("Are you sure you want to remove " + itemName + " from " + libraryName + "?");
        dialogBuilder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {

            }
        });
        dialogBuilder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                removeItem(itemID);
            }
        });
        AlertDialog alertDialog = dialogBuilder.create();
        alertDialog.show();
    }

    public void clearAll() {
        item_names.clear();
        item_ids.clear();
    }
}
