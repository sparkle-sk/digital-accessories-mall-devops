package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class Cart {
    private Integer id;
    private Integer goodsId;
    private Integer skuId;

    private Integer userId;
    private Integer num;
    private String time;
    private String spec;
    private BigDecimal price;
    private String img;

    // 关联查询字段
    private String goodsName;
    private String goodsImg;
    private BigDecimal goodsPrice;
    private String storeName;
    private Integer stock;
}