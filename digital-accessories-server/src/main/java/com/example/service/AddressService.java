package com.example.service;

import com.example.entity.Address;
import com.example.mapper.AddressMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class AddressService {
    @Resource
    private AddressMapper addressMapper;

    @Transactional
    public void add(Address address) {
        // 新增时如果设为默认，先清除该用户所有默认状态
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            addressMapper.cancelDefault(address.getUserId());
        }
        addressMapper.insert(address);
    }

    public void deleteById(Integer id) {
        addressMapper.deleteById(id);
    }

    @Transactional
    public void updateById(Address address) {
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            Integer userId = address.getUserId();
            if (userId == null && address.getId() != null) {
                Address dbAddress = addressMapper.selectById(address.getId());
                if (dbAddress != null) {
                    userId = dbAddress.getUserId();
                    address.setUserId(userId);
                }
            }

            if (userId != null) {
                addressMapper.cancelDefault(userId);
            }
        }

        addressMapper.updateById(address);
    }

    public List<Address> selectAll(Address address) {
        return addressMapper.selectAll(address);
    }
}