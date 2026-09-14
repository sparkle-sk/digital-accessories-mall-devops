<template>
  <div class="main-content" style="width: 85%; margin: 20px auto">
    <div class="card" style="padding: 20px">
      <div class="cart-title">
        我的购物车 <span class="cart-count">({{ data.cartList.length }})</span>
      </div>

      <el-table
        :data="data.cartList"
        @selection-change="handleSelectionChange"
        stripe
        :header-cell-style="{
          background: '#f5f7fa',
          color: '#666',
          fontWeight: 'bold',
        }"
      >
        <el-table-column
          type="selection"
          :selectable="(row) => row.stock > 0"
          width="55"
          align="center"
        />

        <el-table-column label="商品信息" width="450">
          <template #default="scope">
            <div class="jd-item-container">
              <div class="store-box">
                <el-icon><Shop /></el-icon>
                <span class="store-name">{{
                  scope.row.storeName || "数码优选自营"
                }}</span>
                <el-tag
                  v-if="scope.row.stock <= 0"
                  size="small"
                  type="info"
                  style="margin-left: 10px"
                  >无货</el-tag
                >
              </div>

              <div
                class="product-box"
                :style="{ opacity: scope.row.stock <= 0 ? 0.5 : 1 }"
              >
                <el-popover
                  placement="right"
                  :width="300"
                  trigger="hover"
                  popper-style="padding: 0; border: 1px solid #eee; border-radius: 8px; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.15);"
                >
                  <template #reference>
                    <img
                      :src="scope.row.goodsImg"
                      class="product-img"
                      @click="goDetail(scope.row.goodsId)"
                    />
                  </template>
                  <img
                    :src="scope.row.goodsImg"
                    style="width: 100%; display: block"
                  />
                </el-popover>

                <div class="product-info">
                  <el-tooltip
                    effect="dark"
                    :content="scope.row.goodsName"
                    placement="top-start"
                  >
                    <div
                      class="product-name"
                      @click="goDetail(scope.row.goodsId)"
                    >
                      {{ scope.row.goodsName }}
                    </div>
                  </el-tooltip>
                  <div class="product-spec" v-if="scope.row.spec">
                    <span class="spec-label">规格：</span>
                    <span class="spec-value">{{ scope.row.spec }}</span>
                  </div>
                  <div class="service-tags">
                    <span class="price-guard">7天价保</span>
                    <span class="shipping-tag">极速退款</span>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="单价" width="120" align="center">
          <template #default="scope">
            <span class="unit-price">￥{{ scope.row.goodsPrice }}</span>
          </template>
        </el-table-column>

        <el-table-column label="数量" width="160" align="center">
          <template #default="scope">
            <el-input-number
              v-model="scope.row.num"
              :min="1"
              :disabled="scope.row.stock <= 0"
              size="small"
              @change="updateNum(scope.row)"
            />
          </template>
        </el-table-column>

        <el-table-column label="小计" width="120" align="center">
          <template #default="scope">
            <span class="sub-total">
              ￥{{ (scope.row.num * scope.row.goodsPrice).toFixed(2) }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="100" align="center">
          <template #default="scope">
            <el-button
              type="danger"
              size="small"
              link
              @click="del(scope.row.id)"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>

      <div class="settle-bar">
        <div class="settle-left">
          已选
          <span class="highlight">{{ data.selectedList.length }}</span> 件商品
        </div>
        <div class="settle-right">
          总价（不含运费）：<span class="total-price">￥{{ totalPrice }}</span>
          <el-button
            type="danger"
            size="large"
            class="submit-btn"
            @click="submitOrder"
          >
            去结算
          </el-button>
        </div>
      </div>
    </div>

    <el-dialog
      v-model="data.buyNowVisible"
      title="确认结算信息"
      width="650px"
      destroy-on-close
    >
      <div style="padding: 0 10px">
        <div class="order-section-title">
          1. 商品清单 (共 {{ data.selectedList.length }} 件)
        </div>
        <div class="order-goods-list">
          <div
            v-for="item in data.selectedList"
            :key="item.id"
            class="order-goods-item"
          >
            <img :src="item.goodsImg" class="order-goods-img" />
            <div style="flex: 1; margin-left: 15px">
              <div class="goods-name-limit">{{ item.goodsName }}</div>
              <div style="margin-top: 5px; color: #999; font-size: 12px">
                规格：{{ item.spec || "默认" }}
              </div>
            </div>
            <div style="text-align: right">
              <div style="color: #ff4d4f; font-weight: bold">
                ￥{{ item.goodsPrice }}
              </div>
              <div style="color: #999; font-size: 12px">x {{ item.num }}</div>
            </div>
          </div>
        </div>

        <div
          class="order-section-title"
          style="
            margin-top: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
          "
        >
          <span>2. 收货地址确认</span>
          <div style="font-weight: normal; font-size: 13px">
            <el-link
              type="primary"
              :underline="false"
              @click="data.showAllAddress = !data.showAllAddress"
              style="margin-right: 15px"
            >
              <el-icon style="margin-right: 3px">
                <RefreshRight v-if="!data.showAllAddress" />
                <ArrowUp v-else />
              </el-icon>
              {{ data.showAllAddress ? "收起地址" : "切换其他地址" }}
            </el-link>
            <el-link
              type="primary"
              :underline="false"
              @click="router.push('/front/address')"
              >管理地址</el-link
            >
          </div>
        </div>

        <div
          class="address-select-box"
          :style="{ maxHeight: data.showAllAddress ? '300px' : 'auto' }"
        >
          <el-radio-group v-model="data.selectedAddressId" style="width: 100%">
            <div
              v-for="item in data.addressList"
              :key="item.id"
              class="address-card"
              v-show="data.showAllAddress || data.selectedAddressId === item.id"
              :class="{ active: data.selectedAddressId === item.id }"
            >
              <el-radio :label="item.id" size="large">
                <div class="address-content">
                  <div class="address-user">
                    <span class="name">{{ item.name }}</span>
                    <span class="phone">{{ item.phone }}</span>
                    <el-tag
                      size="small"
                      type="danger"
                      v-if="item.isDefault === 1"
                      style="margin-left: 10px"
                      >默认</el-tag
                    >
                  </div>
                  <div class="address-detail">{{ item.address }}</div>
                </div>
              </el-radio>
            </div>
          </el-radio-group>
        </div>
      </div>
      <template #footer>
        <div class="order-footer">
          <div class="total-price-display">
            实付款：<span class="price-num">￥{{ totalPrice }}</span>
          </div>
          <div class="btns">
            <el-button @click="data.buyNowVisible = false">返回修改</el-button>
            <el-button
              type="danger"
              size="large"
              style="width: 150px"
              @click="confirmOrder"
              >提交订单</el-button
            >
          </div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, computed, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { Shop, RefreshRight, ArrowUp } from "@element-plus/icons-vue";
import router from "@/router";

const data = reactive({
  cartList: [],
  selectedList: [],
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  buyNowVisible: false,
  addressList: [],
  selectedAddressId: null,
  showAllAddress: false,
});

const totalPrice = computed(() => {
  return data.selectedList
    .reduce((acc, item) => acc + item.num * item.goodsPrice, 0)
    .toFixed(2);
});

const loadCart = () => {
  request
    .get("/cart/selectAll", { params: { userId: data.user.id } })
    .then((res) => {
      data.cartList = res.data || [];
    });
};

const goDetail = (id) => {
  router.push("/front/detail?id=" + id);
};

const handleSelectionChange = (rows) => {
  data.selectedList = rows;
};

const updateNum = (row) => {
  request.put("/cart/update", row).then((res) => {
    if (res.code !== "200") ElMessage.error(res.msg);
  });
};

const del = (id) => {
  ElMessageBox.confirm("确定要删除这件商品吗？", "提示", {
    type: "warning",
  }).then(() => {
    request.delete("/cart/delete/" + id).then((res) => {
      if (res.code === "200") {
        ElMessage.success("已成功移除");
        loadCart();
      }
    });
  });
};

// 提交订单
const submitOrder = () => {
  if (!data.selectedList.length) {
    ElMessage.warning("请选择商品后再结算");
    return;
  }

  // 获取收货地址
  request
    .get("/address/selectAll", { params: { userId: data.user.id } })
    .then((res) => {
      data.addressList = res.data || [];
      if (data.addressList.length === 0) {
        ElMessageBox.confirm("您还没有收货地址，请先添加后再结算", "系统提示", {
          confirmButtonText: "去添加",
          cancelButtonText: "取消",
          type: "warning",
        }).then(() => {
          router.push("/front/address");
        });
      } else {
        data.showAllAddress = false;
        // 默认选中地址
        const def = data.addressList.find((v) => v.isDefault === 1);
        if (def) data.selectedAddressId = def.id;
        else data.selectedAddressId = data.addressList[0].id;

        data.buyNowVisible = true;
      }
    });
};

// 确认订单
const confirmOrder = () => {
  if (!data.selectedAddressId) {
    ElMessage.warning("请选择收货地址");
    return;
  }

  const activeAddr = data.addressList.find(
    (v) => v.id === data.selectedAddressId,
  );
  const addressSnapshot = `${activeAddr.name} | ${activeAddr.phone} | ${activeAddr.address}`;

  let orderData = {
    userId: data.user.id,
    totalPrice: totalPrice.value,
    address: addressSnapshot,
    cartList: data.selectedList,
  };

  request.post("/orders/add", orderData).then((res) => {
    if (res.code === "200") {
      ElMessage.success("下单成功！");
      data.buyNowVisible = false;
      router.push("/front/orders");
    } else {
      ElMessage.error(res.msg || "下单异常");
    }
  });
};

onMounted(() => {
  loadCart();
});
</script>

<style scoped>
.cart-title {
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 25px;
  color: #333;
}
.cart-count {
  font-size: 14px;
  color: #999;
  font-weight: normal;
}
.jd-item-container {
  padding: 10px 0;
}
.store-box {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  color: #666;
  font-size: 13px;
}
.store-name {
  margin-left: 5px;
  font-weight: bold;
  color: #333;
}
.product-box {
  display: flex;
  gap: 15px;
}
.product-img {
  width: 80px;
  height: 80px;
  border-radius: 4px;
  border: 1px solid #f0f0f0;
  cursor: pointer;
  object-fit: cover;
}
.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}
.product-name {
  font-size: 14px;
  color: #333;
  cursor: pointer;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.product-spec {
  margin-top: 4px;
  font-size: 12px;
  background-color: #f9f9f9;
  padding: 2px 8px;
  border-radius: 4px;
  display: inline-block;
  color: #999;
}
.service-tags {
  margin-top: 8px;
}
.price-guard {
  font-size: 11px;
  color: #f56c6c;
  border: 1px solid #f56c6c;
  padding: 0 4px;
  border-radius: 2px;
  margin-right: 8px;
}
.shipping-tag {
  font-size: 11px;
  color: #999;
  background: #f5f5f5;
  padding: 1px 5px;
  border-radius: 2px;
}
.total-price {
  color: #f56c6c;
  font-size: 26px;
  font-weight: bold;
  margin: 0 20px;
}
.submit-btn {
  width: 160px;
  height: 50px;
  font-size: 18px;
  font-weight: bold;
}
.settle-bar {
  margin-top: 30px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  padding: 15px 30px;
  border: 1px solid #eee;
  border-radius: 4px;
}
.highlight {
  color: #f56c6c;
  font-weight: bold;
  font-size: 18px;
  margin: 0 5px;
}

.order-section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 15px;
}
.order-goods-list {
  max-height: 200px;
  overflow-y: auto;
  background: #fafafa;
  border-radius: 8px;
  padding: 10px;
}
.order-goods-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}
.order-goods-item:last-child {
  border-bottom: none;
}
.order-goods-img {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 4px;
  background: #fff;
}
.goods-name-limit {
  font-size: 13px;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.address-select-box {
  margin-top: 15px;
  border: 1px solid #eee;
  padding: 10px;
  border-radius: 8px;
  overflow: hidden;
}
.address-card {
  padding: 10px;
  border: 1px solid transparent;
  border-radius: 6px;
  margin-bottom: 5px;
}
.address-card.active {
  background: #fffcfc;
  border-color: #ff4d4f;
}
.address-content {
  display: inline-block;
  vertical-align: middle;
  margin-left: 10px;
}
.address-user {
  font-weight: bold;
  font-size: 14px;
}
.address-detail {
  font-size: 12px;
  color: #666;
  margin-top: 4px;
}
.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20px;
  border-top: 1px solid #eee;
}
.total-price-display {
  font-size: 16px;
  color: #333;
}
.price-num {
  color: #ff4d4f;
  font-size: 24px;
  font-weight: bold;
}
</style>
