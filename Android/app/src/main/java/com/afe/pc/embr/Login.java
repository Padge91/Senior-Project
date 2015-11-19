package com.afe.pc.embr;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;

import org.json.JSONException;
import org.json.JSONObject;

import utilities.HttpConnect;
import utilities.HttpResult;

public class Login extends AppCompatActivity implements Button.OnClickListener {

    public static final String PREFS_NAME = "MyPrefsFile";
    Button loginButton, signUpButton;
    EditText username, password;
    String usernameEntry, passwordEntry;
    private boolean logoutAttempt = false;
    private String sessionID = "";
    private int userID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Bundle item_bundle = getIntent().getExtras();
        unpackBundle(item_bundle);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_layout);
        username = (EditText) findViewById(R.id.login_username_editText);
        username.setHint("Username");
        password = (EditText) findViewById(R.id.login_password_editText);
        password.setHint("Password");
        loginButton = (Button) findViewById(R.id.login_login_button);
        loginButton.setOnClickListener(this);
        signUpButton = (Button) findViewById(R.id.signup_button);
        signUpButton.setOnClickListener(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putString("sessionID", "");
        editor.putString("LoggedIn", "");
        editor.putInt("userID", -1);
        editor.apply();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return true;
    }

    @Override
    public void onBackPressed() {
        if (logoutAttempt)
            return;
        else
            super.onBackPressed();
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.login_login_button:
                usernameEntry = username.getText().toString();
                passwordEntry = password.getText().toString();
                verifyLogin(usernameEntry, passwordEntry);
                break;
            case R.id.signup_button:
                Intent intent = new Intent(this, Signup.class);
                startActivity(intent);
                break;
        }
    }

    public void unpackBundle(Bundle bundle) {
        try {
            logoutAttempt = bundle.getBoolean("logoutAttempt");
        } catch (Exception e) {
        }
    }

    public void verifyLogin(String username, String password) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/Login.py?username=" + username + "&password=" + password, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (response.getString("success").equals("false")) {
                        Toast.makeText(Login.this, "Invalid Username or Password", Toast.LENGTH_SHORT).show();
                    } else {
                        try {
                            sessionID = response.getString("response");
                            getUserID();
                        } catch (Exception e) {
                        }
                    }
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
                        openSearchActivity();
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void openSearchActivity() {
        if (!sessionID.isEmpty()) {
            SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("sessionID", sessionID);
            editor.putString("LoggedIn", "true");
            editor.putInt("userID", userID);
            editor.apply();
            Intent intent = new Intent(this, Search.class);
            intent.putExtra("LoggedIn", "true");
            intent.putExtra("sessionID", sessionID);
            intent.putExtra("userID", userID);
            intent.putExtra("isFromLogin", true);
            intent.putExtra("username", username.getText().toString());
            startActivity(intent);
            finish();
        }
    }
}

