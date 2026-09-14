<template>
  <div class="main-content" style="width: 95%; margin: 10px auto">
    <div class="card" style="padding: 20px">
      <div
        style="
          display: flex;
          justify-content: space-between;
          align-items: center;
          border-bottom: 1px solid #eee;
          padding-bottom: 15px;
        "
      >
        <div style="font-size: 18px; font-weight: bold">
          订单生命周期监控 (ID: {{ data.order.id }})
        </div>
        <el-button size="small" @click="router.back()">返回订单列表</el-button>
      </div>

      <div style="margin: 40px 0">
        <el-steps :active="getStep()" finish-status="success" align-center>
          <el-step title="下单时间" :description="data.order.time" />
          <el-step title="支付时间" :description="data.order.payTime" />
          <el-step title="物流发货" />
          <el-step title="签收时间" :description="data.order.receiptTime" />
          <el-step title="交易完成" :description="data.order.finishTime" />
        </el-steps>
      </div>

      <el-row :gutter="20">
        <el-col :span="12">
          <div class="info-box">
            <div class="box-title">收货凭证</div>
            <p>客户姓名：{{ parseAddress().name }}</p>
            <p>联系电话：{{ parseAddress().phone }}</p>
            <p>收货地址：{{ parseAddress().address }}</p>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="info-box">
            <div class="box-title">支付凭证</div>
            <p>订单编号：{{ data.order.orderNo }}</p>
            <p>
              支付流水：<el-tag size="small" type="info">{{
                data.order.payNo || "未产生流水"
              }}</el-tag>
            </p>
            <p>
              当前状态：<el-tag
                size="small"
                :type="statusMap[data.order.status]"
                >{{ data.order.status }}</el-tag
              >
            </p>
          </div>
        </el-col>
      </el-row>

      <div style="margin-top: 30px">
        <div class="box-title">商品快照</div>
        <el-table :data="data.order.itemList" border stripe>
          <el-table-column label="商品图" width="100">
            <template #default="scope"
              ><img
                :src="scope.row.goodsImg"
                style="width: 40px; border-radius: 4px"
            /></template>
          </el-table-column>
          <el-table-column prop="goodsName" label="商品名称" />
          <el-table-column prop="spec" label="规格" width="150" />
          <el-table-column prop="price" label="成交价格" width="120" />
          <el-table-column prop="num" label="数量" width="80" />
        </el-table>
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

const statusMap = {
  待付款: "warning",
  待发货: "danger",
  待收货: "primary",
  已签收: "info",
  已完成: "success",
  已退款: "success",
  已取消: "info",
};

const getStep = () => {
  const s = data.order.status;
  if (s === "待付款") return 1;
  if (s === "待发货") return 2;
  if (s === "待收货") return 3;
  if (s === "已签收") return 4;
  if (s === "已完成" || s === "已退款") return 5;
  if (["退货待审核", "待用户发货", "待商家收货"].includes(s)) return 4;
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
.info-box {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.box-title {
  font-size: 15px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #333;
  border-left: 4px solid #409eff;
  padding-left: 10px;
}
.info-box p {
  font-size: 13px;
  color: #666;
  margin: 5px 0;
}
</style>
