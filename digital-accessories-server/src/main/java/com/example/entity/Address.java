package com.example.entity;

import lombok.Data;

@Data
public class Address {
    private Integer id;
    private Integer userId;
    private String name;
    private String phone;
    private String address;
    private Integer isDefault;
}