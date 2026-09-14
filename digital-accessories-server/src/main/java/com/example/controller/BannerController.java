package com.example.controller;

import com.example.common.Result;
import com.example.entity.Banner;
import com.example.service.BannerService;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/banner")
public class BannerController {

    @Resource
    private BannerService bannerService;

    @PostMapping("/add")
    public Result add(@RequestBody Banner banner) {
        bannerService.add(banner);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        bannerService.deleteById(id);
        return Result.success();
    }

    @PutMapping("/update")
    public Result update(@RequestBody Banner banner) {
        bannerService.updateById(banner);
        return Result.success();
    }

    @GetMapping("/selectPage")
    public Result selectPage(Banner banner,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Banner> pageInfo = bannerService.selectPage(banner, pageNum, pageSize);
        return Result.success(pageInfo);
    }
}