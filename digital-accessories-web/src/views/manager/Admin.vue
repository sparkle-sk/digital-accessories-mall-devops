<template>
  <div>
    <div
      class="card"
      style="
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        justify-content: space-between;
      "
    >
      <div>
        <el-button
          v-if="route.query.username"
          type="warning"
          @click="goBack()"
          style="margin-right: 15px"
        >
          <el-icon><ArrowLeft /></el-icon> 返回列表
        </el-button>
        <el-input
          v-model="data.username"
          placeholder="请输入账号查询"
          style="width: 260px; margin-right: 10px"
          clearable
          :disabled="!!route.query.username"
        />
        <el-button
          type="primary"
          @click="load(1)"
          :disabled="!!route.query.username"
          >查询</el-button
        >
        <el-button
          type="info"
          @click="reset()"
          :disabled="!!route.query.username"
          >重置</el-button
        >
      </div>
      <div v-if="!route.query.username">
        <el-button type="primary" @click="handleAdd()">新增管理员</el-button>
      </div>
    </div>

    <div class="card" style="margin-bottom: 10px">
      <el-table :data="data.tableData" stripe style="width: 100%">
        <el-table-column prop="username" label="账号" />
        <el-table-column prop="name" label="姓名" />
        <el-table-column label="头像">
          <template #default="scope">
            <el-image
              style="width: 40px; height: 40px; border-radius: 50%"
              :src="
                scope.row.avatar ||
                'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
              "
              :preview-src-list="[scope.row.avatar]"
              preview-teleported
            />
          </template>
        </el-table-column>
        <el-table-column label="角色">
          <template #default>
            <el-tag type="success">管理员</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="180">
          <template #default="scope">
            <div
              v-if="scope.row.id === data.user.id"
              style="display: flex; gap: 10px"
            >
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
            </div>
            <el-tag v-else type="info" size="small">没有权限</el-tag>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 15px" v-if="!route.query.username">
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

    <el-dialog
      v-model="data.formVisible"
      title="管理员个人信息设置"
      width="45%"
      destroy-on-close
    >
      <div style="display: flex; gap: 40px; padding: 20px">
        <div
          style="
            width: 160px;
            display: flex;
            flex-direction: column;
            align-items: center;
            border-right: 1px solid #eee;
            padding-right: 40px;
          "
        >
          <img
            :src="
              data.form.avatar ||
              'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
            "
            style="
              width: 120px;
              height: 120px;
              border-radius: 50%;
              border: 1px solid #eee;
              object-fit: cover;
            "
          />

          <el-upload
            action="http://localhost:9090/files/upload"
            :on-success="handleAvatarSuccess"
            :show-file-list="false"
            style="margin-top: 20px"
          >
            <el-button type="primary" size="small" plain style="width: 120px"
              >更换头像图片</el-button
            >
          </el-upload>

          <div style="margin-top: 15px">
            <el-button
              v-if="data.form.id"
              type="danger"
              size="small"
              plain
              @click="data.passwordVisible = true"
              style="width: 120px"
              >修改登录密码</el-button
            >
          </div>
        </div>

        <div style="flex: 1">
          <el-form :model="data.form" label-width="80px">
            <el-form-item label="登录账号">
              <el-input
                v-model="data.form.username"
                placeholder="请输入新账号"
              />
              <div
                v-if="data.form.id"
                style="font-size: 12px; color: #f56c6c; margin-top: 4px"
              >
                提示：账号名每天限修改1次
              </div>
            </el-form-item>
            <el-form-item label="登录密码" v-if="!data.form.id">
              <el-input show-password v-model="data.form.password" />
            </el-form-item>
            <el-form-item label="姓名">
              <el-input v-model="data.form.name" />
            </el-form-item>
            <el-form-item label="角色">
              <el-tag type="info">管理员</el-tag>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <template #footer>
        <el-button @click="data.formVisible = false">取消</el-button>
        <el-button type="primary" @click="save()">确认修改</el-button>
      </template>
    </el-dialog>

    <el-dialog
      title="修改密码"
      v-model="data.passwordVisible"
      width="400px"
      destroy-on-close
    >
      <el-form :model="data.pw" label-width="85px" style="padding: 10px 20px">
        <el-form-item label="原密码">
          <el-input v-model="data.pw.oldPassword" show-password />
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="data.pw.newPassword" show-password />
        </el-form-item>
        <el-form-item label="确认密码">
          <el-input v-model="data.pw.confirmPassword" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="data.passwordVisible = false">取消</el-button>
        <el-button type="primary" @click="updatePassword()">确定修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { ArrowLeft } from "@element-plus/icons-vue";
