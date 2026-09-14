package com.example.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.Result;
import com.example.entity.Admin;
import com.example.service.AdminService;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Resource
    private AdminService adminService;

    @PostMapping("/add")
    public Result add(@RequestBody Admin admin) {
        adminService.add(admin);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        adminService.deleteById(id);
        return Result.success();
    }


//     修改管理员信息
    @PutMapping("/update")
    public Result updateById(@RequestBody Admin admin) {
        Admin dbAdmin = adminService.selectById(admin.getId());
        if (dbAdmin == null) return Result.error("管理员不存在");

        boolean needLogout = false;

        if (!ObjectUtil.equal(dbAdmin.getUsername(), admin.getUsername())) {

            Admin search = new Admin();
            search.setUsername(admin.getUsername());
            List<Admin> allAdmins = adminService.selectAll(search);
            if (ObjectUtil.isNotEmpty(allAdmins) && !allAdmins.get(0).getId().equals(admin.getId())) {
                return Result.error("该账号名已被占用");
            }

            String today = DateUtil.today();
            Integer count = dbAdmin.getUsernameUpdateCount() == null ? 0 : dbAdmin.getUsernameUpdateCount();
            if (today.equals(dbAdmin.getLastUpdateDate())) {
                if (count >= 1) {
                    return Result.error("管理员账号一天内最多只能修改1次");
                }
                admin.setUsernameUpdateCount(count + 1);
            } else {
                admin.setUsernameUpdateCount(1);
            }
            admin.setLastUpdateDate(today);
            needLogout = true;
        } else {
            admin.setUsernameUpdateCount(dbAdmin.getUsernameUpdateCount());
            admin.setLastUpdateDate(dbAdmin.getLastUpdateDate());
        }

        adminService.updateById(admin);

        if (needLogout) return Result.success("LOGOUT");
        return Result.success();
    }

//     修改密码
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Map<String, Object> params) {
        Integer id = Integer.parseInt(params.get("id").toString());
        String oldPassword = params.get("oldPassword").toString();
        String newPassword = params.get("newPassword").toString();

        Admin admin = adminService.selectById(id);
        if (admin == null || !admin.getPassword().equals(oldPassword)) {
            return Result.error("原密码输入错误");
        }
        admin.setPassword(newPassword);
        adminService.updateById(admin);
        return Result.success("LOGOUT");
    }

    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        return Result.success(adminService.selectById(id));
    }

    @GetMapping("/selectAll")
    public Result selectAll(Admin admin) {
        return Result.success(adminService.selectAll(admin));
    }

    @GetMapping("/selectPage")
    public Result selectPage(Admin admin, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(adminService.selectPage(admin, pageNum, pageSize));
    }
}