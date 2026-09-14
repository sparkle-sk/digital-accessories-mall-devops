package com.example.mapper;

import com.example.entity.Admin;
import java.util.List;

// 管理员数据操作接口
public interface AdminMapper {

    int insert(Admin admin);
    int deleteById(Integer id);
    int updateById(Admin admin);
    Admin selectById(Integer id);
    Admin selectByName(String name);
    List<Admin> selectAll(Admin admin);
    Admin selectByUsername(String username);

}