package com.example.mapper;

import com.example.entity.Address;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface AddressMapper {
    int insert(Address address);
    int deleteById(Integer id);
    int updateById(Address address);
    List<Address> selectAll(Address address);
    Address selectById(Integer id);

    // 取消该用户下所有的默认地址状态
    void cancelDefault(@Param("userId") Integer userId);
}