package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class GoodsSku {
    private Integer id;
    private Integer goodsId;
    private String specValue;
    private BigDecimal price;
    private Integer stock;
    private String img;
}