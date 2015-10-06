package com.afe.pc.embr;

import android.app.ActionBar;
import android.content.Intent;
import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;

public class HomeActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.home);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            ActionBar actionBar = getActionBar();
            actionBar.setHomeButtonEnabled(false);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_home, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_search:
                openSearch();
                return true;
            case R.id.action_settings:
                openSettings();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }

    }
    public void openSearch() {

    }

    public void openSettings() {

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
