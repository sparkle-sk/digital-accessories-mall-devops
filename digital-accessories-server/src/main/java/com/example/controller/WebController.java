package com.example.controller;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.date.DateUtil;
import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.User;
import com.example.mapper.UserMapper;
import com.example.service.AdminService;
import com.example.service.UserService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

@RestController
public class WebController {

    @Resource
    private AdminService adminService;

    @Resource
    private UserService userService;

    @Resource
    private UserMapper userMapper;

    @GetMapping("/")
    public Result hello() {
        return Result.success();
    }

//     登录
    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        if (ObjectUtil.isEmpty(account.getUsername()) || ObjectUtil.isEmpty(account.getPassword())
                || ObjectUtil.isEmpty(account.getRole())) {
            return Result.error("参数错误");
        }

        if ("ADMIN".equals(account.getRole())) {
            return Result.success(adminService.login(account));
        } else if ("USER".equals(account.getRole())) {
            User user = userService.login(account);

            if (user != null && Integer.valueOf(0).equals(user.getStatus())) {
                return Result.error("您的账号已被管理员禁用，请联系管理员");
            }

            return Result.success(user);
        }
        return Result.error("非法角色");
    }

//    注册
    @PostMapping("/register")
    public Result register(@RequestBody User user) {
        if (user.getUsername() == null || user.getPassword() == null) {
            return Result.error("账号密码不能为空");
        }
        User dbUser = userMapper.selectByUsername(user.getUsername());
        if (dbUser != null) {
            return Result.error("账号已存在，请换一个试试");
        }
        user.setRole("USER");
        user.setStatus(1);
        userMapper.insert(user);
        return Result.success();
    }

//     修改密码
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Account account) {
        if ("ADMIN".equals(account.getRole())) {
            adminService.updatePassword(account);
        }
        return Result.success();
    }
}