<template>
  <div>
    <div class="card" style="margin-bottom: 10px">
      <el-input
        v-model="data.title"
        placeholder="请输入名称查询"
        style="width: 260px; margin-right: 10px"
        clearable
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
      <el-button type="info" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 10px">
      <el-button type="primary" @click="handleAdd">新增轮播图</el-button>
    </div>

    <div class="card">
      <el-table :data="data.tableData" stripe border>
        <el-table-column prop="title" label="轮播图名称" />
        <el-table-column label="轮播图预览">
          <template #default="scope">
            <el-image
              :src="scope.row.img"
              style="width: 100px; height: 60px; border-radius: 5px"
              :preview-src-list="[scope.row.img]"
              preview-teleported
            />
          </template>
        </el-table-column>
        <el-table-column prop="goodsId" label="关联商品ID" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.goodsId" type="success"
              >商品 ID: {{ scope.row.goodsId }}</el-tag
            >
            <el-tag v-else type="info">无跳转</el-tag>
          </template>
        </el-table-column>
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
          :total="data.total"
          layout="total, prev, pager, next"
        />
      </div>
    </div>

    <el-dialog
      v-model="data.formVisible"
      title="轮播图信息"
      width="35%"
      destroy-on-close
    >
      <el-form
        :model="data.form"
        label-width="100px"
        style="padding-right: 20px"
      >
        <el-form-item label="备注标题">
          <el-input v-model="data.form.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="轮播图片">
          <el-upload
            action="http://localhost:9090/files/upload"
            :on-success="handleImgSuccess"
            :show-file-list="false"
          >
            <el-button type="primary">点击上传图片</el-button>
          </el-upload>
          <img
            v-if="data.form.img"
            :src="data.form.img"
            style="
              width: 100%;
              margin-top: 10px;
              border-radius: 5px;
              border: 1px solid #ddd;
            "
          />
        </el-form-item>
        <el-form-item label="关联商品ID">
          <el-input-number
            v-model="data.form.goodsId"
            :min="1"
            placeholder="填入商品ID点击可跳转"
            style="width: 100%"
          />
          <div
            style="
              font-size: 12px;
              color: #999;
              line-height: 1.2;
              margin-top: 5px;
            "
          >
            提示：请填入商品配件列表中的ID，用户在前台点击此图将直接跳转至该商品详情页。
          </div>
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
import { reactive, onMounted } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  title: "",
  formVisible: false,
  form: {},
});

const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/banner/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        title: data.title,
      },
    })
    .then((res) => {
      data.tableData = res.data?.list || [];
      data.total = res.data?.total || 0;
    });
};

const handleAdd = () => {
  data.form = { img: "", title: "", goodsId: null };
  data.formVisible = true;
};

const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row));
  data.formVisible = true;
};

const handleImgSuccess = (res) => {
  if (res.code === "200") data.form.img = res.data;
};

const save = () => {
  request[data.form.id ? "put" : "post"](
    data.form.id ? "/banner/update" : "/banner/add",
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
    request.delete("/banner/delete/" + id).then((res) => {
      if (res.code === "200") {
        ElMessage.success("删除成功");
        load();
      }
    });
  });
};

const reset = () => {
  data.title = "";
  load(1);
};
onMounted(() => {
  load();
});
</script>
