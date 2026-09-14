<template>
  <div>
    <div class="card" style="margin-bottom: 10px">
      <el-input
        v-model="data.name"
        placeholder="请输入商品名称查询"
        style="width: 260px; margin-right: 10px"
        clearable
      />
      <el-button type="primary" @click="load(1)">查询</el-button>
      <el-button type="info" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 10px">
      <el-button type="primary" @click="handleAdd">录入新配件</el-button>
    </div>

    <div class="card">
      <el-table :data="data.tableData" stripe border style="width: 100%">
        <el-table-column label="配件名称" width="300" align="center">
          <template #default="scope">
            <el-tooltip effect="dark" :content="scope.row.name" placement="top">
              <span class="line-ellipsis" style="font-weight: bold">{{
                scope.row.name
              }}</span>
            </el-tooltip>
          </template>
        </el-table-column>

        <el-table-column label="图片" width="100" align="center">
          <template #default="scope">
            <el-image
              :src="scope.row.img"
              fit="contain"
              style="
                width: 50px;
                height: 50px;
                border-radius: 5px;
                background: #f0f0f0;
              "
              :preview-src-list="[scope.row.img]"
              preview-teleported
            />
          </template>
        </el-table-column>

        <el-table-column prop="brand" label="品牌" width="120" align="center" />
        <el-table-column
          prop="categoryName"
          label="所属分类"
          width="120"
          align="center"
        />
        <el-table-column label="销售价格" width="120" align="center">
          <template #default="scope">
            <span style="color: #ff4d4f">￥{{ scope.row.price }}</span>
          </template>
        </el-table-column>

        <el-table-column label="已售销量" width="120" align="center">
          <template #default="scope">
            <el-tag type="success" effect="plain"
              >{{ scope.row.sales || 0 }} 件</el-tag
            >
          </template>
        </el-table-column>

        <el-table-column
          prop="stock"
          label="当前库存"
          width="260"
          align="center"
        >
          <template #default="scope">
            <div
              style="
                display: flex;
                flex-direction: column;
                align-items: center;
                line-height: 1.6;
              "
            >
              <el-tag :type="scope.row.stock < 10 ? 'danger' : 'success'">
                总计: {{ scope.row.stock }} 件
              </el-tag>

              <div
                v-if="
                  scope.row.specList &&
                  scope.row.lowStockSkus &&
                  scope.row.lowStockSkus.length > 0
                "
                style="
                  font-size: 12px;
                  color: #ff4d4f;
                  margin-top: 4px;
                  font-weight: bold;
                "
              >
                <div v-for="sku in scope.row.lowStockSkus" :key="sku.id">
                  <template v-if="sku.specValue !== '默认规格'">
                    <el-tooltip
                      effect="dark"
                      :content="
                        '规格【' +
                        sku.specValue +
                        '】库存紧张，剩余 ' +
                        sku.stock +
                        ' 件'
                      "
                      placement="top"
                    >
                      <span
                        >规格【{{ sku.specValue }}】库存紧张：{{
                          sku.stock
                        }}
                        件</span
                      >
                    </el-tooltip>
                  </template>
                </div>
              </div>

              <div
                v-if="
                  scope.row.stock < 10 ||
                  (scope.row.lowStockSkus && scope.row.lowStockSkus.length > 0)
                "
                style="
                  color: #f56c6c;
                  font-size: 11px;
                  margin-top: 4px;
                  font-weight: bold;
                "
              >
                请及时补货！
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="160" align="center">
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
          :page-sizes="[5, 10, 20]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="data.total"
        />
      </div>
    </div>

    <el-dialog
      v-model="data.formVisible"
      title="商品配件信息管理"
      width="55%"
      destroy-on-close
      @opened="initEditor"
    >
      <el-form
        :model="data.form"
        label-width="110px"
        style="padding-right: 20px"
      >
        <el-row :gutter="20">
          <el-col :span="12"
            ><el-form-item label="配件名称"
              ><el-input v-model="data.form.name" /></el-form-item
          ></el-col>
          <el-col :span="12">
            <el-form-item label="所属分类">
              <el-select
                v-model="data.form.categoryId"
                placeholder="请选择分类"
                style="width: 100%"
              >
                <el-option
                  v-for="item in data.categoryList"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12"
            ><el-form-item label="所属品牌"
              ><el-input
                v-model="data.form.brand"
                placeholder="如：华为, 小米" /></el-form-item
          ></el-col>
          <el-col :span="12"
            ><el-form-item label="店铺名称"
              ><el-input v-model="data.form.store" /></el-form-item
          ></el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="8"
            ><el-form-item label="基础价格"
              ><el-input-number
                v-model="data.form.price"
                :precision="2"
                :step="0.1"
                style="width: 100%" /></el-form-item
          ></el-col>
          <el-col :span="8"
            ><el-form-item label="当前库存">
              <el-input-number
                v-model="data.form.stock"
                :min="0"
                :disabled="
                  data.form.specList ? data.form.specList.includes('|') : false
                "
                style="width: 100%"
              />
              <div
                class="tip"
                v-if="
                  data.form.specList ? data.form.specList.includes('|') : false
                "
              >
                该商品拥有多规格，总库存由各规格汇总生成，不可手动修改。
              </div>
            </el-form-item></el-col
          >
          <el-col :span="8"
            ><el-form-item label="已售销量"
              ><el-input v-model="data.form.sales" disabled /></el-form-item
          ></el-col>
        </el-row>

        <el-form-item label="商品简述">
          <el-input
            v-model="data.form.description"
            placeholder="请输入简单的文字介绍，如：原装快充，稳定不弹窗"
          />
        </el-form-item>

        <el-form-item label="规格参数定义">
          <el-input
            type="textarea"
            v-model="data.form.specList"
            :rows="3"
            placeholder="格式：1米|19.9|链接1..."
          />
          <el-button
            v-if="
              data.form.id &&
              (data.form.specList ? data.form.specList.includes('|') : false)
            "
            type="success"
            size="small"
            style="margin-top: 10px"
            @click="openSkuManager"
            >管理各规格精准库存</el-button
          >
          <div class="tip" style="color: #e6a23c; font-weight: bold">
            重要：多个规格请用英文逗号隔开。格式说明：规格名|价格|图片链接
          </div>
        </el-form-item>

        <el-form-item label="配件主图">
          <el-upload
            action="http://localhost:9090/files/upload"
            :on-success="handleImgSuccess"
            :show-file-list="false"
          >
            <img v-if="data.form.img" :src="data.form.img" class="avatar-img" />
            <el-button v-else type="primary">点击上传主图</el-button>
          </el-upload>
        </el-form-item>

        <el-form-item label="详细规格参数">
          <div style="border: 1px solid #ccc; width: 100%">
            <div
              id="toolbar-container"
              style="border-bottom: 1px solid #ccc"
            ></div>
            <div id="editor-container" style="height: 300px"></div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="data.formVisible = false">取消</el-button>
        <el-button type="primary" @click="save">保存配件信息</el-button>
      </template>
    </el-dialog>
    <el-dialog
      v-model="data.skuVisible"
      title="规格库存精细化管理"
      width="450px"
      destroy-on-close
    >
      <el-table :data="data.skuList" border stripe>
        <el-table-column prop="specValue" label="规格名称"></el-table-column>
        <el-table-column label="当前库存" width="150">
          <template #default="scope">
            <el-input-number v-model="scope.row.stock" :min="0" size="small" />
          </template>
        </el-table-column>
      </el-table>
      <template #footer>
        <el-button @click="data.skuVisible = false">取消</el-button>
        <el-button type="primary" @click="saveSkuStock"
          >保存并同步总库存</el-button
        >
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, onMounted, nextTick, onBeforeUnmount } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import E from "wangeditor";

