<template>
  <div class="card" style="padding: 20px">
    <el-tabs v-model="data.activeStatus" @tab-click="load" class="order-tabs">
      <el-tab-pane label="全部订单" name="全部"></el-tab-pane>
      <el-tab-pane label="待付款" name="待付款"></el-tab-pane>
      <el-tab-pane label="待发货" name="待发货"></el-tab-pane>
      <el-tab-pane label="待收货" name="待收货"></el-tab-pane>
      <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
      <el-tab-pane label="退换/售后" name="售后"></el-tab-pane>
      <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
    </el-tabs>

    <div style="margin: 20px 0">
      <el-input
        v-model="data.orderNo"
        placeholder="输入订单编号或商品名称查询"
        style="width: 260px"
        clearable
      />

      <el-date-picker
        v-model="data.dateRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        value-format="YYYY-MM-DD HH:mm:ss"
        :default-time="[
          new Date(2000, 1, 1, 0, 0, 0),
          new Date(2000, 1, 1, 23, 59, 59),
        ]"
        style="width: 340px; margin-left: 10px; vertical-align: middle"
      />

      <el-button type="primary" style="margin-left: 10px" @click="load"
        >查询</el-button
      >
      <el-button type="info" @click="reset">重置</el-button>
    </div>

    <el-table :data="data.tableData" stripe border v-loading="data.loading">
      <el-table-column label="订单编号" min-width="180" align="center">
        <template #default="scope">
          <el-tooltip content="点击订单编号查看订单详情" placement="top">
            <span
              style="cursor: pointer; color: #333"
              @click="navToDetail(scope.row.id)"
            >
              {{ scope.row.orderNo }}
            </span>
          </el-tooltip>
        </template>
      </el-table-column>

      <el-table-column
        prop="time"
        label="下单时间"
        width="180"
        align="center"
        sortable
      />

      <el-table-column
        prop="userName"
        label="下单客户"
        width="100"
        align="center"
      />

      <el-table-column
        prop="userAccount"
        label="客户账号"
        width="100"
        align="center"
      />

      <el-table-column label="订单商品详情" min-width="280" align="center">
        <template #default="scope">
          <div
            v-for="(item, index) in scope.row.itemList"
            :key="index"
            class="goods-item"
          >
            <el-image
              class="goods-img"
              :src="item.goodsImg"
              :preview-src-list="[item.goodsImg]"
              preview-teleported
            />
            <div class="goods-info">
              <el-tooltip content="点击商品名称查看订单详情" placement="top">
                <div
                  class="goods-name"
                  style="cursor: pointer"
                  @click="navToDetail(scope.row.id)"
                >
                  {{ item.goodsName }}
                </div>
              </el-tooltip>
              <div class="goods-spec">
                规格：<el-tag size="small" type="warning" effect="light">{{
                  item.spec || "默认规格"
                }}</el-tag>
                <span class="goods-num">x {{ item.num }}</span>
              </div>
            </div>
          </div>
        </template>
      </el-table-column>

      <el-table-column
        prop="totalPrice"
        label="订单总额"
        width="100"
        align="center"
      >
        <template #default="scope">
          <span style="color: #f56c6c; font-weight: bold"
            >￥{{ scope.row.totalPrice }}</span
          >
        </template>
      </el-table-column>

      <el-table-column
        v-if="data.activeStatus === '已取消'"
        prop="cancelReason"
        label="取消原因"
        min-width="120"
        align="center"
      >
        <template #default="scope">
          <span style="color: #999">{{
            scope.row.cancelReason || "未填写"
          }}</span>
        </template>
      </el-table-column>

      <el-table-column
        v-if="data.activeStatus === '售后'"
        prop="returnReason"
        label="退货原因"
        min-width="120"
        align="center"
      />

      <el-table-column
        v-if="data.activeStatus === '售后'"
        prop="expressNo"
        label="退货单号"
        min-width="150"
        align="center"
      >
        <template #default="scope">
          <el-tag v-if="scope.row.expressNo" type="info" size="small">{{
            scope.row.expressNo
          }}</el-tag>
          <span v-else style="color: #ccc">尚未回寄</span>
        </template>
      </el-table-column>

      <el-table-column
        prop="status"
        label="当前状态"
        width="120"
        align="center"
      >
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">{{
            scope.row.status
          }}</el-tag>
        </template>
      </el-table-column>

      <el-table-column label="操作" width="220" align="center">
        <template #default="scope">
          <el-button
            v-if="scope.row.status === '待发货'"
            type="warning"
            size="small"
            @click="doShip(scope.row.id)"
            >去发货</el-button
          >

          <template v-if="scope.row.status === '退货待审核'">
            <el-button
              type="primary"
              size="small"
              @click="approveReturn(scope.row.id)"
              >同意</el-button
            >
            <el-button
              type="danger"
              size="small"
              @click="rejectReturn(scope.row.id)"
              >拒绝</el-button
            >
          </template>

          <el-button
            v-if="scope.row.status === '待商家收货'"
            type="success"
            size="small"
            @click="confirmRefund(scope.row.id)"
            >确认退款</el-button
          >

          <el-button
            v-if="['已完成', '已取消', '已退款'].includes(scope.row.status)"
            type="danger"
            size="small"
            @click="delAdmin(scope.row.id)"
            >删除</el-button
          >

          <div v-if="scope.row.status === '待付款'" class="status-tip">
            等待支付
          </div>
          <div
            v-if="scope.row.status === '待用户发货'"
            class="status-tip tip-blue"
          >
            等待商品寄回
          </div>
          <div
            v-if="scope.row.status === '待收货'"
            class="status-tip tip-green"
          >
            物流中
          </div>
        </template>
      </el-table-column>
    </el-table>

    <div style="margin-top: 15px">
      <el-pagination
        @size-change="load"
        @current-change="load"
        v-model:current-page="data.pageNum"
        v-model:page-size="data.pageSize"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="data.total"
      />
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";

