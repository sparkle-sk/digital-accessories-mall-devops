package com.example.controller;

import com.example.common.Result;
import com.example.entity.Orders;
import com.example.service.OrdersService;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
public class OrdersController {

    @Resource
    private OrdersService ordersService;

    @PostMapping("/add")
    public Result add(@RequestBody Orders orders) {
        ordersService.add(orders);
        return Result.success();
    }

    @GetMapping("/selectAll")
    public Result selectAll(Orders orders) {
        List<Orders> list = ordersService.selectAll(orders);
        return Result.success(list);
    }

    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        return Result.success(ordersService.selectById(id));
    }

    @PutMapping("/updateStatus")
    public Result updateStatus(@RequestBody Orders orders) {
        ordersService.updateStatus(orders);
        return Result.success();
    }


//     用户取消订单
    @PutMapping("/cancel")
    public Result cancel(@RequestBody Orders orders) {
        ordersService.cancelOrder(orders);
        return Result.success();
    }

//     用户确认签收
    @PutMapping("/sign/{id}")
    public Result sign(@PathVariable Integer id) {
        ordersService.signOrder(id);
        return Result.success();
    }

//     确认退款
    @PutMapping("/confirmReturn/{id}")
    public Result confirmReturn(@PathVariable Integer id) {
        ordersService.confirmReturn(id);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        ordersService.deleteById(id);
        return Result.success();
    }

//     管理员删除订单
    @DeleteMapping("/deleteAdmin/{id}")
    public Result deleteAdmin(@PathVariable Integer id) {
        ordersService.deleteAdmin(id);
        return Result.success();
    }

    @GetMapping("/selectPage")
    public Result selectPage(Orders orders,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Orders> pageInfo = ordersService.selectPage(orders, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    @PutMapping("/ship/{id}")
    public Result ship(@PathVariable Integer id) {
        ordersService.ship(id);
        return Result.success();
    }

    @GetMapping("/getReport")
    public Result getReport() {
        return Result.success(ordersService.getReport());
    }

    @PutMapping("/rejectReturn")
    public Result rejectReturn(@RequestBody Orders orders) {
        ordersService.rejectReturn(orders);
        return Result.success();
    }
}