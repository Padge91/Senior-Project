package com.afe.pc.embr;

import android.content.DialogInterface;
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
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.Toast;

public class ItemView extends AppCompatActivity {

    ListView listView;
    Button addToLibraryButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.item_view_layout);

        // List view
        listView = (ListView) findViewById(R.id.list1);
        String[] values = new String[] {"Comment 1", "Comment 2", "Comment 3", "Comment 4",
                "Comment 5", "Comment 6", "Comment 7", "Comment 8", "Comment 9", "Comment 10",
                "Comment 11", "Comment 12", "Comment 13", "Comment 14", "Comment 15", "Comment 16"};
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String itemValue = (String) listView.getItemAtPosition(position);
                openCommentActivity(itemValue);
            }
        });

        // PopUp for the add to libraries button
        addToLibraryButton = (Button) findViewById(R.id.addToLibraryButton);
        addToLibraryButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                PopupMenu popup = new PopupMenu(ItemView.this, addToLibraryButton);
                popup.getMenuInflater().inflate(R.menu.menu_library, popup.getMenu());
                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    public boolean onMenuItemClick(MenuItem item) {
                        addToLibraryButtonStartActivity(item.toString());
                        return true;
                    }
                });
                popup.show();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_item_view, menu);
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

    public void addToLibraryButtonStartActivity(String s) {
        Intent intent;
        switch(s) {
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
                Toast.makeText(ItemView.this, "Not Available", Toast.LENGTH_SHORT).show();
                intent = new Intent(this, HomeActivity.class);
                break;
        }
        startActivity(intent);
    }

    public void openCommentActivity(String s) {
        Intent intent = new Intent(this, CommentView.class);
        intent.putExtra("Comment ID", s);
        startActivity(intent);
    }
}
