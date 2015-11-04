package com.afe.pc.embr;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Map;

public class Login extends AppCompatActivity implements Button.OnClickListener {

    Button loginButton, skipLoginButton;
    EditText username, password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_layout);
        username = (EditText) findViewById(R.id.login_username_editText);
        password = (EditText) findViewById(R.id.login_password_editText);
        loginButton = (Button) findViewById(R.id.login_login_button);
        loginButton.setOnClickListener(this);
        skipLoginButton = (Button) findViewById(R.id.login_skipLogin_button);
        skipLoginButton.setOnClickListener(this);
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
            case R.id.login_login_button:
                if(validateLoginCredentials()) {
                    Intent intent = new Intent(this, Search.class);
                    intent.putExtra("LoggedIn", "true");
                    startActivity(intent);
                    finish();
                }
                else
                    Toast.makeText(Login.this, "Invalid Username or Password", Toast.LENGTH_SHORT).show();
                break;
            case R.id.login_skipLogin_button:
                Toast.makeText(Login.this, "Some features will be disabled until you Login", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, Search.class);
                intent.putExtra("LoggedIn", "false");
                startActivity(intent);
                finish();
                break;
        }
    }

    private boolean validateLoginCredentials() {
        return(username.getText().toString().equals("test") && password.getText().toString().equals("1234"));
    }
}
