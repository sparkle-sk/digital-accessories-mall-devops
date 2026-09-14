<template>
  <div class="main-content" style="width: 80%; margin: 20px auto">
    <div
      style="
        margin-bottom: 25px;
        font-size: 24px;
        font-weight: bold;
        color: #2e3143;
        display: flex;
        align-items: center;
      "
    >
      <el-icon style="margin-right: 10px"><UserFilled /></el-icon> 个人信息资料
    </div>

    <div class="card info-card">
      <div
        style="
          width: 260px;
          text-align: center;
          border-right: 1px solid #eee;
          padding-right: 60px;
        "
      >
        <el-upload
          class="avatar-uploader"
          action="http://localhost:9090/files/upload"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
        >
          <div class="avatar-container">
            <img
              v-if="data.user.avatar"
              :src="data.user.avatar"
              class="avatar"
            />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            <div class="avatar-mask">
              <el-icon><CameraFilled /></el-icon>
              <div style="font-size: 12px; margin-top: 5px">修改头像</div>
            </div>
          </div>
        </el-upload>

        <div
          style="
            margin-top: 20px;
            font-weight: bold;
            font-size: 20px;
            color: #333;
          "
        >
          {{ data.user.name }}
        </div>
        <div style="margin-top: 10px; color: #777; font-size: 14px">
          账号名：{{ data.user.username }}
        </div>

        <div style="margin-top: 40px">
          <el-button type="primary" plain @click="data.passwordVisible = true"
            >修改登录密码</el-button
          >
        </div>
      </div>

      <div style="flex: 1">
        <div
          style="
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 30px;
            border-bottom: 2px solid #2e3143;
            padding-bottom: 10px;
            display: inline-block;
          "
        >
          账户基础资料设置
        </div>

        <el-form
          :model="data.user"
          :rules="rules"
          ref="formRef"
          label-width="100px"
          style="max-width: 550px"
        >
          <el-form-item label="登录账号" prop="username">
            <el-input
              v-model="data.user.username"
              placeholder="请输入新账号名"
            />
            <div style="font-size: 12px; color: #f56c6c; margin-top: 5px">
              提示：账号名每天限修改1次，修改后，下次登录需使用新账号名
            </div>
          </el-form-item>

          <el-form-item label="用户昵称" prop="name">
            <el-input v-model="data.user.name" />
          </el-form-item>

          <el-form-item label="性别">
            <el-radio-group v-model="data.user.sex">
              <el-radio label="男">男</el-radio>
              <el-radio label="女">女</el-radio>
              <el-radio label="保密">保密</el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item label="出生日期">
            <el-date-picker
              v-model="data.user.birthday"
              type="date"
              value-format="YYYY-MM-DD"
              placeholder="选择日期"
              style="width: 100%"
            />
          </el-form-item>

          <el-form-item style="margin-top: 40px">
            <el-button
              type="danger"
              size="large"
              @click="save"
              style="width: 160px; font-weight: bold"
              >提交保存修改</el-button
            >
          </el-form-item>
        </el-form>
      </div>
    </div>

    <el-dialog
      title="修改登录密码"
      v-model="data.passwordVisible"
      width="400px"
      destroy-on-close
    >
      <el-form :model="data.pw" label-width="85px" style="padding: 10px 20px">
        <el-form-item label="当前密码">
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
        <el-button type="primary" @click="updatePassword">确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, CameraFilled, UserFilled } from "@element-plus/icons-vue";
import router from "@/router";

const formRef = ref(null);
const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  passwordVisible: false,
  pw: { oldPassword: "", newPassword: "", confirmPassword: "" },
});

const rules = reactive({
  username: [{ required: true, message: "请输入账号名", trigger: "blur" }],
  name: [{ required: true, message: "请输入昵称", trigger: "blur" }],
});

const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      request.put("/user/update", data.user).then((res) => {
        if (res.code === "200") {
          if (res.data === "USER_CHANGED") {
            ElMessageBox.alert("账号名修改成功，请重新登录", "系统提示", {
              confirmButtonText: "确定",
              callback: () => {
                localStorage.removeItem("system-user");
                location.href = "/login";
              },
            });
          } else {
            ElMessage.success("资料保存成功");
            localStorage.setItem("system-user", JSON.stringify(data.user));
            window.dispatchEvent(new Event("userUpdated"));

            setTimeout(() => {
              router.push("/front/home");
            }, 500);
          }
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};

const updatePassword = () => {
  if (!data.pw.oldPassword || !data.pw.newPassword) {
    ElMessage.warning("请填写完整");
    return;
  }
  if (data.pw.newPassword !== data.pw.confirmPassword) {
    ElMessage.warning("两次新密码不一致");
    return;
  }
  const params = {
    id: data.user.id,
    oldPassword: data.pw.oldPassword,
    newPassword: data.pw.newPassword,
  };
  request.put("/user/updatePassword", params).then((res) => {
    if (res.code === "200") {
      ElMessage.success("密码修改成功，请重新登录");
      localStorage.removeItem("system-user");
      setTimeout(() => (location.href = "/login"), 1000);
    } else {
      ElMessage.error(res.msg);
    }
  });
};

const handleAvatarSuccess = (res) => {
  data.user.avatar = res.data;
  ElMessage.success("头像上传成功（点击下方保存后正式生效）");
};
</script>

<style scoped>
.avatar-container {
  position: relative;
  width: 160px;
  height: 160px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  border: 4px solid #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
.avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.avatar-mask {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  opacity: 0;
  transition: opacity 0.3s;
}
.avatar-container:hover .avatar-mask {
  opacity: 1;
}
.avatar-uploader-icon {
  font-size: 30px;
  color: #8c939d;
  width: 160px;
  height: 160px;
  line-height: 160px;
}

.info-card {
  background: #fff;
  padding: 40px;
  display: flex;
  gap: 60px;
  border-radius: 12px;
  border: 1.5px solid #999 !important;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12) !important;
}

:deep(.el-form-item__label) {
  font-weight: bold;
}
</style>
