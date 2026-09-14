package com.example.mapper;

import com.example.entity.Category;
import java.util.List;

// 分类数据操作接口
public interface CategoryMapper {

    int insert(Category category);
    int deleteById(Integer id);
    int updateById(Category category);
    Category selectById(Integer id);
    List<Category> selectAll(Category category);

}