package com.example.navigatorskakamega;

import android.app.Application;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

public class NavsApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        
        // Manual initialization of Firebase using the provided Database URL
        // This prevents the app from crashing if google-services.json is missing
        try {
            if (FirebaseApp.getApps(this).isEmpty()) {
                FirebaseOptions options = new FirebaseOptions.Builder()
                    .setProjectId("navigators-5d36f")
                    .setApplicationId("com.example.navigatorskakamega")
                    .setDatabaseUrl("https://navigators-5d36f-default-rtdb.firebaseio.com/")
                    .setApiKey("AIzaSyB_REPLACE_THIS_WITH_REAL_KEY_123456")
                    .build();
                FirebaseApp.initializeApp(this, options);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
