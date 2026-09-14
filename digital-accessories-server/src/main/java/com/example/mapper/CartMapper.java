package com.example.mapper;

import com.example.entity.Cart;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CartMapper {
    int insert(Cart cart);
    int updateById(Cart cart);
    int deleteById(Integer id);

    // 根据用户ID、商品ID、规格查询购物车
    Cart selectByUserIdGoodsIdAndSpec(@Param("userId") Integer userId,
                                      @Param("goodsId") Integer goodsId,
                                      @Param("spec") String spec);

    List<Cart> selectAll(Cart cart);
}