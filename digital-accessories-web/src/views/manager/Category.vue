<template>
  <div>
    <div class="card" style="margin-bottom: 10px">
      <el-input
        v-model="data.name"
        placeholder="请输入分类名称查询"
        style="width: 260px; margin-right: 10px"
        clearable
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
      <el-button type="info" @click="reset">重置</el-button>
    </div>
    <div class="card" style="margin-bottom: 10px">
      <el-button type="primary" @click="handleAdd">新增</el-button>
    </div>
    <div class="card" style="margin-bottom: 10px">
      <el-table :data="data.tableData" stripe>
        <el-table-column prop="name" label="分类名称" />
        <el-table-column prop="description" label="分类描述" />
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              type="danger"
              size="small"
              @click="handleDelete(scope.row.id)"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 15px">
        <el-pagination
          @size-change="load(1)"
          @current-change="load"
          v-model:current-page="data.pageNum"
          v-model:page-size="data.pageSize"
          :page-sizes="[1, 5, 10, 20]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="data.total"
        />
      </div>
    </div>

    <el-dialog
      v-model="data.formVisible"
      title="分类信息"
      width="40%"
      destroy-on-close
    >
      <el-form
        :model="data.form"
        label-width="80px"
        style="padding-right: 20px"
      >
        <el-form-item label="分类名称">
          <el-input v-model="data.form.name" />
        </el-form-item>
        <el-form-item label="分类描述">
          <el-input type="textarea" v-model="data.form.description" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="data.formVisible = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10, //默认每页显示 10 条
  name: "",
  formVisible: false,
  form: {},
});

const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/category/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        name: data.name,
      },
    })
    .then((res) => {
      data.tableData = res.data?.list || [];
      data.total = res.data?.total || 0;
    });
};
const handleAdd = () => {
  data.form = {};
  data.formVisible = true;
};
const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row));
  data.formVisible = true;
};
const save = () => {
  request[data.form.id ? "put" : "post"](
    data.form.id ? "/category/update" : "/category/add",
    data.form,
  ).then((res) => {
    if (res.code === "200") {
      ElMessage.success("操作成功");
      data.formVisible = false;
      load();
    } else {
      ElMessage.error(res.msg);
    }
  });
};
const handleDelete = (id) => {
  ElMessageBox.confirm("确认删除吗？", "提示", { type: "warning" }).then(() => {
    request.delete("/category/delete/" + id).then((res) => {
      if (res.code === "200") {
        ElMessage.success("删除成功");
        load();
      }
    });
  });
};
const reset = () => {
  data.name = "";
  load(1);
};
load();
</script>