const data = reactive({
  tableData: [],
  orderNo: "",
  dateRange: null,
  activeStatus: "全部",
  loading: false,
  pageNum: 1,
  pageSize: 10,
  total: 0,
});

//  解析订单商品数据
const parseGoodsData = (goodsDataStr) => {
  try {
    return JSON.parse(goodsDataStr || "[]");
  } catch (e) {
    console.error("解析订单商品数据失败", e);
    return [];
  }
};

// 加载订单列表
const load = (pageNum) => {
  if (typeof pageNum === "number") {
    data.pageNum = pageNum;
  } else {
    data.pageNum = 1;
  }

  data.loading = true;
  let status = data.activeStatus === "全部" ? null : data.activeStatus;

  let startTime = null;
  let endTime = null;
  if (data.dateRange && data.dateRange.length === 2) {
    startTime = data.dateRange[0];
    endTime = data.dateRange[1];
  }

  request
    .get("/orders/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        orderNo: data.orderNo,
        status: status,
        startTime: startTime,
        endTime: endTime,
      },
    })
    .then((res) => {
      data.tableData = res.data.list || [];
      data.total = res.data.total || 0;
      setTimeout(() => {
        data.loading = false;
      }, 100);
    })
    .catch(() => {
      data.loading = false;
    });
};

// 重置查询条件
const reset = () => {
  data.orderNo = "";
  data.dateRange = null;
  data.activeStatus = "全部";
  data.pageNum = 1;
  load(1);
};
// 订单状态标签
const getStatusType = (status) => {
  if (status === "待发货" || status === "退货待审核") return "danger";
  if (status === "已完成" || status === "已退款") return "success";
  if (status === "待付款" || status === "待用户发货") return "warning";
  if (status === "已取消") return "info";
  return "info";
};

const doShip = (id) => {
  request.put("/orders/ship/" + id).then((res) => {
    if (res.code === "200") {
      ElMessage.success("操作成功，已通知物流发货");
      load();
    }
  });
};

const approveReturn = (id) => {
  ElMessageBox.confirm("确定批准该退货申请吗？", "审核确认")
    .then(() => {
      request
        .put("/orders/updateStatus", { id: id, status: "待用户发货" })
        .then((res) => {
          if (res.code === "200") {
            ElMessage.success("审核通过");
            load();
          }
        });
    })
    .catch(() => {});
};

const navToDetail = (id) => {
  location.href = "/manager/orderDetail?id=" + id;
};

// 拒绝退货申请
const rejectReturn = (id) => {
  ElMessageBox.prompt(
    "请输入拒绝退货的原因（如：商品不符合7天无理由要求）",
    "拒绝确认",
    {
      confirmButtonText: "确定拒绝",
      cancelButtonText: "取消",
      inputPattern: /\S+/,
      inputErrorMessage: "拒绝原因不能为空",
    },
  )
    .then(({ value }) => {
      request
        .put("/orders/rejectReturn", { id: id, rejectReason: value })
        .then((res) => {
          if (res.code === "200") {
            ElMessage.success("已驳回退货申请，订单状态已恢复为待用户收货");
            load();
          }
        });
    })
    .catch(() => {});
};

const confirmRefund = (id) => {
  ElMessageBox.confirm(
    "确认收到退货并执行退款？此操作将自动回滚库存。",
    "退款确认",
    { type: "warning" },
  )
    .then(() => {
      request.put("/orders/confirmReturn/" + id).then((res) => {
        if (res.code === "200") {
          ElMessage.success("退款成功，库存已返还");
          load();
        }
      });
    })
    .catch(() => {});
};

const delAdmin = (id) => {
  ElMessageBox.confirm("确定删除该后台记录吗？", "删除确认", { type: "error" })
    .then(() => {
      request.delete("/orders/deleteAdmin/" + id).then((res) => {
        if (res.code === "200") {
          ElMessage.success("删除成功");
          load();
        }
      });
    })
    .catch(() => {});
};

onMounted(() => load());
</script>

<style scoped>
.order-tabs {
  margin-bottom: 5px;
}
.ellipsis-text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
  color: #666;
}
.status-tip {
  font-size: 12px;
  color: #999;
}
.tip-blue {
  color: #409eff;
}
.tip-green {
  color: #67c23a;
}
.el-tag {
  min-width: 70px;
}
.goods-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  padding: 5px;
  background-color: #fcfcfc;
  border-radius: 4px;
}
.goods-img {
  width: 45px;
  height: 45px;
  border-radius: 4px;
  margin-right: 12px;
  border: 1px solid #eee;
}
.goods-info {
  flex: 1;
}
.goods-name {
  font-size: 13px;
  font-weight: bold;
  color: #333;
  margin-bottom: 3px;
}

.goods-spec {
  font-size: 12px;
  color: #666;
}
.goods-num {
  margin-left: 15px;
  color: #999;
  font-weight: bold;
}
</style>
