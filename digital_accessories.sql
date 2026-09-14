/*
 Navicat Premium Data Transfer

 Source Server         : host
 Source Server Type    : MySQL
 Source Server Version : 80408 (8.4.8)
 Source Host           : localhost:3306
 Source Schema         : digital_accessories

 Target Server Type    : MySQL
 Target Server Version : 80408 (8.4.8)
 File Encoding         : 65001

 Date: 04/06/2026 14:38:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `is_default` int NULL DEFAULT 0 COMMENT '是否为默认地址（1是，0否）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (3, 3, '李明', '15322352163', '郑州市金水区', 1);
INSERT INTO `address` VALUES (4, 4, '小华', '13442252355', '南风路23号', 0);
INSERT INTO `address` VALUES (5, 2, '林浩', '14223253512', '郑州市高新区智谷街 71 号启源大厦 608 室', 0);
INSERT INTO `address` VALUES (6, 5, '小美', '13432131566', '发大水开发商', 1);
INSERT INTO `address` VALUES (7, 5, 'das', '14313413421', '1341会挥发', 0);
INSERT INTO `address` VALUES (8, 6, '李明', '14523465436', '郑州市', 1);
INSERT INTO `address` VALUES (9, 7, '李明', '14523552366', '郑州市', 1);
INSERT INTO `address` VALUES (10, 8, '李明', '13536636742', '郑州市', 1);
INSERT INTO `address` VALUES (11, 8, '11', '13519123476', '郑州市', 0);

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ADMIN' COMMENT '角色',
  `username_update_count` int NULL DEFAULT 0 COMMENT '当日修改账号次数',
  `last_update_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后一次修改账号的日期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (3, 'test1', '123', '王阳', 'http://localhost:9090/files/download/1774085126821-avatar-boy2.png', 'ADMIN', 0, NULL);
INSERT INTO `admin` VALUES (4, 'admin', 'admin', '管理员', 'http://localhost:9090/files/download/1774000758546-avatar-boy1.png', 'ADMIN', 1, '2026-03-17');
INSERT INTO `admin` VALUES (7, 'test2', '1234', '管理员2', '', 'ADMIN', 1, '2026-03-20');
INSERT INTO `admin` VALUES (9, 'test3', '12345', '李明', '', 'ADMIN', 0, NULL);

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '海报图片',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注/标题',
  `goods_id` int NULL DEFAULT NULL COMMENT '关联商品ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, 'http://localhost:9090/files/download/1773744490444-banner2.jpg', '小米手表s5', 15);
INSERT INTO `banner` VALUES (2, 'http://localhost:9090/files/download/1773561584153-banner1.jpg', '华为手环', 14);
INSERT INTO `banner` VALUES (4, 'http://localhost:9090/files/download/1773744519407-banner3.jpg', '华为耳机', 16);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NULL DEFAULT NULL COMMENT '商品ID',
  `sku_id` int NULL DEFAULT NULL COMMENT '关联具体商品规格SKU_ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `num` int NULL DEFAULT 1 COMMENT '数量',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '加入时间',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格参数',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '规格价格',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (1, 11, 81, 3, 1, '2026-05-17 22:57:38', '1米', 13.90, 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg');
INSERT INTO `cart` VALUES (2, 11, 82, 3, 1, '2026-05-17 22:57:40', '1.5米', 21.70, 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg');
INSERT INTO `cart` VALUES (3, 10, 8, 3, 1, '2026-05-17 22:57:43', '默认规格', 169.00, 'http://localhost:9090/files/download/1773558705181-baseus-gan-100w.jpg');
INSERT INTO `cart` VALUES (4, 7, 5, 3, 1, '2026-05-17 22:57:45', '默认规格', 149.00, 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg');
INSERT INTO `cart` VALUES (5, 1, 93, 3, 1, '2026-05-17 22:57:53', '[升级款]40W双口线充套装', 69.00, 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg');
INSERT INTO `cart` VALUES (6, 19, 15, 3, 1, '2026-05-17 22:59:09', '默认规格', 20.90, 'http://localhost:9090/files/download/1773818282542-ugreen-typec-cable-1.2mi.jpg');
INSERT INTO `cart` VALUES (7, 22, 18, 3, 1, '2026-05-17 22:59:13', '默认规格', 34.80, 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg');
INSERT INTO `cart` VALUES (8, 6, 4, 3, 10, '2026-05-19 18:49:57', '默认规格', 799.00, 'http://localhost:9090/files/download/1773558817641-jbl-flip6.jpg');
INSERT INTO `cart` VALUES (9, 1, 92, 3, 1, '2026-05-20 20:45:31', '[经典款]40W单口线充套装', 99.00, 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '耳机', '入耳式、头戴式、蓝牙耳机等');
INSERT INTO `category` VALUES (2, '充电器', '快充头、无线充电座');
INSERT INTO `category` VALUES (4, '数据线', 'Type-C、Lightning、安卓线');
INSERT INTO `category` VALUES (5, '智能穿戴', '智能手表、手环等');
INSERT INTO `category` VALUES (6, '存储设备', 'U盘、移动硬盘、内存卡');
INSERT INTO `category` VALUES (7, '电脑外设', '鼠标、键盘、散热器');
INSERT INTO `category` VALUES (8, '音箱设备', '蓝牙音箱、电脑小音箱');
INSERT INTO `category` VALUES (9, '保护配件', '手机壳、钢化膜、电脑包');

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NULL DEFAULT NULL COMMENT '商品ID',
  `sku_id` int NULL DEFAULT NULL COMMENT '关联具体商品规格SKU_ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收藏时间',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格参数',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '规格价格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (3, 14, 63, 3, '2026-05-17 22:58:00', '华为手环11pro', 'http://localhost:9090/files/download/1773750035360-huawei-wristband11pro.jpg', '默认规格', 379.00);
INSERT INTO `collect` VALUES (4, 6, 4, 3, '2026-05-17 22:58:02', 'JBL Flip 6 蓝牙音箱', 'http://localhost:9090/files/download/1773558817641-jbl-flip6.jpg', '默认规格', 799.00);
INSERT INTO `collect` VALUES (5, 9, 7, 3, '2026-05-17 22:59:06', '索尼 WH-1000XM5 耳机', 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg', '默认规格', 1699.00);
INSERT INTO `collect` VALUES (6, 1, 92, 3, '2026-05-20 20:45:35', '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00);
INSERT INTO `collect` VALUES (7, 1, 93, 3, '2026-05-20 20:46:09', '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00);

-- ----------------------------
-- Table structure for file_info
-- ----------------------------
DROP TABLE IF EXISTS `file_info`;
CREATE TABLE `file_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件链接',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of file_info
-- ----------------------------
INSERT INTO `file_info` VALUES (1, 'ugreen-typec-cable-1.5mi.jpg', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg');
INSERT INTO `file_info` VALUES (2, 'ugreen-typec-cable-2mi.jpg', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg');
INSERT INTO `file_info` VALUES (3, 'ugreen-typec-cable-1mi.jpg', 'http://localhost:9090/files/download/1773849168907-ugreen-typec-cable-1mi.jpg');
INSERT INTO `file_info` VALUES (4, 'huawei-charger-set-dual-ports.jpg', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg');
INSERT INTO `file_info` VALUES (5, 'huawei-charger-set-one-liner.jpg', 'http://localhost:9090/files/download/1773849182146-huawei-charger-set-one-liner.jpg');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商品描述',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `stock` int NULL DEFAULT 0 COMMENT '库存',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品图片',
  `category_id` int NULL DEFAULT NULL COMMENT '分类ID',
  `sales` int NULL DEFAULT 0 COMMENT '已售数量',
  `store` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '数码配件官方直营店' COMMENT '店铺名称',
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详细参数规格',
  `spec_list` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格参数定义',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '华为快充套装', '(Max 40W) 3C认证华为原装充电器 适配华为手机Mate60', 99.00, 52, 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', 2, 717, '华为配件官方自营店', '华为', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>华为（HUAWEI）</td><td>商品编号</td><td>100124359481</td></tr><tr><td>国补备案型号</td><td>P0013</td><td>CCC强制性认证</td><td>是</td></tr><tr><td>型号</td><td>P0013</td><td>认证型号</td><td>华为冰糖全能充电器（SuperCharge Max 40W）套装版</td></tr><tr><td>输出电流</td><td>2A</td><td>插口数</td><td>单口</td></tr><tr><td>特色功能</td><td>支持笔记本充电</td><td>快充协议</td><td>SCP协议</td></tr><tr><td>主流功率</td><td>40w</td><td></td><td></td></tr><tr><td>包装清单</td><td>充电器*1、安全信息*1、充电线缆*1</td><td></td><td></td></tr></tbody></table>', '[经典款]40W单口线充套装|99.00|http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg,[升级款]40W双口线充套装|69.00|http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg\n');
INSERT INTO `goods` VALUES (3, '罗技 G502 无线鼠标', '经典外形，HERO 25K 传感器', 499.00, 18, 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', 7, 1179, '罗技配件官方自营店', '罗技', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>罗技（G）</td><td>商品编号</td><td>56442363331</td></tr><tr><td>店铺</td><td>罗技配件官方自营店</td><td>货号</td><td>G501 LIGHTSPEED</td></tr><tr><td>型号</td><td>G501 Lightspeed</td><td><p>国补备案型号</p></td><td>G501 LIGHTSPEED</td></tr><tr><td>是否可选配重模块</td><td>可选配重模块</td><td>线材类型</td><td>无线</td></tr><tr><td>供电方式</td><td>充电电池</td><td>同时连接设备数量</td><td>1台</td></tr><tr><td>最高DPI</td><td>20001-30000</td><td>兼容系统</td><td>Windows</td></tr><tr><td>连接方式</td><td>无线2.4G 有线</td><td></td><td></td></tr></tbody></table>', '');
INSERT INTO `goods` VALUES (4, '雷蛇黑寡妇机械键盘', '绿轴手感，RGB 灯效', 374.00, 30, 'http://localhost:9090/files/download/1773558843192-razer-keyboard.jpg', 7, 873, '雷蛇（Razer）配件官方自营店', '雷蛇(Razer)', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>雷蛇（Razer）</td><td>商品编号</td><td>15913759379</td></tr><tr><td>国补备案型号</td><td>黑寡妇蜘蛛X竞技版</td><td>键帽材质</td><td>ABS</td></tr><tr><td>键帽字符工艺</td><td>激光雕刻</td><td>机身材质</td><td>铝合金</td></tr><tr><td>类型</td><td>静电容键盘</td><td>兼容系统</td><td>兼容多系统</td></tr><tr><td>插拔类型</td><td>不支持热插拔</td><td>同时连接设备</td><td>1台</td></tr><tr><td>颜色</td><td>绿色</td><td>按键数</td><td>81-90键</td></tr><tr><td>包装清单</td><td>键盘x1;USB线 x1;快速安装指南x1；Logo贴x1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (5, '闪迪 128GB 高速U盘', 'USB 3.1 接口，金属机身', 129.90, 198, 'http://localhost:9090/files/download/1773558827055-sandisk-usb.jpg', 6, 2570, '闪迪配件官方自营店', '闪迪', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>闪迪（SanDisk）</td><td>商品编号</td><td>2135507</td></tr><tr><td>系列</td><td>高速U盘</td><td>外壳材质</td><td>金属</td></tr><tr><td>颜色</td><td>银色</td><td>型号</td><td>SDCZ13-128G-Z35</td></tr><tr><td>最大读取速度</td><td>150MB/s</td><td>U盘含资源包</td><td>裸盘</td></tr><tr><td>特性</td><td>加密 高速读写U盘</td><td>优选服务</td><td>只换不修 五年质保</td></tr><tr><td>接口</td><td>USB3.0</td><td>容量</td><td>128GB</td></tr><tr><td>包装清单</td><td>128G闪存盘 × 1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (6, 'JBL Flip 6 蓝牙音箱', 'IP67 防水，震撼音质', 799.00, 5, 'http://localhost:9090/files/download/1773558817641-jbl-flip6.jpg', 8, 947, 'JBL配件官方自营店', 'JBL', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>JBL</td><td>商品编号</td><td>10121484187038</td></tr><tr><td>店铺</td><td>JBL配件官方自营店</td><td>主材质</td><td>金属</td></tr><tr><td>CCC强制性认证</td><td>否</td><td>认证型号</td><td>FLIP6</td></tr><tr><td>型号</td><td>FLIP6</td><td>包装形式</td><td>单品</td></tr><tr><td>国补备案型号</td><td>FLIP6</td><td>电源类型</td><td>电池供电</td></tr><tr><td>蓝牙版本</td><td>蓝牙5.1</td><td>类型</td><td>无源音箱</td></tr><tr><td>类别</td><td>便携/户外音箱</td><td>语音交互</td><td>不支持</td></tr><tr><td>包装清单</td><td><br/>JBL Flip 6*1、Type C USB 连接线*1、快速入门指南*1、保修卡/安全数据表*1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (7, '苹果 Apple Watch 运动表带', '硅胶材质，亲肤舒适', 149.00, 147, 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg', 5, 1025, '数码配件官方自营店', 'Apple', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>货号</td><td>2429</td><td>国补备案型号</td><td>苹果手表</td></tr><tr><td>适用品牌</td><td>APPLE</td><td>材质</td><td>硅胶</td></tr><tr><td>类型</td><td>智能手表表带</td><td>适用型号</td><td>Apple Watch Series 10</td></tr><tr><td>包装清单</td><td>表带*1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (8, 'oppoFindX8s光彩磁吸全包保护壳', '原创设计 简约风,TPU+PET,全包', 65.55, 299, 'http://localhost:9090/files/download/1773762230279-oppoFindx8s-case.jpg', 9, 788, 'oppo配件官方自营店', 'oppo', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>OPPO</td><td>商品编号</td><td>101372644351</td></tr><tr><td>适用品牌</td><td>OPPO</td><td>款式</td><td>全包</td></tr><tr><td>热门机型</td><td>OPPO Find X8s</td><td>材质</td><td>TPU+PET</td></tr><tr><td>风格</td><td>原创设计 简约风</td><td></td><td></td></tr><tr><td>包装清单</td><td>保护壳*1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (9, '索尼 WH-1000XM5 耳机', '旗舰级降噪，舒适佩戴', 1699.00, 24, 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg', 1, 764, '索尼配件官方自营店', '索尼', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>索尼（SONY）</td><td>商品编号</td><td>10126310592695</td></tr><tr><td>店铺</td><td>索尼配件官方直自营店</td><td>IoT智能生态产品</td><td>否</td></tr><tr><td>主机机型</td><td>索尼 WH-1000XM5</td><td>颜色</td><td>玫瑰灰</td></tr><tr><td>型号</td><td>WH-1000XM5</td><td>国补备案型号</td><td>WH-1000XM5</td></tr><tr><td>充电接口</td><td>Type-C</td><td>防水等级</td><td>无防水等级</td></tr><tr><td>场景</td><td>降噪耳机</td><td>特色功能</td><td>超长续航</td></tr><tr><td>佩戴方式</td><td>头戴式</td><td>振膜类型</td><td>单动圈</td></tr><tr><td>包装清单</td><td>暂无</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (10, '倍思 100W 氮化镓充电头', '三口快充，小巧便携', 169.00, 117, 'http://localhost:9090/files/download/1773558705181-baseus-gan-100w.jpg', 2, 1358, '倍思配件官方自营店', '倍思', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>倍思（BASEUS）</td><td>商品编号</td><td>101224368684</td></tr><tr><td>货号</td><td>E0112903</td><td>认证型号</td><td>E01239</td></tr><tr><td>型号</td><td>E01139</td><td>CCC强制性认证</td><td>是</td></tr><tr><td><p>输入电压（v）</p></td><td>最小100V 最大240V</td><td>输出电流</td><td>5A</td></tr><tr><td>输出电压</td><td>20V</td><td>输入电流（A）</td><td>5A</td></tr><tr><td>快充协议</td><td>PD协议</td><td>类型</td><td>线充套装</td></tr><tr><td>特色功能</td><td>支持笔记本充电 氮化镓 折叠插脚</td><td>输入电压</td><td>100-240V</td></tr><tr><td>包装清单</td><td><br/>倍思 EnerFill FE22 快充充电器 2C+U 100W 黑 （劲速C-C 100W 2m 黑）</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (11, '绿联 Type-C 编织数据线', '适用华为超级快充，1米/1.5米/2米 6A，A to Type-c', 13.90, 174, 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', 4, 210, '绿联配件官方自营店', '绿联', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>绿联（UGREEN）</td><td>商品编号</td><td>100110996822</td></tr><tr><td>货号</td><td>US301</td><td>长度</td><td>1m</td></tr><tr><td>国补备案型号</td><td>40100</td><td>电流</td><td>6A</td></tr><tr><td>MFi苹果认证</td><td>否</td><td>接口/接头</td><td>A to Type-c</td></tr><tr><td>电流</td><td>5.1-6A</td><td>材质</td><td>PVC(聚氯乙烯)</td></tr><tr><td>包装规格</td><td>单条装</td><td>是否含充电头</td><td>否</td></tr><tr><td>是否原装</td><td>品牌兼容</td><td>主色系</td><td>白色系 纯白色</td></tr><tr><td>包装清单</td><td>100W超级快充Type-C数据线*1 达国标阻燃和EMC标准线材</td><td></td><td></td></tr></tbody></table>', '1米|13.9|http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg,\n1.5米|21.70|http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg,\n2米|24.60|http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg\n\n');
INSERT INTO `goods` VALUES (12, '小米屏下挂灯', '非对称光学，无屏幕反光', 199.00, 25, 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', 7, 982, '小米配件官方自营店', '小米', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>小米（MI）</td><td>商品编号</td><td>101128930936</td></tr><tr><td>国补备案型号</td><td>MJGJD12YL</td><td>显色指数</td><td>Ra91-95（含</td></tr><tr><td>包装清单</td><td>暂无</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (14, '华为手环11pro', '1.62英寸高亮大屏，独立GNSS五星定位|', 379.00, 76, 'http://localhost:9090/files/download/1773750035360-huawei-wristband11pro.jpg', 5, 255, '华为配件官方自营店', '华为', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>华为（HUAWEI）</td><td>商品编号</td><td>10212122397356</td></tr><tr><td>店铺</td><td><p>华为配件官方自营店</p></td><td>认证型号</td><td>CDY-B29</td></tr><tr><td>消息回复</td><td>支持快捷回复</td><td>型号</td><td>华为手环 11 Pro</td></tr><tr><td>适用人群</td><td>通用</td><td>蓝牙版本</td><td>蓝牙6.0</td></tr><tr><td>IoT智能生态产品</td><td>否</td><td>国补备案型号</td><td>华为手环 11 Pro</td></tr><tr><td>极限续航时间</td><td>14天</td><td>标准续航时间</td><td>8天</td></tr><tr><td>支付功能</td><td>扫码支付 碰一碰</td><td>屏幕显示</td><td>彩色</td></tr><tr><td>AI语音功能</td><td>不支持AI语音功能</td><td>防水</td><td>IP68 5ATM</td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (15, '小米智能手表Watch S5', '全新四灯组 ，心率血氧传感器', 435.00, 43, 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg', 5, 469, '小米配件官方自营店', '小米', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"text-align:left;\"><tbody><tr><td>品牌</td><td>小米（MI）</td><td>商品编号</td><td>10212914579116</td></tr><tr><td>店铺</td><td><p>小米配件官方自营店</p></td><td>国补备案型号</td><td>M2512W1</td></tr><tr><td>认证型号</td><td>M2512W1</td><td>通话类型</td><td>未公布</td></tr><tr><td>主机机型</td><td>未公布</td><td>防水</td><td>未公布</td></tr><tr><td>血氧监测</td><td>未公布</td><td>表盘形状</td><td>未公布</td></tr><tr><td>包装清单</td><td>暂无</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (16, '华为FreeClip 2 耳夹耳机', '音乐耳机，多单元动圈，耳夹式，超长续航', 1299.00, 477, 'http://localhost:9090/files/download/1773749996612-huawei-freeClip2.jpg', 1, 354, '华为配件官方自营店', '华为', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>华为（HUAWEI）</td><td>商品编号</td><td>100319338182</td></tr><tr><td>型号</td><td>T0027</td><td>国补备案型号</td><td><br/>T0027</td></tr><tr><td>IoT智能生态产品</td><td>否</td><td><br/>防水等级</td><td>IPX4</td></tr><tr><td>充电接口</td><td>Type-C</td><td>防尘性能</td><td>IP5X</td></tr><tr><td>场景</td><td>音乐耳机</td><td><br/>振膜类型</td><td><br/>多单元动圈</td></tr><tr><td>佩戴方式</td><td>耳夹式</td><td>特色功能</td><td>超长续航</td></tr><tr><td>包装形式</td><td>单品</td><td></td><td></td></tr><tr><td>包装清单</td><td>外包装采用塑封，彩盒内标配： 耳机 × 2（左右耳各1） <br/>充电盒 × 1 快速指南&amp;安全信息&amp;保修卡 × 1 音乐权益卡 × 1 <br/>本产品标配不含USB Type-C充电线。</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (17, '绿联轻薄电脑包 手提笔记本内胆包带肩带', '16英寸收纳包适用MacBook华为联想', 37.05, 53, 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png', 9, 62, '绿联配件官方自营店', '绿联', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌&nbsp;&nbsp;&nbsp;&nbsp;</td><td>绿联</td><td>商品编号</td><td>100150080406</td></tr><tr><td>货号</td><td>LP909</td><td>材质</td><td>涤纶（）聚酯纤维</td></tr><tr><td>闭合方式</td><td>拉链</td><td>防水强度</td><td>防泼水</td></tr><tr><td>类别</td><td>手提电脑包</td><td>风格</td><td>通勤风 商务风</td></tr><tr><td>适用性别</td><td>通用</td><td>容纳电脑尺寸</td><td>15.1-16英寸</td></tr><tr><td>包装清单</td><td>15-16英寸笔记本手提包 x1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (18, '绿联超清纳米膜 钢化膜', '前膜，钢化玻璃', 11.60, 1230, 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg', 9, 591, '绿联配件官方自营店', '绿联', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>绿联（UGREEN）</td><td>商品编号</td><td>100217110169</td></tr><tr><td>货号</td><td>SP886</td><td>热门机型&nbsp; &nbsp;</td><td>小米15</td></tr><tr><td>类型</td><td>前膜</td><td>材质</td><td>钢化玻璃</td></tr><tr><td>功能&nbsp; &nbsp;</td><td>防指纹 防尘 防爆</td><td>工艺</td><td>全胶</td></tr><tr><td>适用品牌</td><td>小米（MI）</td><td>贴膜神器</td><td>定位器</td></tr><tr><td>包装清单</td><td>手机保护膜 无边超清钢化膜（小米15适用）2片装 贴膜工具包*2 贴膜神器*1&nbsp;</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (19, '绿联Type-C数据线 1.2米', '1.2米, A to Type-c', 20.90, 2355, 'http://localhost:9090/files/download/1773818282542-ugreen-typec-cable-1.2mi.jpg', 4, 1247, '绿联配件官方自营店', '绿联', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>绿联（UGREEN）</td><td>商品编号</td><td>10103842678270</td></tr><tr><td>店铺</td><td>绿联配件官方自营店</td><td>货号</td><td>US303</td></tr><tr><td>电流</td><td>6A</td><td>MFI苹果认证</td><td>否</td></tr><tr><td>电流</td><td>5.1-6A</td><td>包装规格</td><td>单条装</td></tr><tr><td>是否原装</td><td>品牌兼容</td><td>材质</td><td>PVC(聚氯乙烯)</td></tr><tr><td>接口/接头</td><td>A To Type-c</td><td>是否含充电头</td><td>否</td></tr><tr><td>主色系</td><td>白色系 纯白色</td><td></td><td></td></tr><tr><td>包装清单</td><td>暂无</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (20, '漫步者M330Ⅱ复古桌面蓝牙音箱', '木质,蓝牙5.4', 958.90, 155, 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg', 8, 26, '漫步者配件官方自营店', '漫步者', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>漫步者（EDIFIER）</td><td>商品编号</td><td>100234531553</td></tr><tr><td>货号</td><td>6923520224565</td><td>包装形式</td><td>单品</td></tr><tr><td>国补备案型号</td><td>M330</td><td>型号</td><td>M330 Ⅱ</td></tr><tr><td>主材质</td><td>木质</td><td>认证型号</td><td>M330 Ⅱ</td></tr><tr><td>电源类型</td><td>电池供电</td><td>蓝牙版本</td><td>蓝牙5.4</td></tr><tr><td>类型</td><td>有源音箱</td><td>类别</td><td>居家艺术音箱</td></tr><tr><td>语音交互</td><td>不支持</td><td>内置电池</td><td>内置电池</td></tr><tr><td>连接方式</td><td>蓝牙</td><td>外置存储设备读取</td><td>不支持</td></tr><tr><td>是否支持通话</td><td>不支持</td><td>自带滑轮</td><td>无</td></tr><tr><td>搭载AI大模型</td><td>其他</td><td></td><td></td></tr><tr><td>包装清单</td><td>音箱×1、音频线×1、电源线×1、数据线×1、说明书&amp;保修卡×1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (21, '闪迪4TB移动固态硬盘', '黑色，最高连续读速2000MB/s', 3899.00, 157, 'http://localhost:9090/files/download/1773820253621-sandisk-solid-state-portable-hard-drive.jpg', 6, 12, '闪迪配件官方自营店', '闪迪', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>闪迪（SanDisk）</td><td>商品编号&nbsp; &nbsp; &nbsp;</td><td>100192609235</td></tr><tr><td>型号</td><td>SDSSDE82-4T00-Z35</td><td>系列</td><td>至尊超级速</td></tr><tr><td>颜色</td><td>黑色</td><td>指示灯</td><td>无指示灯</td></tr><tr><td>最高连续读速</td><td>3800MB/s</td><td>系统</td><td>Windows 7 Windows 8 Windows 10 MacOS</td></tr><tr><td>产品尺寸</td><td>长140.00mm 宽68.70mm 高11.90mm</td><td>优选服务</td><td>只换不修</td></tr><tr><td>容量</td><td>4TB</td><td>传输速度</td><td>2000MB/s及以上</td></tr><tr><td>外壳材质</td><td>金属</td><td>特征特质</td><td>防水防尘 防摔防震</td></tr><tr><td>接口</td><td>Type-C 雷电接口</td><td></td><td></td></tr><tr><td>包装清单</td><td>4TB移动固态硬盘*1、双Type-C数据线*1</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (22, '倍思 【超瓷晶防爆膜】钢化膜', '钢化玻璃 AR增透 丝印', 34.80, 5528, 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', 9, 5349, '倍思官方自营店', '倍思', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>倍思（BASEUS）</td><td>商品编号</td><td>101063914898</td></tr><tr><td>货号</td><td>P60012102201-Z4</td><td>国补备案型号</td><td>晶曜系列 钢化膜</td></tr><tr><td>热门机型</td><td>Apple iPhone 15 Pro Max</td><td>贴膜神器</td><td>无尘仓</td></tr><tr><td>工艺</td><td>AR增透 丝印</td><td>类型</td><td>前膜</td></tr><tr><td>材质</td><td>钢化玻璃</td><td>适用品牌</td><td><br/>APPLE</td></tr><tr><td>功能</td><td>防尘 防指纹 防摔</td><td></td><td></td></tr><tr><td>包装清单</td><td>DZ-JD 倍思 一体防尘 全屏 高清 钢化膜 For iP 15 Pro Max 透明 双片装 无尘仓 （含：清洁包*2）</td><td></td><td></td></tr></tbody></table>', NULL);
INSERT INTO `goods` VALUES (23, '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标', '炼狱蝰蛇V3 充电电池 右手型 ', 1399.00, 681, 'http://localhost:9090/files/download/1774251788733-razer-mouse.jpg', 7, 478, '雷蛇配件官方自营店', '雷蛇(Razer)', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>雷蛇（Razer）</td><td>商品编号</td><td>10133786537387</td></tr><tr><td>店铺</td><td>雷蛇配件官方自营店</td><td>型号</td><td>炼狱蝰蛇V3</td></tr><tr><td>线材类型</td><td>编织线</td><td>是否可选配重模块</td><td>不可选配重模块</td></tr><tr><td>鼠标重量</td><td>≤60g</td><td>电池容量</td><td>未公布</td></tr><tr><td>供电方式</td><td>充电电池</td><td>IPS</td><td>&gt;650</td></tr><tr><td>最高DPI</td><td>5001-10000</td><td>同时连接设备数量</td><td>1台</td></tr><tr><td>鼠标尺寸</td><td>大手适用型（&gt;11.5 cm）</td><td>可编程键数</td><td>5-8个</td></tr><tr><td>回报速率</td><td>501-1000</td><td>材质</td><td>其他</td></tr><tr><td>鼠标类型</td><td>右手型</td><td>背光灯效</td><td>无光</td></tr><tr><td>连接方式</td><td>有线</td><td></td><td></td></tr></tbody></table>', '');
INSERT INTO `goods` VALUES (24, '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘', '大学生专用 有钥匙孔 蓝色', 48.30, 3424, 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg', 6, 325, '金士顿配件官方自营店', '金士顿', '<table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td>品牌</td><td>金士顿（Kingston）</td><td>商品编号</td><td>10132718543747</td></tr><tr><td>店铺</td><td>金士顿Kingston官方旗舰店</td><td>货号</td><td>DTX</td></tr><tr><td>外壳材质</td><td>塑料</td><td>系列</td><td>DTX</td></tr><tr><td>颜色</td><td>蓝色</td><td>型号</td><td>DTX/64GB</td></tr><tr><td>产品净重</td><td>11g</td><td>钥匙孔</td><td>有钥匙孔</td></tr><tr><td>产品尺寸</td><td>长67.3mm 宽21.04mm 高10.14mm</td><td>指示灯</td><td>无指示灯</td></tr><tr><td>最大写入速度</td><td>5MB/s</td><td>最大读取速度</td><td>50MB/s</td></tr><tr><td>U盘含资源包</td><td>裸盘</td><td>接口</td><td>其他</td></tr><tr><td>优选服务</td><td>只换不修 五年质保</td><td>特性</td><td>高速读写U盘</td></tr><tr><td>容量</td><td>64GB</td><td></td><td></td></tr><tr><td><p>包装清单</p></td><td>单品：U盘*1 组合装：U盘*1、配件*1</td><td></td><td></td></tr></tbody></table>', NULL);

-- ----------------------------
-- Table structure for goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `goods_sku`;
CREATE TABLE `goods_sku`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL COMMENT '关联商品ID',
  `spec_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规格名称（如：1.5米）',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '该规格价格',
  `stock` int NULL DEFAULT 0 COMMENT '该规格独立库存',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '该规格图片',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods_id`(`goods_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品规格库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_sku
-- ----------------------------
INSERT INTO `goods_sku` VALUES (2, 4, '默认规格', 374.00, 30, 'http://localhost:9090/files/download/1773558843192-razer-keyboard.jpg');
INSERT INTO `goods_sku` VALUES (3, 5, '默认规格', 129.90, 198, 'http://localhost:9090/files/download/1773558827055-sandisk-usb.jpg');
INSERT INTO `goods_sku` VALUES (4, 6, '默认规格', 799.00, 5, 'http://localhost:9090/files/download/1773558817641-jbl-flip6.jpg');
INSERT INTO `goods_sku` VALUES (5, 7, '默认规格', 149.00, 147, 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg');
INSERT INTO `goods_sku` VALUES (6, 8, '默认规格', 65.55, 299, 'http://localhost:9090/files/download/1773762230279-oppoFindx8s-case.jpg');
INSERT INTO `goods_sku` VALUES (7, 9, '默认规格', 1699.00, 24, 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg');
INSERT INTO `goods_sku` VALUES (8, 10, '默认规格', 169.00, 117, 'http://localhost:9090/files/download/1773558705181-baseus-gan-100w.jpg');
INSERT INTO `goods_sku` VALUES (13, 17, '默认规格', 37.05, 53, 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png');
INSERT INTO `goods_sku` VALUES (14, 18, '默认规格', 11.60, 1230, 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg');
INSERT INTO `goods_sku` VALUES (15, 19, '默认规格', 20.90, 2355, 'http://localhost:9090/files/download/1773818282542-ugreen-typec-cable-1.2mi.jpg');
INSERT INTO `goods_sku` VALUES (16, 20, '默认规格', 958.90, 155, 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg');
INSERT INTO `goods_sku` VALUES (17, 21, '默认规格', 3899.00, 157, 'http://localhost:9090/files/download/1773820253621-sandisk-solid-state-portable-hard-drive.jpg');
INSERT INTO `goods_sku` VALUES (18, 22, '默认规格', 34.80, 5528, 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg');
INSERT INTO `goods_sku` VALUES (41, 15, '默认规格', 435.00, 43, 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg');
INSERT INTO `goods_sku` VALUES (63, 14, '默认规格', 379.00, 76, 'http://localhost:9090/files/download/1773750035360-huawei-wristband11pro.jpg');
INSERT INTO `goods_sku` VALUES (81, 11, '1米', 13.90, 8, 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg');
INSERT INTO `goods_sku` VALUES (82, 11, '1.5米', 21.70, 6, 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg');
INSERT INTO `goods_sku` VALUES (83, 11, '2米', 24.60, 160, 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg');
INSERT INTO `goods_sku` VALUES (84, 23, '默认规格', 1399.00, 681, 'http://localhost:9090/files/download/1774251788733-razer-mouse.jpg');
INSERT INTO `goods_sku` VALUES (86, 24, '默认规格', 48.30, 3424, 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg');
INSERT INTO `goods_sku` VALUES (87, 12, '默认规格', 199.00, 25, 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png');
INSERT INTO `goods_sku` VALUES (90, 3, '默认规格', 499.00, 18, 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg');
INSERT INTO `goods_sku` VALUES (91, 16, '默认规格', 1299.00, 477, 'http://localhost:9090/files/download/1773749996612-huawei-freeClip2.jpg');
INSERT INTO `goods_sku` VALUES (92, 1, '[经典款]40W单口线充套装', 99.00, 29, 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg');
INSERT INTO `goods_sku` VALUES (93, 1, '[升级款]40W双口线充套装', 69.00, 23, 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL COMMENT '关联主订单ID',
  `goods_id` int NOT NULL COMMENT '商品ID',
  `sku_id` int NULL DEFAULT NULL COMMENT '关联具体商品规格SKU_ID',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品名称快照',
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片快照',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格快照',
  `price` decimal(10, 2) NOT NULL COMMENT '购买时的成交单价',
  `num` int NOT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 70, 15, 41, '小米智能手表Watch S5', 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg', '默认规格', 435.00, 1);
INSERT INTO `order_item` VALUES (2, 71, 18, 14, '绿联超清纳米膜 钢化膜', 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg', '默认规格', 11.60, 1);
INSERT INTO `order_item` VALUES (3, 71, 17, 13, '绿联轻薄电脑包 手提笔记本内胆包带肩带', 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png', '默认规格', 37.05, 1);
INSERT INTO `order_item` VALUES (4, 72, 11, 83, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg', '2米', 24.60, 1);
INSERT INTO `order_item` VALUES (5, 72, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (6, 73, 7, 5, '苹果 Apple Watch 运动表带', 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg', '默认规格', 149.00, 1);
INSERT INTO `order_item` VALUES (7, 73, 16, 65, '华为FreeClip 2 耳夹耳机', 'http://localhost:9090/files/download/1773749996612-huawei-freeClip2.jpg', '默认规格', 1299.00, 1);
INSERT INTO `order_item` VALUES (8, 74, 18, 14, '绿联超清纳米膜 钢化膜', 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg', '默认规格', 11.60, 1);
INSERT INTO `order_item` VALUES (9, 75, 5, 3, '闪迪 128GB 高速U盘', 'http://localhost:9090/files/download/1773558827055-sandisk-usb.jpg', '默认规格', 129.90, 1);
INSERT INTO `order_item` VALUES (10, 76, 11, 83, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg', '2米', 24.60, 1);
INSERT INTO `order_item` VALUES (11, 69, 8, 6, 'oppoFindX8s光彩磁吸全包保护壳', 'http://localhost:9090/files/download/1773762230279-oppoFindx8s-case.jpg', '默认规格', 65.55, 1);
INSERT INTO `order_item` VALUES (12, 69, 17, 13, '绿联轻薄电脑包 手提笔记本内胆包带肩带', 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png', '默认规格', 37.05, 1);
INSERT INTO `order_item` VALUES (13, 68, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (14, 68, 17, 13, '绿联轻薄电脑包 手提笔记本内胆包带肩带', 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png', '默认规格', 37.05, 1);
INSERT INTO `order_item` VALUES (15, 67, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (16, 67, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (17, 66, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 14);
INSERT INTO `order_item` VALUES (18, 65, 3, 90, '罗技 G502 无线鼠标', 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', '默认规格', 499.00, 2);
INSERT INTO `order_item` VALUES (19, 64, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (20, 63, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 1);
INSERT INTO `order_item` VALUES (21, 62, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 1);
INSERT INTO `order_item` VALUES (22, 61, 20, 16, '漫步者M330Ⅱ复古桌面蓝牙音箱', 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg', '默认规格', 958.90, 1);
INSERT INTO `order_item` VALUES (23, 60, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 2);
INSERT INTO `order_item` VALUES (24, 59, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (25, 58, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (26, 57, 24, 86, '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘', 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg', '默认规格', 47.90, 1);
INSERT INTO `order_item` VALUES (27, 56, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 1);
INSERT INTO `order_item` VALUES (28, 55, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (29, 54, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (30, 53, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (31, 52, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (32, 51, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 1);
INSERT INTO `order_item` VALUES (33, 50, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 1);
INSERT INTO `order_item` VALUES (34, 49, 3, 90, '罗技 G502 无线鼠标', 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', '默认规格', 499.00, 1);
INSERT INTO `order_item` VALUES (35, 48, 3, 90, '罗技 G502 无线鼠标', 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', '默认规格', 499.00, 1);
INSERT INTO `order_item` VALUES (36, 47, 3, 90, '罗技 G502 无线鼠标', 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', '默认规格', 499.00, 1);
INSERT INTO `order_item` VALUES (37, 46, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (38, 46, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 1);
INSERT INTO `order_item` VALUES (39, 44, 20, 16, '漫步者M330Ⅱ复古桌面蓝牙音箱', 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg', '默认规格', 958.90, 1);
INSERT INTO `order_item` VALUES (40, 43, 24, 86, '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘', 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg', '默认规格', 47.90, 1);
INSERT INTO `order_item` VALUES (41, 41, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (42, 40, 21, 17, '闪迪4TB移动固态硬盘', 'http://localhost:9090/files/download/1773820253621-sandisk-solid-state-portable-hard-drive.jpg', '默认规格', 3899.00, 1);
INSERT INTO `order_item` VALUES (43, 39, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (44, 38, 23, 84, '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标', 'http://localhost:9090/files/download/1774251788733-razer-mouse.jpg', '默认规格', 1399.00, 1);
INSERT INTO `order_item` VALUES (45, 36, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (46, 34, 24, 86, '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘', 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg', '默认规格', 47.90, 1);
INSERT INTO `order_item` VALUES (47, 33, 20, 16, '漫步者M330Ⅱ复古桌面蓝牙音箱', 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg', '默认规格', 958.90, 1);
INSERT INTO `order_item` VALUES (48, 32, 21, 17, '闪迪4TB移动固态硬盘', 'http://localhost:9090/files/download/1773820253621-sandisk-solid-state-portable-hard-drive.jpg', '默认规格', 3899.00, 1);
INSERT INTO `order_item` VALUES (49, 31, 6, 4, 'JBL Flip 6 蓝牙音箱', 'http://localhost:9090/files/download/1773558817641-jbl-flip6.jpg', '默认规格', 799.00, 1);
INSERT INTO `order_item` VALUES (50, 30, 21, 17, '闪迪4TB移动固态硬盘', 'http://localhost:9090/files/download/1773820253621-sandisk-solid-state-portable-hard-drive.jpg', '默认规格', 3899.00, 1);
INSERT INTO `order_item` VALUES (51, 29, 9, 7, '索尼 WH-1000XM5 耳机', 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg', '默认规格', 1699.00, 1);
INSERT INTO `order_item` VALUES (52, 28, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 1);
INSERT INTO `order_item` VALUES (53, 27, 17, 13, '绿联轻薄电脑包 手提笔记本内胆包带肩带', 'http://localhost:9090/files/download/1773805719612-ugreen-computer -bag.png', '默认规格', 37.05, 1);
INSERT INTO `order_item` VALUES (54, 25, 15, 41, '小米智能手表Watch S5', 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg', '默认规格', 435.00, 1);
INSERT INTO `order_item` VALUES (55, 24, 9, 7, '索尼 WH-1000XM5 耳机', 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg', '默认规格', 1699.00, 1);
INSERT INTO `order_item` VALUES (56, 23, 15, 41, '小米智能手表Watch S5', 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg', '默认规格', 435.00, 1);
INSERT INTO `order_item` VALUES (57, 22, 20, 16, '漫步者M330Ⅱ复古桌面蓝牙音箱', 'http://localhost:9090/files/download/1773819634421-walkman-speaker.jpg', '默认规格', 958.90, 1);
INSERT INTO `order_item` VALUES (58, 21, 19, 15, '绿联Type-C数据线 1.2米', 'http://localhost:9090/files/download/1773818282542-ugreen-typec-cable-1.2mi.jpg', '默认规格', 20.90, 1);
INSERT INTO `order_item` VALUES (59, 20, 14, 63, '华为手环11pro', 'http://localhost:9090/files/download/1773750035360-huawei-wristband11pro.jpg', '默认规格', 379.00, 1);
INSERT INTO `order_item` VALUES (60, 19, 3, 90, '罗技 G502 无线鼠标', 'http://localhost:9090/files/download/1773558856403-logitech-g502.jpg', '默认规格', 499.00, 1);
INSERT INTO `order_item` VALUES (61, 18, 18, 14, '绿联超清纳米膜', 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg', '默认规格', 11.60, 1);
INSERT INTO `order_item` VALUES (62, 16, 19, 15, '绿联Type-C数据线 1.2米', 'http://localhost:9090/files/download/1773818282542-ugreen-typec-cable-1.2mi.jpg', '默认规格', 20.90, 2);
INSERT INTO `order_item` VALUES (63, 14, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 2);
INSERT INTO `order_item` VALUES (64, 77, 11, 83, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg', '2米', 24.60, 1);
INSERT INTO `order_item` VALUES (65, 78, 11, 83, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg', '2米', 24.60, 1);
INSERT INTO `order_item` VALUES (66, 79, 15, 41, '小米智能手表Watch S5', 'http://localhost:9090/files/download/1773750047226-xiaomi-watchS5.jpg', '默认规格', 435.00, 1);
INSERT INTO `order_item` VALUES (67, 80, 10, 8, '倍思 100W 氮化镓充电头', 'http://localhost:9090/files/download/1773558705181-baseus-gan-100w.jpg', '默认规格', 169.00, 1);
INSERT INTO `order_item` VALUES (68, 81, 24, 86, '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘', 'http://localhost:9090/files/download/1774253478155-kingston-usb.jpg', '默认规格', 47.90, 1);
INSERT INTO `order_item` VALUES (69, 82, 18, 14, '绿联超清纳米膜 钢化膜', 'http://localhost:9090/files/download/1773817777849-ugreen-strengthened -film.jpg', '默认规格', 11.60, 1);
INSERT INTO `order_item` VALUES (70, 83, 7, 5, '苹果 Apple Watch 运动表带', 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg', '默认规格', 149.00, 1);
INSERT INTO `order_item` VALUES (71, 84, 7, 5, '苹果 Apple Watch 运动表带', 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg', '默认规格', 149.00, 1);
INSERT INTO `order_item` VALUES (72, 85, 7, 5, '苹果 Apple Watch 运动表带', 'http://localhost:9090/files/download/1773558805173-apple-watch-band.jpg', '默认规格', 149.00, 1);
INSERT INTO `order_item` VALUES (73, 86, 10, 8, '倍思 100W 氮化镓充电头', 'http://localhost:9090/files/download/1773558705181-baseus-gan-100w.jpg', '默认规格', 169.00, 1);
INSERT INTO `order_item` VALUES (74, 87, 8, 6, 'oppoFindX8s光彩磁吸全包保护壳', 'http://localhost:9090/files/download/1773762230279-oppoFindx8s-case.jpg', '默认规格', 65.55, 1);
INSERT INTO `order_item` VALUES (75, 88, 12, 87, '小米屏下挂灯', 'http://localhost:9090/files/download/1773676258041-mi-lightbar.png', '默认规格', 199.00, 1);
INSERT INTO `order_item` VALUES (76, 89, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (77, 90, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (78, 90, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 2);
INSERT INTO `order_item` VALUES (79, 91, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (80, 91, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (81, 92, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (82, 92, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (83, 93, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 1);
INSERT INTO `order_item` VALUES (84, 94, 11, 83, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847221886-ugreen-typec-cable-2mi.jpg', '2米', 24.60, 2);
INSERT INTO `order_item` VALUES (85, 94, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 3);
INSERT INTO `order_item` VALUES (88, 96, 16, 65, '华为FreeClip 2 耳夹耳机', 'http://localhost:9090/files/download/1773749996612-huawei-freeClip2.jpg', '默认规格', 1299.00, 1);
INSERT INTO `order_item` VALUES (89, 97, 1, 89, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 69.00, 1);
INSERT INTO `order_item` VALUES (90, 97, 1, 88, '华为快充套装', 'http://localhost:9090/files/download/1773558870281-huawei-charger-set.jpg', '[经典款]40W单口线充套装', 99.00, 1);
INSERT INTO `order_item` VALUES (91, 98, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (92, 98, 11, 82, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773847214863-ugreen-typec-cable-1.5mi.jpg', '1.5米', 21.70, 1);
INSERT INTO `order_item` VALUES (93, 98, 11, 81, '绿联 Type-C 编织数据线', 'http://localhost:9090/files/download/1773558680443-ugreen-typec-cable.jpg', '1米', 13.90, 1);
INSERT INTO `order_item` VALUES (94, 99, 22, 18, '倍思 【超瓷晶防爆膜】钢化膜', 'http://localhost:9090/files/download/1774251146652-baseus-strengthened -film.jpg', '默认规格', 34.80, 1);
INSERT INTO `order_item` VALUES (95, 100, 1, 93, '华为快充套装', 'http://localhost:9090/files/download/1773849176968-huawei-charger-set-dual-ports.jpg', '[升级款]40W双口线充套装', 49.00, 1);
INSERT INTO `order_item` VALUES (96, 101, 23, 84, '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标', 'http://localhost:9090/files/download/1774251788733-razer-mouse.jpg', '默认规格', 1399.00, 1);
INSERT INTO `order_item` VALUES (97, 104, 9, 7, '索尼 WH-1000XM5 耳机', 'http://localhost:9090/files/download/1773558744462-sony-xm5.jpg', '默认规格', 1699.00, 1);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单编号',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '总价',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '待付款' COMMENT '状态：待付款、已发货、已完成',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下单时间',
  `goods_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品摘要(方便展示)',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址快照',
  `user_delete` int NULL DEFAULT 0 COMMENT '用户逻辑删除(0否 1是)',
  `admin_delete` int NULL DEFAULT 0 COMMENT '管理员逻辑删除(0否 1是)',
  `receipt_time` datetime NULL DEFAULT NULL COMMENT '签收时间',
  `return_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退货原因',
  `express_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退货单号',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `pay_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付时间',
  `finish_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '交易最终完成时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (14, '2034557804152979456', 3, 27.80, '已完成', '2026-03-19 17:09:15', '绿联 Type-C 编织数据线 x2', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (15, '2034557870020329472', 3, 11.60, '已完成', '2026-03-19 17:09:31', '绿联超清纳米膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (16, '2034558049784004608', 3, 41.80, '已退款', '2026-03-19 17:10:13', '绿联Type-C数据线 1.2米 x2', '王明 | 14323125321 | 郑州市中原区', 0, 0, '2026-03-19 23:18:01', '7天无理由', 'saf1314324', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (18, '2034656299811610624', 3, 11.60, '已完成', '2026-03-19 23:40:38', '绿联超清纳米膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-19 23:41:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (19, '2034665444078002176', 3, 499.00, '已完成', '2026-03-20 00:16:58', '罗技 G502 无线鼠标 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-13 00:17:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (20, '2034667372543578112', 3, 379.00, '已完成', '2026-03-20 00:24:38', '华为手环11pro x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 00:25:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (21, '2034667783795085312', 3, 20.90, '已完成', '2026-03-20 00:26:16', '绿联Type-C数据线 1.2米 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 02:09:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (22, '2034678480625029120', 3, 958.90, '待发货', '2026-03-20 01:08:46', '漫步者M330Ⅱ复古桌面蓝牙音箱 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (23, '2034678550850260992', 3, 435.00, '已退款', '2026-03-20 01:09:03', '小米智能手表Watch S5 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 01:24:34', '不喜欢', 'daf3143', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (24, '2034678644362268672', 3, 1699.00, '已取消', '2026-03-20 01:09:25', '索尼 WH-1000XM5 耳机 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '价格高', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (25, '2034684943191855104', 3, 435.00, '已退款', '2026-03-20 01:34:27', '小米智能手表Watch S5 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 01:35:06', '质量问题', 'fad4331', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (27, '2034688815847264256', 3, 37.05, '待发货', '2026-03-20 01:49:51', '绿联轻薄电脑包 手提笔记本内胆包带肩带 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (28, '2034693917500821504', 3, 199.00, '已完成', '2026-03-20 02:10:07', '小米屏下挂灯 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 02:10:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (29, '2034694709200867328', 3, 1699.00, '已退款', '2026-03-20 02:13:16', '索尼 WH-1000XM5 耳机 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 02:13:57', '不喜欢', 'qweq13123', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (30, '2034695578579423232', 3, 3899.00, '已退款', '2026-03-20 02:16:43', '闪迪4TB移动固态硬盘 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-20 02:17:04', '不喜欢', 'addfa134144', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (31, '2034888758708965376', 3, 799.00, '已完成', '2026-03-20 15:04:21', 'JBL Flip 6 蓝牙音箱 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, '2026-03-20 15:04:34', '质量问题', NULL, NULL, '商品不符合7天无理由要求', NULL, NULL, NULL);
INSERT INTO `orders` VALUES (32, '2035043467772035072', 3, 3899.00, '已取消', '2026-03-21 01:19:06', '闪迪4TB移动固态硬盘 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (33, '2035737566464446464', 3, 958.90, '已取消', '2026-03-22 23:17:12', '漫步者M330Ⅱ复古桌面蓝牙音箱 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (34, '2036000554597564416', 4, 47.90, '已取消', '2026-03-23 16:42:13', '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘 x1', '小华 | 13442252355 | 南风路23号', 0, 0, NULL, NULL, NULL, '信息错误', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (36, '2036005650295222272', 4, 34.80, '已退款', '2026-03-23 17:02:28', '倍思 【超瓷晶防爆膜】钢化膜 x1', '小华 | 13442252355 | 南风路23号', 0, 0, '2026-03-23 17:02:41', '发错货', 'sd3134', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (37, '2036006088360914944', 4, 1399.00, '已退款', '2026-03-23 17:04:13', '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标 x1', '小华 | 13442252355 | 南风路23号', 1, 1, '2026-03-23 17:04:24', '7天无理由', 'sdf134', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (38, '2036008504967884800', 4, 1399.00, '已退款', '2026-03-23 17:13:49', '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标 x1', '小华 | 13442252355 | 南风路23号', 0, 0, '2026-03-23 17:14:03', '7天无理由', 'gdf3134', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (39, '2036009036176486400', 4, 34.80, '已完成', '2026-03-23 17:15:56', '倍思 【超瓷晶防爆膜】钢化膜 x1', '小华 | 13442252355 | 南风路23号', 0, 0, '2026-03-23 17:16:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (40, '2036612347992858624', 3, 3899.00, '已取消', '2026-03-25 09:13:16', '闪迪4TB移动固态硬盘 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (41, '2036612910113480704', 3, 34.80, '已取消', '2026-03-25 09:15:30', '倍思 【超瓷晶防爆膜】钢化膜 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (43, '2036618327757545472', 3, 47.90, '已取消', '2026-03-25 09:37:02', '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘 x1', '李明 | 15322352163 | 郑州市金水区', 1, 0, NULL, NULL, NULL, '其他', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (44, '2037094875782455296', 3, 958.90, '已完成', '2026-03-26 17:10:40', '漫步者M330Ⅱ复古桌面蓝牙音箱 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-26 18:10:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (46, '2037128663161974784', 3, 35.60, '已完成', '2026-03-26 19:24:55', '绿联 Type-C 编织数据线(1.5米) x1 绿联 Type-C 编织数据线(1米) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-03-26 19:25:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (47, '2038510353570598912', 3, 499.00, '已取消', '2026-03-30 14:55:16', '罗技 G502 无线鼠标(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (48, '2038511565497962496', 2, 499.00, '已取消', '2026-03-30 15:00:05', '罗技 G502 无线鼠标(默认规格) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (49, '2038523646058172416', 3, 499.00, '已取消', '2026-03-30 15:48:05', '罗技 G502 无线鼠标(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (50, '2038541901745467392', 3, 199.00, '已取消', '2026-03-30 17:00:38', '小米屏下挂灯(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (51, '2038897279809216512', 2, 13.90, '已取消', '2026-03-31 16:32:47', '绿联 Type-C 编织数据线(1米) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '信息错误', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (52, '2038897610135822336', 2, 21.70, '已完成', '2026-03-31 16:34:05', '绿联 Type-C 编织数据线(1.5米) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, '2026-03-31 16:34:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (53, '2039638989585530880', 2, 69.00, '已取消', '2026-04-02 17:40:04', '华为快充套装([升级款]40W双口线充套装) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '信息错误', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (54, '2039639574783213568', 2, 99.00, '已取消', '2026-04-02 17:42:23', '华为快充套装([经典款]40W单口线充套装) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (55, '2039639875019882496', 2, 21.70, '已取消', '2026-04-02 17:43:35', '绿联 Type-C 编织数据线(1.5米) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (56, '2039641368577982464', 2, 13.90, '已取消', '2026-04-02 17:49:31', '绿联 Type-C 编织数据线(1米) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (57, '2039645820915650560', 2, 47.90, '已退款', '2026-04-02 18:07:13', '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘(默认规格) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, '2026-04-02 18:07:40', '质量问题', 's123223123', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (58, '2039646359288123392', 2, 99.00, '已完成', '2026-04-02 18:09:21', '华为快充套装([经典款]40W单口线充套装) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, '2026-04-02 18:09:49', '7天无理由', NULL, NULL, '不符合7天无理由要求', NULL, NULL, NULL);
INSERT INTO `orders` VALUES (59, '2039739268230385664', 2, 34.80, '已完成', '2026-04-03 00:18:32', '倍思 【超瓷晶防爆膜】钢化膜(默认规格) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, '2026-04-03 00:18:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (60, '2039959457391714304', 2, 398.00, '已取消', '2026-04-03 14:53:29', '小米屏下挂灯(默认规格) x2', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (61, '2040009975422001152', 5, 958.90, '已退款', '2026-04-03 18:14:14', '漫步者M330Ⅱ复古桌面蓝牙音箱(默认规格) x1', 'das | 14313413421 | 1341会挥发', 0, 0, '2026-04-03 18:32:29', '质量问题', 'jd1341431', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (62, '2040135758228582400', 3, 199.00, '已取消', '2026-04-04 02:34:03', '小米屏下挂灯(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 1, 0, NULL, NULL, NULL, '信息错误', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (63, '2040307418298695680', 3, 199.00, '已取消', '2026-04-04 13:56:10', '小米屏下挂灯(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付系统自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (64, '2040505270249570304', 3, 21.70, '已完成', '2026-04-05 03:02:21', '绿联 Type-C 编织数据线(1.5米) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-04-05 03:04:12', '7天无理由', NULL, NULL, '商品不符合7天无理由要求', NULL, NULL, NULL);
INSERT INTO `orders` VALUES (65, '2040702237638508544', 3, 998.00, '已退款', '2026-04-05 16:05:02', '罗技 G502 无线鼠标(默认规格) x2', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-04-05 23:01:18', '质量问题', 'sf134145', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (66, '2040804695417143296', 3, 966.00, '已取消', '2026-04-05 22:52:10', '华为快充套装([升级款]40W双口线充套装) x14', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (67, '2053378685205561344', 2, 168.00, '已取消', '2026-05-10 15:36:43', '华为快充套装([升级款]40W双口线充套装) x1 华为快充套装([经典款]40W单口线充套装) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, '超时未支付自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (68, '2053379082439704576', 2, 71.85, '待收货', '2026-05-10 15:38:17', '倍思 【超瓷晶防爆膜】钢化膜(默认规格) x1 绿联轻薄电脑包 手提笔记本内胆包带肩带(默认规格) x1', '林浩 | 14223253512 | 郑州市高新区智谷街 71 号启源大厦 608 室', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (69, '2053512118673825792', 3, 102.60, '已退款', '2026-05-11 00:26:56', 'oppoFindX8s光彩磁吸全包保护壳(默认规格) x1 绿联轻薄电脑包 手提笔记本内胆包带肩带(默认规格) x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-11 00:27:21', '7天无理由', 'jd3413546', NULL, NULL, 'HIST_PAY_69', '2026-05-11 00:26:56', '2026-05-11 17:30:52');
INSERT INTO `orders` VALUES (70, '2053681307568988160', 3, 435.00, '已完成', '2026-05-11 11:39:13', '小米智能手表Watch S5 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-11 14:26:10', NULL, NULL, NULL, NULL, 'PAY799377612871', '2026-05-11 14:25:08', NULL);
INSERT INTO `orders` VALUES (71, '2053681493066276864', 3, 48.65, '已完成', '2026-05-11 11:39:58', '绿联超清纳米膜 钢化膜 x1 绿联轻薄电脑包 手提笔记本内胆包带肩带 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-11 16:22:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (72, '2053770091421757440', 3, 46.30, '已完成', '2026-05-11 17:32:01', '绿联 Type-C 编织数据线 x1 绿联 Type-C 编织数据线 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, '2026-05-11 17:36:31', NULL, NULL, NULL, NULL, 'PAY463653619246', '2026-05-11 17:36:04', '2026-05-11 17:36:49');
INSERT INTO `orders` VALUES (73, '2053802961855049728', 3, 1448.00, '已完成', '2026-05-11 19:42:38', '苹果 Apple Watch 运动表带 x1 华为FreeClip 2 耳夹耳机 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-13 14:02:16', NULL, NULL, NULL, NULL, 'PAY111362305315', '2026-05-11 19:42:59', '2026-05-13 14:02:39');
INSERT INTO `orders` VALUES (74, '2053876529217282048', 3, 11.60, '待发货', '2026-05-12 00:34:58', '绿联超清纳米膜 钢化膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, NULL, NULL, 'UNP394758250948', '2026-05-12 00:45:03', NULL);
INSERT INTO `orders` VALUES (75, '2053879501003382784', 3, 129.90, '已完成', '2026-05-12 00:46:46', '闪迪 128GB 高速U盘 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-12 16:03:42', NULL, NULL, NULL, NULL, 'WXP224930694252', '2026-05-12 00:46:50', '2026-05-12 16:03:49');
INSERT INTO `orders` VALUES (76, '2054127805335224320', 3, 24.60, '已取消', '2026-05-12 17:13:27', '绿联 Type-C 编织数据线 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '其他', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (77, '2054143561766776832', 3, 24.60, '已完成', '2026-05-12 18:16:03', '绿联 Type-C 编织数据线 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-12 18:16:55', NULL, NULL, NULL, NULL, 'ALP676694035659', '2026-05-12 18:16:32', '2026-05-12 18:16:57');
INSERT INTO `orders` VALUES (78, '2054144221820203008', 3, 24.60, '已完成', '2026-05-12 18:18:41', '绿联 Type-C 编织数据线 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, '2026-05-12 18:19:04', NULL, NULL, NULL, NULL, 'WXP135328176406', '2026-05-12 18:18:50', '2026-05-12 18:19:06');
INSERT INTO `orders` VALUES (79, '2054150865895428096', 3, 435.00, '待发货', '2026-05-12 18:45:05', '小米智能手表Watch S5 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, NULL, NULL, 'ALP060875587114', '2026-05-13 14:00:59', NULL);
INSERT INTO `orders` VALUES (80, '2054442263488188416', 3, 169.00, '已完成', '2026-05-13 14:02:59', '倍思 100W 氮化镓充电头 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-13 14:03:24', NULL, NULL, NULL, NULL, 'UNP791535662453', '2026-05-13 14:03:08', '2026-05-20 14:05:33');
INSERT INTO `orders` VALUES (81, '2054443033595957248', 3, 47.90, '已取消', '2026-05-13 14:06:03', '金士顿（Kingston）64GB 高速U盘 USB3.2/Gen 1 高速哨兵车载行车记录仪闪存优盘 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, 'WXP180699118503', '2026-05-13 14:06:11', NULL);
INSERT INTO `orders` VALUES (82, '2054580519081054208', 3, 11.60, '已取消', '2026-05-13 23:12:22', '绿联超清纳米膜 钢化膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '其他', NULL, 'ALP194834307526', '2026-05-13 23:12:46', NULL);
INSERT INTO `orders` VALUES (83, '2054599642196357120', 3, 149.00, '已取消', '2026-05-14 00:28:21', '苹果 Apple Watch 运动表带 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (84, '2054599781698908160', 3, 149.00, '已取消', '2026-05-14 00:28:55', '苹果 Apple Watch 运动表带 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '信息错误', NULL, 'ALP667286761394', '2026-05-14 00:28:57', NULL);
INSERT INTO `orders` VALUES (85, '2054599922833043456', 3, 149.00, '已退款', '2026-05-14 00:29:28', '苹果 Apple Watch 运动表带 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-14 00:30:38', '7天无理由', 'jd15131', NULL, NULL, 'ALP007089630673', '2026-05-14 00:29:31', '2026-05-14 00:33:10');
INSERT INTO `orders` VALUES (86, '2054820215501549568', 3, 169.00, '已完成', '2026-05-14 15:04:50', '倍思 100W 氮化镓充电头 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-14 15:05:46', '7天无理由', NULL, NULL, '不符合7天无理由要求', 'UNP494499910806', '2026-05-14 15:04:54', '2026-05-14 16:35:52');
INSERT INTO `orders` VALUES (87, '2054843168926724096', 3, 65.55, '已完成', '2026-05-14 16:36:03', 'oppoFindX8s光彩磁吸全包保护壳 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-14 16:36:16', '质量问题', NULL, NULL, '商品不符合7天无理由要求', 'ALP901762782141', '2026-05-14 16:36:05', '2026-05-14 16:36:46');
INSERT INTO `orders` VALUES (88, '2054849053057085440', 3, 199.00, '已退款', '2026-05-14 16:59:26', '小米屏下挂灯 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-14 16:59:42', '7天无理由', 'sf1341412', NULL, NULL, 'ALP291136240093', '2026-05-14 16:59:29', '2026-05-14 17:00:37');
INSERT INTO `orders` VALUES (89, '2054963667241418752', 3, 34.80, '已退款', '2026-05-15 00:34:52', '倍思 【超瓷晶防爆膜】钢化膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-15 00:35:06', '不喜欢', 'sf1523132', NULL, NULL, 'UNP351634782701', '2026-05-15 00:34:55', '2026-05-15 00:35:50');
INSERT INTO `orders` VALUES (91, '2055326850473381888', 7, 168.00, '已完成', '2026-05-16 00:38:01', '华为快充套装 x1 华为快充套装 x1', '李明 | 14523552366 | 郑州市', 0, 0, '2026-05-16 00:42:07', NULL, NULL, NULL, NULL, 'WXP776473357272', '2026-05-16 00:38:31', '2026-05-16 00:42:09');
INSERT INTO `orders` VALUES (92, '2055329017515069440', 8, 168.00, '已退款', '2026-05-16 00:46:38', '华为快充套装 x1 华为快充套装 x1', '李明 | 13536636742 | 郑州市', 0, 0, '2026-05-16 00:47:10', '7天无理由', 'jd34134', NULL, NULL, 'WXP816569508269', '2026-05-16 00:46:57', '2026-05-16 00:47:38');
INSERT INTO `orders` VALUES (93, '2055329623340339200', 8, 13.90, '已取消', '2026-05-16 00:49:03', '绿联 Type-C 编织数据线 x1', '11 | 13519123476 | 郑州市', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (94, '2055960862522499072', 3, 90.90, '已取消', '2026-05-17 18:37:22', '绿联 Type-C 编织数据线 x2 绿联 Type-C 编织数据线 x3', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '信息错误', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (96, '2055962140271075328', 3, 1299.00, '已完成', '2026-05-17 18:42:26', '华为FreeClip 2 耳夹耳机 x1', '王明 | 14323125321 | 郑州市中原区', 0, 0, '2026-05-17 18:42:40', NULL, NULL, NULL, NULL, 'ALP517468932257', '2026-05-17 18:42:29', '2026-05-17 18:42:42');
INSERT INTO `orders` VALUES (97, '2056007739720753152', 3, 168.00, '已取消', '2026-05-17 21:43:38', '华为快充套装 x1 华为快充套装 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '不想买了', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (98, '2056021678860935168', 3, 70.40, '已取消', '2026-05-17 22:39:01', '倍思 【超瓷晶防爆膜】钢化膜 x1 绿联 Type-C 编织数据线 x1 绿联 Type-C 编织数据线 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '信息错误', NULL, 'ALP791884353778', '2026-05-17 22:41:02', NULL);
INSERT INTO `orders` VALUES (99, '2056030763861811200', 3, 34.80, '已完成', '2026-05-17 23:15:07', '倍思 【超瓷晶防爆膜】钢化膜 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-17 23:15:23', NULL, NULL, NULL, NULL, 'ALP221861023277', '2026-05-17 23:15:11', '2026-05-17 23:15:47');
INSERT INTO `orders` VALUES (100, '2056038364486012928', 3, 49.00, '已完成', '2026-05-17 23:45:20', '华为快充套装 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-17 23:45:53', NULL, NULL, NULL, NULL, 'ALP154487801524', '2026-05-17 23:45:33', '2026-05-17 23:45:56');
INSERT INTO `orders` VALUES (101, '2056380093479227392', 3, 1399.00, '已取消', '2026-05-18 22:23:14', '雷蛇（Razer） 炼狱蝰蛇V4pro专业版电竞游戏鼠标 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, NULL, NULL, NULL, '超时未支付自动取消', NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (104, '2057082978470957056', 3, 1699.00, '退货待审核', '2026-05-20 20:56:15', '索尼 WH-1000XM5 耳机 x1', '李明 | 15322352163 | 郑州市金水区', 0, 0, '2026-05-20 20:56:45', '7天无理由', NULL, NULL, NULL, 'ALP404751030091', '2026-05-20 20:56:31', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'USER' COMMENT '角色',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '男' COMMENT '性别',
  `birthday` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生日',
  `username_update_count` int NULL DEFAULT 0 COMMENT '当日修改账号次数',
  `last_update_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后一次修改账号的日期',
  `status` int NULL DEFAULT 1 COMMENT '帐号状态：1正常，0禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'user1', '123456', '王明', NULL, 'USER', '男', NULL, 0, NULL, 1);
INSERT INTO `user` VALUES (2, 's111', '111', '林浩', 'http://localhost:9090/files/download/1775052475768-avatar-boy3.png', 'USER', '男', '2026-03-23', 0, NULL, 1);
INSERT INTO `user` VALUES (3, 's222', '222', '小明', 'http://localhost:9090/files/download/1774085149606-default-boy-avatar.png', 'USER', '保密', '2003-03-05', 1, '2026-05-15', 1);
INSERT INTO `user` VALUES (4, 's333', '333', '小华', NULL, 'USER', '女', '2005-03-09', 0, NULL, 1);
INSERT INTO `user` VALUES (5, 's444', '444', '小美', 'http://localhost:9090/files/download/1775210273172-avatar-girl2.png', 'USER', '男', '2026-04-14', 0, NULL, 0);
INSERT INTO `user` VALUES (7, 's11', '11', '李明', 'http://localhost:9090/files/download/1778862980893-avatar-boy1.png', 'USER', '男', '2026-05-16', 0, NULL, 1);
INSERT INTO `user` VALUES (8, 's1212', '12', '李明', 'http://localhost:9090/files/download/1778863406939-avatar-boy3.png', 'USER', '男', '2026-05-16', 1, '2026-05-16', 1);

-- ----------------------------
-- Triggers structure for table goods_sku
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_sku_insert_sync_stock`;
delimiter ;;
CREATE TRIGGER `tr_sku_insert_sync_stock` AFTER INSERT ON `goods_sku` FOR EACH ROW BEGIN
    UPDATE goods SET stock = (SELECT IFNULL(SUM(stock), 0) FROM goods_sku WHERE goods_id = NEW.goods_id)
    WHERE id = NEW.goods_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table goods_sku
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_sku_update_sync_stock`;
delimiter ;;
CREATE TRIGGER `tr_sku_update_sync_stock` AFTER UPDATE ON `goods_sku` FOR EACH ROW BEGIN
    UPDATE goods SET stock = (SELECT IFNULL(SUM(stock), 0) FROM goods_sku WHERE goods_id = NEW.goods_id)
    WHERE id = NEW.goods_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table goods_sku
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_sku_delete_sync_stock`;
delimiter ;;
CREATE TRIGGER `tr_sku_delete_sync_stock` AFTER DELETE ON `goods_sku` FOR EACH ROW BEGIN
    UPDATE goods SET stock = (SELECT IFNULL(SUM(stock), 0) FROM goods_sku WHERE goods_id = OLD.goods_id)
    WHERE id = OLD.goods_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
