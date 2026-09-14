package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.entity.Account;
import com.example.entity.Admin;
import com.example.exception.CustomException;
import com.example.mapper.AdminMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {

    @Resource
    private AdminMapper adminMapper;

    public void add(Admin admin) {
        Admin dbAdmin = adminMapper.selectByUsername(admin.getUsername());
        if (ObjectUtil.isNotNull(dbAdmin)) {
            throw new CustomException("账号已存在");
        }

        Admin dbAdmin2 = adminMapper.selectByName(admin.getName());
        if (ObjectUtil.isNotNull(dbAdmin2)) {
            throw new CustomException("该姓名已被占用，请换一个");
        }

        if (ObjectUtil.isEmpty(admin.getPassword())) {
            admin.setPassword("admin");
        }
        if (ObjectUtil.isEmpty(admin.getName())) {
            admin.setName(admin.getUsername());
        }
        admin.setRole("ADMIN");
        adminMapper.insert(admin);
    }

    public void deleteById(Integer id) {
        adminMapper.deleteById(id);
    }

    public void updateById(Admin admin) {
        Admin dbAdmin = adminMapper.selectByName(admin.getName());
        if (ObjectUtil.isNotNull(dbAdmin) && !dbAdmin.getId().equals(admin.getId())) {
            throw new CustomException("该姓名已被占用，请换一个");
        }
        adminMapper.updateById(admin);
    }

    public Admin selectById(Integer id) {
        return adminMapper.selectById(id);
    }

    public List<Admin> selectAll(Admin admin) {
        return adminMapper.selectAll(admin);
    }

    public PageInfo<Admin> selectPage(Admin admin, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Admin> list = adminMapper.selectAll(admin);
        return PageInfo.of(list);
    }

    public Account login(Account account) {
        Account dbAdmin = adminMapper.selectByUsername(account.getUsername());

        if (ObjectUtil.isNull(dbAdmin)) {
            throw new CustomException("账号不存在");
        }

        if (!dbAdmin.getUsername().equals(account.getUsername())) {
            throw new CustomException("账号不存在");
        }

        if (!account.getPassword().equals(dbAdmin.getPassword())) {
            throw new CustomException("账号或密码错误");
        }

        return dbAdmin;
    }

    public void updatePassword(Account account) {
        Admin dbAdmin = adminMapper.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbAdmin)) {
            throw new CustomException("账号不存在");
        }
        if (!account.getPassword().equals(dbAdmin.getPassword())) {
            throw new CustomException("原密码错误");
        }
        dbAdmin.setPassword(account.getNewPassword());
        adminMapper.updateById(dbAdmin);
    }

}