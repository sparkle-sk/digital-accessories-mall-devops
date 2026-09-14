import { ElMessage } from 'element-plus'
import router from '../router'
import axios from "axios";

const request = axios.create({
    baseURL: import.meta.env.VITE_BASE_URL,
    timeout: 30000  // 后台接口超时时间设置
})

// request 请求拦截器

request.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=utf-8';
    return config
}, error => {
    return Promise.reject(error)
});

// response 响应拦截器

request.interceptors.response.use(
    response => {
        let res = response.data;
        // 文件返回处理
        if (response.config.responseType === 'blob') {
            return res
        }
        // 字符串数据转JSON
        if (typeof res === 'string') {
            res = res ? JSON.parse(res) : res
        }
        
        // 权限不足，跳转登录
        if (res.code === '401') {
            ElMessage.error(res.msg);
            router.push("/login")
            return Promise.reject(res.msg) 
        }

        // 业务异常处理
        if (res.code !== '200') {
            if (res.msg !== '加购商品已紧急安排补货，敬请关注') {
                ElMessage.error(res.msg || '系统异常');
            }
            return Promise.reject(res.msg) 
        }

        return res;
    },
    error => {
        console.log('err' + error)
        return Promise.reject(error.message || error)
    }
)

export default request