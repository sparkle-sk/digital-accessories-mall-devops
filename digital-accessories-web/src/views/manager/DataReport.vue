<template>
  <div style="padding: 20px">
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="8">
        <el-card shadow="hover" style="text-align: center">
          <div style="color: #909399; font-size: 14px">累计销售额 (已完成)</div>
          <div
            style="
              font-size: 28px;
              font-weight: bold;
              margin-top: 10px;
              color: #f56c6c;
            "
          >
            ￥ {{ data.report.totalRevenue || 0 }}
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" style="text-align: center">
          <div style="color: #909399; font-size: 14px">已成交订单量</div>
          <div
            style="
              font-size: 28px;
              font-weight: bold;
              margin-top: 10px;
              color: #409eff;
            "
          >
            {{ data.report.totalOrders || 0 }} 单
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" style="text-align: center">
          <div style="color: #909399; font-size: 14px">库存预警商品</div>
          <div
            style="
              font-size: 28px;
              font-weight: bold;
              margin-top: 10px;
              color: #e6a23c;
            "
          >
            {{ data.report.stockAlertCount || 0 }} 款
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="12">
        <el-card shadow="hover">
          <div
            style="
              font-weight: bold;
              margin-bottom: 20px;
              padding-bottom: 10px;
              border-bottom: 1px solid #eee;
            "
          >
            订单状态占比分布
          </div>
          <div id="categoryChart" style="height: 350px"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card shadow="hover">
          <div
            style="
              font-weight: bold;
              margin-bottom: 20px;
              padding-bottom: 10px;
              border-bottom: 1px solid #eee;
            "
          >
            配件热销排行榜 (Top 5)
          </div>
          <div id="hotChart" style="height: 350px"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="24">
        <el-card shadow="hover">
          <div
            style="
              font-weight: bold;
              margin-bottom: 20px;
              padding-bottom: 10px;
              border-bottom: 1px solid #eee;
            "
          >
            用户取消/退货订单分析
          </div>
          <div id="cancelChart" style="height: 350px"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import request from "@/utils/request";
import * as echarts from "echarts";

const data = reactive({
  report: {},
});

// 加载报表数据
const loadReport = () => {
  request.get("/orders/getReport").then((res) => {
    data.report = res.data || {};

    initCategoryChart(data.report.categoryData);
    initHotChart(data.report.hotData);
    initCancelChart(data.report.cancelData);
  });
};

// 订单状态饼图
const initCategoryChart = (chartData) => {
  const chartDom = document.getElementById("categoryChart");
  if (!chartDom) return;
  const chart = echarts.init(chartDom);
  chart.setOption({
    tooltip: { trigger: "item", formatter: "{b}: {c} 单 ({d}%)" },
    legend: { bottom: "0" },
    series: [
      {
        type: "pie",
        radius: ["35%", "60%"],
        avoidLabelOverlap: true,
        itemStyle: { borderRadius: 10, borderColor: "#fff", borderWidth: 2 },
        label: {
          show: true,
          formatter: "{b}: {c}单 ({d}%)",
          fontSize: 12,
          fontWeight: "normal",
        },
        labelLine: {
          show: true,
        },
        data: chartData || [],
      },
    ],
  });
};

// 热销商品柱状图
const initHotChart = (chartData) => {
  const chartDom = document.getElementById("hotChart");
  if (!chartDom) return;
  const chart = echarts.init(chartDom);
  const safeData = chartData || [];

  chart.setOption({
    tooltip: { trigger: "axis", axisPointer: { type: "shadow" } },
    grid: { left: "3%", right: "4%", bottom: "3%", containLabel: true },
    xAxis: { type: "value" },
    yAxis: { type: "category", data: safeData.map((i) => i.name).reverse() },
    series: [
      {
        name: "真实销量",
        type: "bar",
        data: safeData.map((i) => i.value).reverse(),
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color: "#83bff6" },
            { offset: 1, color: "#188df0" },
          ]),
          borderRadius: [0, 5, 5, 0],
        },
      },
    ],
  });
};

// 取消/退货订单数据图
const initCancelChart = (chartData) => {
  const chartDom = document.getElementById("cancelChart");
  if (!chartDom) return;
  const chart = echarts.init(chartDom);
  const safeData = chartData || [];

  chart.setOption({
    tooltip: { trigger: "item", formatter: "{b}: {c} 件 ({d}%)" },
    legend: { bottom: "10" },
    series: [
      {
        name: "取消/退货订单数量",
        type: "pie",
        radius: ["25%", "65%"],
        center: ["50%", "45%"],
        roseType: "area",
        data: safeData,
        itemStyle: {
          borderRadius: 8,
        },
        label: {
          show: true,
          formatter: "{b}: {c}件 ({d}%)",
          fontSize: 12,
        },
        labelLine: {
          show: true,
        },
      },
    ],
  });
};

onMounted(() => {
  loadReport();
});
</script>

<style scoped>
.el-card {
  border-radius: 8px;
}
</style>
