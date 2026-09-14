<template>
  <div class="login-wrapper">
    <div class="dot-bg"></div>

    <div class="login-container">
      <div class="login-left">
        <div class="brand-content">
          <img src="@/assets/imgs/logo.png" class="brand-logo" alt="logo" />
          <h1>DIGITAL</h1>
          <p>数码配件销售管理系统</p>
          <div class="brand-tags">
            <span>高效</span>
            <span>安全</span>
            <span>智能</span>
          </div>
        </div>
      </div>

      <div class="login-right">
        <div class="form-header">
          <h2>欢迎登录</h2>
          <span>请使用您的账号和密码进行身份验证</span>
        </div>

        <el-form
          :model="data.form"
          ref="formRef"
          :rules="data.rules"
          size="large"
        >
          <el-form-item prop="username">
            <el-input
              v-model="data.form.username"
              prefix-icon="User"
              placeholder="请输入账号"
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="data.form.password"
              prefix-icon="Lock"
              show-password
              placeholder="请输入密码"
            />
          </el-form-item>
          <el-form-item prop="role">
            <el-select
              v-model="data.form.role"
              placeholder="选择登录角色"
              style="width: 100%"
            >
              <el-option label="普通用户" value="USER" />
              <el-option label="管理员" value="ADMIN" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" class="login-submit" @click="login"
              >登录</el-button
            >
          </el-form-item>
        </el-form>

        <div class="form-footer">
          <span>还没有账号？<a href="/register">点击注册新用户</a></span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import request from "@/utils/request";
import { ElMessage } from "element-plus";
import router from "@/router";
import { User, Lock } from "@element-plus/icons-vue";

const data = reactive({
  form: { role: "ADMIN" },
  rules: {
    username: [{ required: true, message: "请输入账号", trigger: "blur" }],
    password: [{ required: true, message: "请输入密码", trigger: "blur" }],
  },
});

const formRef = ref();

const login = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      request.post("/login", data.form).then((res) => {
        if (res.code === "200") {
          if (!res.data) {
            ElMessage.error("登录异常：服务器未返回用户信息");
            return;
          }

          localStorage.setItem("system-user", JSON.stringify(res.data));
          ElMessage.success("登录成功");

          // 根据角色调转不同页面
          if (res.data.role === "ADMIN") {
            router.push("/manager/home");
          } else {
            router.push("/front/home");
          }
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};
</script>

<style scoped>
.login-wrapper {
  height: 100vh;
  background-color: #f0f2f5;
  background-image: linear-gradient(120deg, #e0c3fc 0%, #8ec5fc 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
}

.dot-bg {
  position: absolute;
  width: 100%;
  height: 100%;
  background-image: radial-gradient(#ffffff 1px, transparent 1px);
  background-size: 30px 30px;
  opacity: 0.3;
}

.login-container {
  width: 1000px;
  height: 600px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  display: flex;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  z-index: 1;
  overflow: hidden;
}

.login-left {
  flex: 1.2;
  background: #2e3143;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  position: relative;
}

.brand-content {
  text-align: center;
}

.brand-logo {
  width: 80px;
  margin-bottom: 20px;
  filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.5));
}

.brand-content h1 {
  font-size: 48px;
  letter-spacing: 4px;
  margin-bottom: 5px;
  background: linear-gradient(to bottom, #fff, #999);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.brand-tags {
  margin-top: 30px;
}

.brand-tags span {
  padding: 5px 15px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  margin: 0 5px;
  font-size: 12px;
  color: #ccc;
}

.login-right {
  flex: 1;
  padding: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.form-header {
  margin-bottom: 40px;
}

.form-header h2 {
  font-size: 32px;
  color: #1f2937;
  margin-bottom: 8px;
}

.form-header span {
  color: #6b7280;
  font-size: 14px;
}

.login-submit {
  width: 100%;
  height: 50px;
  font-weight: bold;
  font-size: 16px;
  background-color: #2e3143;
  border: none;
  border-radius: 12px;
  transition: all 0.3s;
}

.login-submit:hover {
  background-color: #43475e;
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.form-footer {
  margin-top: 24px;
  text-align: center;
  font-size: 14px;
  color: #4b5563;
}

.form-footer a {
  color: #4f46e5;
  text-decoration: none;
  font-weight: 600;
  margin-left: 5px;
}

@media (max-width: 1024px) {
  .login-left {
    display: none;
  }
  .login-container {
    width: 450px;
  }
}
</style>
