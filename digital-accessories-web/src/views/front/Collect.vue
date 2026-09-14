<template>
  <div class="main-content" style="width: 85%; margin: 20px auto">
    <div class="card" style="padding: 20px">
      <div
        style="
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 25px;
        "
      >
        <div class="collect-title" style="margin-bottom: 0">
          我的收藏
          <span class="collect-count">({{ data.tableData.length }})</span>
        </div>

        <div style="display: flex; align-items: center; gap: 10px">
          <el-input
            v-model="data.inputKeyword"
            placeholder="请输入商品名称"
            style="width: 260px"
            clearable
            @keyup.enter="handleSearch"
            @clear="handleSearch"
            class="custom-input"
          >
            <template #append>
              <el-button class="custom-search-btn" @click="handleSearch">
                搜索
              </el-button>
            </template>
          </el-input>

          <el-button
            class="custom-reset-btn"
            @click="handleReset"
            plain
            style="width: 70px"
          >
            重置
          </el-button>
        </div>
      </div>

      <el-table
        :data="data.tableData"
        stripe
        :header-cell-style="{
          background: '#f5f7fa',
          color: '#666',
          fontWeight: 'bold',
        }"
      >
        <el-table-column label="商品信息" width="480">
          <template #default="scope">
            <div class="jd-collect-item">
              <div class="store-row">
                <el-icon><Shop /></el-icon>
                <span class="store-name">{{
                  scope.row.storeName || "数码配件官方直营"
                }}</span>
              </div>

              <div class="product-row">
                <el-popover placement="right" :width="300" trigger="hover">
                  <template #reference>
                    <img
                      :src="scope.row.goodsImg"
                      class="product-img"
                      @click="goDetail(scope.row.goodsId)"
                    />
                  </template>
                  <img
                    :src="scope.row.goodsImg"
                    style="width: 100%; border-radius: 8px"
                  />
                </el-popover>

                <div class="product-info">
                  <div
                    class="product-name"
                    @click="goDetail(scope.row.goodsId)"
                  >
                    {{ scope.row.goodsName }}
                  </div>

                  <div class="spec-display" v-if="scope.row.spec">
                    <span class="label">当前规格：</span>
                    <el-tag size="small" type="danger" effect="plain">{{
                      scope.row.spec
                    }}</el-tag>
                  </div>

                  <div class="tag-row">
                    <el-tag
                      size="small"
                      type="info"
                      effect="plain"
                      style="font-size: 10px"
                      >收藏人气商品</el-tag
                    >
                  </div>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="收藏价格" width="150" align="center">
          <template #default="scope">
            <span class="price-text">￥{{ scope.row.goodsPrice }}</span>
          </template>
        </el-table-column>

        <el-table-column
          prop="time"
          label="收藏时间"
          width="180"
          align="center"
        />

        <el-table-column label="操作选项" align="center">
          <template #default="scope">
            <div
              style="
                display: flex;
                flex-direction: column;
                gap: 8px;
                align-items: center;
              "
            >
              <el-button
                type="warning"
                size="small"
                @click="addCart(scope.row)"
                style="width: 110px"
              >
                <el-icon><ShoppingCart /></el-icon> 加入购物车
              </el-button>

              <el-button
                type="danger"
                size="small"
                link
                @click="del(scope.row.id)"
              >
                <el-icon><Delete /></el-icon> 移除收藏
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted, onBeforeUnmount } from "vue";
import request from "@/utils/request";
import router from "@/router";
import { ElMessage } from "element-plus";
import { ShoppingCart, Delete, Shop } from "@element-plus/icons-vue";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  tableData: [],
  inputKeyword: "",
  searchKeyword: "",
});

const handleSearch = () => {
  data.searchKeyword = data.inputKeyword;
  load();
};

const handleReset = () => {
  data.inputKeyword = "";
  data.searchKeyword = "";
  load();
};

onBeforeUnmount(() => {
  data.inputKeyword = "";
  data.searchKeyword = "";
});

const load = () => {
  request
    .get("/collect/selectAll", {
      params: {
        userId: data.user.id,
        goodsName: data.searchKeyword,
      },
    })
    .then((res) => {
      if (res.code === "200") data.tableData = res.data || [];
    });
};

const goDetail = (id) => {
  router.push("/front/detail?id=" + id);
};
// 收藏商品加入购物车
const addCart = (row) => {
  const cartData = {
    goodsId: row.goodsId,
    num: 1,
    userId: data.user.id,
    spec: row.spec,
    price: row.goodsPrice,
    img: row.goodsImg,
  };
  request.post("/cart/add", cartData).then((res) => {
    if (res.code === "200") ElMessage.success("已成功移入购物车");
  });
};

const del = (id) => {
  request.delete("/collect/delete/" + id).then((res) => {
    if (res.code === "200") {
      ElMessage.success("移除成功");
      load();
    }
  });
};

onMounted(() => {
  load();
});
</script>

<style scoped>
.collect-title {
  font-size: 22px;
  font-weight: bold;
  margin-bottom: 25px;
  color: #333;
}
.collect-count {
  font-size: 14px;
  color: #999;
  margin-left: 8px;
}

.custom-input :deep(.el-input__wrapper) {
  border-radius: 20px 0 0 20px !important;
  box-shadow: 0 0 0 1px #e5e5e5 inset !important;
}

.custom-input :deep(.el-input-group__append) {
  border-radius: 0 20px 20px 0 !important;
  padding: 0 !important;
  width: 80px !important;
  background-color: #f5f5f5 !important;
  border: none !important;
  box-shadow: 0 0 0 1px #e5e5e5 inset !important;
  overflow: hidden;
}

.custom-search-btn {
  width: 100% !important;
  height: 100% !important;
  margin: 0 !important;
  padding: 0 !important;
  background-color: transparent !important;
  color: #606266 !important;
  font-weight: bold !important;
  border: none !important;
}

.custom-search-btn:hover {
  background-color: #eeeeee !important;
}

.custom-reset-btn {
  border-radius: 20px !important;
  border-color: #e5e5e5 !important;
  color: #606266 !important;
  width: 80px;
}

.jd-collect-item {
  padding: 10px 0;
}
.store-row {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  color: #666;
  font-size: 13px;
}
.store-name {
  margin-left: 6px;
  font-weight: bold;
  color: #333;
}
.product-row {
  display: flex;
  gap: 20px;
}
.product-img {
  width: 90px;
  height: 90px;
  border-radius: 8px;
  border: 1px solid #eee;
  cursor: pointer;
  object-fit: cover;
}
.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.product-name {
  font-size: 15px;
  color: #333;
  font-weight: 500;
  cursor: pointer;
}
.product-name:hover {
  color: #ff4d4f;
}
.spec-display {
  font-size: 12px;
  color: #999;
  background: #f8f8f8;
  padding: 4px 8px;
  border-radius: 4px;
  display: inline-block;
}
.price-text {
  color: #ff4d4f;
  font-weight: bold;
  font-size: 18px;
}
</style>
