<template>
  <div class="main-content" style="width: 85%; margin: 20px auto">
    <el-tabs v-model="data.activeStatus" @tab-click="load" class="order-tabs">
      <el-tab-pane label="全部订单" name="全部"></el-tab-pane>
      <el-tab-pane label="待付款" name="待付款"></el-tab-pane>
      <el-tab-pane label="待发货" name="待发货"></el-tab-pane>
      <el-tab-pane label="待收货" name="待收货"></el-tab-pane>
      <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
      <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
      <el-tab-pane label="退换/售后" name="售后"></el-tab-pane>
    </el-tabs>

    <div
      style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 20px 0;
      "
    >
      <div class="page-title" style="margin: 0">
        订单列表 ({{ data.tableData.length }})
      </div>

      <div style="display: flex; align-items: center; gap: 10px">
        <el-input
          v-model="data.inputKeyword"
          placeholder="搜索订单号或商品名称"
          style="width: 200px"
          clearable
          @keyup.enter="handleSearch"
          class="custom-input"
        />

        <el-date-picker
          v-model="data.dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD"
          style="width: 260px"
        />

        <el-button class="custom-search-btn" @click="handleSearch">
          搜索
        </el-button>

        <el-button
          class="custom-reset-btn"
          @click="handleReset"
          plain
          style="width: 80px"
        >
          重置
        </el-button>
      </div>
    </div>

    <div v-for="order in data.tableData" :key="order.id" class="order-card">
      <div class="order-header">
        <div class="header-left">
          <span class="order-time">{{ order.time }}</span>
          <span class="order-id">订单号：{{ order.orderNo }}</span>
          <span class="store-info">
            <el-icon><Shop /></el-icon> {{ getStoreName(order) }}
          </span>
          <el-link
            type="primary"
            :underline="false"
            style="margin-left: 20px; font-size: 13px; font-weight: normal"
            @click="router.push('/front/orderDetail?id=' + order.id)"
          >
            订单详情
          </el-link>
        </div>
        <div class="header-right" v-if="canDelete(order.status)">
          <el-tooltip content="删除订单" placement="top">
            <el-icon class="delete-icon" @click="del(order.id)"
              ><Delete
            /></el-icon>
          </el-tooltip>
        </div>
      </div>

      <div class="order-body">
        <el-row style="width: 100%">
          <el-col :span="10" class="body-col goods-list-col">
            <div
              v-for="goods in order.itemList"
              :key="goods.id"
              class="goods-item"
            >
              <el-popover placement="right" :width="300" trigger="hover">
                <template #reference>
                  <img
                    :src="goods.goodsImg || goods.img"
                    class="goods-img"
                    @click="goDetail(goods.goodsId)"
                  />
                </template>
                <img :src="goods.goodsImg || goods.img" style="width: 100%" />
              </el-popover>
              <div class="goods-info">
                <el-tooltip :content="goods.goodsName" placement="top">
                  <div class="goods-name" @click="goDetail(goods.goodsId)">
                    {{ goods.goodsName }}
                  </div>
                </el-tooltip>
                <div class="goods-spec">规格：{{ goods.spec || "默认" }}</div>
              </div>
              <div class="goods-num">x {{ goods.num }}</div>
            </div>
          </el-col>

          <el-col :span="5" class="body-col border-left">
            <div class="address-box">
              <div class="user-line">
                <el-icon><User /></el-icon>
                <span class="user-name">{{
                  parseAddress(order.address).name
                }}</span>
              </div>
              <div class="phone-line">
                {{ maskPhone(parseAddress(order.address).phone) }}
              </div>
              <div class="addr-detail">
                {{ parseAddress(order.address).address }}
              </div>
            </div>
          </el-col>

          <el-col :span="4" class="body-col border-left text-center">
            <div class="total-price">￥{{ order.totalPrice }}</div>
            <div style="font-size: 12px; color: #999">（在线支付）</div>
            <div v-if="order.receiptTime" class="sign-tag">已签收</div>
          </el-col>

          <el-col :span="5" class="body-col border-left text-center">
            <div class="status-text" :class="order.status">
              {{ order.status === "待用户发货" ? "待寄回商品" : order.status }}
            </div>
            <div
              v-if="order.status === '已取消' && order.cancelReason"
              style="font-size: 12px; color: #999; margin-bottom: 8px"
            >
              原因：{{ order.cancelReason }}
            </div>
            <div class="action-btns">
              <div
                v-if="order.status === '已签收' && order.rejectReason"
                class="reject-box"
              >
                <el-tooltip
                  :content="'原因：' + order.rejectReason"
                  placement="top"
                >
                  <div class="reject-text">退货申请被驳回</div>
                </el-tooltip>
              </div>
              <el-button
                v-if="order.status === '待付款'"
                type="primary"
                size="small"
                @click="pay(order)"
                >立即支付</el-button
              >

              <el-button
                v-if="order.status === '待付款' || order.status === '待发货'"
                size="small"
                plain
                @click="cancel(order.id)"
                >取消订单</el-button
              >

              <el-button
                v-if="order.status === '待收货'"
                type="warning"
                size="small"
                @click="sign(order.id)"
                >确认签收</el-button
              >

              <el-button
                v-if="order.status === '已签收'"
                type="success"
                size="small"
                @click="confirmReceipt(order)"
                >确认收货</el-button
              >
              <el-button
                v-if="canApplyReturn(order)"
                size="small"
                style="margin-top: 8px"
                @click="openReturn(order)"
                >申请退货</el-button
              >
              <el-button
                v-if="order.status === '待用户发货'"
                type="primary"
                size="small"
                @click="openExpress(order.id)"
                >填写单号</el-button
              >
              <div v-if="order.status === '退货待审核'" class="info-tip">
                退货审核中...
              </div>
              <div v-if="order.status === '待商家收货'" class="info-tip">
                等待商家收货
              </div>
              <div v-if="order.status === '已退款'" class="success-text">
                款项已原路退回
              </div>
              <div v-if="order.status === '已完成'" class="success-text">
                交易成功
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>

    <el-dialog
      v-model="data.returnVisible"
      title="申请退货"
      width="450px"
      destroy-on-close
    >
      <div style="padding: 10px">
        <el-form :model="data.returnForm" label-width="80px">
          <el-form-item label="退货原因">
            <el-select
              v-model="data.returnForm.reason"
              placeholder="请选择退货原因"
              style="width: 100%"
            >
              <el-option label="7天无理由退换货" value="7天无理由" />
              <el-option label="商品质量问题" value="质量问题" />
              <el-option label="发错货/漏发" value="发错货" />
              <el-option label="不喜欢/不想要了" value="不喜欢" />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="data.returnVisible = false">取消</el-button>
        <el-button type="primary" @click="submitReturn">提交申请</el-button>
      </template>
    </el-dialog>

    <el-dialog
      v-model="data.cancelVisible"
      title="取消订单"
      width="400px"
      destroy-on-close
    >
      <div style="padding: 10px">
        <div style="margin-bottom: 15px; color: #666">
          请告知我们取消的原因，帮我们做得更好：
        </div>
        <el-form :model="data.cancelForm">
          <el-form-item>
            <el-select
              v-model="data.cancelForm.reason"
              placeholder="请选择取消原因"
              style="width: 100%"
            >
              <el-option label="不想买了" value="不想买了" />
              <el-option label="信息填写错误，重新下单" value="信息错误" />
              <el-option label="价格有点贵" value="价格高" />
              <el-option label="其他原因" value="其他" />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="data.cancelVisible = false">暂不取消</el-button>
        <el-button type="primary" @click="submitCancel">提交并取消</el-button>
      </template>
    </el-dialog>

    <el-dialog
      v-model="data.expressVisible"
      title="填写退货单号"
      width="450px"
      destroy-on-close
    >
      <el-form
        :model="data.expressForm"
        label-width="80px"
        style="padding: 10px"
      >
        <el-form-item label="快递单号">
          <el-input
            v-model="data.expressForm.expressNo"
            placeholder="请输入退回商品的快递单号"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="data.expressVisible = false">取消</el-button>
        <el-button type="primary" @click="submitExpress">确认发货</el-button>
      </template>
    </el-dialog>

    <el-dialog
      v-model="data.payVisible"
      title="支付结算"
      width="400px"
      destroy-on-close
    >
      <div style="text-align: center; padding: 10px">
        <div style="margin-bottom: 10px; font-size: 13px; color: #999">
          订单编号：{{ data.currentOrder.orderNo }}
        </div>
        <div style="margin-bottom: 20px; font-size: 18px; color: #333">
          应付金额：<span style="color: #f56c6c; font-weight: bold"
            >￥{{ data.currentOrder.totalPrice }}</span
          >
        </div>

        <el-radio-group v-model="data.payType" style="margin-bottom: 20px">
          <el-radio label="alipay">支付宝</el-radio>
          <el-radio label="wechat">微信支付</el-radio>
          <el-radio label="union">银联/闪付</el-radio>
        </el-radio-group>

        <div
          style="
            border: 1px solid #f2f2f2;
            padding: 15px;
            border-radius: 8px;
            background: #fafafa;
          "
        >
          <img
            src="@/assets/imgs/pay_qr.png"
            style="width: 180px; height: 180px; display: block; margin: 0 auto"
          />

          <div
            style="
              margin-top: 15px;
              color: #333;
              font-size: 14px;
              font-weight: bold;
            "
          >
            正在使用
            {{
              data.payType === "alipay"
                ? "支付宝"
                : data.payType === "wechat"
                  ? "微信"
                  : "银联"
            }}
            支付
          </div>
          <div style="color: #999; font-size: 12px; margin-top: 5px">
            请扫描上方二维码完成支付
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="data.payVisible = false">返回修改</el-button>
        <el-button type="primary" @click="confirmPay">确认已完成支付</el-button>
      </template>
    </el-dialog>

    <el-empty v-if="data.tableData.length === 0" description="暂无相关订单" />
  </div>
