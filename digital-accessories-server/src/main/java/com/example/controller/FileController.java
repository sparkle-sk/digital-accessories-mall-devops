package com.example.controller;

import cn.hutool.core.io.FileUtil;
import com.example.common.Result;
import com.example.entity.FileInfo;
import com.example.mapper.FileMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/files")
public class FileController {

    private static final String filePath = System.getProperty("user.dir") + "/files/";

    @Value("${fileBaseUrl}")
    private String fileBaseUrl;

    @Value("${server.port}")
    private String port;

    @Resource
    private FileMapper fileMapper;

//     文件上传
    @PostMapping("/upload")
    public Result upload(MultipartFile file, @RequestParam(required = false) String type) {
        String originalFilename = file.getOriginalFilename();
        String fileName = System.currentTimeMillis() + "-" + originalFilename;
        String realFilePath = filePath + fileName;
        try {
            if (!FileUtil.isDirectory(filePath)) {
                FileUtil.mkdir(filePath);
            }
            FileUtil.writeBytes(file.getBytes(), realFilePath);
        } catch (IOException e) {
            return Result.error("文件上传错误");
        }

        String url = fileBaseUrl + ":" + port + "/files/download/" + fileName;

        // 手动上传时保存文件信息
        if ("manual".equals(type)) {
            FileInfo fileInfo = new FileInfo();
            fileInfo.setName(originalFilename);
            fileInfo.setUrl(url);
            fileMapper.insert(fileInfo);
        }

        return Result.success(url);
    }

//     分页查询文件
    @GetMapping("/selectPage")
    public Result selectPage(FileInfo fileInfo,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<FileInfo> list = fileMapper.selectAll(fileInfo);
        return Result.success(PageInfo.of(list));
    }

//     删除文件
    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        fileMapper.deleteById(id);
        return Result.success();
    }

//      文件下载
    @GetMapping("/download/{fileName}")
    public void download(@PathVariable String fileName, HttpServletResponse response) {
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, StandardCharsets.UTF_8));
        String realFilePath = filePath + fileName;
        try {
            byte[] bytes = FileUtil.readBytes(realFilePath);
            ServletOutputStream os = response.getOutputStream();
            os.write(bytes);
            os.flush();
            os.close();
        } catch (IOException e) {
            System.out.println("文件下载错误");
        }
    }
}