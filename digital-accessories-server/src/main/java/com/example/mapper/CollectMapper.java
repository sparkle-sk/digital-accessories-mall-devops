package com.example.mapper;

import com.example.entity.Collect;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CollectMapper {
    int insert(Collect collect);

    int deleteById(Integer id);
    Collect selectByUserIdGoodsIdAndSpec(@Param("userId") Integer userId,
                                         @Param("goodsId") Integer goodsId,
                                         @Param("spec") String spec);

    List<Collect> selectAll(Collect collect);
}