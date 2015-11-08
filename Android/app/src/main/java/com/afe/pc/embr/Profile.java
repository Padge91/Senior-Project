package com.afe.pc.embr;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.PopupMenu;
import android.widget.SearchView;

public class Profile extends AppCompatActivity implements View.OnClickListener {

    Button button1;
    SearchView search_text;

    public static final String SEARCH_QUERY_KEY = "SEARCH_QUERY";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);
        button1 = (Button)findViewById(R.id.search_for_items);
        button1.setOnClickListener(this);
        search_text = (SearchView)findViewById(R.id.search_for_Item);
    }

    public void showPopUp(View view){
        PopupMenu popupMenu = new PopupMenu(this,view);
        MenuInflater menuInflater=popupMenu.getMenuInflater();
        PopUpMenuEventHandle popUpMenuEventHandle=new PopUpMenuEventHandle(getApplicationContext());
        popupMenu.setOnMenuItemClickListener(popUpMenuEventHandle);
        menuInflater.inflate(R.menu.menu_profile,popupMenu.getMenu());
        popupMenu.show();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_profile, menu);

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
                //if () {
                Intent intent = new Intent(this, Library_activity.class);
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

    public void openActivity(String S){
        if (S.equals("Home")){
            Intent intent = new Intent(this, Search.class);
            startActivity(intent);
        }
        else if (S.equals("RecommendedItems")){
            Intent intent = new Intent(this, RecommendedItems.class);
            startActivity(intent);
        }
        else if (S.equals("Library_activity")){
            Intent intent = new Intent(this, Library_activity.class);
            startActivity(intent);
        }
        else if (S.equals("SearchResults")){
            CharSequence search_query = search_text.getQuery();
            Intent intent = new Intent(this, SearchResults.class);
            intent.putExtra(SEARCH_QUERY_KEY, search_query);
            startActivity(intent);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.search_for_items:
                openActivity("SearchResults");
                break;
        }
    }
}
