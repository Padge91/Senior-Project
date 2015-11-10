package com.afe.pc.embr;

import android.content.Intent;
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

    Button loginButton, skipLoginButton, signUpButton;
    EditText username, password;
    String usernameEntry, passwordEntry;
    private String sessionID = "";
    private int userID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_layout);
        username = (EditText) findViewById(R.id.login_username_editText);
        username.setHint("Username");
        password = (EditText) findViewById(R.id.login_password_editText);
        password.setHint("Password");
        loginButton = (Button) findViewById(R.id.login_login_button);
        loginButton.setOnClickListener(this);
        skipLoginButton = (Button) findViewById(R.id.login_skipLogin_button);
        skipLoginButton.setOnClickListener(this);
        signUpButton = (Button) findViewById(R.id.signup_button);
        signUpButton.setOnClickListener(this);
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
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.login_login_button:
                usernameEntry = username.getText().toString();
                passwordEntry = password.getText().toString();
                verifyLogin(usernameEntry, passwordEntry);
                break;
            case R.id.login_skipLogin_button:
                openSearchActivity("Skip Login");
                break;
            case R.id.signup_button:
                Intent intent = new Intent(this, Signup.class);
                startActivity(intent);
                break;
        }
    }

    public void verifyLogin(String username, String password) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/Login.py?username=" + username + "&password=" + password, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (response.getString("success").equals("false")) {
                        Toast.makeText(Login.this, "Invalid Username or Password", Toast.LENGTH_SHORT).show();
                    }
                    else {
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
                        openSearchActivity("Login");
                    } catch (Exception e) {
                    }
                }
            }
        });
    }

    public void openSearchActivity(String loginStatus) {
        switch (loginStatus) {
            case "Login":
                if (!sessionID.isEmpty()) {
                    Intent intent = new Intent(this, Search.class);
                    intent.putExtra("LoggedIn", "true");
                    intent.putExtra("sessionID", sessionID);
                    intent.putExtra("userID", userID);
                    startActivity(intent);
                    finish();
                }
                break;
            case "Skip Login":
                Toast.makeText(Login.this, "Some features will be disabled until you Login", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, Search.class);
                intent.putExtra("LoggedIn", "false");
                startActivity(intent);
                finish();
                break;
        }
    }
}

