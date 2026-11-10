package com.example.navigatorskakamega.model;

public class Member {
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private String phone;
    private String idNumber;
    private String password;
    private String profilePicUrl;
    private String role; // "Student" or "Staff"

    public Member() {
        // Default constructor for Firebase
    }

    public Member(String username, String email, String phone, String role) {
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }

    // Full constructor including password and profile picture
    public Member(String firstName, String lastName, String username, String email, String phone, String idNumber, String password, String profilePicUrl, String role) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.idNumber = idNumber;
        this.password = password;
        this.profilePicUrl = profilePicUrl;
        this.role = role;
    }

    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getIdNumber() { return idNumber; }
    public String getPassword() { return password; }
    public String getProfilePicUrl() { return profilePicUrl; }
    public String getRole() { return role; }
}
