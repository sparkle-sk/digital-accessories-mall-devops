package com.example.mapper;

import com.example.entity.Orders;
import com.example.entity.ReportVO;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface OrdersMapper {

    int insert(Orders orders);

    int updateById(Orders orders);

    int deleteById(Integer id);

    Orders selectById(Integer id);

    List<Orders> selectAll(Orders orders);

    void updateAutoConfirm();

    Double totalRevenue();
    List<ReportVO> selectCategoryCount();
    List<Orders> selectExpiredOrders();
    Double todayRevenue();
    Integer todayOrders();
}