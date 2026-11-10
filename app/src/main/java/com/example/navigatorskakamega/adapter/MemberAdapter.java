package com.example.navigatorskakamega.adapter;

import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.R;
import com.example.navigatorskakamega.model.Member;
import java.util.List;

public class MemberAdapter extends RecyclerView.Adapter<MemberAdapter.ViewHolder> {
    private final List<Member> members;

    public MemberAdapter(List<Member> members) {
        this.members = members;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_member, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Member member = members.get(position);
        holder.usernameTv.setText(member.getUsername());
        holder.phoneTv.setText(member.getPhone());
        holder.emailTv.setText(member.getEmail());

        holder.phoneTv.setOnClickListener(v -> {
            Intent intent = new Intent(Intent.ACTION_DIAL);
            intent.setData(Uri.parse("tel:" + member.getPhone()));
            v.getContext().startActivity(intent);
        });

        holder.emailTv.setOnClickListener(v -> {
            Intent intent = new Intent(Intent.ACTION_SENDTO);
            intent.setData(Uri.parse("mailto:" + member.getEmail()));
            v.getContext().startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return members.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        TextView usernameTv, phoneTv, emailTv;

        ViewHolder(View view) {
            super(view);
            usernameTv = view.findViewById(R.id.tv_username);
            phoneTv = view.findViewById(R.id.tv_phone);
            emailTv = view.findViewById(R.id.tv_email);
        }
    }
}