</template>

<script setup>
import { reactive, onMounted, onBeforeUnmount } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { Shop, User, Delete } from "@element-plus/icons-vue";
import router from "@/router";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  tableData: [],
  activeStatus: "全部",
  returnVisible: false,
  returnForm: { id: null, reason: "" },
  expressVisible: false,
  expressForm: { id: null, expressNo: "" },
  cancelVisible: false,
  cancelForm: { id: null, reason: "" },
  payVisible: false,
  payType: "alipay",
  currentOrder: {},
  inputKeyword: "",
  searchKeyword: "",
  dateRange: null,
});
const canApplyReturn = (order) => {
  if (order.status !== "已签收" || !order.receiptTime || order.rejectReason)
    return false;
  const receiptDate = new Date(order.receiptTime).getTime();
  const now = new Date().getTime();
  // 签收后7天内可申请
  return now - receiptDate < 7 * 24 * 3600 * 1000;
};

const parseGoods = (json) => {
  try {
    return JSON.parse(json || "[]");
  } catch (e) {
    return [];
  }
};
const parseAddress = (str) => {
  if (!str) return { name: "-", phone: "-", address: "-" };
  const parts = str.split(" | ");
  return { name: parts[0], phone: parts[1], address: parts[2] };
};
const maskPhone = (phone) => {
  if (!phone || phone.length < 11) return phone;
  return phone.replace(/(\d{3})\d{4}(\d{4})/, "$1****$2");
};
const getStoreName = (order) => {
  const goods = parseGoods(order.goodsData);
  return goods.length > 0
    ? goods[0].storeName || "数码优选旗舰店"
    : "数码配件商城";
};
const handleSearch = () => {
  data.searchKeyword = data.inputKeyword;
  load();
};

