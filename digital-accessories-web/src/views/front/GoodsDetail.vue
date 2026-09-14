<template>
  <div class="main-content">
    <div class="detail-container card" v-if="data.goods.id">
      <el-row :gutter="40">
        <el-col :span="12">
          <div class="img-box">
            <el-image
              :src="data.displayImg"
              fit="contain"
              class="detail-img"
              :preview-src-list="[data.displayImg]"
            ></el-image>
          </div>
        </el-col>

        <el-col :span="12">
          <div class="detail-info">
            <div class="store-info-line">
              <span class="store-name"
                ><el-icon><Shop /></el-icon> {{ data.goods.store }}</span
              >
              <el-tag size="small" type="danger" style="margin-left: 10px"
                >自营</el-tag
              >
            </div>

            <h1 class="title">{{ data.goods.name }}</h1>

            <div class="desc" style="color: #666; margin-bottom: 15px">
              {{ data.goods.description }}
            </div>

            <div class="price-box">
              <div style="margin-bottom: 8px">
                <span class="label">售价：</span>
                <span class="price">￥{{ data.displayPrice }}</span>
              </div>
              <div
                v-if="data.goods.stock < 3"
                style="margin-bottom: 10px; font-weight: bold; font-size: 14px"
              >
                <span v-if="data.goods.stock <= 0" style="color: #f56c6c">
                  <el-icon style="vertical-align: middle"
                    ><CircleCloseFilled
                  /></el-icon>
                  该商品已无货，请挑选同类型的商品
                </span>
                <span v-else style="color: #e6a23c">
                  <el-icon style="vertical-align: middle"
                    ><WarningFilled
                  /></el-icon>
                  该商品库存已低于3件，请尽快购买
                </span>
              </div>
              <div style="font-size: 13px; color: #999">
                累计销量：<span style="color: #444; font-weight: bold"
                  >{{ data.goods.sales || 0 }} 件</span
                >
              </div>
            </div>

            <div
              class="spec-section"
              v-if="data.specObjects.length > 0"
              style="margin: 20px 0"
            >
              <div
                class="label"
                style="margin-bottom: 12px; color: #666; font-weight: bold"
              >
                选择规格参数：
              </div>
              <el-radio-group
                v-model="data.currentSpecName"
                @change="handleSpecChange"
              >
                <el-radio-button
                  v-for="item in data.specObjects"
                  :key="item.name"
                  :label="item.name"
                />
              </el-radio-group>
            </div>

            <div class="main-btn-row">
              <el-button
                type="warning"
                size="large"
                plain
                @click="collect"
                class="half-btn"
              >
                <el-icon>
                  <StarFilled v-if="data.isCollect" />
                  <Star v-else />
                </el-icon>
                {{ data.isCollect ? "已收藏" : "收藏配件" }}
              </el-button>
              <el-button
                type="danger"
                size="large"
                @click="addToCart"
                class="half-btn"
              >
                <el-icon><ShoppingCart /></el-icon> 加入购物车
              </el-button>
            </div>

            <div class="compare-btn-row">
              <el-button
                type="primary"
                size="large"
                @click="openCompareDialog"
                class="half-btn"
              >
                <el-icon><Histogram /></el-icon> 参数对比
              </el-button>

              <el-button
                type="success"
                size="large"
                @click="buyNow"
                class="half-btn"
                :disabled="data.goods.stock <= 0"
              >
                <el-icon><CreditCard /></el-icon>
                {{ data.goods.stock <= 0 ? "暂时无货" : "立即购买" }}
              </el-button>
            </div>

            <div
              class="service-promise"
              style="margin-top: 30px; font-size: 13px; color: #999"
            >
              <span style="margin-right: 20px"
                ><el-icon color="#67C23A"><CircleCheck /></el-icon>
                厂家直发</span
              >
              <span style="margin-right: 20px"
                ><el-icon color="#67C23A"><CircleCheck /></el-icon>
                7天无理由</span
              >
              <span
                ><el-icon color="#67C23A"><CircleCheck /></el-icon>
                官方售后保障</span
              >
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <el-dialog
      v-model="data.buyNowVisible"
      title="确认订单信息"
      width="600px"
      destroy-on-close
    >
      <div style="padding: 0 10px">
        <div class="order-section-title">1. 商品清单</div>
        <div class="order-goods-item">
          <img :src="data.displayImg" class="order-goods-img" />
          <div style="flex: 1; margin-left: 15px">
            <div style="font-weight: bold; color: #333">
              {{ data.goods.name }}
            </div>
            <div style="margin-top: 5px; color: #999; font-size: 13px">
              规格：{{ data.currentSpecName || "默认规格" }}
            </div>
          </div>
          <div style="text-align: right">
            <div style="color: #ff4d4f; font-weight: bold; font-size: 16px">
              ￥{{ data.displayPrice }}
            </div>
            <div style="color: #999; font-size: 12px">x 1</div>
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
              {{ data.showAllAddress ? "收起地址" : "选择其他地址" }}
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
          <div class="total-price">
            应付总计：<span class="price-num">￥{{ data.displayPrice }}</span>
          </div>
          <div class="btns">
            <el-button @click="data.buyNowVisible = false">返回</el-button>
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

    <el-dialog v-model="data.compareVisible" title="对比配件选择" width="650px">
      <div style="margin-bottom: 20px">
        <el-input
          v-model="data.compareSearch"
          placeholder="手动输入名称检索更多配件..."
          @input="filterSimilarGoods"
          clearable
        >
          <template #append
            ><el-icon><Search /></el-icon
          ></template>
        </el-input>
      </div>
      <el-table
        :data="data.similarGoods"
        style="width: 100%"
        max-height="400px"
        empty-text="未找到匹配配件"
      >
        <el-table-column label="配件图片" width="90" align="center">
          <template #default="scope">
            <el-image
              :src="scope.row.img"
              style="
                width: 45px;
                height: 45px;
                border-radius: 4px;
                border: 1px solid #eee;
              "
            />
          </template>
        </el-table-column>
        <el-table-column prop="name" label="名称" show-overflow-tooltip />
        <el-table-column label="品牌" prop="brand" width="100" />
        <el-table-column label="操作" width="100" align="center">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="startCompare(scope.row.id)"
              >对比</el-button
            >
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>

    <el-dialog
      v-model="data.resultVisible"
      title="详细参数横向对比"
      width="85%"
      top="5vh"
    >
      <div class="compare-wrapper">
        <el-row :gutter="30">
          <el-col :span="12" class="compare-col">
            <div class="compare-header-box current">
              当前配件：{{ data.goods.name }}
            </div>
            <div class="compare-card">
              <el-image
                :src="data.displayImg"
                class="compare-img"
                fit="contain"
              />
              <div class="compare-price">￥{{ data.displayPrice }}</div>
            </div>
            <div
              class="compare-html-area"
              v-html="data.processedContentA"
            ></div>
          </el-col>
          <el-col :span="12" class="compare-col border-left">
            <div class="compare-header-box target">
              对比目标：{{ data.targetGoods.name }}
            </div>
            <div class="compare-card">
              <el-image
                :src="data.targetGoods.img"
                class="compare-img"
                fit="contain"
              />
              <div class="compare-price">￥{{ data.targetGoods.price }}</div>
            </div>
            <div
              class="compare-html-area"
              v-html="data.processedContentB"
            ></div>
          </el-col>
        </el-row>
      </div>
    </el-dialog>

    <div
      class="card detail-content"
      style="margin-top: 20px; padding: 30px"
      v-if="data.goods.id"
    >
      <div class="content-title">基本规格参数</div>
      <el-descriptions :column="2" border style="margin: 20px 0">
        <el-descriptions-item label="品牌">{{
          data.goods.brand || "数码优选"
        }}</el-descriptions-item>
        <el-descriptions-item label="售后服务"
          >1年全国联保</el-descriptions-item
        >
        <el-descriptions-item label="包装清单"
          >原机配件/说明书/保修卡</el-descriptions-item
        >
        <el-descriptions-item label="仓库发货"
          >{{ data.goods.store }}仓</el-descriptions-item
        >
      </el-descriptions>
      <div class="content-title" style="margin-top: 30px">详细图文展示</div>
      <div
        v-html="data.goods.content || '暂无详细介绍'"
        class="rich-content"
      ></div>
      <div class="detail-end">
        <div class="end-line"></div>
        <span class="end-text">已经到底啦，看看别的吧</span>
        <div class="end-line"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import { useRoute } from "vue-router";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  Star,
  StarFilled,
  ShoppingCart,
  Shop,
  CircleCheck,
  Histogram,
  Search,
  CreditCard,
} from "@element-plus/icons-vue";
import router from "@/router";

