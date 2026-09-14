package com.example.mapper;

import com.example.entity.FileInfo;
import java.util.List;


public interface FileMapper {
    void insert(FileInfo fileInfo);

    List<FileInfo> selectAll(FileInfo fileInfo);

    void deleteById(Integer id);
}