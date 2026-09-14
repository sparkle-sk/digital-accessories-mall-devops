package com.example.mapper;

import com.example.entity.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserMapper {

    int insert(User user);
    User selectByUsername(String username);
    User selectById(Integer id);
    void updateById(User user);
    List<User> selectAll(@Param("username") String username, @Param("name") String name);
}