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
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.TextView;
import android.widget.Toast;

public class ItemView extends AppCompatActivity {

    ListView listView;
    Button addToLibraryButton;
    TextView title;
    TextView author;
    TextView releaseDate;
    TextView pageCount;
    ImageView coverPicture;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        String item_name = "";
        try {
            item_name = item_bundle.getString("Book Title");
        } catch (Exception e) {}
        if (item_name != null && item_name.equalsIgnoreCase("The Lord of the Rings: The Fellowship of the Ring")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.item_view_layout);
            title = (TextView) findViewById(R.id.itemView_title_textView);
            author = (TextView) findViewById(R.id.itemView_author_textView);
            releaseDate = (TextView) findViewById(R.id.itemView_releaseDate_textView);
            pageCount = (TextView) findViewById(R.id.itemView_pageCount_textView);
            coverPicture = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);
            title.setText(item_bundle.getString("Book Title"));
            author.setText(item_bundle.getString("Book Author"));
            releaseDate.setText("June 19, 1957");
            pageCount.setText("437");
            coverPicture.setImageResource(getResources().getIdentifier("@drawable/lotr1", null, getPackageName()));
        }
        else if (item_name != null && item_name.equalsIgnoreCase("The Lord of the Rings: The Two Towers")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.item_view_layout);
            title = (TextView) findViewById(R.id.itemView_title_textView);
            author = (TextView) findViewById(R.id.itemView_author_textView);
            releaseDate = (TextView) findViewById(R.id.itemView_releaseDate_textView);
            pageCount = (TextView) findViewById(R.id.itemView_pageCount_textView);
            coverPicture = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);
            title.setText(item_bundle.getString("Book Title"));
            author.setText(item_bundle.getString("Book Author"));
            releaseDate.setText("June 19, 1958");
            pageCount.setText("438");
            coverPicture.setImageResource(getResources().getIdentifier("@drawable/lotr2", null, getPackageName()));
        }
        else if (item_name != null && item_name.equalsIgnoreCase("The Lord of the Rings: The Return of the King")) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.item_view_layout);
            title = (TextView) findViewById(R.id.itemView_title_textView);
            author = (TextView) findViewById(R.id.itemView_author_textView);
            releaseDate = (TextView) findViewById(R.id.itemView_releaseDate_textView);
            pageCount = (TextView) findViewById(R.id.itemView_pageCount_textView);
            coverPicture = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);
            title.setText(item_bundle.getString("Book Title"));
            author.setText(item_bundle.getString("Book Author"));
            releaseDate.setText("June 19, 1959");
            pageCount.setText("439");
            coverPicture.setImageResource(getResources().getIdentifier("@drawable/lotr3", null, getPackageName()));
        }

        // Comments list view
        listView = (ListView) findViewById(R.id.itemView_comments_listView);
        String[] values = new String[]{"Comment 1", "Comment 2", "Comment 3", "Comment 4",
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
        addToLibraryButton = (Button) findViewById(R.id.itemView_addToLibrary_button);
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
        getMenuInflater().inflate(R.menu.menu_item_view, menu);
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

    public void addToLibraryButtonStartActivity(String s) {
        switch(s) {
            case "Owned":
                Toast.makeText(ItemView.this, "Added book to Owned Library", Toast.LENGTH_SHORT).show();
                break;
            case "Wishlist":
                Toast.makeText(ItemView.this, "Added book to Wish List Library", Toast.LENGTH_SHORT).show();
                break;
            case "Viewed":
                Toast.makeText(ItemView.this, "Added book to Viewed Library", Toast.LENGTH_SHORT).show();
                break;
            default:
                Toast.makeText(ItemView.this, "Not Available", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    public void openCommentActivity(String s) {
        Intent intent = new Intent(this, CommentView.class);
        intent.putExtra("Comment ID", s);
        startActivity(intent);
    }
}
