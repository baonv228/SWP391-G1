package model;

/** Google profile returned by the OAuth2 UserInfo endpoint. */
public class GoogleAccount {

    private String id;
    private String email;
    private String name;
    private String first_name;
    private String given_name;
    private String family_name;
    private String picture;
    private boolean verified_email;

    public String getId() { return id; }
    public String getEmail() { return email; }
    public String getName() { return name; }
    public String getFirst_name() { return first_name; }
    public String getGiven_name() { return given_name; }
    public String getFamily_name() { return family_name; }
    public String getPicture() { return picture; }
    public boolean isVerified_email() { return verified_email; }
}
