package com.afe.pc.embr;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Toast;
import android.support.v7.widget.Toolbar;

/*
*  Making this view be a temporary Search on start, to maintain consistency with the iOS version
*
*  Author: Tyler Davis
*  Date: 10.9.15 - 2:12AM
 */
public class HomeActivity extends AppCompatActivity {

    ListView listView;
    String placeHolder = "";
    Toolbar appBar;
    ImageButton action_bar_button;
    EditText action_bar_edit_text;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.home_layout);

        appBar = (Toolbar) findViewById(R.id.action_bar);
        action_bar_button = (ImageButton) findViewById(R.id.action_bar_button);
        action_bar_edit_text = (EditText) findViewById(R.id.action_bar_edit_text);

        action_bar_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(HomeActivity.this, action_bar_edit_text.getText().toString(), Toast.LENGTH_SHORT).show();
                action_bar_edit_text.setText("");
            }
        });

        // Get ListView object from xml
        listView = (ListView) findViewById(R.id.list);

        // Defined Array values to show in ListView
        String[] values = new String[] {"Go to ItemView", "Go to SearchResults", "Go to Profile", "Go to Library", "Go to RecommendedItems", "Go to Login",
                placeHolder, placeHolder, placeHolder, placeHolder, placeHolder, placeHolder, placeHolder, placeHolder, placeHolder};



        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);

        // Assign adapter to ListView
        listView.setAdapter(adapter);

        // ListView Item Click Listener
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                // ListView Clicked item index
                int itemPosition = position;

                // ListView Clicked item value
                String itemValue = (String) listView.getItemAtPosition(itemPosition);

                openActivity(itemValue);
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_home, menu);

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
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
                //if () {
                Intent intent = new Intent(this, Library.class);
                startActivity(intent);
                break;
                //}
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

    public void openActivity(String S) {
        switch (S) {
            case "Go to RecommendedItems": {
                Intent intent = new Intent(this, RecommendedItems.class);
                startActivity(intent);
                break;
            }
            case "Go to ItemView": {
                Intent intent = new Intent(this, ItemView.class);
                startActivity(intent);
                break;
            }
            case "Go to Profile": {
                Intent intent = new Intent(this, Profile.class);
                startActivity(intent);
                break;
            }
            case "Go to Library": {
                //if () {
                    Intent intent = new Intent(this, Library.class);
                    startActivity(intent);
                    break;
                //}
            }
            case "Go to SearchResults": {
                Intent intent = new Intent(this, SearchResults.class);
                startActivity(intent);
                break;
            }
            case "Go to Login": {
                Intent intent = new Intent(this, Login.class);
                startActivity(intent);
                break;
            }
            default: {
                break;
            }
        }
    }

    public void changeToItemView(View view) {
        Intent intent = new Intent(this, ItemView.class);
        startActivity(intent);
    }

    public void changeToLibraryView(View view) {
        Intent intent = new Intent(this, Library.class);
        startActivity(intent);
    }

    public void changeToSearchResultsView(View view) {
        Intent intent = new Intent(this, SearchResults.class);
        startActivity(intent);
    }

    public void changeToProfileView(View view) {
        Intent intent = new Intent(this, Profile.class);
        startActivity(intent);
    }

    public void changeToRecommendedItemsView(View view) {
        Intent intent = new Intent(this, RecommendedItems.class);
        startActivity(intent);
    }

}
