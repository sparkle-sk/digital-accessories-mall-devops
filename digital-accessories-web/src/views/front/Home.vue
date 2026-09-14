<template>
  <div class="main-content">
    <el-carousel
      height="400px"
      style="
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      "
    >
      <el-carousel-item v-for="item in data.bannerList" :key="item.id">
        <img
          :src="item.img"
          @click="item.goodsId ? goDetail(item.goodsId) : null"
          style="
            width: 100%;
            height: 100%;
            object-fit: contain;
            background-color: #f5f5f5;
            cursor: pointer;
          "
          :title="item.goodsId ? '点击查看商品详情' : item.title"
          lazy
        />
      </el-carousel-item>
    </el-carousel>

    <div id="goods-list" style="margin-top: 30px">
      <div class="card filter-container">
        <div class="filter-item">
          <span class="filter-label">分类浏览：</span>
          <el-radio-group v-model="data.categoryId" @change="loadGoods()">
            <el-radio-button :label="null">全部</el-radio-button>
            <el-radio-button :label="1">耳机</el-radio-button>
            <el-radio-button :label="2">充电器</el-radio-button>
            <el-radio-button :label="4">数据线</el-radio-button>
            <el-radio-button :label="5">智能穿戴</el-radio-button>
            <el-radio-button :label="6">存储设备</el-radio-button>
            <el-radio-button :label="7">电脑外设</el-radio-button>
            <el-radio-button :label="8">音箱设备</el-radio-button>
            <el-radio-button :label="9">保护配件</el-radio-button>
          </el-radio-group>
        </div>

        <div class="filter-item" style="margin-top: 20px">
          <span class="filter-label">品牌筛选：</span>
          <el-radio-group
            v-model="data.brand"
            @change="loadGoods()"
            size="small"
          >
            <el-radio label="">全部品牌</el-radio>
            <el-radio label="华为">华为</el-radio>
            <el-radio label="小米">小米</el-radio>
            <el-radio label="Apple">苹果(Apple)</el-radio>
            <el-radio label="罗技">罗技</el-radio>
            <el-radio label="雷蛇(Razer)">雷蛇(Razer)</el-radio>
            <el-radio label="索尼">索尼</el-radio>
            <el-radio label="倍思">倍思</el-radio>
            <el-radio label="绿联">绿联</el-radio>
            <el-radio label="oppo">oppo</el-radio>
            <el-radio label="闪迪">闪迪</el-radio>
            <el-radio label="JBL">JBL</el-radio>
          </el-radio-group>
        </div>
      </div>

      <div style="display: flex; align-items: center; margin: 25px 0">
        <span style="font-size: 24px; font-weight: bold; color: #333">
          {{
            route.query.name ? "搜索结果：" + route.query.name : "精选数码配件"
          }}
        </span>
        <el-tag type="danger" style="margin-left: 15px" effect="dark"
          >品质精选</el-tag
        >
      </div>

      <el-row :gutter="15">
        <el-col
          :span="4"
          v-for="item in data.goodsList"
          :key="item.id"
          style="margin-bottom: 20px"
        >
          <div class="goods-card" @click="goDetail(item.id)">
            <img :src="item.img" class="goods-img" />
            <div class="goods-info">
              <div class="goods-name">{{ item.name }}</div>
              <div class="goods-desc">{{ item.description }}</div>
              <div class="goods-bottom">
                <span class="price">￥{{ item.price }}</span>
                <el-button
                  type="primary"
                  size="small"
                  circle
                  icon="ShoppingCartFull"
                ></el-button>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>

      <el-empty
        v-if="data.goodsList.length === 0"
        description="没有找到相关的配件，换个筛选条件试试吧~"
      />
    </div>
  </div>
</template>

<script setup>
import { reactive, watch, nextTick } from "vue";
import { useRoute } from "vue-router";
import request from "@/utils/request";
import router from "@/router";
import { ShoppingCartFull } from "@element-plus/icons-vue";

const route = useRoute();
const data = reactive({
  goodsList: [],
  bannerList: [],
  categoryId: null,
  brand: "",
});

// 获取商品列表
const loadGoods = () => {
  request
    .get("/goods/selectPage", {
      params: {
        pageNum: 1,
        pageSize: 24,
        name: route.query.name,
        categoryId: data.categoryId,
        brand: data.brand,
      },
    })
    .then((res) => {
      data.goodsList = res.data?.list || [];
      if (route.query.name) {
        nextTick(() => {
          const el = document.getElementById("goods-list");
          if (el) el.scrollIntoView({ behavior: "smooth" });
        });
      }
    });
};

// 加载轮播图
const loadBanners = () => {
  request.get("/banner/selectPage", { params: { pageSize: 5 } }).then((res) => {
    data.bannerList = res.data?.list || [];
  });
};

// 跳转商品详情
const goDetail = (id) => {
  if (!id) return;
  router.push("/front/detail?id=" + id);
};

// 搜索内容改变时重新加载商品
watch(
  () => route.query.name,
  () => {
    loadGoods();
  },
  { immediate: true },
);

loadBanners();
</script>

<style scoped>
.main-content {
  width: 95%;
  margin: 0 auto;
}

.filter-container {
  padding: 25px;
  background-color: #fff;
  border-radius: 12px;
  border: 1px solid #ebeef5;
}
.filter-item {
  display: flex;
  align-items: center;
}
.filter-label {
  width: 90px;
  font-weight: bold;
  color: #606266;
  font-size: 14px;
}

.goods-card {
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #f0f0f0;
}
.goods-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}
.goods-img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}
.goods-info {
  padding: 12px;
}
.goods-name {
  font-size: 14px;
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.goods-desc {
  font-size: 12px;
  color: #999;
  height: 32px;
  line-height: 16px;
  margin-bottom: 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.goods-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.price {
  font-size: 16px;
  color: #ff4d4f;
  font-weight: bold;
}
</style>
