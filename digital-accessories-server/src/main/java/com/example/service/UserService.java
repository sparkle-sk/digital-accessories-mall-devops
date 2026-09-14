package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.entity.Account;
import com.example.entity.User;
import com.example.mapper.UserMapper;
import com.example.exception.CustomException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Resource
    private UserMapper userMapper;

    public PageInfo<User> selectPage(Integer pageNum, Integer pageSize, String username, String name) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> list = userMapper.selectAll(username, name);
        return PageInfo.of(list);
    }

    public User selectById(Integer id) {
        return userMapper.selectById(id);
    }
    public User selectByUsername(String username) {
        return userMapper.selectByUsername(username);
    }
    public User login(Account account) {
        User dbUser = userMapper.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbUser)) {
            throw new CustomException("账号不存在");
        }
        if (!account.getPassword().equals(dbUser.getPassword())) {
            throw new CustomException("账号或密码错误");
        }
        return dbUser;
    }

    public void add(User user) {
        User dbUser = userMapper.selectByUsername(user.getUsername());
        if (ObjectUtil.isNotNull(dbUser)) {
            throw new CustomException("账号已存在");
        }
        userMapper.insert(user);
    }

    public void updateById(User user) {
        userMapper.updateById(user);
    }
}