const data = reactive({
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  name: "",
  formVisible: false,
  form: {},
  categoryList: [],
  skuVisible: false,
  skuList: [],
});

let editor = null;
const initEditor = () => {
  nextTick(() => {
    if (editor) {
      editor.destroy();
      editor = null;
    }
    editor = new E("#toolbar-container", "#editor-container");
    editor.config.uploadImgServer = "http://localhost:9090/files/upload/editor";
    editor.config.uploadFileName = "file";
    editor.config.onchange = (html) => {
      data.form.content = html;
    };
    editor.create();
    editor.txt.html(data.form.content || "");
  });
};

const loadCategory = () => {
  request.get("/category/selectAll").then((res) => {
    data.categoryList = res.data || [];
  });
};
const load = (pageNum) => {
  if (pageNum) data.pageNum = pageNum;
  request
    .get("/goods/selectPage", {
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
const handleAdd = () => {
  loadCategory();
  data.form = {
    img: "",
    sales: 0,
    store: "官方直营店",
    content: "",
    brand: "",
    description: "",
    specList: "",
  };
  data.formVisible = true;
};
const handleEdit = (row) => {
  loadCategory();
  // 拷贝商品信息
  data.form = JSON.parse(JSON.stringify(row));

  // 加载商品规格
  request.get("/goods/getSkus/" + row.id).then((res) => {
    data.form.skuList = res.data || [];
    data.formVisible = true;
  });
};
const handleImgSuccess = (res) => {
  if (res.code === "200") data.form.img = res.data;
};
const save = () => {
  if (!data.form.name || data.form.name.trim() === "") {
    ElMessage.warning("没有录入信息，请录入商品信息");
    return;
  }

  if (
    !data.form.specList ||
    data.form.specList.trim() === "" ||
    !data.form.specList.includes("|")
  ) {
    data.form.skuList = [];
  }

  // 新增或更新商品
  request[data.form.id ? "put" : "post"](
    data.form.id ? "/goods/update" : "/goods/add",
    data.form,
  ).then((res) => {
    if (res.code === "200") {
      ElMessage.success("保存成功");
      data.formVisible = false;
      load();
    }
  });
};
const handleDelete = (id) => {
  ElMessageBox.confirm("确认删除？", "警告").then(() => {
    request.delete("/goods/delete/" + id).then((res) => {
      if (res.code === "200") load();
    });
  });
};
const reset = () => {
  data.name = "";
  load(1);
};
// 打开规格管理
const openSkuManager = () => {
  // 优先读取外层表单暂存的数据
  if (data.form.skuList && data.form.skuList.length > 0) {
    data.skuList = JSON.parse(JSON.stringify(data.form.skuList));
    data.skuVisible = true;
  } else {
    request.get("/goods/getSkus/" + data.form.id).then((res) => {
      data.skuList = res.data || [];
      data.form.skuList = JSON.parse(JSON.stringify(data.skuList));
      data.skuVisible = true;
    });
  }
};
// 暂存规格库存，自动计算总库存
const saveSkuStock = () => {
  // 保存规格到表单
  data.form.skuList = JSON.parse(JSON.stringify(data.skuList));
  let totalStock = 0;
  data.form.skuList.forEach((sku) => {
    totalStock += sku.stock || 0;
  });
  data.form.stock = totalStock;
  ElMessage.success("规格已暂存，请点击保存配件信息确认修改");
  data.skuVisible = false;
};
onMounted(() => {
  load();
});
onBeforeUnmount(() => {
  if (editor) editor.destroy();
});
</script>

<style scoped>
.line-ellipsis {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: block;
}
.avatar-img {
  width: 100px;
  height: 100px;
  border-radius: 5px;
  margin-bottom: 10px;
  border: 1px solid #ddd;
  object-fit: contain;
}
.tip {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
  line-height: 1.2;
}
:deep(.w-e-text-container) {
  z-index: 1 !important;
}
:deep(.w-e-toolbar) {
  z-index: 2 !important;
}
</style>
