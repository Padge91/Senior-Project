package com.afe.pc.embr;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.PopupMenu;
import android.widget.Toast;

import static android.support.v4.app.ActivityCompat.startActivity;

/**
 * Created by Matt McInturff on 10/4/2015.
 */
public class PopUpMenuEventHandle implements PopupMenu.OnMenuItemClickListener {
    Context context;

    public PopUpMenuEventHandle(Context context) {
        this.context = context;
    }

    @Override
    public boolean onMenuItemClick(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.Home:
                Intent intent = new Intent(context, HomeActivity.class);
                context.startActivity(intent);
                Toast.makeText(context, "Home", Toast.LENGTH_SHORT).show();
                break;
            case R.id.Recommended_Items:
                Intent intent1 = new Intent(String.valueOf(RecommendedItems.class));
                context.startActivity(intent1);
                Toast.makeText(context, "Recommended Items", Toast.LENGTH_SHORT).show();
                break;
            case R.id.Libraries:
                Intent intent2 = new Intent(String.valueOf(Library.class));
                context.startActivity(intent2);
                Toast.makeText(context, "Library", Toast.LENGTH_SHORT).show();
                break;
        }
        return true;
    }


}


