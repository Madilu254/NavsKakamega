package com.example.navigatorskakamega;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import com.example.navigatorskakamega.model.Member;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class RegisterFragment extends Fragment {
    private DatabaseReference mDatabase;
    private FirebaseAuth mAuth;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_register, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        
        try {
            mDatabase = FirebaseDatabase.getInstance().getReference();
            mAuth = FirebaseAuth.getInstance();
        } catch (Exception e) {
            mDatabase = null;
            mAuth = null;
        }

        EditText etFirstName = view.findViewById(R.id.et_first_name);
        EditText etLastName = view.findViewById(R.id.et_last_name);
        EditText etUsername = view.findViewById(R.id.et_username);
        EditText etEmail = view.findViewById(R.id.et_email);
        EditText etPhone = view.findViewById(R.id.et_phone);
        EditText etId = view.findViewById(R.id.et_id_number);
        EditText etPassword = view.findViewById(R.id.et_password);
        RadioGroup rgRole = view.findViewById(R.id.rg_role);

        view.findViewById(R.id.btn_register).setOnClickListener(v -> {
            String firstName = etFirstName.getText().toString().trim();
            String lastName = etLastName.getText().toString().trim();
            String username = etUsername.getText().toString().trim();
            String email = etEmail.getText().toString().trim();
            String phone = etPhone.getText().toString().trim();
            String id = etId.getText().toString().trim();
            String password = etPassword.getText().toString().trim();

            if (firstName.isEmpty() || lastName.isEmpty() || username.isEmpty() || email.isEmpty() || password.isEmpty() || id.isEmpty()) {
                Toast.makeText(getContext(), "Please fill all required fields", Toast.LENGTH_SHORT).show();
                return;
            }

            int selectedRoleId = rgRole.getCheckedRadioButtonId();
            RadioButton rbSelected = view.findViewById(selectedRoleId);
            String role = rbSelected.getText().toString();

            if (mAuth != null && !password.isEmpty()) {
                mAuth.createUserWithEmailAndPassword(email, password)
                    .addOnCompleteListener(task -> {
                        if (task.isSuccessful()) {
                            saveUserToDatabase(firstName, lastName, username, email, phone, id, password, role);
                        } else {
                            // If Auth fails (e.g. invalid API key), we'll still save to DB so user can test UI
                            Toast.makeText(getContext(), "Auth failed (using fallback): " + task.getException().getMessage(), Toast.LENGTH_SHORT).show();
                            saveUserToDatabase(firstName, lastName, username, email, phone, id, password, role);
                        }
                    });
            } else {
                saveUserToDatabase(firstName, lastName, username, email, phone, id, password, role);
            }
        });

        view.findViewById(R.id.tv_login_link).setOnClickListener(v -> {
            ((MainActivity) requireActivity()).showLogin();
        });
    }

    private void saveUserToDatabase(String firstName, String lastName, String username, String email, String phone, String id, String password, String role) {
        if (mDatabase == null) {
            // Local fallback
            storeLocalUser(firstName, lastName, username, email, phone, id, role);
            return;
        }

        Member newMember = new Member(firstName, lastName, username, email, phone, id, password, null, role);
        String userId = id.replace(".", "_");
        mDatabase.child("users").child(userId).setValue(newMember)
            .addOnSuccessListener(aVoid -> {
                storeLocalUser(firstName, lastName, username, email, phone, id, role);
                Toast.makeText(getContext(), "Registration successful!", Toast.LENGTH_SHORT).show();
                ((MainActivity) requireActivity()).onLoginSuccess();
            })
            .addOnFailureListener(e -> {
                Toast.makeText(getContext(), "Database save failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
            });
    }

    private void storeLocalUser(String firstName, String lastName, String username, String email, String phone, String id, String role) {
        SharedPreferences prefs = requireActivity().getSharedPreferences("NavsPrefs", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putBoolean("is_registered", true);
        editor.putString("first_name", firstName);
        editor.putString("last_name", lastName);
        editor.putString("username", username);
        editor.putString("email", email);
        editor.putString("phone", phone);
        editor.putString("id_number", id);
        editor.putString("role", role);
        editor.apply();
    }
}
