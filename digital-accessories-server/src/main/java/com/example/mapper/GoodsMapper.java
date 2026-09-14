package com.example.mapper;

import com.example.entity.Goods;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GoodsMapper {
    int insert(Goods goods);

    int deleteById(Integer id);

    int updateById(Goods goods);

    Goods selectById(Integer id);

    List<Goods> selectAll(Goods goods);

    // 同步总库存
    void updateStockDirect(@Param("goodsId") Integer goodsId, @Param("total") Integer total);

    // 更新商品销量
    int updateSales(@Param("id") Integer id, @Param("num") Integer num);

    int updateStock(@Param("id") Integer id, @Param("num") Integer num);

    int updateStockAndSales(@Param("id") Integer id, @Param("num") Integer num);

    int rollbackStockAndSales(@Param("id") Integer id, @Param("num") Integer num);

    int countLowStock(@Param("threshold") Integer threshold);
}