package com.example.controller;

import com.example.common.Result;
import com.example.entity.Collect;
import com.example.service.CollectService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/collect")
public class CollectController {

    @Resource
    private CollectService collectService;

    @PostMapping("/add")
    public Result add(@RequestBody Collect collect) {
        collectService.add(collect);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        collectService.deleteById(id);
        return Result.success();
    }

    @GetMapping("/selectAll")
    public Result selectAll(Collect collect) {
        List<Collect> list = collectService.selectAll(collect);
        return Result.success(list);
    }
    // 根据用户ID和商品ID查询收藏信息
    @GetMapping("/selectByUserIdAndGoodsId")
    public Result selectByUserIdAndGoodsId(@RequestParam Integer userId,
                                           @RequestParam Integer goodsId,
                                           @RequestParam(required = false) String spec) {
        Collect collect = collectService.selectByUserIdAndGoodsId(userId, goodsId, spec);
        return Result.success(collect);
    }
}