import { onMounted, onUnmounted } from "vue";

const route = useRoute();
const router = useRouter();
const emit = defineEmits(["updateUser"]);

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  username: route.query.username || "",
  formVisible: false,
  form: {},
  passwordVisible: false,
  pw: {},
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
});
const updateUserInfo = () => {
  data.user = JSON.parse(localStorage.getItem("system-user") || "{}");
};

onMounted(() => {
  // 监听用户信息更新
  window.addEventListener("userUpdated", updateUserInfo);
});

onUnmounted(() => {
  // 移除监听
  window.removeEventListener("userUpdated", updateUserInfo);
});
watch(
  () => route.query.username,
  (newVal) => {
    data.username = newVal || "";
    load(1);
  },
);

const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/admin/selectPage", {
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
      }
    });
};

const save = () => {
  const method = data.form.id ? "put" : "post";
  request[method]("/admin/update", data.form).then((res) => {
    if (res.code === "200") {
      if (res.data === "LOGOUT") {
        forceLogout("账号名已修改成功，系统将强制退出，请重新登录");
      } else {
        ElMessage.success("保存成功");
        updateLocalCache();
        data.formVisible = false;
        load();
      }
    } else {
      ElMessage.error(res.msg);
    }
  });
};

const updatePassword = () => {
  if (data.pw.newPassword !== data.pw.confirmPassword) {
    ElMessage.error("两次输入的新密码不一致");
    return;
  }
  const params = {
    id: data.form.id,
    oldPassword: data.pw.oldPassword,
    newPassword: data.pw.newPassword,
  };
  request.put("/admin/updatePassword", params).then((res) => {
    if (res.code === "200") {
      forceLogout("密码已重置成功，请重新登录");
    } else {
      ElMessage.error(res.msg);
    }
  });
};

const handleDelete = (id) => {
  const isSelf = id === data.user.id;
  const tipMessage = isSelf
    ? "此操作不可恢复，删除账号将立即退出登录，确认注销您的账号吗？"
    : "确认要删除该管理员账号吗？";

  ElMessageBox.confirm(tipMessage, "严重警告", {
    confirmButtonText: "确定删除",
    cancelButtonText: "取消",
    type: "error",
  })
    .then(() => {
      request.delete("/admin/delete/" + id).then((res) => {
        if (res.code === "200") {
          if (isSelf) {
            localStorage.removeItem("system-user");
            location.href = "/login";
          } else {
            ElMessage.success("账号已删除");
            load();
          }
        }
      });
    })
    .catch(() => {});
};

const forceLogout = (msg) => {
  ElMessageBox.alert(msg, "系统提示", {
    confirmButtonText: "确定",
    callback: () => {
      localStorage.removeItem("system-user");
      location.href = "/login";
    },
  });
};

const updateLocalCache = () => {
  if (data.form.id === data.user.id) {
    localStorage.setItem(
      "system-user",
      JSON.stringify(Object.assign({}, data.user, data.form)),
    );
    emit("updateUser");
  }
};

const goBack = () => router.push("/manager/admin");
const reset = () => {
  data.username = "";
  load(1);
};
const handleAdd = () => {
  data.form = { role: "ADMIN", avatar: "" };
  data.formVisible = true;
};
const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row));
  data.formVisible = true;
};
const handleAvatarSuccess = (res) => {
  if (res.code === "200") data.form.avatar = res.data;
};

load();
</script>
