package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.example.entity.Cart;
import com.example.entity.Orders;
import com.example.entity.OrderItem;
import com.example.entity.GoodsSku;
import com.example.mapper.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Arrays;
import java.util.stream.Collectors;

@Service
public class OrdersService {
    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private OrderItemMapper orderItemMapper;
    @Resource
    private CartMapper cartMapper;
    @Resource
    private GoodsMapper goodsMapper;
    @Resource
    private GoodsSkuMapper goodsSkuMapper;

//    下单
    @Transactional
    public void add(Orders orders) {
        orders.setOrderNo(IdUtil.getSnowflakeNextIdStr());
        orders.setTime(DateUtil.now());
        orders.setStatus("待付款");

        List<Cart> selectedCartList = orders.getCartList();
        StringBuilder sb = new StringBuilder();
        if (selectedCartList != null && !selectedCartList.isEmpty()) {
            for (Cart cart : selectedCartList) {
                sb.append(cart.getGoodsName()).append(" x").append(cart.getNum()).append(" ");
            }
        }
        orders.setGoodsName(sb.toString().trim());


        ordersMapper.insert(orders);
        if (selectedCartList != null && !selectedCartList.isEmpty()) {
            for (Cart cart : selectedCartList) {
                String currentSpec = StrUtil.isBlank(cart.getSpec()) ? "默认规格" : cart.getSpec();
                // 下单前进行SKU级别实时库存校验
                GoodsSku sku = goodsSkuMapper.selectByGoodsIdAndSpec(cart.getGoodsId(), currentSpec);
                if (sku == null || sku.getStock() < cart.getNum()) {
                    throw new com.example.exception.CustomException("商品规格【" + currentSpec + "】库存不足");
                }

                OrderItem item = new OrderItem();
                item.setOrderId(orders.getId());
                item.setGoodsId(cart.getGoodsId());

                if (sku != null) {
                    item.setSkuId(sku.getId());
                }

                item.setGoodsName(cart.getGoodsName());
                item.setGoodsImg(cart.getGoodsImg());
                item.setSpec(currentSpec);
                if (cart.getGoodsPrice() != null) {
                    item.setPrice(cart.getGoodsPrice().doubleValue());
                }
                item.setNum(cart.getNum());
                orderItemMapper.insert(item);

                int skuRows = goodsSkuMapper.updateSkuStock(cart.getGoodsId(), currentSpec, cart.getNum());
                if (skuRows <= 0) {
                    throw new com.example.exception.CustomException("商品规格【" + currentSpec + "】并发扣减失败");
                }
                if (cart.getId() != null) {
                    cartMapper.deleteById(cart.getId());
                }
            }
        }
    }

//   订单数据包装
    private void wrapItemList(Orders o) {
        if (o == null) return;
        List<OrderItem> items = orderItemMapper.selectByOrderId(o.getId());
        o.setItemList(items);
        // 支付流水与时间补全
        boolean isPaid = !"待付款".equals(o.getStatus()) && !"已取消".equals(o.getStatus());
        if (isPaid) {
            if (StrUtil.isBlank(o.getPayNo())) o.setPayNo("HIST_PAY_" + o.getId());
            if (StrUtil.isBlank(o.getPayTime())) o.setPayTime(o.getTime());
        }

        if (Arrays.asList("已签收", "已完成", "退货待审核", "已退款").contains(o.getStatus())) {
            if (StrUtil.isBlank(o.getReceiptTime())) o.setReceiptTime(o.getPayTime());
        }

        if (Arrays.asList("已完成", "已退款").contains(o.getStatus())) {
            if (StrUtil.isBlank(o.getFinishTime())) o.setFinishTime(o.getReceiptTime());
        }
    }

//      确认签收
    public void signOrder(Integer id) {
        Orders o = new Orders();
        o.setId(id);
        o.setStatus("已签收");
        o.setReceiptTime(DateUtil.now());
        ordersMapper.updateById(o);
    }

//    修改订单状态
    @Transactional
    public void updateStatus(Orders orders) {
        if ("待发货".equals(orders.getStatus())) {
            orders.setPayTime(DateUtil.now());

            String prefix = "PAY";
            if ("alipay".equals(orders.getPayType())) {
                prefix = "ALP";
            } else if ("wechat".equals(orders.getPayType())) {
                prefix = "WXP";
            } else if ("union".equals(orders.getPayType())) {
                prefix = "UNP";
            }

            orders.setPayNo(prefix + RandomUtil.randomNumbers(12));

            Orders dbOrder = selectById(orders.getId());
            if (dbOrder.getItemList() != null) {
                for (OrderItem item : dbOrder.getItemList()) {
                    goodsMapper.updateSales(item.getGoodsId(), item.getNum());
                }
            }
        }
        if ("已完成".equals(orders.getStatus())) {
            orders.setFinishTime(DateUtil.now());
        }
        ordersMapper.updateById(orders);
    }

//    确认退款
    @Transactional
    public void confirmReturn(Integer id) {
        Orders order = selectById(id);
        if (order != null) {
            order.setStatus("已退款");
            order.setFinishTime(DateUtil.now());
            ordersMapper.updateById(order);
            if (order.getItemList() != null) {
                for (OrderItem item : order.getItemList()) {
                    // 按规格ID回退库存，无规格ID则按商品+规格匹配回退
                    if (item.getSkuId() != null) {
                        goodsSkuMapper.rollbackSkuStockById(item.getSkuId(), item.getNum());
                    } else {
                        goodsSkuMapper.rollbackSkuStock(item.getGoodsId(), item.getSpec(), item.getNum());
                    }
                    goodsMapper.updateSales(item.getGoodsId(), -item.getNum());
                }
            }
        }
    }

