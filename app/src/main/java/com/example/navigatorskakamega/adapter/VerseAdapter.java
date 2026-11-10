package com.example.navigatorskakamega.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.R;
import com.example.navigatorskakamega.model.TmsVerse;
import java.util.List;

public class VerseAdapter extends RecyclerView.Adapter<VerseAdapter.ViewHolder> {
    private final List<TmsVerse> verses;

    public VerseAdapter(List<TmsVerse> verses) {
        this.verses = verses;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_verse, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        TmsVerse verse = verses.get(position);
        holder.topicTv.setText(verse.getTopic());
        holder.referenceTv.setText(verse.getReference());
        holder.textTv.setText(verse.getText());
    }

    @Override
    public int getItemCount() {
        return verses.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        TextView topicTv, referenceTv, textTv;

        ViewHolder(View view) {
            super(view);
            topicTv = view.findViewById(R.id.verse_topic);
            referenceTv = view.findViewById(R.id.verse_reference);
            textTv = view.findViewById(R.id.verse_text);
        }
    }
}
