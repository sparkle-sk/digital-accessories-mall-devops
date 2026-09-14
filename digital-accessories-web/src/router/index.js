import {createRouter, createWebHistory} from 'vue-router'
import { ElMessage } from 'element-plus' // [最新修改前端代码 - 引入组件弹窗提示组件]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/front/home' },
    
    // 管理员后台路由
    {
      path: '/manager',
      component: () => import('@/views/Manager.vue'),
      redirect: '/manager/home',
      children: [
        { path: 'home', component: () => import('@/views/manager/Home.vue')},
        { path: 'admin', component: () => import('@/views/manager/Admin.vue') },
        { path: 'category', component: () => import('@/views/manager/Category.vue') },
        { path: 'goods', component: () => import('@/views/manager/Goods.vue') },
        { path: 'banner', component: () => import('@/views/manager/Banner.vue') },
        { path: 'orders', component: () => import('@/views/manager/Orders.vue') },
        { path: 'report', component: () => import('@/views/manager/DataReport.vue') },
        { path: 'file', component: () => import('@/views/manager/File.vue') },
        { path: 'user', component: () => import('@/views/manager/UserManage.vue') },
        { 
          path: 'orderDetail', 
          name: 'ManagerOrderDetail', 
          meta: { name: '订单详情' }, 
          component: () => import('@/views/manager/OrderDetail.vue') 
        },
      ]
    },

    // 前台商城路由
    {
      path: '/front',
      component: () => import('@/views/front/Front.vue'),
      redirect: '/front/home',
      children: [
        { path: 'home', component: () => import('@/views/front/Home.vue') },
        { path: 'person', component: () => import('@/views/front/Person.vue') },
        { path: 'detail', component: () => import('@/views/front/GoodsDetail.vue') },
        { path: 'cart', component: () => import('@/views/front/Cart.vue') },
        { path: 'orders', component: () => import('@/views/front/Orders.vue') },
        { path: 'collect', component: () => import('@/views/front/Collect.vue') },
        { path: 'address', component: () => import('@/views/front/Address.vue') },
        { path: 'orderDetail', component: () => import('@/views/front/OrderDetail.vue') },
      ]
    },

    // 登录与注册
    { path: '/login', component: () => import('@/views/Login.vue') },
    { path: '/register', component: () => import('@/views/Register.vue') }
  ]
})


  // 全局路由守卫
 
router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('system-user') || '{}');

  // 校验管理员权限
  if (to.path.startsWith('/manager')) {
    if (!user.id || user.role !== 'ADMIN') {
      ElMessage.error('权限不足，请使用管理员账号登录！');
      return next('/login'); 
    }
  }

  // 前台登录校验
  const authFrontPaths = [
    '/front/cart', 
    '/front/orders', 
    '/front/person', 
    '/front/collect', 
    '/front/address', 
    '/front/orderDetail'
  ];
  
  if (authFrontPaths.includes(to.path)) {
    if (!user.id) {
      ElMessage.warning('请先登录后再进行操作！');
      return next('/login');
    }
  }

  next();
});

export default router