    public Orders selectById(Integer id) {
        Orders o = ordersMapper.selectById(id);
        wrapItemList(o);
        return o;
    }

    public List<Orders> selectAll(Orders orders) {
        List<Orders> list = ordersMapper.selectAll(orders);
        for (Orders o : list) { wrapItemList(o); }
        return list;
    }

    public PageInfo<Orders> selectPage(Orders orders, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        for (Orders o : list) { wrapItemList(o); }
        return PageInfo.of(list);
    }

    @Transactional
    public void cancelOrder(Orders orders) {
        Orders dbOrder = ordersMapper.selectById(orders.getId());
        if (dbOrder != null && ("待付款".equals(dbOrder.getStatus()) || "待发货".equals(dbOrder.getStatus()))) {
            String oldStatus = dbOrder.getStatus();

            dbOrder.setStatus("已取消");
            dbOrder.setCancelReason(orders.getCancelReason());
            ordersMapper.updateById(dbOrder);
            wrapItemList(dbOrder);

            if (dbOrder.getItemList() != null) {
                for (OrderItem item : dbOrder.getItemList()) {
                    if (item.getSkuId() != null) {
                        goodsSkuMapper.rollbackSkuStockById(item.getSkuId(), item.getNum());
                    } else {
                        goodsSkuMapper.rollbackSkuStock(item.getGoodsId(), item.getSpec(), item.getNum());
                    }
                    if ("待发货".equals(oldStatus)) {
                        goodsMapper.updateSales(item.getGoodsId(), -item.getNum());
                    }
                }
            }
        }
    }

    public void applyReturn(Orders orders) { orders.setStatus("退货待审核"); ordersMapper.updateById(orders); }
    public void approveReturn(Integer id) { Orders o = new Orders(); o.setId(id); o.setStatus("待用户发货"); ordersMapper.updateById(o); }
    public void rejectReturn(Orders orders) { orders.setStatus("已签收"); ordersMapper.updateById(orders); }
    public void submitExpress(Orders orders) { orders.setStatus("待商家收货"); ordersMapper.updateById(orders); }
    public void ship(Integer id) { Orders o = new Orders(); o.setId(id); o.setStatus("待收货"); ordersMapper.updateById(o); }
    public void deleteById(Integer id) { Orders o = new Orders(); o.setId(id); o.setUserDelete(1); ordersMapper.updateById(o); }
    public void deleteAdmin(Integer id) { Orders o = new Orders(); o.setId(id); o.setAdminDelete(1); ordersMapper.updateById(o); }

