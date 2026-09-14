package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Collect;
import com.example.entity.GoodsSku;
import com.example.mapper.CollectMapper;
import com.example.mapper.GoodsSkuMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CollectService {
    @Resource
    private CollectMapper collectMapper;
    @Resource
    private GoodsSkuMapper goodsSkuMapper;

    public void add(Collect collect) {
        // 规格为空时设置默认值
        if (collect.getSpec() == null) {
            collect.setSpec("默认规格");
        }
        Collect dbCollect = collectMapper.selectByUserIdGoodsIdAndSpec(
                collect.getUserId(), collect.getGoodsId(), collect.getSpec());

        if (dbCollect != null) {
            collectMapper.deleteById(dbCollect.getId());
        } else {
            collect.setTime(DateUtil.now());
//            绑定对于SKU ID
            GoodsSku sku = goodsSkuMapper.selectByGoodsIdAndSpec(collect.getGoodsId(), collect.getSpec());
            if (sku != null) {
                collect.setSkuId(sku.getId());
            }

            collectMapper.insert(collect);
        }
    }

    public void deleteById(Integer id) {
        collectMapper.deleteById(id);
    }

    public List<Collect> selectAll(Collect collect) {
        return collectMapper.selectAll(collect);
    }
    //判断当前规格是否已收藏
    public Collect selectByUserIdAndGoodsId(Integer userId, Integer goodsId, String spec) {
        return collectMapper.selectByUserIdGoodsIdAndSpec(userId, goodsId, spec);
    }
}