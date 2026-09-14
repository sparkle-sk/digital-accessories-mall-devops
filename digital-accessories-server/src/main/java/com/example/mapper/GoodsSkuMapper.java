package com.example.mapper;

import com.example.entity.GoodsSku;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GoodsSkuMapper {
    int insert(GoodsSku goodsSku);

    int deleteByGoodsId(Integer goodsId);

    List<GoodsSku> selectByGoodsId(Integer goodsId);

    int updateById(GoodsSku goodsSku);
    GoodsSku selectByGoodsIdAndSpec(@Param("goodsId") Integer goodsId, @Param("specValue") String specValue);
    int updateSkuStock(@Param("goodsId") Integer goodsId, @Param("specValue") String specValue, @Param("num") Integer num);
    int rollbackSkuStock(@Param("goodsId") Integer goodsId, @Param("specValue") String specValue, @Param("num") Integer num);
    int countDistinctLowStock(@Param("threshold") Integer threshold);
    int deleteById(Integer id);
    int rollbackSkuStockById(@Param("id") Integer id, @Param("num") Integer num);
}