<template>
  <div class="main-content" style="width: 70%; margin: 20px auto">
    <div class="card" style="padding: 30px">
      <div
        style="
          display: flex;
          justify-content: space-between;
          border-bottom: 1px solid #eee;
          padding-bottom: 20px;
        "
      >
        <div style="font-size: 20px; font-weight: bold">订单详情</div>
        <el-button @click="router.back()">返回列表</el-button>
      </div>

      <div style="margin-top: 30px">
        <el-steps :active="getStep()" finish-status="success" align-center>
          <el-step title="提交订单" :description="data.order.time" />
          <el-step title="已支付" :description="data.order.payTime" />
          <el-step title="商家发货" />
          <el-step title="已签收" :description="data.order.receiptTime" />
          <el-step title="交易完成" :description="data.order.finishTime" />
        </el-steps>
      </div>

      <div class="info-section">
        <div class="section-title">收货人信息</div>
        <div class="info-content">
          <p>收 货 人：{{ parseAddress().name }}</p>
          <p>联系电话：{{ parseAddress().phone }}</p>
          <p>收货地址：{{ parseAddress().address }}</p>
        </div>
      </div>

      <div class="info-section">
        <div class="section-title">订单及支付信息</div>
        <div class="info-content">
          <p>订单编号：{{ data.order.orderNo }}</p>
          <p>支付流水：{{ data.order.payNo || "未支付" }}</p>
          <p>支付时间：{{ data.order.payTime || "-" }}</p>
        </div>
      </div>

      <div class="info-section">
        <div class="section-title">商品清单</div>
        <el-table :data="data.order.itemList" stripe>
          <el-table-column label="商品图" width="100">
            <template #default="scope"
              ><img
                :src="scope.row.goodsImg"
                style="width: 50px; border-radius: 4px"
            /></template>
          </el-table-column>
          <el-table-column prop="goodsName" label="商品名称" />
          <el-table-column prop="spec" label="规格" width="150" />
          <el-table-column prop="price" label="单价" width="120">
            <template #default="scope">￥{{ scope.row.price }}</template>
          </el-table-column>
          <el-table-column prop="num" label="数量" width="100" />
          <el-table-column label="小计" width="120">
            <template #default="scope"
              >￥{{ (scope.row.price * scope.row.num).toFixed(2) }}</template
            >
          </el-table-column>
        </el-table>
      </div>

      <div style="text-align: right; margin-top: 30px; font-size: 18px">
        <span v-if="data.order.status === '待付款'">应付总额：</span>
        <span v-else-if="data.order.status === '已取消'">应付款：</span>
        <span
          v-else-if="['待发货', '待收货', '已签收'].includes(data.order.status)"
          >已付款：</span
        >
        <span v-else>总共实付：</span>

        <span style="color: #f56c6c; font-weight: bold; font-size: 24px">
          ￥{{ data.order.totalPrice }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import { useRoute } from "vue-router";
import request from "@/utils/request";
import router from "@/router";

const route = useRoute();
const data = reactive({ order: {} });
const getStep = () => {
  const status = data.order.status;
  if (status === "待付款") return 1;
  if (status === "待发货") return 2;
  if (status === "待收货") return 3;
  if (status === "已签收") return 4;
  if (status === "已完成" || status === "已退款") return 5;
  if (["退货待审核", "待用户发货", "待商家收货"].includes(status)) return 4;

  return 0;
};

const parseAddress = () => {
  if (!data.order.address) return {};
  const parts = data.order.address.split(" | ");
  return { name: parts[0], phone: parts[1], address: parts[2] };
};

onMounted(() => {
  request.get("/orders/selectById/" + route.query.id).then((res) => {
    data.order = res.data;
  });
});
</script>

<style scoped>
.info-section {
  margin-top: 40px;
}
.section-title {
  font-size: 16px;
  font-weight: bold;
  border-left: 4px solid #f56c6c;
  padding-left: 10px;
  margin-bottom: 15px;
}
.info-content p {
  margin: 10px 0;
  color: #666;
  font-size: 14px;
}
</style>
