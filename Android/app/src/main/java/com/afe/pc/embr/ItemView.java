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
import java.util.ArrayList;

import common.Item;
import common.Library;
import utilities.HttpConnect;
import utilities.HttpResult;

public class ItemView extends AppCompatActivity {

    private boolean isLoggedIn = false;
    private String loggedIn_status = "";
    private String sessionID = "";
    private int userID;
    private long itemID = 0; // id from the search
    private int addToLibraryID;

    private Item item;
    private ArrayList<Library> libraries_list = new ArrayList<>();
    private ArrayList<String> library_names = new ArrayList<>();
    private ArrayList<Integer> library_ids = new ArrayList<>();

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
        getLibraries();
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
                if (!isLoggedIn)
                    Toast.makeText(ItemView.this, "Please login to use this feature", Toast.LENGTH_SHORT).show();
                else {
                    PopupMenu popup = new PopupMenu(ItemView.this, addToLibraryButton);
                    popup.getMenuInflater().inflate(R.menu.menu_library_button, popup.getMenu());
                    populateMenuLibraryButton(popup.getMenu());
                    popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                        public boolean onMenuItemClick(MenuItem item) {
                            addToLibraryID = item.getItemId();
                            addToLibraryButton(item.toString());
                            return true;
                        }
                    });
                    popup.show();
                }
            }
        });

        // PopUp for the add comment button
        addCommentButton = (Button) findViewById(R.id.itemView_addComment_button);
        addCommentButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!isLoggedIn)
                    Toast.makeText(ItemView.this, "Please login to use this feature", Toast.LENGTH_SHORT).show();
                else {
                    // logic for adding comments
                    // probably create a separate layout for this
                    // take to layout, enter comment, submit comment, return to item with the updated comment
                    // or create a popup for them to enter comment into, submit comment (requires page refresh...)
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_item_view, menu);
        if (!isLoggedIn) {
            menu.getItem(4).setTitle("Login");
            menu.getItem(3).setVisible(false);
            menu.getItem(2).setVisible(false);
            menu.getItem(0).setVisible(false);
        }
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
            Intent intent = new Intent(this, Library_activity.class);
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

    public void addToLibraryButton(String s) {
        addToLibrary(s);
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
        getUserID();
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

                        item.setAverage_score((double) response.getInt("average_score"));
                        item.setItem_id(response.getLong("id"));
                        item.setUser_score(response.getInt("user_score"));
                        item.setTitle(response.getJSONObject("title").toString());
                        item.setCreator(response.getString("creator"));
                        item.setDescription(response.getString("description"));
                        item.setImageURI(response.getString("image"));

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

    public void getLibraries() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetLibrariesList.py?session=" + sessionID + "&user_id=" + Integer.toString(userID), Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        JSONArray jsonArray = response.getJSONArray("response");
                        for (int i = 0; i < jsonArray.length(); i++) {
                            Library library = new Library();
                            library.setId(jsonArray.getJSONObject(i).getInt("id"));
                            library.setUser_id(jsonArray.getJSONObject(i).getInt("user_id"));
                            library.setName(jsonArray.getJSONObject(i).getString("name"));
                            libraries_list.add(library);
                        }
                        setLibrary_names();
                        setLibrary_ids();
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void addToLibrary(final String s) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/AddItemToLibrary.py?session=" + sessionID + "&library_id=" +
                addToLibraryID + "&itemID=" + itemID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (!response.getBoolean("success"))
                        Toast.makeText(ItemView.this, item.getTitle() + " was not added to " + s + " Library", Toast.LENGTH_SHORT).show();
                    else
                        Toast.makeText(ItemView.this, "Added to " + s + " Library", Toast.LENGTH_SHORT).show();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void getUserID() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/GetUserIdFromSession.py?session=" + sessionID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                if (!success) {
                } else {
                    try {
                        userID = response.getInt("response");
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void setLibrary_names() {
        for(int i = 0; i < libraries_list.size(); i++)
            library_names.add(libraries_list.get(i).getName());
    }

    public void setLibrary_ids() {
        for(int i = 0; i < libraries_list.size(); i++)
            library_ids.add(libraries_list.get(i).getId());
    }

    public void populateMenuLibraryButton(Menu menu) {
//        for(int i = 0; i < library_names.size(); i++)
//            menu.getItem(i + 3).setTitle(library_names.get(i));
        for(int i = 3; i < menu.size(); i++)
            menu.getItem(i).setVisible(false);
    }
}
