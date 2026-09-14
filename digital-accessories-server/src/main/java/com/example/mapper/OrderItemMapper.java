package com.example.mapper;

import com.example.entity.OrderItem;
import org.apache.ibatis.annotations.Param;
import java.util.List;

//订单明细Mapper接口
public interface OrderItemMapper {
    int insert(OrderItem orderItem);
    List<OrderItem> selectByOrderId(@Param("orderId") Integer orderId);
    OrderItem selectById(Integer id);
    List<OrderItem> selectAll();
}