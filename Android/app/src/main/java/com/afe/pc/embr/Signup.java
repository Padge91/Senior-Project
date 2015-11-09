package com.afe.pc.embr;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
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

public class Signup extends AppCompatActivity implements Button.OnClickListener{

    Button signupsubmitbutton;
    EditText signupusername, signupemail, signuppassword, signuppasswordconfirm;
    String usernameEntry, useremailEntry, passwordEntry, confirmpasswordEntry;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        signupusername = (EditText) findViewById(R.id.signup_username_editText);
        signupusername.setHint("Username");
        signupemail = (EditText) findViewById(R.id.signup_email_editText);
        signupemail.setHint("Username");
        signuppassword = (EditText) findViewById(R.id.signup_password_editText);
        signuppassword.setHint("Password");
        signuppasswordconfirm = (EditText) findViewById(R.id.signup_confirmpassword_editText);
        signuppasswordconfirm.setHint("Confirm Password");
        signupsubmitbutton = (Button) findViewById(R.id.signup_submit_button);
        signupsubmitbutton.setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.signup_submit_button:
                usernameEntry = signupusername.getText().toString();
                useremailEntry = signupemail.getText().toString();
                passwordEntry = signuppassword.getText().toString();
                confirmpasswordEntry = signuppasswordconfirm.getText().toString();
                verifySignUp(usernameEntry, useremailEntry, passwordEntry, confirmpasswordEntry);
                break;
        }
    }

    public void verifySignUp (String username,String email, String password, String passwordConfirm) {
        HttpConnect.requestJson("http://52.88.5.108/cgi-bin/CreateAccount.py?username=" + username + "&email" + email + "&password=" + password + "&passwordConfirm" + passwordConfirm, Request.Method.GET, null, new HttpResult() {

            @Override
            public void onCallback(JSONObject response, boolean success) {
                try {
                    if (success == false) {
                        Toast.makeText(Signup.this, response.getString("response"), Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(Signup.this, response.getString("response"), Toast.LENGTH_SHORT).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
