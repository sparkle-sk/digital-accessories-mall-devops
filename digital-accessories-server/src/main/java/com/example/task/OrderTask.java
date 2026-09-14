package com.example.task;
import com.example.mapper.OrdersMapper;
import jakarta.annotation.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class OrderTask {
    @Resource
    private OrdersMapper ordersMapper;
    @Scheduled(fixedRate = 3600000) // 每小时
    public void autoConfirmOrder() {
        ordersMapper.updateAutoConfirm();
    }
}