package com.example.navigatorskakamega.model;

public class TmsVerse {
    private String topic;
    private String reference;
    private String text;

    public TmsVerse(String topic, String reference, String text) {
        this.topic = topic;
        this.reference = reference;
        this.text = text;
    }

    public String getTopic() { return topic; }
    public String getReference() { return reference; }
    public String getText() { return text; }
}
