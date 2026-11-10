package com.example.navigatorskakamega;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.adapter.MemberAdapter;
import com.example.navigatorskakamega.model.Member;
import com.google.android.material.tabs.TabLayout;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import java.util.ArrayList;
import java.util.List;

public class PeopleFragment extends Fragment {
    private List<Member> allMembers = new ArrayList<>();
    private MemberAdapter adapter;
    private DatabaseReference mDatabase;
    private static final String DB_URL = "https://navigators-5d36f-default-rtdb.firebaseio.com/";
    private String currentRoleFilter = "Students";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_people, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        TabLayout tabLayout = view.findViewById(R.id.tab_layout);
        RecyclerView recyclerView = view.findViewById(R.id.rv_members);
        
        mDatabase = FirebaseDatabase.getInstance(DB_URL).getReference().child("users");

        adapter = new MemberAdapter(filteredMembers);
        recyclerView.setAdapter(adapter);

        fetchMembers();

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                currentRoleFilter = tab.getText().toString();
                applyFilter();
            }
            @Override public void onTabUnselected(TabLayout.Tab tab) {}
            @Override public void onTabReselected(TabLayout.Tab tab) {}
        });
    }

    private List<Member> filteredMembers = new ArrayList<>();

    private void fetchMembers() {
        mDatabase.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                allMembers.clear();
                for (DataSnapshot data : snapshot.getChildren()) {
                    Member member = data.getValue(Member.class);
                    if (member != null) {
                        allMembers.add(member);
                    }
                }
                applyFilter();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                // Handle error
            }
        });
    }

    private void applyFilter() {
        filteredMembers.clear();
        String target = currentRoleFilter.endsWith("s") ? currentRoleFilter.substring(0, currentRoleFilter.length() - 1) : currentRoleFilter;
        for (Member m : allMembers) {
            if (m.getRole().equalsIgnoreCase(target) || m.getRole().equalsIgnoreCase(currentRoleFilter)) {
                filteredMembers.add(m);
            }
        }
        adapter.notifyDataSetChanged();
    }
}
