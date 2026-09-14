package com.example.entity;

import java.math.BigDecimal;
import java.util.List;

public class Goods {
    private Integer id;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stock;
    private Integer sales;
    private String img;
    private Integer categoryId;
    private String categoryName;
    private String store;
    private String brand;
    private String content;
    private String specList;

    private List<GoodsSku> skuList;
    private List<GoodsSku> lowStockSkus;

    public List<GoodsSku> getSkuList() { return skuList; }
    public void setSkuList(List<GoodsSku> skuList) { this.skuList = skuList; }

    public List<GoodsSku> getLowStockSkus() { return lowStockSkus; }
    public void setLowStockSkus(List<GoodsSku> lowStockSkus) { this.lowStockSkus = lowStockSkus; }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public Integer getSales() { return sales; }
    public void setSales(Integer sales) { this.sales = sales; }
    public String getImg() { return img; }
    public void setImg(String img) { this.img = img; }
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getStore() { return store; }
    public void setStore(String store) { this.store = store; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getSpecList() { return specList; }
    public void setSpecList(String specList) { this.specList = specList; }
}