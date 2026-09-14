<template>
  <div class="manager-container">
    <div class="manager-sidebar">
      <div class="sidebar-header">
        <img src="@/assets/imgs/logo.png" alt="logo" />
        <div v-show="!data.isCollapse" class="logo-text">数码配件销售系统</div>
      </div>

      <el-menu
        router
        :default-active="router.currentRoute.value.path"
        :collapse="data.isCollapse"
        class="custom-menu"
      >
        <el-menu-item index="/manager/home">
          <el-icon><HomeFilled /></el-icon>
          <span>系统首页</span>
        </el-menu-item>

        <el-menu-item index="/manager/category">
          <el-icon><MenuIcon /></el-icon>
          <span>分类管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/goods">
          <el-icon><ShoppingBag /></el-icon>
          <span>数码配件管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/banner">
          <el-icon><Picture /></el-icon>
          <span>轮播图管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/orders">
          <el-icon><List /></el-icon>
          <span>订单管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/report">
          <el-icon><PieChart /></el-icon> <span>数据报表管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/file">
          <el-icon><Document /></el-icon>
          <span>文件管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/user">
          <el-icon><Avatar /></el-icon>
          <span>用户账号管理</span>
        </el-menu-item>

        <el-menu-item index="/manager/admin">
          <el-icon><Avatar /></el-icon>
          <span>管理员信息</span>
        </el-menu-item>

        <el-menu-item @click="logout" class="logout-item">
          <el-icon><SwitchButton /></el-icon>
          <span>退出登录</span>
        </el-menu-item>
      </el-menu>
    </div>

    <div class="manager-main">
      <div class="manager-header">
        <div class="header-left">
          <el-icon
            class="collapse-btn"
            @click.prevent="data.isCollapse = !data.isCollapse"
          >
            <Expand v-if="data.isCollapse" />
            <Fold v-else />
          </el-icon>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item>管理中心</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentMenuName }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>

        <div class="header-right">
          <el-dropdown trigger="hover">
            <div
              class="user-info"
              style="
                cursor: pointer;
                outline: none;
                display: flex;
                align-items: center;
                gap: 8px;
              "
            >
              <span class="user-name">{{
                data.user.name || "系统管理员"
              }}</span>
              <el-image
                class="user-avatar"
                :src="
                  data.user.avatar ||
                  'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
                "
              />
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item
                  @click="
                    router.push('/manager/admin?username=' + data.user.username)
                  "
                >
                  <el-icon><User /></el-icon>个人信息
                </el-dropdown-item>
                <el-dropdown-item
                  divided
                  @click="logout"
                  style="color: #f56c6c"
                >
                  <el-icon><SwitchButton /></el-icon>退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <div class="manager-content">
        <router-view @updateUser="updateUser" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, computed } from "vue";
import router from "@/router";
import { ElMessage } from "element-plus";
import {
  HomeFilled,
  User,
  SwitchButton,
  Menu as MenuIcon,
  Expand,
  Fold,
  Avatar,
  ShoppingBag,
  Picture,
  List,
  PieChart,
  Document,
} from "@element-plus/icons-vue";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  isCollapse: false,
});

const currentMenuName = computed(() => {
  const path = router.currentRoute.value.path;
  if (path.includes("home")) return "系统首页";
  if (path.includes("user")) return "用户管理";
  if (path.includes("admin")) return "管理员信息";
  if (path.includes("category")) return "分类管理";
  if (path.includes("goods")) return "数码配件管理";
  if (path.includes("banner")) return "轮播图管理";
  if (path.includes("orderDetail")) return "订单详情";
  if (path.includes("orders")) return "订单管理";
  if (path.includes("report")) return "数据报表管理";
  if (path.includes("file")) return "文件管理";
  return "功能页";
});

// 登录拦截
if (!data.user?.id) {
  router.push("/login");
}

const logout = () => {
  localStorage.removeItem("system-user");
  router.push("/login");
  ElMessage.success("已安全退出");
};

const updateUser = () => {
  data.user = JSON.parse(localStorage.getItem("system-user") || "{}");
};
</script>

<style scoped>
.manager-container {
  display: flex;
  height: 100vh;
  background-color: #f5f7fa;
}

.manager-sidebar {
  background-color: #2e3143;
  /* transition: width 0.3s; */
  width: v-bind('data.isCollapse ? "64px" : "240px"');
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 15px;
  background: rgba(255, 255, 255, 0.05);
}

.sidebar-header img {
  width: 32px;
  margin-right: 10px;
}

.logo-text {
  color: white;
  font-weight: bold;
  font-size: 18px;
  white-space: nowrap;
}

.custom-menu {
  border-right: none !important;
  background: transparent !important;
  flex: 1;
}

:deep(.el-menu),
:deep(.el-menu-item),
:deep(.el-sub-menu__title),
:deep(.el-menu--inline) {
  background-color: #2e3143 !important;
  color: #b1b3be !important;
}

:deep(.el-menu-item:hover),
:deep(.el-sub-menu__title:hover) {
  background-color: rgba(255, 255, 255, 0.1) !important;
  color: #fff !important;
}

:deep(.el-menu-item.is-active) {
  background-color: #43475e !important;
  color: #fff !important;
  border-radius: 8px;
  margin: 4px 8px;
  width: calc(100% - 16px);
}

.manager-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.manager-header {
  height: 60px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  margin-right: 20px;
}

.header-left {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-name {
  font-weight: 500;
  color: #303133;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 2px solid #e4e7ed;
  object-fit: cover;
}

.manager-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-image: radial-gradient(#dcdfe6 1px, transparent 1px);
  background-size: 20px 20px;
}
</style>

<style>
.el-menu--popup {
  background-color: #2e3143 !important;
  padding: 5px !important;
  border-radius: 8px !important;
}

.el-menu--popup .el-menu-item {
  color: #b1b3be !important;
}

.el-menu--popup .el-menu-item:hover {
  background-color: #409eff !important;
  color: #fff !important;
}
</style>
