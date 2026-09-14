<template>
  <div style="padding: 20px">
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="6">
        <el-card shadow="hover" class="kpi-card">
          <template #header>今日成交额</template>
          <div class="kpi-value">￥{{ data.report.todayRevenue || 0 }}</div>
          <div class="kpi-footer">基于今日已完成订单</div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="kpi-card">
          <template #header>今日订单量</template>
          <div class="kpi-value">
            {{ data.report.todayOrders || 0 }}
            <span style="font-size: 14px">单</span>
          </div>
          <div class="kpi-footer">今日新增完成订单</div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="kpi-card">
          <template #header>累计总营收</template>
          <div class="kpi-value" style="color: #f56c6c">
            ￥{{ data.report.totalRevenue || 0 }}
          </div>
          <div class="kpi-footer">商城的历史总收益</div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="kpi-card">
          <template #header>配件库存状态</template>
          <div
            class="kpi-value"
            :style="{
              color: data.report.stockAlertCount > 0 ? '#f56c6c' : '#67c23a',
            }"
          >
            {{
              data.report.stockAlertCount > 0
                ? data.report.stockAlertCount + " 种配件告急"
                : "运行正常"
            }}
          </div>
          <div class="kpi-footer">存在规格库存低于 10 件的配件</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="16">
        <el-card shadow="hover">
          <template #header>
            <div style="font-weight: bold">全站订单处理现状 (运营看板)</div>
          </template>
          <div id="statusChart" style="height: 400px; width: 100%"></div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card shadow="hover" header="快速通道">
          <div class="quick-link" @click="router.push('/manager/orders')">
            <el-button
              type="primary"
              plain
              style="width: 100%; margin-bottom: 15px"
              >前往订单管理</el-button
            >
          </div>
          <div class="quick-link" @click="router.push('/manager/goods')">
            <el-button
              type="success"
              plain
              style="width: 100%; margin-bottom: 15px"
              >配件库存补货</el-button
            >
          </div>
          <div class="quick-link" @click="router.push('/manager/report')">
            <el-button type="warning" plain style="width: 100%"
              >查看深度报表</el-button
            >
          </div>
          <div
            style="
              margin-top: 30px;
              border-top: 1px solid #eee;
              padding-top: 20px;
            "
          >
            <p style="font-size: 12px; color: #999; line-height: 2">
              💡 小提示：<br />
              管理员可在此快速处理待发货订单或补充告急配件库存。
            </p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { reactive, onMounted, nextTick } from "vue";
import request from "@/utils/request";
import * as echarts from "echarts";
import { useRouter } from "vue-router";

const router = useRouter();
const data = reactive({
  report: {},
});

// 获取统计报表数据
const loadData = () => {
  request.get("/orders/getReport").then((res) => {
    if (res.code === "200") {
      data.report = res.data || {};
      nextTick(() => {
        initStatusChart(res.data.categoryData || []);
      });
    }
  });
};

// 初始化订单状态图表
const initStatusChart = (chartData) => {
  const chartElement = document.getElementById("statusChart");
  if (!chartElement) return;
  const chart = echarts.init(chartElement);
  chart.setOption({
    tooltip: { trigger: "item" },
    legend: { orient: "vertical", left: "left" },
    series: [
      {
        name: "订单状态",
        type: "pie",
        radius: "70%",
        center: ["60%", "50%"],
        data: chartData,
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: "rgba(0, 0, 0, 0.5)",
          },
        },
      },
    ],
  });
};

onMounted(() => {
  loadData();
});
</script>

<style scoped>
.kpi-card :deep(.el-card__header) {
  font-size: 14px;
  color: #909399;
  border-bottom: none;
  padding-bottom: 0;
}
.kpi-value {
  font-size: 24px;
  font-weight: bold;
  padding: 10px 0;
  color: #303133;
}
.kpi-footer {
  font-size: 12px;
  color: #c0c4cc;
}
.quick-link {
  cursor: pointer;
}
</style>
