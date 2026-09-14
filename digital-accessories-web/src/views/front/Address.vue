<template>
  <div class="main-content" style="width: 80%; margin: 20px auto">
    <div class="card" style="padding: 30px">
      <div
        style="
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 30px;
        "
      >
        <div style="font-size: 20px; font-weight: bold; color: #333">
          <el-icon style="vertical-align: middle; margin-right: 5px"
            ><Location
          /></el-icon>
          我的收货地址
        </div>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon> 新增收货地址
        </el-button>
      </div>

      <el-table :data="data.tableData" stripe border style="width: 100%">
        <el-table-column prop="name" label="收货人" width="120" />
        <el-table-column prop="phone" label="联系电话" width="150" />
        <el-table-column
          prop="address"
          label="详细地址"
          show-overflow-tooltip
        />
        <el-table-column label="默认状态" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.isDefault === 1" type="danger" effect="dark"
              >默认</el-tag
            >
            <el-tag v-else type="info" plain>普通</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" align="center">
          <template #default="scope">
            <el-button
              size="small"
              type="primary"
              link
              @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              size="small"
              type="danger"
              link
              @click="del(scope.row.id)"
              >删除</el-button
            >
            <el-button
              size="small"
              type="warning"
              link
              v-if="scope.row.isDefault === 0"
              @click="setDefault(scope.row)"
              >设为默认</el-button
            >
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog
      v-model="data.formVisible"
      :title="data.form.id ? '编辑地址' : '新增地址'"
      width="500px"
      destroy-on-close
    >
      <el-form
        :model="data.form"
        ref="formRef"
        :rules="rules"
        label-width="100px"
        style="padding-right: 30px"
      >
        <el-form-item label="收货人" prop="name">
          <el-input v-model="data.form.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="data.form.phone" placeholder="请输入11位手机号" />
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
          <el-input
            v-model="data.form.address"
            type="textarea"
            :rows="3"
            placeholder="需包含汉字"
          />
        </el-form-item>
        <el-form-item label="设为默认">
          <el-switch
            v-model="data.form.isDefault"
            :active-value="1"
            :inactive-value="0"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="data.formVisible = false">取消</el-button>
        <el-button type="primary" @click="save">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, onMounted, ref } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, Location } from "@element-plus/icons-vue";

const formRef = ref(null);
const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  tableData: [],
  formVisible: false,
  form: {},
});

const rules = reactive({
  name: [{ required: true, message: "姓名不能为空", trigger: "blur" }],
  phone: [
    { required: true, message: "电话不能为空", trigger: "blur" },
    { pattern: /^1[3-9]\d{9}$/, message: "手机号格式不正确", trigger: "blur" },
  ],
  address: [
    { required: true, message: "地址不能为空", trigger: "blur" },
    {
      pattern: /.*[\u4e00-\u9fa5].*/,
      message: "地址必须包含汉字",
      trigger: "blur",
    },
  ],
});

const load = () => {
  request
    .get("/address/selectAll", { params: { userId: data.user.id } })
    .then((res) => {
      data.tableData = res.data || [];
    });
};

const handleAdd = () => {
  data.form = { userId: data.user.id, isDefault: 0 };
  data.formVisible = true;
};

const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row));
  data.formVisible = true;
};
// 保存地址
const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      // 补全用户ID
      if (!data.form.userId) {
        data.form.userId = data.user.id;
      }
      // 区分新增/更新
      const api = data.form.id ? "/address/update" : "/address/add";
      const method = data.form.id ? "put" : "post";
      request[method](api, data.form).then((res) => {
        if (res.code === "200") {
          ElMessage.success("操作成功");
          data.formVisible = false;
          load();
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};

const del = (id) => {
  ElMessageBox.confirm("确认删除该收货地址吗？", "提示", { type: "warning" })
    .then(() => {
      request.delete("/address/delete/" + id).then((res) => {
        if (res.code === "200") {
          ElMessage.success("删除成功");
          load();
        }
      });
    })
    .catch(() => {});
};

const setDefault = (row) => {
  // 设置默认地址
  const item = {
    id: row.id,
    userId: row.userId ?? data.user.id,
    isDefault: 1,
  };
  request.put("/address/update", item).then((res) => {
    if (res.code === "200") {
      ElMessage.success("默认地址设置成功");
      load();
    } else {
      ElMessage.error(res.msg || "操作失败");
    }
  });
};

onMounted(() => {
  load();
});
</script>
