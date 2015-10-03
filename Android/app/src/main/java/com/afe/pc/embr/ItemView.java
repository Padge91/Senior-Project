package com.afe.pc.embr;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;

public class ItemView extends AppCompatActivity {

    ImageButton star_1_1;
    ImageButton star_1_2;
    ImageButton star_1_3;
    ImageButton star_1_4;
    ImageButton star_1_5;
    ImageButton star_2_1;
    ImageButton star_2_2;
    ImageButton star_2_3;
    ImageButton star_2_4;
    ImageButton star_2_5;
    ImageButton star_3_1;
    ImageButton star_3_2;
    ImageButton star_3_3;
    ImageButton star_3_4;
    ImageButton star_3_5;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item_view);
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

    public void addListenerOnButton_1_1() {

        star_1_1 = (ImageButton) findViewById(R.id.star_1_1);
        star_1_1.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_1_1.setImageResource(R.drawable.star_filled);
                star_1_2.setImageResource(R.drawable.star_empty);
                star_1_3.setImageResource(R.drawable.star_empty);
                star_1_4.setImageResource(R.drawable.star_empty);
                star_1_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_1_2() {

        star_1_2 = (ImageButton) findViewById(R.id.star_1_2);
        star_1_2.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_1_1.setImageResource(R.drawable.star_filled);
                star_1_2.setImageResource(R.drawable.star_filled);
                star_1_3.setImageResource(R.drawable.star_empty);
                star_1_4.setImageResource(R.drawable.star_empty);
                star_1_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_1_3() {

        star_1_3 = (ImageButton) findViewById(R.id.star_1_3);
        star_1_3.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_1_1.setImageResource(R.drawable.star_filled);
                star_1_2.setImageResource(R.drawable.star_filled);
                star_1_3.setImageResource(R.drawable.star_filled);
                star_1_4.setImageResource(R.drawable.star_empty);
                star_1_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_1_4() {

        star_1_4 = (ImageButton) findViewById(R.id.star_1_4);
        star_1_4.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_1_1.setImageResource(R.drawable.star_filled);
                star_1_2.setImageResource(R.drawable.star_filled);
                star_1_3.setImageResource(R.drawable.star_filled);
                star_1_4.setImageResource(R.drawable.star_filled);
                star_1_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_1_5() {

        star_1_5 = (ImageButton) findViewById(R.id.star_1_5);
        star_1_5.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_1_1.setImageResource(R.drawable.star_filled);
                star_1_2.setImageResource(R.drawable.star_filled);
                star_1_3.setImageResource(R.drawable.star_filled);
                star_1_4.setImageResource(R.drawable.star_filled);
                star_1_5.setImageResource(R.drawable.star_filled);
            }
        });
    }
    public void addListenerOnButton_2_1() {

        star_2_1 = (ImageButton) findViewById(R.id.star_2_1);
        star_2_1.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_2_1.setImageResource(R.drawable.star_filled);
                star_2_2.setImageResource(R.drawable.star_empty);
                star_2_3.setImageResource(R.drawable.star_empty);
                star_2_4.setImageResource(R.drawable.star_empty);
                star_2_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_2_2() {

        star_2_2 = (ImageButton) findViewById(R.id.star_2_2);
        star_2_2.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_2_1.setImageResource(R.drawable.star_filled);
                star_2_2.setImageResource(R.drawable.star_filled);
                star_2_3.setImageResource(R.drawable.star_empty);
                star_2_4.setImageResource(R.drawable.star_empty);
                star_2_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_2_3() {

        star_2_3 = (ImageButton) findViewById(R.id.star_2_3);
        star_2_3.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_2_1.setImageResource(R.drawable.star_filled);
                star_2_2.setImageResource(R.drawable.star_filled);
                star_2_3.setImageResource(R.drawable.star_filled);
                star_2_4.setImageResource(R.drawable.star_empty);
                star_2_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_2_4() {

        star_2_4 = (ImageButton) findViewById(R.id.star_2_4);
        star_2_4.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_2_1.setImageResource(R.drawable.star_filled);
                star_2_2.setImageResource(R.drawable.star_filled);
                star_2_3.setImageResource(R.drawable.star_filled);
                star_2_4.setImageResource(R.drawable.star_filled);
                star_2_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_2_5() {

        star_2_5 = (ImageButton) findViewById(R.id.star_2_5);
        star_2_5.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_2_1.setImageResource(R.drawable.star_filled);
                star_2_2.setImageResource(R.drawable.star_filled);
                star_2_3.setImageResource(R.drawable.star_filled);
                star_2_4.setImageResource(R.drawable.star_filled);
                star_2_5.setImageResource(R.drawable.star_filled);
            }
        });
    }
    public void addListenerOnButton_3_1() {

        star_3_1 = (ImageButton) findViewById(R.id.star_3_1);
        star_3_1.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_3_1.setImageResource(R.drawable.star_filled);
                star_3_2.setImageResource(R.drawable.star_empty);
                star_3_3.setImageResource(R.drawable.star_empty);
                star_3_4.setImageResource(R.drawable.star_empty);
                star_3_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_3_2() {

        star_3_2 = (ImageButton) findViewById(R.id.star_3_2);
        star_3_2.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_3_1.setImageResource(R.drawable.star_filled);
                star_3_2.setImageResource(R.drawable.star_filled);
                star_3_3.setImageResource(R.drawable.star_empty);
                star_3_4.setImageResource(R.drawable.star_empty);
                star_3_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_3_3() {

        star_3_3 = (ImageButton) findViewById(R.id.star_3_3);
        star_3_3.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_3_1.setImageResource(R.drawable.star_filled);
                star_3_2.setImageResource(R.drawable.star_filled);
                star_3_3.setImageResource(R.drawable.star_filled);
                star_3_4.setImageResource(R.drawable.star_empty);
                star_3_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_3_4() {

        star_3_4 = (ImageButton) findViewById(R.id.star_3_4);
        star_3_4.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_3_1.setImageResource(R.drawable.star_filled);
                star_3_2.setImageResource(R.drawable.star_filled);
                star_3_3.setImageResource(R.drawable.star_filled);
                star_3_4.setImageResource(R.drawable.star_filled);
                star_3_5.setImageResource(R.drawable.star_empty);
            }
        });
    }
    public void addListenerOnButton_3_5() {

        star_3_5 = (ImageButton) findViewById(R.id.star_3_5);
        star_3_5.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View arg0) {
                star_3_1.setImageResource(R.drawable.star_filled);
                star_3_2.setImageResource(R.drawable.star_filled);
                star_3_3.setImageResource(R.drawable.star_filled);
                star_3_4.setImageResource(R.drawable.star_filled);
                star_3_5.setImageResource(R.drawable.star_filled);
            }
        });
    }

}