    @Scheduled(cron = "0 0 * * * ?")// 每小时整点触发一次
    public void autoCancelOrders() {
        List<Orders> expired = ordersMapper.selectExpiredOrders();
        if (expired != null) {
            for (Orders o : expired) {
                o.setCancelReason("超时未支付自动取消");
                this.cancelOrder(o);// 调用取消订单逻辑并回滚库存
            }
        }
    }

//     报表统计
    public Map<String, Object> getReport() {
        Map<String, Object> map = new HashMap<>();
        map.put("totalRevenue", ordersMapper.totalRevenue() == null ? 0 : ordersMapper.totalRevenue());

        List<Orders> allOrders = selectAll(null);

        map.put("totalOrders", allOrders.stream().filter(o -> "已完成".equals(o.getStatus())).count());
        map.put("todayRevenue", ordersMapper.todayRevenue() == null ? 0 : ordersMapper.todayRevenue());
        map.put("todayOrders", ordersMapper.todayOrders() == null ? 0 : ordersMapper.todayOrders());
        map.put("stockAlertCount", goodsSkuMapper.countDistinctLowStock(10));

        Map<String, Integer> salesMap = new HashMap<>();
        Map<String, Integer> cancelItemMap = new HashMap<>();
        Map<String, Integer> returnItemMap = new HashMap<>();

        for (Orders o : allOrders) {
            if (o.getItemList() != null) {
                for (OrderItem item : o.getItemList()) {
                    salesMap.putIfAbsent(item.getGoodsName(), 0);
                }
            }

            if ("已完成".equals(o.getStatus())) {
                if (o.getItemList() != null) {
                    for (OrderItem item : o.getItemList()) {
                        salesMap.put(item.getGoodsName(), salesMap.get(item.getGoodsName()) + item.getNum());
                    }
                }
            }
            else if ("已取消".equals(o.getStatus())) {
                if (o.getItemList() != null) {
                    for (OrderItem item : o.getItemList()) {
                        cancelItemMap.put(item.getGoodsName(), cancelItemMap.getOrDefault(item.getGoodsName(), 0) + item.getNum());
                    }
                }
            } else if (Arrays.asList("退货待审核", "待用户发货", "待商家收货", "已退款").contains(o.getStatus())) {
                if (o.getItemList() != null) {
                    for (OrderItem item : o.getItemList()) {
                        returnItemMap.put(item.getGoodsName(), returnItemMap.getOrDefault(item.getGoodsName(), 0) + item.getNum());
                    }
                }
            }
        }

        List<Map<String, Object>> hotData = salesMap.entrySet().stream()
                .sorted((e1, e2) -> {
                    int compareValue = e2.getValue().compareTo(e1.getValue());
                    if (compareValue == 0) return e1.getKey().compareTo(e2.getKey());
                    return compareValue;
                })
                .limit(5)
                .map(e -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", e.getKey());
                    m.put("value", e.getValue());
                    return m;
                })
                .collect(Collectors.toList());

        List<Map<String, Object>> cancelData = new ArrayList<>();

        List<Map<String, Object>> topCancelList = cancelItemMap.entrySet().stream()
                .sorted((e1, e2) -> {
                    int compareValue = e2.getValue().compareTo(e1.getValue());
                    if (compareValue == 0) return e1.getKey().compareTo(e2.getKey());
                    return compareValue;
                })
                .limit(2)
                .map(e -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", "[取消] " + e.getKey());
                    m.put("value", e.getValue());
                    return m;
                })
                .collect(Collectors.toList());

        List<Map<String, Object>> topReturnList = returnItemMap.entrySet().stream()
                .sorted((e1, e2) -> {
                    int compareValue = e2.getValue().compareTo(e1.getValue());
                    if (compareValue == 0) return e1.getKey().compareTo(e2.getKey());
                    return compareValue;
                })
                .limit(2)
                .map(e -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", "[售后] " + e.getKey());
                    m.put("value", e.getValue());
                    return m;
                })
                .collect(Collectors.toList());

        cancelData.addAll(topCancelList);
        cancelData.addAll(topReturnList);

        map.put("hotData", hotData);
        map.put("cancelData", cancelData);
        map.put("categoryData", ordersMapper.selectCategoryCount());

        return map;
    }
}