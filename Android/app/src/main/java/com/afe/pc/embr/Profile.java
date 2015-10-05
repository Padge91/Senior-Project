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

public class Profile extends AppCompatActivity implements View.OnClickListener {

    Button button1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);
        button1 = (Button)findViewById(R.id.search_for_items);
        button1.setOnClickListener(this);
        getActionBar().setDisplayHomeAsUpEnabled(true);
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

        return super.onOptionsItemSelected(item);
    }
    public void openActivity(String S){
        if (S == "Home"){
            Intent intent = new Intent(this, HomeActivity.class);
            startActivity(intent);
        }
        else if (S == "RecommendedItems"){
            Intent intent = new Intent(this, RecommendedItems.class);
            startActivity(intent);
        }
        else if (S == "Library"){
            Intent intent = new Intent(this, Library.class);
            startActivity(intent);
        }
        else if (S == "SearchResults"){
            Intent intent = new Intent(this, SearchResults.class);
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
