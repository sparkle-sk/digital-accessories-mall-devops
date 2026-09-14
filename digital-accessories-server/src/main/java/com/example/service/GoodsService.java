package com.example.service;

import cn.hutool.core.util.StrUtil;
import com.example.entity.Goods;
import com.example.entity.GoodsSku;
import com.example.mapper.GoodsMapper;
import com.example.mapper.GoodsSkuMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class GoodsService {
    @Resource
    private GoodsMapper goodsMapper;
    @Resource
    private GoodsSkuMapper goodsSkuMapper;

    @Transactional
    public void add(Goods goods) {
        goodsMapper.insert(goods);
        saveSkus(goods);
    }

    public void deleteById(Integer id) {
        goodsSkuMapper.deleteByGoodsId(id);
        goodsMapper.deleteById(id);
    }

    @Transactional
    public void updateById(Goods goods) {
        goodsMapper.updateById(goods);
        saveSkus(goods);
    }

//     保存商品规格信息，维护库存一致性
    private void saveSkus(Goods goods) {
        List<GoodsSku> originSkus = goodsSkuMapper.selectByGoodsId(goods.getId());
        if (originSkus == null) originSkus = new ArrayList<>();
        Map<String, GoodsSku> originSkuMap = originSkus.stream()
                .filter(s -> s.getSpecValue() != null)
                .collect(Collectors.toMap(GoodsSku::getSpecValue, s -> s, (v1, v2) -> v1));

        Map<String, Integer> stockMap = originSkus.stream()
                .filter(s -> s.getSpecValue() != null)
                .collect(Collectors.toMap(GoodsSku::getSpecValue, s -> s.getStock() != null ? s.getStock() : 0, (v1, v2) -> v1));
        Map<String, Integer> frontStockMap = new java.util.HashMap<>();
        if (goods.getSkuList() != null && !goods.getSkuList().isEmpty()) {
            frontStockMap = goods.getSkuList().stream()
                    .filter(s -> s.getSpecValue() != null)
                    .collect(Collectors.toMap(GoodsSku::getSpecValue, s -> s.getStock() != null ? s.getStock() : 0, (v1, v2) -> v1));
        }
//      单规格处理
        if (StrUtil.isBlank(goods.getSpecList()) || !goods.getSpecList().contains("|")) {
            GoodsSku oldSku = originSkuMap.get("默认规格");
            if (oldSku != null) {
                GoodsSku sku = new GoodsSku();
                sku.setId(oldSku.getId());
                sku.setGoodsId(goods.getId());
                sku.setSpecValue("默认规格");
                sku.setPrice(goods.getPrice());
                sku.setImg(goods.getImg());
                sku.setStock(goods.getStock() != null ? goods.getStock() : 0);
                goodsSkuMapper.updateById(sku);
//                删除多余规格
                for (GoodsSku os : originSkus) {
                    if (!"默认规格".equals(os.getSpecValue())) {
                        goodsSkuMapper.deleteById(os.getId());
                    }
                }
            } else {
                goodsSkuMapper.deleteByGoodsId(goods.getId());
                insertSingleSku(goods, "默认规格", goods.getStock() != null ? goods.getStock() : 0);
            }
        } else {
            // 多规格处理
            String[] specArray = goods.getSpecList().split(",");
            List<String> targetSpecNames = new ArrayList<>();
            for (String specStr : specArray) {
                String[] parts = specStr.split("\\|");
                targetSpecNames.add(parts[0].trim());
            }

            // 删除废弃规格
            for (GoodsSku oldSku : originSkus) {
                if (!targetSpecNames.contains(oldSku.getSpecValue())) {
                    goodsSkuMapper.deleteById(oldSku.getId());
                }
            }

            // 新增/更新规格
            for (String specStr : specArray) {
                String[] parts = specStr.split("\\|");
                String name = parts[0].trim();
                int finalStock = 0;
                if (frontStockMap.containsKey(name)) {
                    finalStock = frontStockMap.get(name);
                } else {
                    finalStock = stockMap.getOrDefault(name, 0);
                }

                GoodsSku oldSku = originSkuMap.get(name);
                GoodsSku sku = new GoodsSku();
                sku.setGoodsId(goods.getId());
                sku.setSpecValue(name);
                sku.setPrice(parts.length > 1 ? new java.math.BigDecimal(parts[1].trim()) : goods.getPrice());
                sku.setImg(parts.length > 2 ? parts[2].trim() : goods.getImg());
                sku.setStock(finalStock);
                if (oldSku != null) {
                    sku.setId(oldSku.getId());
                    goodsSkuMapper.updateById(sku);
                } else {
                    goodsSkuMapper.insert(sku);
                }
            }
        }
        // 同步总库存
        syncTotalStock(goods.getId());
    }

    private void insertSingleSku(Goods goods, String specName, Integer stock) {
        GoodsSku sku = new GoodsSku();
        sku.setGoodsId(goods.getId());
        sku.setSpecValue(specName);
        sku.setPrice(goods.getPrice());
        sku.setImg(goods.getImg());
        sku.setStock(stock);
        goodsSkuMapper.insert(sku);
    }

    @Transactional
    public void updateSkuBatch(List<GoodsSku> skuList) {
        if (skuList == null || skuList.isEmpty()) return;
        Integer goodsId = skuList.get(0).getGoodsId();
        for (GoodsSku sku : skuList) {
            goodsSkuMapper.updateById(sku);
        }
        syncTotalStock(goodsId);
    }

    public void syncTotalStock(Integer goodsId) {
        if (goodsId == null) return;
        List<GoodsSku> skus = goodsSkuMapper.selectByGoodsId(goodsId);
        int total = skus.stream().mapToInt(s -> s.getStock() != null ? s.getStock() : 0).sum();
        goodsMapper.updateStockDirect(goodsId, total);
    }

    public List<GoodsSku> selectSkusByGoodsId(Integer id) {
        return goodsSkuMapper.selectByGoodsId(id);
    }

    public PageInfo<Goods> selectPage(Goods goods, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Goods> list = goodsMapper.selectAll(goods);
        for (Goods g : list) {
            List<GoodsSku> skus = goodsSkuMapper.selectByGoodsId(g.getId());
            List<GoodsSku> lowStockSkus = skus.stream()
                    .filter(s -> s.getStock() < 10)
                    .collect(Collectors.toList());
            g.setLowStockSkus(lowStockSkus);
        }
        return PageInfo.of(list);
    }

    public List<Goods> selectAll(Goods goods) {
        return goodsMapper.selectAll(goods);
    }

    public Goods selectById(Integer id) {
        Goods goods = goodsMapper.selectById(id);
        if (goods != null) {
//            查询该商品关联的所有 SKU 多规格数据，并封装进商品对象中
            goods.setSkuList(goodsSkuMapper.selectByGoodsId(id));
        }
        return goods;
    }
}