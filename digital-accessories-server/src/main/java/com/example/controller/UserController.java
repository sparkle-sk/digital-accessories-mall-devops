package com.example.controller;

import cn.hutool.core.date.DateUtil;
import com.example.common.Result;
import com.example.entity.User;
import com.example.service.UserService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/user")
public class UserController {
    @Resource
    private UserService userService;

//     管理员端：分页查询普通用户列表
    @GetMapping("/selectPage")
    public Result selectPage(@RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize,
                             @RequestParam(required = false) String username,
                             @RequestParam(required = false) String name) {
        return Result.success(userService.selectPage(pageNum, pageSize, username, name));
    }

//     管理员端：修改用户状态（启用/禁用）
    @PutMapping("/updateStatus")
    public Result updateStatus(@RequestBody User user) {
        User dbUser = userService.selectById(user.getId());
        if (dbUser == null) {
            return Result.error("用户不存在");
        }
        dbUser.setStatus(user.getStatus());
        userService.updateById(dbUser);
        return Result.success();
    }

//     用户端：修改个人资料
    @PutMapping("/update")
    public Result update(@RequestBody User user) {
        User dbUser = userService.selectById(user.getId());
        if (dbUser == null) {
            return Result.error("用户不存在");
        }

        boolean usernameChanged = false;
        String today = DateUtil.today();

        // 用户名修改校验
        if (!dbUser.getUsername().equals(user.getUsername())) {
            if (today.equals(dbUser.getLastUpdateDate())) {
                Integer count = dbUser.getUsernameUpdateCount() == null ? 0 : dbUser.getUsernameUpdateCount();
                if (count >= 1) {
                    return Result.error("账号名每天最多只能修改1次哦！");
                }
                dbUser.setUsernameUpdateCount(count + 1);
            } else {
                dbUser.setUsernameUpdateCount(1);
            }
            dbUser.setLastUpdateDate(today);
            User checkUser = userService.selectByUsername(user.getUsername());
            if (checkUser != null && !checkUser.getId().equals(user.getId())) {
                return Result.error("该账号名已被占用");
            }

            dbUser.setUsername(user.getUsername());
            usernameChanged = true;
        }

        dbUser.setName(user.getName());
        dbUser.setAvatar(user.getAvatar());
        dbUser.setSex(user.getSex());
        dbUser.setBirthday(user.getBirthday());

        userService.updateById(dbUser);

        if (usernameChanged) {
            return Result.success("USER_CHANGED");
        }
        return Result.success();
    }

//      修改密码
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Map<String, String> params) {
        Integer id = Integer.parseInt(params.get("id").toString());
        String oldPassword = (String) params.get("oldPassword");
        String newPassword = (String) params.get("newPassword");

        User user = userService.selectById(id);
        if (!user.getPassword().equals(oldPassword)) {
            return Result.error("原密码输入错误");
        }

        user.setPassword(newPassword);
        userService.updateById(user);
        return Result.success();
    }
}