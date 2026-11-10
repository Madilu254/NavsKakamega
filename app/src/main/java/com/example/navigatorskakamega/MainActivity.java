package com.example.navigatorskakamega;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.graphics.Insets;
import androidx.core.view.GravityCompat;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import com.google.android.material.navigation.NavigationView;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class MainActivity extends AppCompatActivity {
    private DrawerLayout drawerLayout;
    private View appBar;
    private Toolbar toolbar;
    private static final String DB_URL = "https://navigators-5d36f-default-rtdb.firebaseio.com/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        drawerLayout = findViewById(R.id.drawer_layout);
        appBar = findViewById(R.id.app_bar);
        toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        View mainView = findViewById(R.id.main_content);
        ViewCompat.setOnApplyWindowInsetsListener(mainView, (v, insets) -> {
            Insets bars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(0, 0, 0, 0);
            return insets;
        });

        // if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
        //     getWindow().setStatusBarColor(Color.TRANSPARENT);
        // }

        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawerLayout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.nav_home) loadFragment(new HomeFragment(), "Dashboard");
            else if (id == R.id.nav_devotion) loadFragment(new DevotionFragment(), "Daily Devotion");
            else if (id == R.id.nav_people) loadFragment(new PeopleFragment(), "People");
            else if (id == R.id.nav_programs) loadFragment(new ProgramsFragment(), "Programs");
            else if (id == R.id.nav_chat) loadFragment(new ChatFragment(), "Chat Room");
            else if (id == R.id.nav_profile) loadFragment(new ProfileFragment(), "Profile");
            else if (id == R.id.nav_logout) logout();

            drawerLayout.closeDrawer(GravityCompat.START);
            return true;
        });

        // Check registration status
        android.content.SharedPreferences prefs = getSharedPreferences("NavsPrefs", android.content.Context.MODE_PRIVATE);
        boolean isRegistered = prefs.getBoolean("is_registered", false);
        String savedId = prefs.getString("id_number", "");

        // Check login state
        com.google.firebase.auth.FirebaseUser currentUser = null;
        try {
            currentUser = com.google.firebase.auth.FirebaseAuth.getInstance().getCurrentUser();
        } catch (Exception ignored) {}

        if (currentUser != null || isRegistered) {
            // If already registered/logged in, show Dashboard directly
            onLoginSuccess();
        } else {
            // First-time user: show Registration
            loadFragment(new RegisterFragment(), null);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(android.view.Menu menu) {
        // Inflate a simple menu to show the 3-dot overflow
        getMenuInflater().inflate(R.menu.main_overflow, menu);
        return true;
    }

    public void showLogin() {
        loadFragment(new LoginFragment(), null);
    }

    public void showRegister() {
        loadFragment(new RegisterFragment(), null);
    }

    private void logout() {
        appBar.setVisibility(View.GONE);
        showLogin();
    }

    public String getUsername() {
        android.content.SharedPreferences prefs = getSharedPreferences("NavsPrefs", android.content.Context.MODE_PRIVATE);
        return prefs.getString("first_name", "Elvis") + " " + prefs.getString("last_name", "Mowdi");
    }

    public void onLoginSuccess() {
        appBar.setVisibility(View.VISIBLE);
        loadFragment(new HomeFragment(), "Dashboard");
        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setCheckedItem(R.id.nav_home);
    }

    public void selectBottomNavItem(int itemId) {
        // Updated to handle drawer navigation instead of bottom nav
        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setCheckedItem(itemId);
        // Map the IDs if necessary, or just trigger the click logic
        if (itemId == R.id.nav_home) loadFragment(new HomeFragment(), "Dashboard");
        else if (itemId == R.id.nav_people) loadFragment(new ProgressFragment(), "People");
    }

    private void loadFragment(Fragment fragment, String title) {
        if (title != null && getSupportActionBar() != null) {
            getSupportActionBar().setTitle(title);
        }
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.nav_host_fragment, fragment)
                .commitAllowingStateLoss();
    }

    @Override
    public void onBackPressed() {
        if (drawerLayout.isDrawerOpen(GravityCompat.START)) {
            drawerLayout.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }
}
