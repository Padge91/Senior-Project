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
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListAdapter;
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
import java.util.HashMap;
import java.util.Map;

import common.Comment;
import common.Item;
import common.Library;
import common.itemTypes.Book;
import common.itemTypes.Game;
import common.itemTypes.Movie;
import common.itemTypes.Music;
import common.itemTypes.TV;
import utilities.HttpConnect;
import utilities.HttpResult;

import static utilities.Activity.putExtraForMenuItem;

public class ItemView extends AppCompatActivity {

    private boolean isLoggedIn = false;
    private String loggedIn_status = "";
    private String sessionID = "";
    private String username = "";
    private int userID;
    private long itemID = 0;
    private int libraryID = 0;
    private String libraryName = "";
    private String itemName = "";

    private ArrayList<Library> libraries_list = new ArrayList<>();
    private ArrayList<String> library_names = new ArrayList<>();
    private ArrayList<Integer> library_ids = new ArrayList<>();
    private Map<String, Integer> library_keys = new HashMap<>();

    ListView listView;
    Button addToLibraryButton;
    Button addCommentButton;
    TextView titleView;
    TextView creatorView;
    TextView userScoreView;
    TextView averageScoreView;
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
        setTitle(itemName);
        getData();
        getLibraries();
        titleView = (TextView) findViewById(R.id.itemView_title_textView);
        creatorView = (TextView) findViewById(R.id.itemView_creator_textView);
        averageScoreView = (TextView) findViewById(R.id.itemView_allReviews_textView);
        descriptionView = (TextView) findViewById(R.id.itemView_description_textView);
        imageView = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);

        // Comments list view
        listView = (ListView) findViewById(R.id.itemView_comments_listView);
        String[] values = new String[]{"Comment 1", "Comment 2", "Comment 3", "Comment 4",
                "Comment 5", "Comment 6", "Comment 7", "Comment 8", "Comment 9", "Comment 10",
                "Comment 11", "Comment 12", "Comment 13", "Comment 14", "Comment 15", "Comment 16"};
        populate_listview(values, listView);

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
                    for (int i = 0; i < library_names.size(); i++)
                        popup.getMenu().getItem(i).setTitle(library_names.get(i));
                    for (int i = library_names.size(); i < popup.getMenu().size(); i++)
                        popup.getMenu().getItem(i).setVisible(false);
                    popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                        public boolean onMenuItemClick(MenuItem item) {
                            libraryName = item.toString();
                            libraryID = library_keys.get(libraryName);
                            addToLibrary();
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
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Search")) {
            Intent intent = new Intent(this, Search.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Libraries")) {
            Intent intent = new Intent(this, LibraryList.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Recommended Items")) {
            Intent intent = new Intent(this, RecommendedItems.class);
            putExtraForMenuItem(item, loggedIn_status, sessionID, userID, username, intent);
            startActivity(intent);
        } else if (s.equals("Login") || s.equals("Logout")) {
            Intent intent = new Intent(this, Login.class);
            startActivity(intent);
        }
        return super.onOptionsItemSelected(item);
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
        try {
            userID = bundle.getInt("userID");
        } catch (Exception e) {
        }
        try {
            itemName = bundle.getString("itemName");
        } catch (Exception e) {
        }
        try {
            username = bundle.getString("username");
        } catch (Exception e) {
        }
    }

    public void populate_listview(final String[] values, final ListView listView) {

        // Define a new Adapter
        // First parameter - Context
        // Second parameter - Layout for the row
        // Third parameter - ID of the TextView to which the data is written
        // Forth - the Array of data

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
        setListViewHeightBasedOnChildren(listView);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String itemValue = (String) listView.getItemAtPosition(position);
                openCommentActivity(itemValue);
            }
        });
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
                if (!success) {
                    Toast.makeText(ItemView.this, "No Response", Toast.LENGTH_SHORT).show();
                } else {
                    try {
                        response = response.getJSONObject("response");
                        String item_type = response.getString("type");
                        switch (item_type) {
                            case "Book":
                                Book book = new Book();
                                setItemDetails(response, book);
                                book.setPublish_date(response.getString("publish_date"));
                                book.setNumber_of_pages(response.getInt("pages"));
                                book.setAuthor(response.getString("author"));
                                book.setPublisher(response.getString("publisher"));
                                book.setEdition(response.getString("edition"));
                                setItemLayout(book);
                                break;
                            case "Game":
                                Game game = new Game();
                                setItemDetails(response, game);
                                game.setPublisher(response.getString("publisher"));
                                game.setDeveloper_studio(response.getString("developer_studio"));
                                game.setRelease_date(response.getString("release_date"));
                                game.setRating(response.getString("rating"));
                                game.setAverage_length_of_play(response.getInt("average_length_of_play"));
                                game.setIs_multiplayer(response.getBoolean("multiplayer"));
                                game.setIs_singleplayer(response.getBoolean("singleplayer"));
                                setItemLayout(game);
                                break;
                            case "Movie":
                                Movie movie = new Movie();
                                setItemDetails(response, movie);
                                movie.setRating(response.getString("rating"));
                                movie.setRelease_date(response.getString("release_date"));
                                movie.setRuntime(response.getString("runtime"));
                                movie.setDirector(response.getString("director"));
                                movie.setWriter(response.getString("writer"));
                                movie.setStudio(response.getString("studio"));
                                movie.setActors(response.getString("actors").split(" "));
                                setItemLayout(movie);
                                break;
                            case "Music":
                                Music music = new Music();
                                setItemDetails(response, music);
                                music.setRelease_date(response.getString("release_date"));
                                music.setRecording_company(response.getString("recording_company"));
                                music.setArtist(response.getString("artist"));
                                music.setLength(response.getString("length"));
                                setItemLayout(music);
                                break;
                            case "TV":
                                TV tv = new TV();
                                setItemDetails(response, tv);
                                tv.setAir_date(response.getString("airDate"));
                                tv.setDirectors(response.getString("director"));
                                tv.setRuntime(response.getString("length"));
                                tv.setActors(response.getString("actors").split(" "));
                                tv.setWriters(response.getString("writer"));
                                tv.setChannel(response.getString("channel"));
                                setItemLayout(tv);
                                break;
                            default:
                                break;
                        }
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
                            library_keys.put(library.getName(), library.getId());
                        }
                        setLibrary_names();
                        setLibrary_ids();
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void addToLibrary() {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/AddItemToLibrary.py?session=" + sessionID + "&library_id=" +
                libraryID + "&item_id=" + itemID, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (!response.getBoolean("success"))
                        Toast.makeText(ItemView.this, response.getString("response"), Toast.LENGTH_SHORT).show();
                    else
                        Toast.makeText(ItemView.this, "Added to " + libraryName + " Library", Toast.LENGTH_SHORT).show();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void setLibrary_names() {
        for (int i = 0; i < libraries_list.size(); i++)
            library_names.add(libraries_list.get(i).getName());
    }

    public void setLibrary_ids() {
        for (int i = 0; i < libraries_list.size(); i++)
            library_ids.add(libraries_list.get(i).getId());
    }

    public void setItemDetails(JSONObject response, Item item) {

        try {
            if (!response.isNull("user_score"))
                item.setUser_score(response.getInt("user_score"));
            else
                item.setUser_score(-1);
            item.setItem_rating(response.getString("rating"));
            JSONArray item_genres = response.getJSONArray("genres");
            String[] item_temp_genres = new String[item_genres.length()];
            for (int i = 0; i < item_genres.length(); i++)
                item_temp_genres[i] = item_genres.get(i).toString();
            item.setGenres(item_temp_genres);
            item.setAverage_score(response.getDouble("average_score"));
            item.setDescription(response.getString("description"));
            item.setTitle(response.getString("title"));
            item.setImage_URL(response.getString("image"));
            if (!response.isNull("parent_id"))
                item.setParent_id(response.getInt("parent_id"));
            else
                item.setParent_id(-1);
            JSONArray item_child_items = response.getJSONArray("child_items");
            long[] item_temp_child_items = new long[item_child_items.length()];
            for (int i = 0; i < item_child_items.length(); i++)
                item_temp_child_items[i] = item_child_items.getInt(i);
            item.setChild_items(item_temp_child_items);
            item.setMedia_type(response.getString("type"));
            item.setItem_id(response.getLong("id"));
            ArrayList<Comment> comments_array = new ArrayList<>();
            item.setComments(parseComments(response.getJSONArray("comments"), comments_array));
        } catch (Exception e) {
        }
    }

    public void setItemLayout(Item item) {

        switch (item.getMedia_type()) {
            case "Book":

                break;
            case "Game":

                break;
            case "Movie":

                break;
            case "Music":

                break;
            case "TV":

                break;
            default:
                break;
        }
        // userscore, itemrating, genres, averagescore, description, title, image, parentid, childitems, mediatype, itemid, comments
        

        // new DownloadImageTask((ImageView) findViewById(R.id.itemView_coverPicture_imageView)).execute(item.getImage_URL());
    }

    public ArrayList<Comment> parseComments(JSONArray comments, ArrayList<Comment> comments_array) {

        try {
            for (int i = 0; i < comments.length(); i++) {
                Comment comment = new Comment();
                comment.setCreate_date(comments.getJSONObject(i).getString("create_date"));
                comment.setContent(comments.getJSONObject(i).getString("content"));
                if (!comments.getJSONObject(i).isNull("user_review"))
                    comment.setUser_score(comments.getJSONObject(i).getInt("user_review"));
                else
                    comment.setUser_score(-1);
                comment.setItem_id(comments.getJSONObject(i).getLong("item_id"));
                comment.setUser_id(comments.getJSONObject(i).getInt("user_id"));
                comment.setComment_rating(comments.getJSONObject(i).getInt("comment_rating"));
                comment.setUser_name(comments.getJSONObject(i).getString("user_name"));
                comment.setComment_id(comments.getJSONObject(i).getLong("comment_id"));
                if (comments.getJSONObject(i).getJSONArray("child_comments").length() != 0)
                    parseComments(comments.getJSONObject(i).getJSONArray("child_comments"), comment.getChild_comments());
                comments_array.add(comment);
            }
        } catch (Exception e) {
        }
        return comments_array;
    }

    public static void setListViewHeightBasedOnChildren(ListView listView) {
        ListAdapter listAdapter = listView.getAdapter();
        if (listAdapter == null) {
            // pre-condition
            return;
        }

        int totalHeight = 0;
        for (int i = 0; i < listAdapter.getCount(); i++) {
            View listItem = listAdapter.getView(i, null, listView);
            listItem.measure(0, 0);
            totalHeight += listItem.getMeasuredHeight();
        }

        ViewGroup.LayoutParams params = listView.getLayoutParams();
        params.height = totalHeight + (listView.getDividerHeight() * (listAdapter.getCount() - 1));
        listView.setLayoutParams(params);
    }
}
