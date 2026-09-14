package com.example.entity;

public class User {
    private Integer id;
    private String username;
    private String password;
    private String name;
    private String avatar;
    private String role;
    private String sex;
    private String birthday;
    private Integer usernameUpdateCount;
    private String lastUpdateDate;
    private Integer status;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }
    public String getBirthday() { return birthday; }
    public void setBirthday(String birthday) { this.birthday = birthday; }
    public Integer getUsernameUpdateCount() { return usernameUpdateCount; }
    public void setUsernameUpdateCount(Integer usernameUpdateCount) { this.usernameUpdateCount = usernameUpdateCount; }
    public String getLastUpdateDate() { return lastUpdateDate; }
    public void setLastUpdateDate(String lastUpdateDate) { this.lastUpdateDate = lastUpdateDate; }
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

}