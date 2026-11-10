package com.example.navigatorskakamega;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import com.example.navigatorskakamega.model.Member;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class LoginFragment extends Fragment {
    private FirebaseAuth mAuth;
    private DatabaseReference mDatabase;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_login, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        
        try {
            mAuth = FirebaseAuth.getInstance();
            mDatabase = FirebaseDatabase.getInstance().getReference();
        } catch (Exception e) {
            mAuth = null;
            mDatabase = null;
        }

        EditText emailInput = view.findViewById(R.id.email_input);
        EditText passwordInput = view.findViewById(R.id.password_input);
        TextView emailError = view.findViewById(R.id.email_error);
        View signInButton = view.findViewById(R.id.sign_in_button);

        signInButton.setOnClickListener(v -> {
            String email = emailInput.getText().toString().trim();
            String password = passwordInput.getText().toString().trim();

            if (email.isEmpty() || password.isEmpty()) {
                Toast.makeText(getContext(), "Email and password are required", Toast.LENGTH_SHORT).show();
                return;
            }

            if (mDatabase != null) {
                mDatabase.child("users").orderByChild("email").equalTo(email).addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if (snapshot.exists()) {
                            Member member = null;
                            for (DataSnapshot data : snapshot.getChildren()) {
                                Member m = data.getValue(Member.class);
                                if (m != null && password.equals(m.getPassword())) {
                                    member = m;
                                    break;
                                }
                            }
                            
                            if (member != null) {
                                // Passwords match!
                                updateLocalStorage(member);
                                ((MainActivity) requireActivity()).onLoginSuccess();
                            } else {
                                Toast.makeText(getContext(), "Incorrect password", Toast.LENGTH_SHORT).show();
                            }
                        } else {
                            Toast.makeText(getContext(), "Account not found. Please register.", Toast.LENGTH_LONG).show();
                            ((MainActivity) requireActivity()).showRegister();
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {
                        Toast.makeText(getContext(), "Database error: " + error.getMessage(), Toast.LENGTH_SHORT).show();
                    }
                });
            } else {
                // Fallback if DB is disconnected
                ((MainActivity) requireActivity()).onLoginSuccess();
            }
        });

        view.findViewById(R.id.register_link).setOnClickListener(v -> {
            ((MainActivity) requireActivity()).showRegister();
        });
    }

    private void updateLocalStorage(Member member) {
        android.content.SharedPreferences prefs = requireActivity().getSharedPreferences("NavsPrefs", android.content.Context.MODE_PRIVATE);
        android.content.SharedPreferences.Editor editor = prefs.edit();
        editor.putBoolean("is_registered", true);
        editor.putString("first_name", member.getFirstName());
        editor.putString("last_name", member.getLastName());
        editor.putString("username", member.getUsername());
        editor.putString("email", member.getEmail());
        editor.putString("phone", member.getPhone());
        editor.putString("id_number", member.getIdNumber());
        editor.putString("role", member.getRole());
        editor.apply();
    }
}
