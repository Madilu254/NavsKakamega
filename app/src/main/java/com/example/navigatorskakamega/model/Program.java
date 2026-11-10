package com.example.navigatorskakamega.model;

public class Program {
    private String id;
    private String name;
    private String schedule;

    public Program(String id, String name, String schedule) {
        this.id = id;
        this.name = name;
        this.schedule = schedule;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public String getSchedule() { return schedule; }
    
    public void setName(String name) { this.name = name; }
    public void setSchedule(String schedule) { this.schedule = schedule; }
}
