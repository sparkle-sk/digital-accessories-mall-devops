<template>
  <div class="front-container">
    <div class="front-header">
      <div class="front-header-left">
        <img src="@/assets/imgs/logo.png" alt="logo" />
        <div
          class="title"
          @click="router.push('/front/home')"
          style="cursor: pointer"
        >
          数码配件商城
        </div>

        <el-link
          @click="router.push('/front/home')"
          :underline="false"
          class="nav-item"
          :class="{
            'nav-active': router.currentRoute.value.path === '/front/home',
          }"
          style="margin-left: 30px"
        >
          <el-icon style="margin-right: 3px"><HomeFilled /></el-icon>首页
        </el-link>
      </div>

      <div
        class="front-header-center"
        style="display: flex; align-items: center; padding-left: 50px"
      >
        <div style="width: 375px">
          <el-input
            v-model="data.name"
            placeholder="搜一搜心仪的配件..."
            :prefix-icon="Search"
            clearable
            @keyup.enter="search"
            @clear="handleClear"
            class="search-input"
          >
            <template #append>
              <el-button :icon="Search" @click="search" />
            </template>
          </el-input>
        </div>
      </div>

      <div class="front-header-right">
        <div class="header-links">
          <el-link
            @click="router.push('/front/cart')"
            :underline="false"
            class="nav-item"
            :class="{
              'nav-active': router.currentRoute.value.path === '/front/cart',
            }"
          >
            <el-icon style="margin-right: 3px"><ShoppingCart /></el-icon
            >我的购物车
          </el-link>

          <el-link
            @click="router.push('/front/collect')"
            :underline="false"
            class="nav-item"
            :class="{
              'nav-active': router.currentRoute.value.path === '/front/collect',
            }"
            style="margin-left: 10px"
          >
            <el-icon style="margin-right: 3px"><StarFilled /></el-icon>我的收藏
          </el-link>

          <el-link
            @click="router.push('/front/orders')"
            :underline="false"
            class="nav-item"
            :class="{
              'nav-active': router.currentRoute.value.path === '/front/orders',
            }"
            style="margin-left: 10px"
          >
            <el-icon style="margin-right: 3px"><List /></el-icon>我的订单
          </el-link>
        </div>

        <div v-if="!data.user.id" style="margin-left: 20px">
          <el-button size="small" @click="router.push('/login')"
            >登录</el-button
          >
          <el-button
            type="primary"
            size="small"
            @click="router.push('/register')"
            >注册</el-button
          >
        </div>
        <div v-else class="user-info" style="margin-left: 20px">
          <el-dropdown trigger="hover">
            <div
              class="el-dropdown-link"
              style="display: flex; align-items: center; cursor: pointer"
            >
              <el-avatar
                :size="30"
                :src="
                  data.user.avatar ||
                  'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
                "
              />
              <span style="margin-left: 10px; font-size: 14px; color: #333">{{
                data.user.name
              }}</span>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="router.push('/front/person')"
                  >个人信息</el-dropdown-item
                >
                <el-dropdown-item @click="router.push('/front/cart')"
                  >我的购物车</el-dropdown-item
                >
                <el-dropdown-item @click="router.push('/front/collect')"
                  >我的收藏</el-dropdown-item
                >
                <el-dropdown-item @click="router.push('/front/address')"
                  >收货地址</el-dropdown-item
                >
                <el-dropdown-item @click="router.push('/front/orders')"
                  >我的订单</el-dropdown-item
                >
                <el-dropdown-item divided @click="logout" style="color: #f56c6c"
                  >退出登录</el-dropdown-item
                >
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </div>
    <div class="front-main">
      <router-view @updateUser="updateUser" />
    </div>
  </div>
</template>

<script setup>
import {
  HomeFilled,
  ShoppingCart,
  StarFilled,
  List,
  Search,
} from "@element-plus/icons-vue";
import { reactive, onMounted, onUnmounted, watch } from "vue";
import { useRoute } from "vue-router";
import router from "@/router";

const route = useRoute();

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  name: "",
});

watch(
  () => route.query.name,
  (newName) => {
    data.name = newName || "";
  },
  { immediate: true },
);

const search = () => {
  router.push({ path: "/front/home", query: { name: data.name } });
};

const handleClear = () => {
  data.name = "";
  router.push("/front/home");
};

const logout = () => {
  localStorage.removeItem("system-user");
  router.push("/login");
};

const updateUser = () => {
  data.user = JSON.parse(localStorage.getItem("system-user") || "{}");
};

// 监听用户信息更新
onMounted(() => {
  window.addEventListener("userUpdated", updateUser);
});

// 移除监听
onUnmounted(() => {
  window.removeEventListener("userUpdated", updateUser);
});
</script>

<style scoped>
.front-header {
  height: 60px;
  background: #fff;
  display: flex;
  align-items: center;
  padding: 0 40px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}
.front-header-left {
  display: flex;
  align-items: center;
  width: 450px;
}
.front-header-left img {
  width: 35px;
  margin-right: 10px;
}
.front-header-left .title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}
.front-header-center {
  flex: 1;
}
.front-header-right {
  display: flex;
  align-items: center;
}
.search-input :deep(.el-input__wrapper) {
  border-radius: 20px 0 0 20px;
}
.search-input :deep(.el-input-group__append) {
  border-radius: 0 20px 20px 0;
  background-color: #2e3143;
  color: white;
  border: none;
}
.nav-item {
  padding: 8px 18px;
  border-radius: 6px;
  transition: all 0.2s ease;
  font-size: 14px;
  color: #606266;
}
.nav-active {
  background-color: #2e3143 !important;
  color: #ffffff !important;
  font-weight: bold;
}
.front-main {
  width: 80%;
  margin: 20px auto;
}
.el-dropdown-link:focus,
.el-dropdown-link:focus-visible {
  outline: none;
}
</style>
