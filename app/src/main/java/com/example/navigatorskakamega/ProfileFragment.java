package com.example.navigatorskakamega;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import java.util.Locale;

public class ProfileFragment extends Fragment {

    private TextView tvFullName, tvEmail, tvPhone, tvLanguage, tvTimezone;
    private ImageView ivProfilePic;
    private SharedPreferences prefs;
    private DatabaseReference mDatabase;
    private String userId;

    private final ActivityResultLauncher<String> mGetContent = registerForActivityResult(
            new ActivityResultContracts.GetContent(),
            uri -> {
                if (uri != null) {
                    ivProfilePic.setImageURI(uri);
                    updateProfilePicInFirebase(uri);
                }
            }
    );

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_profile, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        prefs = requireActivity().getSharedPreferences("NavsPrefs", Context.MODE_PRIVATE);
        mDatabase = FirebaseDatabase.getInstance().getReference();
        userId = prefs.getString("id_number", "default_user").replace(".", "_");

        tvFullName = view.findViewById(R.id.profile_full_name);
        tvEmail = view.findViewById(R.id.tv_profile_email);
        tvPhone = view.findViewById(R.id.tv_profile_phone);
        tvLanguage = view.findViewById(R.id.tv_current_language);
        tvTimezone = view.findViewById(R.id.tv_current_timezone);
        ivProfilePic = view.findViewById(R.id.profile_avatar);

        loadUserData();

        view.findViewById(R.id.btn_change_name).setOnClickListener(v -> showEditDialog("Change Name", "first_name", tvFullName, "firstName"));
        view.findViewById(R.id.btn_edit_avatar).setOnClickListener(v -> mGetContent.launch("image/*"));
        
        view.findViewById(R.id.tv_profile_email).setOnClickListener(v -> showEditDialog("Edit Email", "email", tvEmail, "email"));
        view.findViewById(R.id.tv_profile_phone).setOnClickListener(v -> showEditDialog("Edit Phone", "phone", tvPhone, "phone"));

        view.findViewById(R.id.btn_language_selector).setOnClickListener(v -> showLanguageDialog());
        view.findViewById(R.id.btn_timezone_selector).setOnClickListener(v -> showTimezoneDialog());
    }

    private void loadUserData() {
        String firstName = prefs.getString("first_name", "Eric");
        String lastName = prefs.getString("last_name", "Opilo");
        String email = prefs.getString("email", "opiloeric395@gmail.com");
        String phone = prefs.getString("phone", "0700000089");
        String lang = prefs.getString("app_lang", "English");
        String tz = prefs.getString("app_tz", "(GMT+03:00) Nairobi");
        String picUri = prefs.getString("profile_pic_uri", null);

        tvFullName.setText(firstName + " " + lastName);
        tvEmail.setText(email);
        tvPhone.setText(phone);
        tvLanguage.setText(lang);
        tvTimezone.setText(tz);
        
        if (picUri != null) {
            try {
                ivProfilePic.setImageURI(Uri.parse(picUri));
            } catch (Exception e) {
                // If URI permission is lost (very common with content uris), fallback to default
                ivProfilePic.setImageResource(R.drawable.avatar_circle);
                // Clear the invalid URI
                SharedPreferences.Editor editor = prefs.edit();
                editor.remove("profile_pic_uri");
                editor.apply();
            }
        }
    }

    private void showLanguageDialog() {
        String[] languages = {"English", "Swahili", "French", "Spanish"};
        AlertDialog.Builder builder = new AlertDialog.Builder(requireContext());
        builder.setTitle("Select Language");
        builder.setItems(languages, (dialog, which) -> {
            String selectedLang = languages[which];
            tvLanguage.setText(selectedLang);
            saveToPrefsAndFirebase("app_lang", selectedLang, "language");
            setLocale(selectedLang);
        });
        builder.show();
    }

    private void setLocale(String lang) {
        String langCode = "en";
        if (lang.equals("Swahili")) langCode = "sw";
        else if (lang.equals("French")) langCode = "fr";
        else if (lang.equals("Spanish")) langCode = "es";

        Locale myLocale = new Locale(langCode);
        Locale.setDefault(myLocale);
        Resources res = getResources();
        Configuration conf = res.getConfiguration();
        conf.setLocale(myLocale);
        res.updateConfiguration(conf, res.getDisplayMetrics());
        
        // Refresh the activity to apply changes - Use local check to prevent crash
        if (isAdded() && getActivity() != null) {
            SharedPreferences.Editor editor = prefs.edit();
            editor.putString("app_lang", lang);
            editor.apply();
            requireActivity().recreate();
        }
    }

    private void showTimezoneDialog() {
        String[] timezones = {"(GMT+03:00) Nairobi", "(GMT+00:00) London", "(GMT-05:00) New York", "(GMT+08:00) Singapore"};
        AlertDialog.Builder builder = new AlertDialog.Builder(requireContext());
        builder.setTitle("Select Timezone");
        builder.setItems(timezones, (dialog, which) -> {
            String selectedTz = timezones[which];
            tvTimezone.setText(selectedTz);
            saveToPrefsAndFirebase("app_tz", selectedTz, "timezone");
        });
        builder.show();
    }

    private void showEditDialog(String title, String prefKey, TextView targetTv, String firebaseKey) {
        AlertDialog.Builder builder = new AlertDialog.Builder(requireContext());
        builder.setTitle(title);

        final EditText input = new EditText(requireContext());
        input.setPadding(40, 40, 40, 40);
        input.setText(targetTv.getText().toString());
        builder.setView(input);

        builder.setPositiveButton("Save", (dialog, which) -> {
            String newValue = input.getText().toString().trim();
            if (!newValue.isEmpty()) {
                saveToPrefsAndFirebase(prefKey, newValue, firebaseKey);
                loadUserData(); // Refresh UI
            }
        });
        builder.setNegativeButton("Cancel", null);
        builder.show();
    }

    private void saveToPrefsAndFirebase(String prefKey, String value, String firebaseKey) {
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(prefKey, value);
        editor.apply();

        mDatabase.child("users").child(userId).child(firebaseKey).setValue(value)
                .addOnFailureListener(e -> Toast.makeText(getContext(), "Sync failed: " + e.getMessage(), Toast.LENGTH_SHORT).show());
    }

    private void updateProfilePicInFirebase(Uri uri) {
        // In a real app, upload to Firebase Storage then save URL to Database
        // For now, we save the local URI as a string to the database
        saveToPrefsAndFirebase("profile_pic_uri", uri.toString(), "profilePicUrl");
        Toast.makeText(getContext(), "Profile picture updated!", Toast.LENGTH_SHORT).show();
    }
}
