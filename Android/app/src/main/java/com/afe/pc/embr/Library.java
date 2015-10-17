package com.afe.pc.embr;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class Library extends AppCompatActivity {

    Toolbar appBar;
    private EditText action_bar_edit_text;
    private String[] a_library_names = {"Owned", "Wishlist", "Custom", "test"};
    private String[] a_owned_library_items = new String[]{"Fellowship of the Ring", "Two Towers", "Return of the King", "test"};
    private String[] a_wishlist_library_items = new String[]{"Goblet of Fire", "The Hobbit", "Not 50 shades of Gray", "test"};
    private String[] a_custom_library_items = new String[]{"test1", "test2", "test3", "test4"};
    private ArrayList<String> al_library_names = new ArrayList<>();
    private ArrayList<String> al_owned_library_items = new ArrayList<>();
    private ArrayList<String> al_wishlist_library_items = new ArrayList<>();
    private ArrayList<String> al_custom_library_items = new ArrayList<>();
    private ArrayList<String> listview_values = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle library_bundle = getIntent().getExtras();
        String library_name = "";
        try {
            library_name = library_bundle.getString("Library Name");
        } catch (Exception e) {}
        if (library_name != null && library_name.equalsIgnoreCase("Owned")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.library_layout_owned);
            add_to_arrayList(al_owned_library_items, a_owned_library_items);
            populate_listview(al_owned_library_items, (ListView) findViewById(R.id.owned_library_listView));

            appBar = (Toolbar) findViewById(R.id.action_bar);
            ImageButton action_bar_button = (ImageButton) findViewById(R.id.action_bar_button);
            action_bar_edit_text = (EditText) findViewById(R.id.action_bar_edit_text);
            action_bar_edit_text.setHint("Owned");

            action_bar_button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    // using action_bar_edit_text.getText().toString() to extract the search input
                    // send that value to the backend, and everything that gets returned needs to
                    // be put into a string array which will be used to populate the listview.
                    // populate_listview((String[]) owned_library_items.toArray());
                    al_owned_library_items.clear();
                    for (int i = 0; i < a_owned_library_items.length; i++)
                        if (a_owned_library_items[i].equalsIgnoreCase(action_bar_edit_text.getText().toString()))
                            al_owned_library_items.add(a_owned_library_items[i]);

                    action_bar_edit_text.setText("");
                    populate_listview(al_owned_library_items, (ListView) findViewById(R.id.owned_library_listView));
                }
            });
        }
        else if (library_name != null && library_name.equalsIgnoreCase("Wishlist")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.library_layout_wishlist);
            add_to_arrayList(al_wishlist_library_items, a_wishlist_library_items);
            populate_listview(al_wishlist_library_items, (ListView) findViewById(R.id.wishlist_library_listView));

            appBar = (Toolbar) findViewById(R.id.action_bar);
            ImageButton action_bar_button = (ImageButton) findViewById(R.id.action_bar_button);
            action_bar_edit_text = (EditText) findViewById(R.id.action_bar_edit_text);
            action_bar_edit_text.setHint("Wish List");

            action_bar_button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    // using action_bar_edit_text.getText().toString() to extract the search input
                    // send that value to the backend, and everything that gets returned needs to
                    // be put into a string array which will be used to populate the listview.
                    // populate_listview((String[]) wishlist_library_items.toArray());
                    al_wishlist_library_items.clear();
                    for (int i = 0; i < a_wishlist_library_items.length; i++)
                        if (a_wishlist_library_items[i].equalsIgnoreCase(action_bar_edit_text.getText().toString()))
                            al_wishlist_library_items.add(a_wishlist_library_items[i]);

                    action_bar_edit_text.setText("");
                    populate_listview(al_wishlist_library_items, (ListView) findViewById(R.id.wishlist_library_listView));
                }
            });
        }
        else if (library_name != null && library_name.equalsIgnoreCase("Custom")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.library_layout_custom);
            add_to_arrayList(al_custom_library_items, a_custom_library_items);
            populate_listview(al_custom_library_items, (ListView) findViewById(R.id.custom_library_listView));

            appBar = (Toolbar) findViewById(R.id.action_bar);
            ImageButton action_bar_button = (ImageButton) findViewById(R.id.action_bar_button);
            action_bar_edit_text = (EditText) findViewById(R.id.action_bar_edit_text);
            action_bar_edit_text.setHint("Custom");

            action_bar_button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    // using action_bar_edit_text.getText().toString() to extract the search input
                    // send that value to the backend, and everything that gets returned needs to
                    // be put into a string array which will be used to populate the listview.
                    // populate_listview((String[]) custom_library_items.toArray());
                    al_custom_library_items.clear();
                    for (int i = 0; i < a_custom_library_items.length; i++)
                        if (a_custom_library_items[i].equalsIgnoreCase(action_bar_edit_text.getText().toString()))
                            al_custom_library_items.add(a_custom_library_items[i]);

                    action_bar_edit_text.setText("");
                    populate_listview(al_custom_library_items, (ListView) findViewById(R.id.custom_library_listView));
                }
            });
        }
        else {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.library_layout);
            populate_listview(al_library_names, (ListView) findViewById(R.id.library_listView));
            add_to_arrayList(al_library_names, a_library_names);
            appBar = (Toolbar) findViewById(R.id.action_bar);
            ImageButton action_bar_button = (ImageButton) findViewById(R.id.action_bar_button);
            action_bar_edit_text = (EditText) findViewById(R.id.action_bar_edit_text);
            action_bar_edit_text.setHint("Libraries");

            action_bar_button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    // using action_bar_edit_text.getText().toString() to extract the search input
                    // send that value to the backend, and everything that gets returned needs to
                    // be put into a string array which will be used to populate the listview.
                    listview_values.clear();
                    for (int i = 0; i < al_library_names.size(); i++)
                        if (a_library_names[i].equals(action_bar_edit_text.getText().toString()))
                            listview_values.add(a_library_names[i]);

                    action_bar_edit_text.setText("");
                    populate_listview(listview_values, (ListView) findViewById(R.id.library_listView));
                }
            });
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_library, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }
        switch (item.getTitle().toString()) {
            case "Recommended Items": {
                Intent intent = new Intent(this, RecommendedItems.class);
                startActivity(intent);
                break;
            }
            case "Home": {
                Intent intent = new Intent(this, HomeActivity.class);
                startActivity(intent);
                break;
            }
            case "Profile": {
                Intent intent = new Intent(this, Profile.class);
                startActivity(intent);
                break;
            }
            case "Libraries": {
                Intent intent = new Intent(this, Library.class);
                startActivity(intent);
                break;
            }
            case "Go to SearchResults": {
                Intent intent = new Intent(this, SearchResults.class);
                startActivity(intent);
                break;
            }
            case "Login": {
                Intent intent = new Intent(this, Login.class);
                startActivity(intent);
                break;
            }
            default: {
                break;
            }
        }

        return super.onOptionsItemSelected(item);
    }

    public void populate_listview(ArrayList<String> values, final ListView listView) {

        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        if(listView.equals(findViewById(R.id.library_listView))) {
            ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    int itemPosition = position;
                    String itemValue = (String) listView.getItemAtPosition(itemPosition);
                    openLibraryActivity(itemValue);
                }
            });
        }
        else {
            ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    int itemPosition = position;
                    String itemValue = (String) listView.getItemAtPosition(itemPosition);
                    openItemViewActivity(itemValue);
                }
            });
        }
    }

    public void add_to_arrayList(ArrayList<String> list, String[] values) {
        for(int counter = 0; counter < values.length; counter++)
            list.add(values[counter]);
    }

    public void openLibraryActivity(String s) {
        Intent intent;
        switch (s) {
            case "Owned":
                intent = new Intent(this, Library.class);
                intent.putExtra("Library Name", "Owned");
                break;
            case "Wishlist":
                intent = new Intent(this, Library.class);
                intent.putExtra("Library Name", "Wishlist");
                break;
            case "Custom":
                intent = new Intent(this, Library.class);
                intent.putExtra("Library Name", "Custom");
                break;
            default:
                Toast.makeText(Library.this, "Not Available", Toast.LENGTH_SHORT).show();
                intent = new Intent(this, HomeActivity.class);
                break;
        }
        startActivity(intent);
    }

    public void openItemViewActivity(String s) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("Book Name", s);
        startActivity(intent);
    }
}
