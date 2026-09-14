package com.example.controller;

import com.example.common.Result;
import com.example.entity.Address;
import com.example.service.AddressService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/address")
public class AddressController {
    @Resource
    private AddressService addressService;

    @PostMapping("/add")
    public Result add(@RequestBody Address address) {
        addressService.add(address);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        addressService.deleteById(id);
        return Result.success();
    }

    @PutMapping("/update")
    public Result update(@RequestBody Address address) {
        addressService.updateById(address);
        return Result.success();
    }

    @GetMapping("/selectAll")
    public Result selectAll(Address address) {
        List<Address> list = addressService.selectAll(address);
        return Result.success(list);
    }
}