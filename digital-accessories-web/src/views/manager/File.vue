<template>
  <div>
    <div
      class="card"
      style="margin-bottom: 10px; display: flex; gap: 10px; align-items: center"
    >
      <el-input
        v-model="data.name"
        placeholder="请输入文件名称查询"
        style="width: 260px"
        clearable
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
      <el-button type="info" @click="reset">重置</el-button>

      <el-upload
        action="http://localhost:9090/files/upload"
        :data="{ type: 'manual' }"
        :on-success="handleUploadSuccess"
        :show-file-list="false"
        style="display: inline-block; margin-left: 10px"
      >
        <el-button type="primary">上传新文件</el-button>
      </el-upload>
      <el-button type="info" @click="load(1)">刷新列表</el-button>
    </div>

    <div class="card">
      <el-table :data="data.tableData" stripe border style="width: 100%">
        <el-table-column label="文件预览" width="120" align="center">
          <template #default="scope">
            <el-image
              v-if="isImage(scope.row.url)"
              :src="scope.row.url"
              :preview-src-list="[scope.row.url]"
              style="width: 50px; height: 50px; border-radius: 5px"
              preview-teleported
            />
            <el-icon v-else style="font-size: 30px; color: #909399"
              ><Document
            /></el-icon>
          </template>
        </el-table-column>
        <el-table-column
          prop="name"
          label="文件名"
          min-width="200"
          show-overflow-tooltip
        />
        <el-table-column prop="url" label="下载/预览地址" min-width="300" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="copyUrl(scope.row.url)"
              >复制链接</el-button
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
          :page-sizes="[5, 10, 20]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="data.total"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { Document } from "@element-plus/icons-vue";

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  name: "",
});

// 加载文件列表
const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/files/selectPage", {
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

// 重置搜索
const reset = () => {
  data.name = "";
  load(1);
};

// 文件上传成功后执行
const handleUploadSuccess = (res) => {
  if (res.code === "200") {
    ElMessage.success("文件上传成功");
    load(1);
  } else {
    ElMessage.error(res.msg);
  }
};

// 复制文件链接
const copyUrl = (url) => {
  const input = document.createElement("input");
  input.value = url;
  document.body.appendChild(input);
  input.select();
  document.execCommand("copy");
  document.body.removeChild(input);
  ElMessage.success("链接已复制到剪贴板");
};

// 删除文件
const handleDelete = (id) => {
  ElMessageBox.confirm("确认永久删除该文件吗？", "警告", {
    type: "error",
  }).then(() => {
    request.delete("/files/delete/" + id).then((res) => {
      if (res.code === "200") {
        ElMessage.success("删除成功");
        load();
      }
    });
  });
};

// 判断文件是不是图片
const isImage = (url) => {
  if (!url) return false;
  const extension = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
  return ["jpg", "jpeg", "png", "gif", "webp"].includes(extension);
};

onMounted(() => {
  load();
});
</script>
