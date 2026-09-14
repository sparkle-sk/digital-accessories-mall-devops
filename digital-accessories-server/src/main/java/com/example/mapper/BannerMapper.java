package com.example.mapper;

import com.example.entity.Banner;
import java.util.List;

public interface BannerMapper {
    int insert(Banner banner);
    int deleteById(Integer id);
    int updateById(Banner banner);
    List<Banner> selectAll(Banner banner);
}