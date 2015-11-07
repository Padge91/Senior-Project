package com.afe.pc.embr;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
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

import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;

import common.Item;
import utilities.HttpConnect;
import utilities.HttpResult;

public class ItemView extends AppCompatActivity {

    private boolean isLoggedIn = false;
    private String loggedIn_status = "";
    private String sessionID = "";
    private long itemID = 0; // id from the search

    private Item item;

    ListView listView;
    Button addToLibraryButton;
    Button addCommentButton;
    TextView titleView;
    TextView creatorView;
    TextView userScoreView;
    TextView descriptionView;
    ImageView imageView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        unpackBundle(item_bundle);
        super.onCreate(savedInstanceState);
        if (loggedIn_status.equalsIgnoreCase("true") && !sessionID.isEmpty())
            isLoggedIn = true;
        setContentView(R.layout.item_view_layout);
        getData();
        titleView = (TextView) findViewById(R.id.itemView_title_textView);
        creatorView = (TextView) findViewById(R.id.itemView_creator_textView);
        userScoreView = (TextView) findViewById(R.id.itemView_allReviews_textView);
        descriptionView = (TextView) findViewById(R.id.itemView_description_textView);
        imageView = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);
        //new DownloadImageTask((ImageView) findViewById(R.id.itemView_coverPicture_imageView)).execute(image);

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

        // PopUp for the add comment button
        addCommentButton = (Button) findViewById(R.id.itemView_addComment_button);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_item_view, menu);
        if (isLoggedIn)
            menu.getItem(4).setTitle("Logout");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String s = item.getTitle().toString();
        if (s.equals("Profile")) {
            Intent intent = new Intent(this, Profile.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Libraries")) {
            Intent intent = new Intent(this, Library.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            intent.putExtra("LoggedIn", loggedIn_status);
            intent.putExtra("sessionID", sessionID);
            startActivity(intent);
        } else if (s.equals("Login") || s.equals("Logout")) {
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
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
            itemID = bundle.getInt("itemID");
        } catch (Exception e) {
        }
    }

    public void openCommentActivity(String s) {
        Intent intent = new Intent(this, CommentView.class);
        intent.putExtra("Comment ID", s);
        startActivity(intent);
    }

    class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
        ImageView bmImage;
        public DownloadImageTask(ImageView bmImage) {
            this.bmImage = bmImage;
        }
        protected Bitmap doInBackground(String... urls) {
            String urldisplay = urls[0];
            Bitmap mIcon11 = null;
            try {
                InputStream in = new java.net.URL(urldisplay).openStream();
                mIcon11 = BitmapFactory.decodeStream(in);
            } catch (Exception e) {
                Log.e("Error", e.getMessage());
                e.printStackTrace();
            }
            return mIcon11;
        }

        protected void onPostExecute(Bitmap result) {
            bmImage.setImageBitmap(result);
        }
    }

    public void getData() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetItemInfo.py?id=" + Long.toString(itemID) + "&session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                Log.i("in oncallback", "response: ");
                if (!success) {
                    Toast.makeText(ItemView.this, "No Response", Toast.LENGTH_SHORT).show();
                    Log.i("not success", "response: ");
                } else {
                    Log.i("in else", "response: ");
                    try {
                        Log.i("trying", "response: ");
                        //JSONArray jsonArray = response.getJSONArray("comments");
                        /*
                        for (int i = 0; i < jsonArray.length(); i++) {
                            // child comments array
                            comment_rating = jsonArray.getJSONObject(i).getInt("comment_rating");
                            content = jsonArray.getJSONObject(i).getString("content");
                            create_date = jsonArray.getJSONObject(i).getString("create_date");
                            comment_id = jsonArray.getJSONObject(i).getInt("id");
                            item_id = jsonArray.getJSONObject(i).getInt("item_id");
                            user_id = jsonArray.getJSONObject(i).getInt("user_id");
                            user_name = jsonArray.getJSONObject(i).getString("user_name");
                            user_review = jsonArray.getJSONObject(i).getInt("user_review");
                            addCommentDetails();
                        } */


                        //item.setAverage_score((double) response.getInt("average_score"));
                        //Log.i("average score", "response: " + item.getAverage_score());
                        //item.setItem_id(response.getLong("id"));
                        //Log.i("item id", "response: " + item.getItem_id());
                        //item.setUser_score(response.getInt("user_score"));
                        //Log.i("user score", "response: " + item.getUser_score());
                        item.setTitle(response.getJSONObject("title").toString());
                        Log.i("title", "response: " + item.getTitle());
                        item.setCreator(response.getString("creator"));
                        Log.i("creator", "response: " + item.getCreator());
                        item.setDescription(response.getString("description"));
                        Log.i("description", "response: " + item.getDescription());
                        item.setImageURI(response.getString("image"));
                        Log.i("image uri", "response: " + item.getImageURI());

                        // populate textViews in itemView layout
                        titleView.setText(item.getTitle());
                        creatorView.setText(item.getCreator());
                        userScoreView.setText(Integer.toString(item.getUser_score()));
                        descriptionView.setText(item.getDescription());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
    }
}
