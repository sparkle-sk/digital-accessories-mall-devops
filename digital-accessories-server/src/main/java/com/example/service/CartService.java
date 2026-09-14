package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.example.entity.Cart;
import com.example.entity.Goods;
import com.example.entity.GoodsSku;
import com.example.exception.CustomException;
import com.example.mapper.CartMapper;
import com.example.mapper.GoodsMapper;
import com.example.mapper.GoodsSkuMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CartService {
    @Resource
    private CartMapper cartMapper;

    @Resource
    private GoodsMapper goodsMapper;

    @Resource
    private GoodsSkuMapper goodsSkuMapper;

    public void add(Cart cart) {
//        规格为空时设置默认值
        if (cart.getSpec() == null) {
            cart.setSpec("默认规格");
        }
        String currentSpec = cart.getSpec();
        GoodsSku sku = goodsSkuMapper.selectByGoodsIdAndSpec(cart.getGoodsId(), currentSpec);
        int stock = sku != null ? sku.getStock() : 0;
        Cart dbCart = cartMapper.selectByUserIdGoodsIdAndSpec(cart.getUserId(), cart.getGoodsId(), currentSpec);

        if (stock <= 0) {
            if (dbCart != null) {
                throw new CustomException("加购商品已紧急安排补货，敬请关注");
            } else {
                cart.setNum(1);
                cart.setTime(DateUtil.now());
                if (sku != null) {
                    cart.setSkuId(sku.getId());
                }
                cartMapper.insert(cart);
            }
        } else {
            if (dbCart != null) {
                dbCart.setNum(dbCart.getNum() + (cart.getNum() != null ? cart.getNum() : 1));
                dbCart.setTime(DateUtil.now());
                dbCart.setPrice(cart.getPrice());
                dbCart.setImg(cart.getImg());
                if (sku != null) {
                    dbCart.setSkuId(sku.getId());
                }
                cartMapper.updateById(dbCart);
            } else {
                cart.setTime(DateUtil.now());
                if (cart.getNum() == null) cart.setNum(1);
                if (sku != null) {
                    cart.setSkuId(sku.getId());
                }
                cartMapper.insert(cart);
            }
        }
    }

    public List<Cart> selectAll(Cart cart) {
        return cartMapper.selectAll(cart);
    }

    public void updateById(Cart cart) {
        cart.setTime(DateUtil.now());
        cartMapper.updateById(cart);
    }

    public void deleteById(Integer id) {
        cartMapper.deleteById(id);
    }
}