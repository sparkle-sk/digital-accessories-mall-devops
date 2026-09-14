package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class Collect {
    private Integer id;
    private Integer goodsId;

    private Integer skuId;

    private Integer userId;
    private String time;
    private String spec;
    private BigDecimal price;

    private String goodsName;
    private String goodsImg;
    private BigDecimal goodsPrice;
}