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
import java.util.ArrayList;
import common.Strings;

/*
*  Making this view be a temporary Search on start, to maintain consistency with the iOS version
*
*  Author: Tyler Davis
*  Date: 10.9.15 - 2:12AM
 */
public class Search extends AppCompatActivity implements View.OnClickListener {

    private String[] emptyStrings = new String[]{"", "", "", "", "", "", "", "", "", "", "", ""};
    private String[] titles = new String[]{"The Lord of the Rings: The Fellowship of the Ring",
            "The Lord of the Rings: The Two Towers", "The Lord of the Rings: The Return of the King"};
    private String[] authors = new String[]{"J. R. R. Tolkien", "J. R. R. Tolkien", "J. R. R. Tolkien"};
    private String[] pictures = new String[]{"fellowship", "towers", "king"};
    private ArrayList<String> listview_values = new ArrayList<>();
    private ArrayList<String[]> listview_values_with_more = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.search_layout);
        populate_listview_on_start(appendStrings(listview_values, emptyStrings), (ListView) findViewById(R.id.search_listview));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_search, menu);
        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView = (SearchView) menu.findItem(R.id.menu_search).getActionView();
        if (null != searchView) {
            searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
            searchView.setIconifiedByDefault(false);
        }
        SearchView.OnQueryTextListener queryTextListener = new SearchView.OnQueryTextListener() {
            public boolean onQueryTextChange(String newText) {
                return true;
            }
            public boolean onQueryTextSubmit(String query) {
                ArrayList<String> tempTitles = new ArrayList<>();
                ArrayList<String> tempAuthors = new ArrayList<>();
                ArrayList<String> tempPictures = new ArrayList<>();
                listview_values_with_more.clear();
                for (int count = 0; count < titles.length; count++) {
                    if (Strings.compareString(query, titles[count])) {
                        tempTitles.add(titles[count]);
                        tempAuthors.add(authors[count]);
                        tempPictures.add(pictures[count]);
                    }
                }
                String[] tempStrArrayTitles = new String[tempTitles.size()];
                tempStrArrayTitles = tempTitles.toArray(tempStrArrayTitles);
                String[] tempStrArrayAuthors = new String[tempAuthors.size()];
                tempStrArrayAuthors = tempAuthors.toArray(tempStrArrayAuthors);
                String[] tempStrArrayPictures = new String[tempPictures.size()];
                tempStrArrayPictures = tempPictures.toArray(tempStrArrayPictures);
                listview_values_with_more.add(0, (tempStrArrayTitles));
                listview_values_with_more.add(1, (tempStrArrayAuthors));
                listview_values_with_more.add(2, (tempStrArrayPictures));
                populate_listview(listview_values_with_more, (ListView) findViewById(R.id.search_listview));
                return true;
            }
        };
        if(searchView != null)
            searchView.setOnQueryTextListener(queryTextListener);
        else
            Toast.makeText(Search.this, "Search Not Available", Toast.LENGTH_SHORT).show();
        return super.onCreateOptionsMenu(menu);
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
                Intent intent = new Intent(this, Search.class);
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
            case "SearchResults": {
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

    public void populate_listview(final ArrayList<String[]> values, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.single_row, R.id.results_Title, values.get(0));
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String title = values.get(0)[position];
                String author = values.get(1)[position];
                String picture = values.get(2)[position];
                openItemViewActivity(title, author, picture);
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

    public void openActivity(String S) {
        switch (S) {
            case "RecommendedItems": {
                Intent intent = new Intent(this, RecommendedItems.class);
                startActivity(intent);
                break;
            }
            case "ItemView": {
                Intent intent = new Intent(this, ItemView.class);
                startActivity(intent);
                break;
            }
            case "Profile": {
                Intent intent = new Intent(this, Profile.class);
                startActivity(intent);
                break;
            }
            case "Library": {
                Intent intent = new Intent(this, Library.class);
                startActivity(intent);
                break;
            }
            case "SearchResults": {
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
                Toast.makeText(Search.this, "Not Available", Toast.LENGTH_SHORT).show();
                break;
            }
        }
    }

    public void openItemViewActivity(String title, String author, String picture) {
        Intent intent = new Intent(this, ItemView.class);
        intent.putExtra("Book Title", title);
        intent.putExtra("Book Author", author);
        intent.putExtra("Book Picture", picture);
        startActivity(intent);
    }

    public ArrayList<String> appendStrings(ArrayList<String> arrayList, String[] stringArray) {
        for(int count = 0; count < stringArray.length; count++)
            arrayList.add(stringArray[count]);
        return arrayList;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.search_for_items:
                openActivity("SearchResults");
                break;
        }
    }
}
