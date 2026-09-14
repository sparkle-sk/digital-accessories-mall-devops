package com.example.entity;

import lombok.Data;

// 订单明细
@Data
public class OrderItem {
    private Integer id;
    private Integer orderId;
    private Integer goodsId;
    private Integer skuId;
    private String goodsName;
    private String goodsImg;
    private String spec;
    private Double price;
    private Integer num;
}