const handleReset = () => {
  data.inputKeyword = "";
  data.searchKeyword = "";
  data.dateRange = null;
  load();
};

onBeforeUnmount(() => {
  data.inputKeyword = "";
  data.searchKeyword = "";
  data.dateRange = null;
});

const load = () => {
  const status = data.activeStatus === "全部" ? null : data.activeStatus;
  let startTime = null;
  let endTime = null;
  if (data.dateRange && data.dateRange.length === 2) {
    startTime = data.dateRange[0] + " 00:00:00";
    endTime = data.dateRange[1] + " 23:59:59";
  }

  request
    .get("/orders/selectAll", {
      params: {
        userId: data.user.id,
        status: status,
        orderNo: data.searchKeyword,
        startTime: startTime,
        endTime: endTime,
      },
    })
    .then((res) => {
      data.tableData = res.data || [];
    });
};

//
const cancel = (id) => {
  data.cancelForm.id = id;
  data.cancelForm.reason = "";
  data.cancelVisible = true;
};

// 提交取消订单
const submitCancel = () => {
  if (!data.cancelForm.reason) {
    return ElMessage.warning("请选择取消原因");
  }

  request
    .put("/orders/cancel", {
      id: data.cancelForm.id,
      cancelReason: data.cancelForm.reason,
    })
    .then((res) => {
      if (res.code === "200") {
        ElMessage.success("订单已取消，库存已自动回退");
        data.cancelVisible = false;
        load();
      }
    });
};