const route = useRoute();
const data = reactive({
  goodsId: route.query.id,
  goods: {},
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  isCollect: false,
  currentSpecName: "",
  specObjects: [],
  displayPrice: 0,
  displayImg: "",
  compareVisible: false,
  resultVisible: false,
  compareSearch: "",
  allSimilarGoods: [],
  similarGoods: [],
  targetGoods: {},
  processedContentA: "",
  processedContentB: "",
  buyNowVisible: false,
  addressList: [],
  selectedAddressId: null,
  showAllAddress: false,
});

const loadGoods = () => {
  request.get("/goods/selectById/" + data.goodsId).then((res) => {
    const goods = res.data || {};
    data.goods = goods;

    if (goods.skuList && goods.skuList.length > 0) {
      data.specObjects = goods.skuList.map((sku) => ({
        name: sku.specValue,
        price: sku.price,
        img: sku.img,
        stock: sku.stock,
      }));

      const firstSku = data.specObjects[0];
      data.currentSpecName = firstSku.name;
      data.displayPrice = firstSku.price;
      data.displayImg = firstSku.img;

      data.goods.stock = firstSku.stock;
    }
    checkCollect();
  });
};

const buyNow = () => {
  if (!data.user.id) {
    ElMessage.warning("请先登录");
    return;
  }
  request
    .get("/address/selectAll", { params: { userId: data.user.id } })
    .then((res) => {
      data.addressList = res.data || [];
      if (data.addressList.length === 0) {
        ElMessageBox.confirm(
          "您还没有设置收货地址，请先添加地址后再购买",
          "系统提示",
          {
            confirmButtonText: "去添加",
            cancelButtonText: "取消",
            type: "warning",
          },
        )
          .then(() => {
            router.push("/front/address");
          })
          .catch(() => {});
      } else {
        data.showAllAddress = false;
        // 选中默认地址，无默认则选中第一个
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

  // 拼接地址信息
  const activeAddr = data.addressList.find(
    (v) => v.id === data.selectedAddressId,
  );
  const addressSnapshot = `${activeAddr.name} | ${activeAddr.phone} | ${activeAddr.address}`;

  // 组装商品信息
  const cartItem = {
    goodsId: data.goodsId,
    goodsName: data.goods.name,
    goodsImg: data.displayImg,
    goodsPrice: data.displayPrice,
    storeName: data.goods.store,
    num: 1,
    spec: data.currentSpecName || "默认规格",
  };

  // 组装订单数据
  const orderData = {
    userId: data.user.id,
    totalPrice: data.displayPrice,
    address: addressSnapshot,
    cartList: [cartItem],
  };

  request.post("/orders/add", orderData).then((res) => {
    if (res.code === "200") {
      ElMessage.success("下单成功，正在进入我的订单...");
      data.buyNowVisible = false;
      router.push("/front/orders");
    } else {
      ElMessage.error(res.msg || "下单异常");
    }
  });
};

// 打开商品对比窗口
const openCompareDialog = () => {
  request
    .get("/goods/selectAll", { params: { categoryId: data.goods.categoryId } })
    .then((res) => {
      // 过滤当前商品，获取同类商品
      const allList = (res.data || []).filter(
        (item) => item.id !== data.goods.id,
      );
      data.allSimilarGoods = allList;
      const coreKeyword =
        data.goods.name.length > 2
          ? data.goods.name.substring(data.goods.name.length - 2)
          : data.goods.name;
      const filtered = allList.filter(
        (item) =>
          item.name.includes(coreKeyword) ||
          data.goods.name.includes(item.name),
      );
      if (filtered.length > 0) {
        data.similarGoods = filtered;
        data.compareVisible = true;
      } else {
        data.similarGoods = [];
        ElMessageBox.confirm("暂无名称高度匹配的配件，请手动挑选", "智能提示", {
          confirmButtonText: "确定",
          type: "info",
        })
          .then(() => {
            data.similarGoods = allList;
            data.compareVisible = true;
          })
          .catch(() => {});
      }
    });
};

const filterSimilarGoods = () => {
  data.similarGoods = data.allSimilarGoods.filter((item) =>
    item.name.toLowerCase().includes(data.compareSearch.toLowerCase()),
  );
};

const processContent = (html) => {
  if (!html) return "<div style='color:#999'>暂无详细内容</div>";
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, "text/html");
  const tables = doc.querySelectorAll("table");
  tables.forEach((table) => {
    const rows = table.querySelectorAll("tr");
    if (rows.length > 0) rows[rows.length - 1].remove();
  });
  return doc.body.innerHTML;
};

const startCompare = (targetId) => {
  request.get("/goods/selectById/" + targetId).then((res) => {
    data.targetGoods = res.data || {};
    data.processedContentA = processContent(data.goods.content);
    data.processedContentB = processContent(data.targetGoods.content);
    data.compareVisible = false;
    data.resultVisible = true;
  });
};

const handleSpecChange = (selectedName) => {
  const target = data.specObjects.find((item) => item.name === selectedName);
  if (target) {
    data.displayPrice = target.price;
    data.displayImg = target.img;
    data.goods.stock = target.stock;
    checkCollect();
  }
};

const checkCollect = () => {
  if (!data.user.id) return;
  request
    .get("/collect/selectByUserIdAndGoodsId", {
      params: {
        userId: data.user.id,
        goodsId: data.goodsId,
        spec: data.currentSpecName || "默认规格",
      },
    })
    .then((res) => {
      data.isCollect = !!res.data;
    });
};

const collect = () => {
  if (!data.user.id) {
    ElMessage.warning("请先登录");
    return;
  }
  request
    .post("/collect/add", {
      goodsId: data.goodsId,
      userId: data.user.id,
      spec: data.currentSpecName || "默认规格",
      price: data.displayPrice,
      goodsName: data.goods.name,
      goodsImg: data.displayImg,
    })
    .then((res) => {
      if (res.code === "200") {
        data.isCollect = !data.isCollect;
        ElMessage.success("收藏状态已更新");
      }
    });
};

const addToCart = () => {
  if (!data.user.id) {
    ElMessage.warning("请先登录");
    return;
  }
  request
    .post("/cart/add", {
      goodsId: data.goodsId,
      userId: data.user.id,
      num: 1,
      spec: data.currentSpecName || "默认规格",
      price: data.displayPrice,
      img: data.displayImg,
    })
    .then((res) => {
      ElMessage.success("成功加入购物车");
    })
    .catch((err) => {
      console.log("业务逻辑拦截：", err);

      if (err === "加购商品已紧急安排补货，敬请关注") {
        ElMessage.info(err);
      } else {
      }
    });
};

onMounted(() => {
  loadGoods();
});
</script>

<style scoped>
.main-content {
  width: 85%;
  margin: 20px auto;
}
.detail-container {
  padding: 40px;
}
.img-box {
  width: 100%;
  height: 450px;
  background: #fff;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #eee;
}
.detail-img {
  width: 90%;
  height: 90%;
}
.price-box {
  background: #fdf6f6;
  padding: 20px;
  border-radius: 8px;
  margin: 20px 0;
  border: 1px solid #fde2e2;
}
.price {
  color: #ff4d4f;
  font-size: 36px;
  font-weight: bold;
}
.title {
  font-size: 24px;
  color: #333;
  margin: 15px 0;
}
.main-btn-row {
  display: flex;
  gap: 15px;
  margin-top: 30px;
}
.compare-btn-row {
  display: flex;
  gap: 15px;
  margin-top: 15px;
}
.half-btn {
  flex: 1;
  height: 50px;
  font-size: 15px;
  font-weight: bold;
}

.order-section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 15px;
}
.order-goods-item {
  display: flex;
  align-items: center;
  padding: 15px;
  background: #fafafa;
  border-radius: 8px;
}
.order-goods-img {
  width: 60px;
  height: 60px;
  object-fit: contain;
  background: #fff;
  border-radius: 4px;
}
.address-select-box {
  margin-top: 15px;
  max-height: 250px;
  overflow-y: auto;
  border: 1px solid #eee;
  padding: 10px;
  border-radius: 8px;
}
.address-card {
  padding: 12px;
  border: 1px solid transparent;
  border-radius: 6px;
  transition: 0.2s;
  margin-bottom: 8px;
}
.address-card:hover {
  background: #fdfdfd;
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
  margin-bottom: 5px;
}
.address-detail {
  font-size: 12px;
  color: #666;
}
.order-footer {
  padding: 20px 10px 0 10px;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.price-num {
  color: #ff4d4f;
  font-size: 24px;
  font-weight: bold;
}

.compare-wrapper {
  padding: 10px;
}
.compare-col {
  text-align: center;
}
.border-left {
  border-left: 1px dashed #eee;
}
.compare-header-box {
  padding: 12px;
  border-radius: 4px;
  font-weight: bold;
  margin-bottom: 20px;
}
.compare-header-box.current {
  background: #fdf6f6;
  color: #ff4d4f;
}
.compare-header-box.target {
  background: #f0f9eb;
  color: #67c23a;
}
.compare-img {
  width: 140px;
  height: 140px;
}
.compare-price {
  font-size: 26px;
  color: #ff4d4f;
  font-weight: bold;
  margin: 10px 0;
}
.compare-html-area {
  text-align: left;
  border-top: 1px solid #f0f0f0;
  padding: 15px;
  overflow-y: auto;
  max-height: 500px;
}
.compare-html-area :deep(table) {
  width: 100% !important;
  border-collapse: collapse;
  margin-bottom: 10px;
}
.compare-html-area :deep(td) {
  border: 1px solid #eee;
  padding: 8px;
  font-size: 13px;
}
.compare-html-area :deep(img) {
  max-width: 100% !important;
}
.detail-end {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  color: #ccc;
}
.end-line {
  height: 1px;
  background: #eee;
  flex: 0.2;
}
.end-text {
  margin: 0 20px;
  font-size: 12px;
}
</style>
