package com.example.navigatorskakamega;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.RecyclerView;
import com.example.navigatorskakamega.adapter.VerseAdapter;
import com.example.navigatorskakamega.model.TmsVerse;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import java.util.ArrayList;
import java.util.List;

public class TmsActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tms);

        // Set status bar color to match the primary color
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(getResources().getColor(R.color.primary, getTheme()));
        }

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setTitle("Topical Memory System");
        }

        findViewById(R.id.card_series_a).setOnClickListener(v -> showVersesDialog("A: Living The New Life", getSeriesAVerses()));
        findViewById(R.id.card_series_b).setOnClickListener(v -> showVersesDialog("B: Proclaiming Christ", getSeriesBVerses()));
        findViewById(R.id.card_series_c).setOnClickListener(v -> showVersesDialog("C: Reliance On God’s Resources", getSeriesCVerses()));
        findViewById(R.id.card_series_d).setOnClickListener(v -> showVersesDialog("D: Being Christ’s Disciple", getSeriesDVerses()));
        findViewById(R.id.card_series_e).setOnClickListener(v -> showVersesDialog("E: Growth In Christlikeness", getSeriesEVerses()));
    }

    private void showVersesDialog(String title, List<TmsVerse> verses) {
        BottomSheetDialog bottomSheetDialog = new BottomSheetDialog(this);
        View dialogView = LayoutInflater.from(this).inflate(R.layout.dialog_series_verses, null);
        
        TextView titleTv = dialogView.findViewById(R.id.dialog_title);
        RecyclerView recyclerView = dialogView.findViewById(R.id.verses_recycler_view);
        
        titleTv.setText(title);
        VerseAdapter adapter = new VerseAdapter(verses);
        recyclerView.setAdapter(adapter);
        
        bottomSheetDialog.setContentView(dialogView);
        bottomSheetDialog.show();
    }

    private List<TmsVerse> getSeriesAVerses() {
        List<TmsVerse> verses = new ArrayList<>();
        verses.add(new TmsVerse("CHRIST THE CENTER", "2 Corinthians 5:17 (NIV)", "Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!"));
        verses.add(new TmsVerse("CHRIST THE CENTER", "Galatians 2:20 (NIV)", "I have been crucified with Christ and I no longer live, but Christ lives in me. The life I now live in the body, I live by faith in the Son of God, who loved me and gave himself for me."));
        verses.add(new TmsVerse("OBEDIENCE TO CHRIST", "Romans 12:1 (NIV)", "Therefore, I urge you, brothers and sisters, in view of God’s mercy, to offer your bodies as a living sacrifice, holy and pleasing to God—this is your true and proper worship."));
        verses.add(new TmsVerse("OBEDIENCE TO CHRIST", "John 14:21 (NIV)", "Whoever has my commands and keeps them is the one who loves me. The one who loves me will be loved by my Father, and I too will love them and show myself to them."));
        verses.add(new TmsVerse("THE WORD", "2 Timothy 3:16 (NIV)", "All Scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness."));
        verses.add(new TmsVerse("THE WORD", "Joshua 1:8 (NIV)", "Keep this Book of the Law always on your lips; meditate on it day and night, so that you may be careful to do everything written in it. Then you will be prosperous and successful."));
        verses.add(new TmsVerse("PRAYER", "John 15:7 (NIV)", "If you remain in me and my words remain in you, ask whatever you wish, and it will be done for you."));
        verses.add(new TmsVerse("PRAYER", "Philippians 4:6-7 (NIV)", "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God. And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."));
        verses.add(new TmsVerse("FELLOWSHIP", "Matthew 18:20 (NIV)", "For where two or three gather in my name, there am I with them."));
        verses.add(new TmsVerse("FELLOWSHIP", "Hebrews 10:24-25 (NIV)", "And let us consider how we may spur one another on toward love and good deeds, not giving up meeting together, as some are in the habit of doing, but encouraging one another—and all the more as you see the Day approaching."));
        verses.add(new TmsVerse("WITNESSING", "Matthew 4:19 (NIV)", "“Come, follow me,” Jesus said, “and I will send you out to fish for people.”"));
        verses.add(new TmsVerse("WITNESSING", "Romans 1:16 (NIV)", "For I am not ashamed of the gospel, because it is the power of God that brings salvation to everyone who believes: first to the Jew, then to the Gentile."));
        return verses;
    }

    private List<TmsVerse> getSeriesBVerses() {
        List<TmsVerse> verses = new ArrayList<>();
        verses.add(new TmsVerse("ALL HAVE SINNED", "Romans 3:23 (NIV)", "for all have sinned and fall short of the glory of God,"));
        verses.add(new TmsVerse("ALL HAVE SINNED", "Isaiah 53:6 (NIV)", "We all, like sheep, have gone astray, each of us has turned to our own way; and the Lord has laid on him the iniquity of us all."));
        verses.add(new TmsVerse("SIN’S PENALTY", "Romans 6:23 (NIV)", "For the wages of sin is death, but the gift of God is eternal life in Christ Jesus our Lord."));
        verses.add(new TmsVerse("SIN’S PENALTY", "Hebrews 9:27 (NIV)", "Just as people are destined to die once, and after that to face judgment,"));
        verses.add(new TmsVerse("CHRIST PAID THE PENALTY", "Romans 5:8 (NIV)", "But God demonstrates his own love for us in this: While we were still sinners, Christ died for us."));
        verses.add(new TmsVerse("CHRIST PAID THE PENALTY", "1 Peter 3:18 (NIV)", "For Christ also suffered once for sins, the righteous for the unrighteous, to bring you to God. He was put to death in the body but made alive in the Spirit."));
        verses.add(new TmsVerse("SALVATION IS NOT BY WORKS", "Ephesians 2:8-9 (NIV)", "For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God— not by works, so that no one can boast."));
        verses.add(new TmsVerse("SALVATION IS NOT BY WORKS", "Titus 3:5 (NIV)", "he saved us, not because of righteous things we had done, but because of his mercy. He saved us through the washing of rebirth and renewal by the Holy Spirit,"));
        verses.add(new TmsVerse("MUST RECEIVE CHRIST", "John 1:12 (NIV)", "Yet to all who did receive him, to those who believed in his name, he gave the right to become children of God—"));
        verses.add(new TmsVerse("MUST RECEIVE CHRIST", "Revelation 3:20 (NIV)", "Here I am! I stand at the door and knock. If anyone hears my voice and opens the door, I will come in and eat with that person, and they with me."));
        verses.add(new TmsVerse("ASSURANCE OF SALVATION", "1 John 5:13 (NIV)", "I write these things to you who believe in the name of the Son of God so that you may know that you have eternal life."));
        verses.add(new TmsVerse("ASSURANCE OF SALVATION", "John 5:24 (NIV)", "“Very truly I tell you, whoever hears my word and believes him who sent me has eternal life and will not be judged but has crossed over from death to life."));
        return verses;
    }

    private List<TmsVerse> getSeriesCVerses() {
        List<TmsVerse> verses = new ArrayList<>();
        verses.add(new TmsVerse("HIS SPIRIT", "1 Corinthians 3:16 (NIV)", "Don’t you know that you yourselves are God’s temple and that God’s Spirit dwells in your midst?"));
        verses.add(new TmsVerse("HIS SPIRIT", "1 Corinthians 2:12 (NIV)", "What we have received is not the spirit of the world, but the Spirit who is from God, so that we may understand what God has freely given us."));
        verses.add(new TmsVerse("HIS STRENGTH", "Isaiah 41:10 (NIV)", "So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand."));
        verses.add(new TmsVerse("HIS STRENGTH", "Philippians 4:13 (NIV)", "I can do all this through him who gives me strength."));
        verses.add(new TmsVerse("HIS FAITHFULNESS", "Lamentations 3:22-23 (NIV)", "Because of the Lord’s great love we are not consumed, for his compassions never fail. They are new every morning; great is your faithfulness."));
        verses.add(new TmsVerse("HIS FAITHFULNESS", "Numbers 23:19 (NIV)", "God is not human, that he should lie, not a human being, that he should change his mind. Does he speak and then not act? Does he promise and then not fulfill?"));
        verses.add(new TmsVerse("HIS PEACE", "Isaiah 26:3 (NIV)", "You will keep in perfect peace those whose minds are steadfast, because they trust in you."));
        verses.add(new TmsVerse("HIS PEACE", "1 Peter 5:7 (NIV)", "Cast all your anxiety on him because he cares for you."));
        verses.add(new TmsVerse("HIS PROVISION", "Romans 8:32 (NIV)", "He who did not spare his own Son, but gave him up for us all—how will he not also, along with him, graciously give us all things?"));
        verses.add(new TmsVerse("HIS PROVISION", "Philippians 4:19 (NIV)", "And my God will meet all your needs according to the riches of his glory in Christ Jesus."));
        verses.add(new TmsVerse("HIS HELP IN TEMPTATION", "Hebrews 2:18 (NIV)", "Because he himself suffered when he was tempted, he is able to help those who are being tempted."));
        verses.add(new TmsVerse("HIS HELP IN TEMPTATION", "Psalm 119:9,11 (NIV)", "How can a young person stay on the path of purity? By living according to your word. I have hidden your word in my heart that I might not sin against you."));
        return verses;
    }

    private List<TmsVerse> getSeriesDVerses() {
        List<TmsVerse> verses = new ArrayList<>();
        verses.add(new TmsVerse("PUT CHRIST FIRST", "Matthew 6:33 (NIV)", "But seek first his kingdom and his righteousness, and all these things will be given to you as well."));
        verses.add(new TmsVerse("PUT CHRIST FIRST", "Luke 9:23 (NIV)", "Then he said to them all: “Whoever wants to be my disciple must deny themselves and take up their cross daily and follow me."));
        verses.add(new TmsVerse("SEPARATE FROM THE WORLD", "1 John 2:15-16 (NIV)", "Do not love the world or anything in the world. If anyone loves the world, love for the Father is not in them. For everything in the world—the lust of the flesh, the lust of the eyes, and the pride of life—comes not from the Father but from the world."));
        verses.add(new TmsVerse("SEPARATE FROM THE WORLD", "Romans 12:2 (NIV)", "Do not conform to the pattern of this world, but be transformed by the renewing of your mind. Then you will be able to test and approve what God’s will is—his good, pleasing and perfect will."));
        verses.add(new TmsVerse("BE STEADFAST", "1 Corinthians 15:58 (NIV)", "Therefore, my dear brothers and sisters, stand firm. Let nothing move you. Always give yourselves fully to the work of the Lord, because you know that your labor in the Lord is not in vain."));
        verses.add(new TmsVerse("BE STEADFAST", "Hebrews 12:3 (NIV)", "Consider him who endured such opposition from sinners, so that you will not grow weary and lose heart."));
        verses.add(new TmsVerse("SERVE OTHERS", "Mark 10:45 (NIV)", "For even the Son of Man did not come to be served, but to serve, and to give his life as a ransom for many.”"));
        verses.add(new TmsVerse("SERVE OTHERS", "2 Corinthians 4:5 (NIV)", "For what we preach is not ourselves, but Jesus Christ as Lord, and ourselves as your servants for Jesus’ sake."));
        verses.add(new TmsVerse("GIVE GENEROUSLY", "Proverbs 3:9-10 (NIV)", "Honor the Lord with your wealth, with the firstfruits of all your crops; then your barns will be filled to overflowing, and your vats will brim over with new wine."));
        verses.add(new TmsVerse("GIVE GENEROUSLY", "2 Corinthians 9:6-7 (NIV)", "Remember this: Whoever sows sparingly will also reap sparingly, and whoever sows generously will also reap generously. Each of you should give what you have decided in your heart to give, not reluctantly or under compulsion, for God loves a cheerful giver."));
        verses.add(new TmsVerse("DEVELOP WORLD VISION", "Acts 1:8 (NIV)", "But you will receive power when the Holy Spirit comes on you; and you will be my witnesses in Jerusalem, and in all Judea and Samaria, and to the ends of the earth.”"));
        verses.add(new TmsVerse("DEVELOP WORLD VISION", "Matthew 28:19-20 (NIV)", "Therefore go and make disciples of all nations, baptizing them in the name of the Father and of the Son and of the Holy Spirit, and teaching them to obey everything I have commanded you. And surely I am with you always, to the very end of the age.”"));
        return verses;
    }

    private List<TmsVerse> getSeriesEVerses() {
        List<TmsVerse> verses = new ArrayList<>();
        verses.add(new TmsVerse("LOVE", "John 13:34-35 (NIV)", "“A new command I give you: Love one another. As I have loved you, so you must love one another. By this everyone will know that you are my disciples, if you love one another.”"));
        verses.add(new TmsVerse("LOVE", "1 John 3:18 (NIV)", "Dear children, let us not love with words or speech but with actions and in truth."));
        verses.add(new TmsVerse("HUMILITY", "Philippians 2:3-4 (NIV)", "Do nothing out of selfish ambition or vain conceit. Rather, in humility value others above yourselves, not looking to your own interests but each of you to the interests of the others."));
        verses.add(new TmsVerse("HUMILITY", "1 Peter 5:5-6 (NIV)", "In the same way, you who are younger, submit yourselves to your elders. All of you, clothe yourselves with humility toward one another, because, “God opposes the proud but shows favor to the humble.” Humble yourselves, therefore, under God’s mighty hand, that he may lift you up in due time."));
        verses.add(new TmsVerse("PURITY", "Ephesians 5:3 (NIV)", "But among you there must not be even a hint of sexual immorality, or of any kind of impurity, or of greed, because these are improper for God’s holy people."));
        verses.add(new TmsVerse("PURITY", "1 Peter 2:11 (NIV)", "Dear friends, I urge you, as foreigners and exiles, to abstain from sinful desires, which wage war against your soul."));
        verses.add(new TmsVerse("HONESTY", "Leviticus 19:11 (NIV)", "“‘Do not steal. “‘Do not lie. “‘Do not deceive one another."));
        verses.add(new TmsVerse("HONESTY", "Acts 24:16 (NIV)", "So I strive always to keep my conscience clear before God and man."));
        verses.add(new TmsVerse("FAITH", "Hebrews 11:6 (NIV)", "And without faith it is impossible to please God, because anyone who comes to him must believe that he exists and that he rewards those who earnestly seek him."));
        verses.add(new TmsVerse("FAITH", "Romans 4:20-21 (NIV)", "Yet he did not waver through unbelief regarding the promise of God, but was strengthened in his faith and gave glory to God, being fully persuaded that God had power to do what he had promised."));
        verses.add(new TmsVerse("GOOD WORKS", "Galatians 6:9-10 (NIV)", "Let us not become weary in doing good, for at the proper time we will reap a harvest if we do not give up. Therefore, as we have opportunity, let us do good to all people, especially to those who belong to the family of believers."));
        verses.add(new TmsVerse("GOOD WORKS", "Matthew 5:16 (NIV)", "In the same way, let your light shine before others, that they may see your good deeds and glorify your Father in heaven."));
        return verses;
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }
}