const sign = (id) => {
  request.put("/orders/sign/" + id).then((res) => {
    if (res.code === "200") {
      ElMessage.success("签收成功，可在7天内申请售后！");
      load();
    }
  });
};

const pay = (row) => {
  data.currentOrder = JSON.parse(JSON.stringify(row));
  data.payType = "alipay";
  data.payVisible = true;
};
// 确认支付
const confirmPay = () => {
  request
    .put("/orders/updateStatus", {
      id: data.currentOrder.id,
      status: "待发货",
      payType: data.payType,
    })
    .then((res) => {
      if (res.code === "200") {
        ElMessage.success("支付成功");
        data.payVisible = false;
        load();
      }
    })
    .catch((err) => {
      console.error("支付异常：", err);
    });
};

const confirmReceipt = (row) => {
  ElMessageBox.confirm("确认已收到商品？确认后将无法发起售后服务。", "确认收货")
    .then(() => {
      request
        .put("/orders/updateStatus", { id: row.id, status: "已完成" })
        .then((res) => {
          if (res.code === "200") {
            ElMessage.success("订单已完成");
            load();
          }
        });
    })
    .catch(() => {});
};

const openReturn = (order) => {
  data.returnForm.id = order.id;
  data.returnForm.reason = "";
  data.returnVisible = true;
};

const submitReturn = () => {
  if (!data.returnForm.reason) return ElMessage.warning("请选择退货原因");
  request
    .put("/orders/updateStatus", {
      id: data.returnForm.id,
      status: "退货待审核",
      returnReason: data.returnForm.reason,
    })
    .then((res) => {
      ElMessage.success("申请已提交");
      data.returnVisible = false;
      load();
    });
};

const openExpress = (id) => {
  data.expressForm.id = id;
  data.expressForm.expressNo = "";
  data.expressVisible = true;
};

const submitExpress = () => {
  if (!data.expressForm.expressNo) return ElMessage.warning("请填写快递单号");
  request
    .put("/orders/updateStatus", {
      id: data.expressForm.id,
      status: "待商家收货",
      expressNo: data.expressForm.expressNo,
    })
    .then((res) => {
      ElMessage.success("单号已提交");
      data.expressVisible = false;
      load();
    });
};

const del = (id) => {
  ElMessageBox.confirm("确认删除该订单记录吗？删除后不可恢复。", "警告", {
    type: "error",
  })
    .then(() => {
      request.delete("/orders/delete/" + id).then((res) => {
        if (res.code === "200") {
          ElMessage.success("删除成功");
          load();
        }
      });
    })
    .catch(() => {});
};

const canDelete = (status) => ["已完成", "已取消", "已退款"].includes(status);
const goDetail = (id) => {
  router.push("/front/detail?id=" + id);
};

