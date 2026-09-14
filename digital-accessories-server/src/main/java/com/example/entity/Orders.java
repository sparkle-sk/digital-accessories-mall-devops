package com.example.entity;

import lombok.Data;
import java.util.List;

// 订单实体类
@Data
public class Orders {
    private Integer id;
    private String orderNo;
    private Integer userId;
    private Double totalPrice;
    private String status;
    private String time;
    private String payTime;
    private String payNo;
    private String goodsName;
    private String userName;
    private String address;
    private Integer userDelete;
    private Integer adminDelete;
    private String userAccount;
    private String receiptTime;
    private String finishTime;
    private String returnReason;
    private String expressNo;
    private String cancelReason;
    private String rejectReason;
    private String startTime;
    private String endTime;
    private String payType;
    private List<Cart> cartList;
    private List<OrderItem> itemList;
}