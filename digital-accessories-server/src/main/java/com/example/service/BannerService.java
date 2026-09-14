package com.example.service;

import com.example.entity.Banner;
import com.example.mapper.BannerMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class BannerService {

    @Resource
    private BannerMapper bannerMapper;

    public void add(Banner banner) {
        bannerMapper.insert(banner);
    }

    public void deleteById(Integer id) {
        bannerMapper.deleteById(id);
    }

    public void updateById(Banner banner) {
        bannerMapper.updateById(banner);
    }

    public PageInfo<Banner> selectPage(Banner banner, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Banner> list = bannerMapper.selectAll(banner);
        return PageInfo.of(list);
    }
}