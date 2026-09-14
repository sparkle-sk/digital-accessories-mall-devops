package com.example.entity;

// 管理员
public class Admin extends Account {

    private Integer id;
    private String username;
    private String password;
    private String name;
    private String avatar;
    private String role;
    private Integer usernameUpdateCount;
    private String lastUpdateDate;

    @Override
    public Integer getId() { return id; }
    @Override
    public void setId(Integer id) { this.id = id; }
    @Override
    public String getUsername() { return username; }
    @Override
    public void setUsername(String username) { this.username = username; }
    @Override
    public String getPassword() { return password; }
    @Override
    public void setPassword(String password) { this.password = password; }
    @Override
    public String getName() { return name; }
    @Override
    public void setName(String name) { this.name = name; }
    @Override
    public String getAvatar() { return avatar; }
    @Override
    public void setAvatar(String avatar) { this.avatar = avatar; }
    @Override
    public String getRole() { return role; }
    @Override
    public void setRole(String role) { this.role = role; }

    public Integer getUsernameUpdateCount() { return usernameUpdateCount; }
    public void setUsernameUpdateCount(Integer usernameUpdateCount) { this.usernameUpdateCount = usernameUpdateCount; }
    public String getLastUpdateDate() { return lastUpdateDate; }
    public void setLastUpdateDate(String lastUpdateDate) { this.lastUpdateDate = lastUpdateDate; }
}