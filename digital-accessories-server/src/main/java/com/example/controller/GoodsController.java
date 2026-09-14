package com.example.controller;

import com.example.common.Result;
import com.example.entity.Goods;
import com.example.entity.GoodsSku;
import com.example.service.GoodsService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/goods")
public class GoodsController {
    @Resource
    private GoodsService goodsService;

    @PostMapping("/add") public Result add(@RequestBody Goods goods) { goodsService.add(goods); return Result.success(); }
    @DeleteMapping("/delete/{id}") public Result delete(@PathVariable Integer id) { goodsService.deleteById(id); return Result.success(); }
    @PutMapping("/update") public Result update(@RequestBody Goods goods) { goodsService.updateById(goods); return Result.success(); }

    @GetMapping("/getSkus/{id}")
    public Result getSkus(@PathVariable Integer id) {
        return Result.success(goodsService.selectSkusByGoodsId(id));
    }

    @PostMapping("/updateSkus")
    public Result updateSkus(@RequestBody List<GoodsSku> skuList) {
        goodsService.updateSkuBatch(skuList);
        return Result.success();
    }

    @GetMapping("/selectPage") public Result selectPage(Goods goods, @RequestParam(defaultValue="1") Integer pageNum, @RequestParam(defaultValue="10") Integer pageSize) {
        return Result.success(goodsService.selectPage(goods, pageNum, pageSize));
    }

    @GetMapping("/selectAll")
    public Result selectAll(Goods goods) {
        List<Goods> list = goodsService.selectAll(goods);
        return Result.success(list);
    }

    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Goods goods = goodsService.selectById(id);
        return Result.success(goods);
    }
}