<template>
  <div>
    <div
      class="card"
      style="margin-bottom: 10px; display: flex; align-items: center"
    >
      <el-input
        v-model="data.username"
        placeholder="请输入账号查询"
        style="width: 260px; margin-right: 10px"
        clearable
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
      <el-button type="info" @click="reset()">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 10px">
      <el-table :data="data.tableData" stripe style="width: 100%">
        <el-table-column prop="username" label="账号" />
        <el-table-column prop="name" label="姓名/昵称" />
        <el-table-column prop="sex" label="性别" />

        <el-table-column label="账号状态" width="150">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              :active-value="1"
              :inactive-value="0"
              @change="changeStatus(scope.row)"
              active-text="启用"
              inactive-text="禁用"
              inline-prompt
            />
          </template>
        </el-table-column>
      </el-table>

      <div style="margin-top: 15px">
        <el-pagination
          @size-change="load(1)"
          @current-change="load"
          v-model:current-page="data.pageNum"
          v-model:page-size="data.pageSize"
          :page-sizes="[5, 10, 20]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="data.total"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  username: "",
});

// 获取用户列表
const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/user/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        username: data.username,
      },
    })
    .then((res) => {
      if (res.code === "200") {
        data.tableData = res.data.list;
        data.total = res.data.total;
      } else {
        ElMessage.error(res.msg);
      }
    });
};

// 修改用户状态（禁用/启用）
const changeStatus = (row) => {
  request.put("/user/updateStatus", row).then((res) => {
    if (res.code === "200") {
      ElMessage.success("状态更新成功");
    } else {
      ElMessage.error(res.msg);
      load();
    }
  });
};

// 重置搜索
const reset = () => {
  data.username = "";
  load(1);
};

// 页面加载
load(1);
</script>

<style scoped>
.card {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
</style>
