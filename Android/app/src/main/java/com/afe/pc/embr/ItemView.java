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
import android.widget.EditText;
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
import org.w3c.dom.Text;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.Inflater;

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
    private String parent_type = "item";
    private long parent_id;

    private ArrayList<Library> libraries_list = new ArrayList<>();
    private ArrayList<String> library_names = new ArrayList<>();
    private ArrayList<Integer> library_ids = new ArrayList<>();
    private Map<String, Integer> library_keys = new HashMap<>();

    ListView listView;
    Button addToLibraryButton;
    Button addCommentButton;
    TextView titleView;
    TextView creatorView;
    TextView averageScoreView;
    TextView descriptionView;
    ImageView imageView;

    TextView commentView;
    ListView commentsList;
    EditText result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        unpackBundle(item_bundle);
        super.onCreate(savedInstanceState);
        if (loggedIn_status.equalsIgnoreCase("true") && !sessionID.isEmpty())
            isLoggedIn = true;
        setContentView(R.layout.item_view_layout);
        setTitle(itemName);
        titleView = (TextView) findViewById(R.id.itemView_title_textView);
        creatorView = (TextView) findViewById(R.id.itemView_creator_textView);
        averageScoreView = (TextView) findViewById(R.id.itemView_allReviews_textView);
        descriptionView = (TextView) findViewById(R.id.itemView_description_textView);
        imageView = (ImageView) findViewById(R.id.itemView_coverPicture_imageView);
        getData();
        getLibraries();

        // Comments list view
        listView = (ListView) findViewById(R.id.itemView_comments_listView);

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
                    //setContentView(R.layout.add_comment_layout);
                    final ViewGroup viewGroup = (ViewGroup) findViewById(R.id.itemView_relative_layout);
                    final View commentLayout = getLayoutInflater().inflate(R.layout.add_comment_layout, viewGroup);
                    //viewGroup.addView(commentLayout);
                    result = (EditText) findViewById(R.id.addComment_newComment_editText);
                    Button submitButton = (Button) findViewById(R.id.addComment_submit_button);
                    submitButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            String comment = result.getText().toString();
                            addComment(comment.replaceAll(" ", " "));
                            viewGroup.removeView(commentLayout);
                        }
                    });
                    Button cancelButton = (Button) findViewById(R.id.addComment_cancel_button);
                    cancelButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            viewGroup.removeView(commentLayout);
                        }
                    });
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

    public void populate_listview(final ArrayList<Comment> comments, final ListView listView) {

        String[] comments_content = new String[comments.size()];
        for (int i = 0; i < comments.size(); i++) {
            if (comments.get(i).getContent().length() > 60)
                comments_content[i] = comments.get(i).getContent().substring(0, 50) + "...";
            else
                comments_content[i] = comments.get(i).getContent();
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, comments_content);
        listView.setAdapter(adapter);
        setListViewHeightBasedOnChildren(listView);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                openCommentLayout(comments.get(position));
            }
        });
    }

    public void openCommentLayout(Comment comment) {
        parent_type = "comment";
        parent_id = comment.getComment_id();
        setContentView(R.layout.create_library_layout);
        commentView = (TextView) findViewById(R.id.commentView_text_textView);
        commentsList = (ListView) findViewById(R.id.commentView_subContent_listView);
        commentView.setText(comment.getContent());
        populate_listview(comment.getChild_comments(), commentsList);
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
                        String item_type = response.optString("type", "type");
                        switch (item_type) {
                            case "Book":
                                Book book = new Book();
                                setItemDetails(response, book);
                                book.setPublish_date(response.optString("publish_date", "publish_date"));
                                book.setNumber_of_pages(response.optInt("pages", -1));
                                book.setAuthor(response.optString("author", "author"));
                                book.setPublisher(response.optString("publisher", "publisher"));
                                book.setEdition(response.optString("edition", "edition"));
                                setItemLayout(book);
                                parent_id = book.getItem_id();
                                break;
                            case "Game":
                                Game game = new Game();
                                setItemDetails(response, game);
                                game.setPublisher(response.optString("publisher", "publisher"));
                                game.setDeveloper_studio(response.optString("studio", "studio"));
                                game.setRelease_date(response.optString("releaseDate", "releaseDate"));
                                game.setRating(response.optString("rating", "rating"));
                                game.setAverage_length_of_play(response.optInt("gameLength", -1));
                                game.setIs_multiplayer(response.optBoolean("multiplayer", false));
                                game.setIs_singleplayer(response.optBoolean("singleplayer", false));
                                setItemLayout(game);
                                parent_id = game.getItem_id();
                                break;
                            case "Movie":
                                Movie movie = new Movie();
                                setItemDetails(response, movie);
                                movie.setRating(response.optString("rating", "rating"));
                                movie.setRelease_date(response.optString("release_date", "release_date"));
                                movie.setRuntime(response.optString("runtime", "runtime"));
                                movie.setDirector(response.optString("director", "director"));
                                movie.setWriter(response.optString("writer", "writer"));
                                movie.setStudio(response.optString("studio", "studio"));
                                movie.setActors(response.optString("actors", "actors").split(", "));
                                setItemLayout(movie);
                                parent_id = movie.getItem_id();
                                break;
                            case "Music":
                                Music music = new Music();
                                setItemDetails(response, music);
                                music.setRelease_date(response.optString("release_date", "release_date"));
                                music.setRecording_company(response.optString("recording_company", "recording_company"));
                                music.setArtist(response.optString("artist", "artist"));
                                music.setLength(response.optString("length", "length"));
                                setItemLayout(music);
                                parent_id = music.getItem_id();
                                break;
                            case "TV":
                                TV tv = new TV();
                                setItemDetails(response, tv);
                                tv.setAir_date(response.optString("airDate", "airDate"));
                                tv.setDirectors(response.optString("director", "director"));
                                tv.setRuntime(response.optString("length", "length"));
                                tv.setActors(response.optString("actors", "actors").split(", "));
                                tv.setWriters(response.optString("writer", "writer"));
                                tv.setChannel(response.optString("channel", "channel"));
                                setItemLayout(tv);
                                parent_id = tv.getItem_id();
                                break;
                            default:
                                break;
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    parent_type = "item";
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

    public void addComment(String comment) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/AddComment.py?parent_type=" + parent_type + "&parent_id=" + Double.toString(parent_id) +
                "&session=" + sessionID + "&content=" + comment, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (!response.getBoolean("success"))
                        Toast.makeText(ItemView.this, "Unable to add comment", Toast.LENGTH_SHORT).show();
                    else {
                        Toast.makeText(ItemView.this, "Added Comment", Toast.LENGTH_SHORT).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
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
            item.setUser_score(response.optInt("user_score", -1));
            item.setItem_rating(response.optString("rating", "rating"));
            JSONArray item_genres = response.getJSONArray("genres");
            String[] item_temp_genres = new String[item_genres.length()];
            for (int i = 0; i < item_genres.length(); i++)
                item_temp_genres[i] = item_genres.get(i).toString();
            item.setGenres(item_temp_genres);
            item.setAverage_score(response.optDouble("average_score", -1));
            item.setDescription(response.optString("description", "description"));
            item.setTitle(response.optString("title", "title"));
            item.setImage_URL(response.optString("image", "image.png"));
            item.setParent_id(response.optInt("parent_id", -1));
//            JSONArray item_child_items = response.getJSONArray("child_items");
//            long[] item_temp_child_items = new long[item_child_items.length()];
//            for (int i = 0; i < item_child_items.length(); i++)
//                item_temp_child_items[i] = item_child_items.getInt(i);
//            item.setChild_items(item_temp_child_items);
            item.setMedia_type(response.optString("type", "type"));
            item.setItem_id(response.optLong("id", -1));
            ArrayList<Comment> comments_array = new ArrayList<>();
            item.setComments(parseComments(response.getJSONArray("comments"), comments_array));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Comment> parseComments(JSONArray comments, ArrayList<Comment> comments_array) {

        try {
            for (int i = 0; i < comments.length(); i++) {
                Comment comment = new Comment();
                comment.setCreate_date(comments.getJSONObject(i).optString("create_date", "create_date"));
                comment.setContent(comments.getJSONObject(i).optString("content", "content"));
                comment.setUser_score(comments.getJSONObject(i).optInt("user_review", -1));
                comment.setItem_id(comments.getJSONObject(i).optLong("item_id", -1));
                comment.setUser_id(comments.getJSONObject(i).optInt("user_id", -1));
                comment.setComment_rating(comments.getJSONObject(i).optInt("comment_rating", -1));
                comment.setUser_name(comments.getJSONObject(i).optString("user_name", "user_name"));
                comment.setComment_id(comments.getJSONObject(i).optLong("id", -1));
                if (comments.getJSONObject(i).getJSONArray("child_comments").length() != 0) {
                    comment.setChild_comments(new ArrayList<Comment>());
                    parseComments(comments.getJSONObject(i).getJSONArray("child_comments"), comment.getChild_comments());
                }
                comments_array.add(comment);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return comments_array;
    }

    public void setItemLayout(Item item) {

//        switch (item.getMedia_type()) {
//            case "Book":
//
//                break;
//            case "Game":
//
//                break;
//            case "Movie":
//
//                break;
//            case "Music":
//
//                break;
//            case "TV":
//
//                break;
//            default:
//                break;
//        }
        populate_listview(item.getComments(), listView);
        // userscore, itemrating, genres, averagescore, description, title, image, parentid, childitems, mediatype, itemid, comments
        averageScoreView.setText(item.getAverage_score());
        descriptionView.setText(item.getDescription());
        titleView.setText(item.getTitle());
        new DownloadImageTask((ImageView) findViewById(R.id.itemView_coverPicture_imageView)).execute(item.getImage_URL());
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