onMounted(() => {
  load();
});
</script>

<style scoped>
.order-tabs {
  margin-bottom: 10px;
}
.page-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 20px;
  color: #333;
}

.custom-input :deep(.el-input__wrapper),
:deep(.el-range-editor.el-input__wrapper) {
  box-shadow: 0 0 0 1px #e5e5e5 inset !important;
  border: none !important;
}

.custom-input :deep(.el-input__wrapper):hover,
:deep(.el-range-editor.el-input__wrapper):hover,
.custom-input :deep(.el-input__wrapper.is-focus),
:deep(.el-range-editor.is-active) {
  box-shadow: 0 0 0 1px #dcdfe6 inset !important;
}

.custom-search-btn {
  background-color: #f5f5f5 !important;
  color: #606266 !important;
  border: 1px solid #e5e5e5 !important;
  width: 90px;
  font-weight: bold;
}

.custom-reset-btn {
  border-color: #e5e5e5 !important;
  color: #606266 !important;
  width: 80px;
}

.custom-reset-btn:hover {
  background-color: #fafafa !important;
  border-color: #dcdfe6 !important;
  color: #333 !important;
}

.el-button.is-plain:hover {
  border-color: #dcdfe6;
  color: #606266;
}

.custom-search-btn:hover {
  background-color: #eeeeee !important;
  border-color: #dcdfe6 !important;
}

.order-card {
  background: #fff;
  border: 1px solid #e5e5e5;
  margin-bottom: 20px;
  border-radius: 4px;
  overflow: hidden;
}
.order-header {
  background: #f5f5f5;
  padding: 10px 20px;
  font-size: 13px;
  color: #666;
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #e5e5e5;
}
.header-left span {
  margin-right: 30px;
}
.delete-icon {
  cursor: pointer;
  font-size: 16px;
}
.delete-icon:hover {
  color: #f56c6c;
}
.order-body {
  display: flex;
  align-items: stretch;
}
.body-col {
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.border-left {
  border-left: 1px solid #f2f2f2;
}
.text-center {
  align-items: center;
}
.goods-list-col {
  gap: 15px;
}
.goods-item {
  display: flex;
  align-items: center;
}
.goods-img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border: 1px solid #eee;
  border-radius: 4px;
  cursor: pointer;
}
.goods-info {
  flex: 1;
  margin-left: 15px;
  overflow: hidden;
}
.goods-name {
  font-size: 13px;
  color: #333;
  cursor: pointer;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.goods-name:hover {
  color: #f56c6c;
}
.goods-spec {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}
.goods-num {
  width: 40px;
  text-align: right;
  color: #999;
  font-size: 13px;
}
.address-box {
  font-size: 12px;
  color: #666;
  line-height: 1.6;
}
.user-line {
  color: #333;
  font-weight: bold;
  margin-bottom: 4px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.total-price {
  font-size: 18px;
  color: #333;
  font-weight: bold;
}
.sign-tag {
  margin-top: 5px;
  font-size: 11px;
  color: #67c23a;
  background: #f0f9eb;
  padding: 2px 5px;
  border-radius: 2px;
}
.status-text {
  font-size: 14px;
  margin-bottom: 12px;
  font-weight: bold;
}
.status-text.待付款 {
  color: #ff9900;
}
.status-text.待发货 {
  color: #409eff;
}
.status-text.待收货 {
  color: #e6a23c;
}
.status-text.已完成 {
  color: #67c23a;
}
.status-text.已取消 {
  color: #909399;
}
.action-btns {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.info-tip {
  font-size: 12px;
  color: #999;
}
.success-text {
  font-size: 12px;
  color: #67c23a;
}
.reject-box {
  margin-bottom: 4px;
}
.reject-text {
  font-size: 12px;
  color: #f56c6c;
  background: #fef0f0;
  border: 1px solid #fde2e2;
  padding: 2px 8px;
  border-radius: 4px;
  cursor: help;
  font-weight: bold;
}
</style>
