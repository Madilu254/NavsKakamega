package com.example.navigatorskakamega.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.R;
import com.example.navigatorskakamega.model.Program;
import java.util.List;

public class ProgramAdapter extends RecyclerView.Adapter<ProgramAdapter.ViewHolder> {
    private final List<Program> programs;
    private final OnProgramActionListener listener;

    public interface OnProgramActionListener {
        void onEdit(Program program);
        void onDelete(Program program);
    }

    public ProgramAdapter(List<Program> programs, OnProgramActionListener listener) {
        this.programs = programs;
        this.listener = listener;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_program, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Program program = programs.get(position);
        holder.nameTv.setText(program.getName());
        holder.scheduleTv.setText(program.getSchedule());

        holder.editBtn.setOnClickListener(v -> listener.onEdit(program));
        holder.deleteBtn.setOnClickListener(v -> listener.onDelete(program));
    }

    @Override
    public int getItemCount() {
        return programs.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        TextView nameTv, scheduleTv;
        View editBtn, deleteBtn;

        ViewHolder(View view) {
            super(view);
            nameTv = view.findViewById(R.id.tv_program_name);
            scheduleTv = view.findViewById(R.id.tv_program_schedule);
            editBtn = view.findViewById(R.id.btn_edit_program);
            deleteBtn = view.findViewById(R.id.btn_delete_program);
        }
    }
}
