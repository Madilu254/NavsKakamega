package com.example.navigatorskakamega;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.adapter.ProgramAdapter;
import com.example.navigatorskakamega.model.Program;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ProgramsFragment extends Fragment {
    private List<Program> programs = new ArrayList<>();
    private ProgramAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_programs, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        RecyclerView recyclerView = view.findViewById(R.id.rv_programs);
        
        if (programs.isEmpty()) {
            programs.add(new Program(UUID.randomUUID().toString(), "Bible Study", "Every Saturday (9:00 AM – 12:00 PM)"));
            programs.add(new Program(UUID.randomUUID().toString(), "Family Tea", "Every Sunday (3:00 PM – 6:30 PM)"));
            programs.add(new Program(UUID.randomUUID().toString(), "Hiking", "Quarterly events"));
            programs.add(new Program(UUID.randomUUID().toString(), "Sleepover", "Monthly fellowship"));
        }

        adapter = new ProgramAdapter(programs, new ProgramAdapter.OnProgramActionListener() {
            @Override
            public void onEdit(Program program) {
                showProgramDialog(program);
            }

            @Override
            public void onDelete(Program program) {
                programs.remove(program);
                adapter.notifyDataSetChanged();
            }
        });
        recyclerView.setAdapter(adapter);

        view.findViewById(R.id.fab_add_program).setOnClickListener(v -> showProgramDialog(null));
    }

    private void showProgramDialog(@Nullable Program program) {
        AlertDialog.Builder builder = new AlertDialog.Builder(requireContext());
        View dialogView = getLayoutInflater().inflate(R.layout.dialog_program, null);
        EditText etName = dialogView.findViewById(R.id.et_program_name);
        EditText etSchedule = dialogView.findViewById(R.id.et_program_schedule);

        if (program != null) {
            etName.setText(program.getName());
            etSchedule.setText(program.getSchedule());
            builder.setTitle("Edit Program");
        } else {
            builder.setTitle("Add New Program");
        }

        builder.setView(dialogView)
                .setPositiveButton("Save", (dialog, which) -> {
                    String name = etName.getText().toString();
                    String schedule = etSchedule.getText().toString();
                    if (program != null) {
                        program.setName(name);
                        program.setSchedule(schedule);
                    } else {
                        programs.add(new Program(UUID.randomUUID().toString(), name, schedule));
                    }
                    adapter.notifyDataSetChanged();
                })
                .setNegativeButton("Cancel", null)
                .show();
    }
}
