package com.afe.pc.embr;

import android.app.Application;
import android.content.Context;

public class MyApplication extends Application {
    private static MyApplication mInstance;

    @Override
    public void onCreate() {
        mInstance = this;
        super.onCreate();
    }

    public static MyApplication getInstance() {
        return mInstance;
    }


    public static Context getAppContext() {
        return mInstance.getApplicationContext();
    }
}
