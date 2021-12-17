/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.90.205
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : 192.168.90.205:32490
 Source Schema         : aiops_dev

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 13/04/2021 09:44:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for air_conditioner
-- ----------------------------
DROP TABLE IF EXISTS `air_conditioner`;
CREATE TABLE `air_conditioner`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `mount_point_id` bigint(32) NULL DEFAULT NULL COMMENT '安装点id,外键',
  `number` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号,自定义编号唯一硬件资源编码',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '空调名称',
  `position` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装位置',
  `brand` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `production_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产日期',
  `install_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装日期',
  `cooling_capacity` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '制冷量',
  `rated_voltage` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定电压,220V',
  `rated_current` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定电流,24V',
  `rated_power` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定功率,750W',
  `manufacturer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产商',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供货商',
  `service_provider` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务商',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for alert_stat_min
-- ----------------------------
DROP TABLE IF EXISTS `alert_stat_min`;
CREATE TABLE `alert_stat_min`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `time` datetime(0) NOT NULL COMMENT '时间',
  `urgent_count` int(11) NOT NULL DEFAULT 0 COMMENT '紧急告警数量',
  `urgent_recovery_count` int(11) NOT NULL DEFAULT 0 COMMENT '紧急告警恢复数量',
  `critical_count` int(11) NOT NULL DEFAULT 0 COMMENT '严重告警数量',
  `critical_recovery_count` int(11) NOT NULL DEFAULT 0 COMMENT '严重告警恢复数量',
  `secondary_count` int(11) NOT NULL DEFAULT 0 COMMENT '次要告警数量',
  `secondary_recovery_count` int(11) NOT NULL DEFAULT 0 COMMENT '次要告警恢复数量',
  `warn_count` int(11) NOT NULL DEFAULT 0 COMMENT '警告告警数量',
  `warn_recovery_count` int(11) NOT NULL DEFAULT 0 COMMENT '警告告警恢复数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 675000 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '告警统计表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_ldu_relation
-- ----------------------------
DROP TABLE IF EXISTS `app_ldu_relation`;
CREATE TABLE `app_ldu_relation`  (
  `ldu_relation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `from_ldu_id` bigint(20) NULL DEFAULT NULL COMMENT '链出ldu的id',
  `to_ldu_id` bigint(20) NULL DEFAULT NULL COMMENT '链入ldu的id',
  `relation_id` bigint(20) NULL DEFAULT NULL COMMENT '全局关系id',
  `audit_status` tinyint(4) NULL DEFAULT NULL COMMENT '审核状态:是否生效 1生效0未生效-1失效',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`ldu_relation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '逻辑部署单元关系' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_maintenance_plan
-- ----------------------------
DROP TABLE IF EXISTS `app_maintenance_plan`;
CREATE TABLE `app_maintenance_plan`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `application_id` int(11) NOT NULL COMMENT '业务系统id',
  `maintenance_ticket_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '检修票号',
  `operation_ticket_number` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作票号',
  `maintenance_start_time` datetime(0) NOT NULL COMMENT '检修起始时间',
  `maintenance_end_time` datetime(0) NOT NULL COMMENT '检修结束时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停机检修描述',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `object_type` tinyint(2) NOT NULL COMMENT '对象类型 1业务系统  2平台系统  3.设备',
  `object_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计划名称',
  `mark_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标识字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 154054 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务系统停机检修' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system
-- ----------------------------
DROP TABLE IF EXISTS `app_system`;
CREATE TABLE `app_system`  (
  `application_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `system_name_id` int(11) NOT NULL COMMENT '系统名称,id,来自分组',
  `owning_system_id` int(11) NOT NULL COMMENT '所属系统，数据字典',
  `business_type_id` int(11) NULL DEFAULT NULL COMMENT '业务类型，数据字典',
  `system_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统版本号',
  `system_type` enum('测试系统','生产系统') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测试系统、生产系统',
  `current_status_id` int(11) NULL DEFAULT NULL COMMENT '当前状态id,数据字典',
  `update_date` date NULL DEFAULT NULL COMMENT '版本更新日期',
  `system_online_time` date NULL DEFAULT NULL COMMENT '系统上线时间',
  `system_logout_time` date NULL DEFAULT NULL COMMENT '系统下线时间',
  `deploy_way_id` int(11) NULL DEFAULT NULL COMMENT '部署方式,数据字典',
  `access_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '访问地址',
  `network` enum('内网','外网') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内网/外网',
  `system_level_id` int(11) NULL DEFAULT NULL COMMENT '系统等级,数据字典',
  `construction_type_id` int(11) NULL DEFAULT NULL COMMENT '建设类型,数据字典',
  `software_ids` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用软件ids,以逗号隔开',
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `intake_i6000_monitor` tinyint(2) NULL DEFAULT NULL COMMENT '是否纳入i6000监控',
  `filing_in_i6000` tinyint(2) NULL DEFAULT NULL COMMENT '是否在i6000备案',
  `filing_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'i6000备案编号',
  `access_property_monitor` tinyint(2) NULL DEFAULT NULL COMMENT '是否接入性能检测',
  `third_party_security_assessment` tinyint(2) NULL DEFAULT NULL COMMENT '第三方安全测评',
  `evaluate_company_vendor_id` int(11) NULL DEFAULT NULL COMMENT '测评厂商',
  `evaluate_report_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '测评报告编号',
  `security_level_id` int(11) NULL DEFAULT NULL COMMENT '等级保护安全等级,数据字典',
  `security_level_evaluation_date` date NULL DEFAULT NULL COMMENT '等级保护测评日期',
  `occupy_company_id` int(11) NULL DEFAULT NULL COMMENT '使用部门,来自company,id',
  `occupy_org_id` int(11) NULL DEFAULT NULL COMMENT '使用部门,来自org,id',
  `system_vendor_id` int(11) NULL DEFAULT NULL COMMENT '系统实施厂商,id',
  `system_vendor_contacts` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统实施厂商联系方式',
  `outsourcing_maintain_company_id` int(11) NULL DEFAULT NULL COMMENT '外委运维厂商,来自company,id',
  `outsourcing_maintain_org_id` int(11) NULL DEFAULT NULL COMMENT '外委运维厂商,来自org,id',
  `outsourcing_maintain_contacts_id` int(11) NULL DEFAULT NULL COMMENT '外委运维联系人,id',
  `outsourcing_maintain_contacts` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外委运维联系人联系方式',
  `business_charge_company_id` int(11) NULL DEFAULT NULL COMMENT '业务主管部门,来自company,id',
  `business_charge_org_id` int(11) NULL DEFAULT NULL COMMENT '业务主管部门,来自org,id',
  `business_director_id` int(11) NOT NULL COMMENT '业务负责人,id',
  `business_director_contacts` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务负责人联系方式',
  `maintain_company_id` int(11) NULL DEFAULT NULL COMMENT '运维部门,来自company,id',
  `maintain_org_id` int(11) NULL DEFAULT NULL COMMENT '运维部门,来自org,id',
  `maintainer_id` int(11) NOT NULL COMMENT '运维责任人',
  `maintainer_contacts` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运维责任人联系方式',
  `is_monitor` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否监控',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'system' COMMENT '创建人 ',
  `gmt_create` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'system' COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`application_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 577003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用系统' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system_group
-- ----------------------------
DROP TABLE IF EXISTS `app_system_group`;
CREATE TABLE `app_system_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分组名称',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modify` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 126003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务系统分组' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system_interrupt
-- ----------------------------
DROP TABLE IF EXISTS `app_system_interrupt`;
CREATE TABLE `app_system_interrupt`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `interrupt_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `app_id` bigint(20) UNSIGNED NOT NULL COMMENT '业务系统标识',
  `start_time` datetime(0) NOT NULL COMMENT '业务系统中断开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '业务系统中断结束时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务系统中断记录' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system_ldu
-- ----------------------------
DROP TABLE IF EXISTS `app_system_ldu`;
CREATE TABLE `app_system_ldu`  (
  `ldu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NULL DEFAULT NULL,
  `ldu_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '逻辑部署单元名称',
  `ldu_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件类型',
  `node_count` int(11) NULL DEFAULT NULL COMMENT '节点数量',
  `ldu_nodes` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ldu节点',
  `cluster_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群id',
  `cluster_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群编码',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '0 集群， 1 实例',
  `ci_mapping_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '映射键',
  `architecture_pattern_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '架构模式编码',
  `architecture_pattern_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '架构模式名称',
  `description` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`ldu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 224236 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '逻辑部署单元' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system_ldu_weight
-- ----------------------------
DROP TABLE IF EXISTS `app_system_ldu_weight`;
CREATE TABLE `app_system_ldu_weight`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `app_id` int(11) NOT NULL COMMENT '业务系统id',
  `weight` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权重，以json字符串存储',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务系统组件权重表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for app_system_score
-- ----------------------------
DROP TABLE IF EXISTS `app_system_score`;
CREATE TABLE `app_system_score`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `time` datetime(0) NOT NULL COMMENT '时间',
  `app_id` int(11) NOT NULL COMMENT '业务系统id',
  `score` int(11) NOT NULL COMMENT '分数',
  `interrupt_count` int(11) NULL DEFAULT NULL COMMENT '中断次数',
  `interrupt_time` int(11) NULL DEFAULT NULL COMMENT '中断时长',
  `max_interrupt_time` int(11) NULL DEFAULT NULL COMMENT '最大中断时长',
  `average_interrupt_time` int(11) NULL DEFAULT NULL COMMENT '平均中断时长',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for auth_user_status
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_status`;
CREATE TABLE `auth_user_status`  (
  `user_status_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户编码， 关联用户表User',
  `channel_id` tinyint(1) NULL DEFAULT NULL COMMENT '渠道编码， 用于标识不同登录渠道，可动态扩展，默认1\n1：kangpaas-web\n',
  `login_fail_times` int(11) NULL DEFAULT NULL COMMENT '登录失败次数',
  `lock_status` tinyint(1) NULL DEFAULT NULL COMMENT '锁定状态（暂时不用），1：锁定 0：正常， 默认0',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`user_status_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户状态' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cloud_platform
-- ----------------------------
DROP TABLE IF EXISTS `cloud_platform`;
CREATE TABLE `cloud_platform`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `platform_name` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '云平台名称',
  `platform_address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '资源池地址',
  `cluster_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '集群名称',
  `login_address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '登录地址',
  `cluster_count` int(11) NULL DEFAULT NULL COMMENT '集群数量',
  `software_classification` int(11) NULL DEFAULT NULL COMMENT '软件分类',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '密码',
  `maintenance_id` int(11) NULL DEFAULT NULL COMMENT '运维项目id',
  `version` int(11) NULL DEFAULT NULL COMMENT '虚拟化软件版本',
  `area` int(11) NULL DEFAULT NULL COMMENT '集群所在区域',
  `login_way` int(11) NULL DEFAULT NULL COMMENT '登录方式',
  `platform_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '平台类型',
  `sync_status` tinyint(4) NULL DEFAULT NULL COMMENT '同步状态 0:未同步 1:同步中 2:同步成功 3:同步失败',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `network` tinyint(2) NOT NULL DEFAULT 0 COMMENT '0 内网 1 外网',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 120113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cloud_platform_property
-- ----------------------------
DROP TABLE IF EXISTS `cloud_platform_property`;
CREATE TABLE `cloud_platform_property`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `cloud_platform_id` int(11) NOT NULL COMMENT '云平台id',
  `property` json NOT NULL COMMENT '云平台属性',
  `sync_time` datetime(0) NULL DEFAULT NULL COMMENT '同步时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cloud_platform_id`(`cloud_platform_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 150012 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cloud_property
-- ----------------------------
DROP TABLE IF EXISTS `cloud_property`;
CREATE TABLE `cloud_property`  (
  `property_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '属性唯一id',
  `tenant_id` bigint(20) NULL DEFAULT NULL,
  `platform_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ciid` bigint(20) NULL DEFAULT NULL COMMENT '所属配置项id',
  `parent_id` bigint(20) NULL DEFAULT NULL,
  `attribute_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联的配置项属性名称',
  `property_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性的名称-vmware中的属性名称字符串 如configuration.drsconfig.enabled',
  `property_type` tinyint(4) NULL DEFAULT 1 COMMENT '属性类型 0自动属性 1基础属性，从vcenter直接赋值(字符串类型) 2mor属性中的属性 3mor列表中属性计数keycount 4mor列表中的属性值汇总valuecount 5属性列表中的单个属性 6属性列表中的数据值汇总',
  `property_default` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pchild_mor` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `data_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性的数据库数据类型如varchar(25)',
  `property_display` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '属性的显示名称',
  `sync_enabled` tinyint(4) NULL DEFAULT 1 COMMENT '是否需要同步 1需要 0不需要',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`property_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_asset
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_asset`;
CREATE TABLE `cmdb_asset`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `asset_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资产类型,对应cmdb_asset_category的asset_category_type',
  `asset_uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资产唯一标识',
  `asset_desc` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(4) NOT NULL DEFAULT 0 COMMENT '删除状态:\'1\':已删除,\'0\':未删除',
  `CREATOR` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_CREATE` datetime(0) NULL DEFAULT NULL,
  `UPDATER` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_MODIFIED` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 335018 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_asset_category
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_asset_category`;
CREATE TABLE `cmdb_asset_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `asset_category_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资产类型,相同用途下唯一',
  `asset_category_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `asset_category_purpose` tinyint(1) NOT NULL COMMENT '用途 0-设备 1-软件 2-虚拟机',
  `asset_category_leaf` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否叶子节点 0否 1是',
  `asset_category_desc` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `asset_category_parent_id` int(11) NOT NULL DEFAULT 0 COMMENT '父分类id',
  `asset_category_display_order` int(6) NOT NULL DEFAULT 0 COMMENT '显示顺序 从小到大',
  `CREATOR` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_CREATE` datetime(0) NULL DEFAULT NULL,
  `UPDATER` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_MODIFIED` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产分类' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_asset_extend
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_asset_extend`;
CREATE TABLE `cmdb_asset_extend`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `asset_id` int(11) NOT NULL COMMENT '资产id',
  `asset_extend_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'key值',
  `asset_extend_value` json NULL COMMENT 'value值',
  `CREATOR` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_CREATE` datetime(0) NULL DEFAULT NULL,
  `UPDATER` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_MODIFIED` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cmdb_asset_extend_unique`(`asset_id`, `asset_extend_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 482466 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产扩展数据' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_asset_extend_template
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_asset_extend_template`;
CREATE TABLE `cmdb_asset_extend_template`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `asset_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资产类型,对应cmdb_asset_category的asset_category_type',
  `asset_extend_template_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'key值',
  `asset_extend_template_ui` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板界面配置',
  `asset_extend_template_data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板数据配置',
  `asset_extend_template_excel` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板Excel配置',
  `asset_extend_template_alert` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板告警配置',
  `asset_extend_template_desc` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `CREATOR` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_CREATE` datetime(0) NULL DEFAULT NULL,
  `UPDATER` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_MODIFIED` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 670269 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产扩展数据模板' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_asset_his
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_asset_his`;
CREATE TABLE `cmdb_asset_his`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `asset_id` int(11) NOT NULL COMMENT '资产id',
  `asset_extend_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'key值',
  `asset_extend_oldvalue` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原来value值',
  `asset_extend_newvalue` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '新value值',
  `asset_his_version` int(11) NULL DEFAULT NULL,
  `CREATOR` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_CREATE` datetime(0) NULL DEFAULT NULL,
  `UPDATER` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `GMT_MODIFIED` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 397182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产历史数据' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_atomic_system
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_atomic_system`;
CREATE TABLE `cmdb_atomic_system`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源编码',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源名称',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型  weblogic,oracle...',
  `ip` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip + port ',
  `uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'uuid 唯一',
  `host_uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应主机 uuid',
  `config` json NULL COMMENT '配置信息 非共性信息',
  `collect_time` datetime(0) NULL DEFAULT NULL COMMENT '采集时间',
  `version` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '版本',
  `related_host_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联主机编码',
  `maintain_owner_id` bigint(20) NULL DEFAULT NULL COMMENT '运维负责人id',
  `maintain_department_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运维部门id',
  `installation_date` datetime(0) NULL DEFAULT NULL COMMENT '安装日期',
  `account` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登陆账户',
  `login_address` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录地址',
  `comment` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `online_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0 断链 1正常',
  `task_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cmdb_atomic_system_uuid_uindex`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 189218 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '原子系统' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_attribute
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attribute`;
CREATE TABLE `cmdb_attribute`  (
  `attribute_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'uuid',
  `field_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字段模型 使用数据字典中FIELD_MODEL下的值作为模型',
  `attribute_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性名，系统内使用的名称，英文  产生方式：手工维护 组成字符：英文、数字、“_” 数据长度：50 规则：按照数据表字段命名规则命名',
  `display_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性显示名称，用于界面显示。一般中文  产生方式：手工维护 组成字符：中文、英文、数字 数据长度：50 规则：内容无空格',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位。自行定义  产生方式：手工维护 组成字符：英文、数字 数据长度：50 规则：',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性的描述说明  产生方式：手工维护 组成字符：英文、数字、中文、符号 数据长度：50 规则：',
  `is_predefined` tinyint(1) NOT NULL DEFAULT 0 COMMENT '表明该属性是否由系统预先设置，预先设置的属性。不可以对其属性、约整、状态等进行修改  产生方式：手工维护 组成字符：0，1 数据长度：1 规则： 0：非预设 1：有预设',
  `is_valid` tinyint(1) NOT NULL DEFAULT 1 COMMENT '属性的状态。有效、无效。 当状态为无效时，不可被后续业务引用（如：配置项属性分配），但不影响已使用的业务。  产生方式：手工维护 组成字符：0，1 数据长度：1 规则： 0：无效 1：有效',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否作为默认属性,如果作为默认属性则创建配置项实例表的时候默认属性会作为初始属性预制进去',
  `data_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据格式 的描述。  产生方式：手工维护 组成字符：字母 数据长度：50 规则：  详见 数据格式   日期时间：datetime 整数数字：int 浮点数字：decimal（m，d），m表示该值的总共长度，d表示小数点后面的长度 字符串：varchar 普通文本：text',
  `max_length` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性值的最大长度',
  `min_value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性值的最小值',
  `max_value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性值的最大值',
  `place_holder` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '前段输入框中的提示内容文字',
  `constraint_id` bigint(20) NULL DEFAULT NULL COMMENT '约束记录的 uuid',
  `is_referred` tinyint(1) NULL DEFAULT NULL COMMENT '表明该属性的值来源，是否引用的其他数据表的数据对象集规则： 0：无引用 1：引用其他表 具体数据关联为table_name、table_column、table_condition2：引用syscode表数据,具体关联数据为code_category_id3：引用API，具体关联数据为url和key_name4：引用固定数据值，具体关联实质为syscode，关联数据为category_id和column_condition；5：引用标签库，具体关联为标签类型label_type',
  `referred_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源字段的名称或描述信息',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '引用的系统代码的分类id。  实例化后，该属性的值，将是该分类对应的name-value的name值  产生方式：手工维护 组成字符：英文、数字 数据长度：20 规则：',
  `table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为表是，表的名称',
  `table_field` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为表时，标的字段名称',
  `table_field_extra` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为表时，表的字段名称 - 级联使用',
  `table_condition` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为表是，筛选字段内容的条件，如a>20;a<30',
  `url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为URL时，获取的url地址',
  `url_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为URL时，获取结果中的json key',
  `url_key_extra` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为URL时，获取结果中的json key - 级联使用',
  `label_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源为标签时，值所属的标签类型',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  `is_generated` tinyint(1) NULL DEFAULT 0 COMMENT '是否自动生成的属性, 1:是/0:否，默认:0，如果是自动生成的属性，则新增、编辑时置灰，且不作为记录差异判断依据',
  PRIMARY KEY (`attribute_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '全局属性表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_attribute_group
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attribute_group`;
CREATE TABLE `cmdb_attribute_group`  (
  `group_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'uuid',
  `group_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组名。一般是英文  产生方式：手工维护 组成字符：中文、数字、英文 数据长度：50 规则：无',
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '默认属性所在的分组。该分组不可删除，系统预设。  产生方式：手工维护 组成字符：0，1 数据长度：1 规则： 0：不是默认分组 1：是默认分组  只能有一个唯一的默认分组。',
  `display_order` smallint(6) NULL DEFAULT 1 COMMENT '显示顺序',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述信息',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  `is_predefined` tinyint(1) NULL DEFAULT 0 COMMENT '是否预置记录, 1:是/0:否，默认:0，预置记录无法编辑删除',
  PRIMARY KEY (`group_id`) USING BTREE,
  INDEX `uk_attributegroup`(`group_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_category
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_category`;
CREATE TABLE `cmdb_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类类别,相同用途下唯一',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `purpose` tinyint(1) NULL DEFAULT NULL COMMENT '用途 0-设备 1-软件 2-平台 3-中台 4-镜像 5-应用',
  `leaf` tinyint(1) NULL DEFAULT NULL COMMENT '是否叶子节点 0否 1是',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父节点',
  `display_order` int(10) NULL DEFAULT NULL COMMENT '排序 从小到大显示',
  `is_predefined` tinyint(1) NULL DEFAULT NULL COMMENT '是否预置 1是 0否',
  `excel_id` int(11) NULL DEFAULT NULL COMMENT 'excel导出模板id, 对应属性表的device_id',
  `contains_port` tinyint(1) NULL DEFAULT 0 COMMENT '是否包含端口 0-不包含 1-包含',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '--备注',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_device_prop`(`purpose`, `type`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资源台账分类' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_ci_instance_host_config
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_instance_host_config`;
CREATE TABLE `cmdb_ci_instance_host_config`  (
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `config` json NULL,
  `task_id` int(64) NULL DEFAULT NULL COMMENT '任务id',
  `basetaskid` int(64) NULL DEFAULT NULL COMMENT '基础版本最后变更任务id',
  `change_status` tinyint(4) NOT NULL COMMENT '0 更新 1 新增',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_ci_instance_ip_info
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_instance_ip_info`;
CREATE TABLE `cmdb_ci_instance_ip_info`  (
  `task_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `task_type` tinyint(4) NULL DEFAULT NULL COMMENT 'ip扫描类型',
  `config` json NULL COMMENT '扫描结果',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 570065 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'ip信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_ci_instance_software_config
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_instance_software_config`;
CREATE TABLE `cmdb_ci_instance_software_config`  (
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `config` json NULL,
  `task_id` int(64) NULL DEFAULT NULL COMMENT '任务id',
  `basetaskid` int(64) NULL DEFAULT NULL COMMENT '基础版本最后变更任务id',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_ci_relation
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_relation`;
CREATE TABLE `cmdb_ci_relation`  (
  `ci_relation_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'uuid',
  `ci_id_from` bigint(20) UNSIGNED NOT NULL COMMENT '一对关系中起始配置项的uuid',
  `ci_id_to` bigint(20) UNSIGNED NOT NULL COMMENT '一对关系中，终止端配置项uuid',
  `relation_id` bigint(20) UNSIGNED NOT NULL COMMENT '关系自身的uuid',
  `relation_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关系的名称 对应于关系的方向的名称 name_linkout还是name_linkin',
  `relation_direction` tinyint(3) NOT NULL DEFAULT 1 COMMENT 'linkout=1还是linkin=0',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置项间关系描述说明  产生方式：手工维护组成字符：英文、数字、中文、符号 数据长度：50 规则：',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  `is_predefined` tinyint(1) NULL DEFAULT 0 COMMENT '是否预置记录, 1:是/0:否，默认:0，预置记录无法编辑删除',
  PRIMARY KEY (`ci_relation_id`) USING BTREE,
  INDEX `uk_cirelation`(`relation_id`, `ci_id_from`, `ci_id_to`) USING BTREE,
  INDEX `ixfk_ci_relation_ci_from`(`ci_id_from`) USING BTREE,
  INDEX `ixfk_ci_relation_ci_to`(`ci_id_to`) USING BTREE,
  INDEX `ixfk_ci_relation_relation`(`relation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置项间的关系定义' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_software
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_software`;
CREATE TABLE `cmdb_software`  (
  `soft_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '软件分类(oracle/mysql/pg)',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '软件名称',
  `soft_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '软件编号',
  `soft_type` varchar(6) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '软件类型 系统软件/工具软件/应用软件',
  `soft_version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '软件版本',
  `dev_language_id` int(11) NOT NULL COMMENT '开发语言-数据字典id',
  `dev_language_version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开发语言版本',
  `language` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '界面语言 中文/英文/其他',
  `soft_worth` double(14, 4) NOT NULL COMMENT '软件价值(万元)',
  `soft_size` double(14, 4) NOT NULL COMMENT '软件大小',
  `soft_size_unit` tinyint(1) NOT NULL COMMENT '软件大小 单位 kb/mb/gb/tb/pb/eb',
  `medium_type` enum('光盘','程序包','u盘','其他') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '介质光盘,光盘、程序包、u盘、其他',
  `medium_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '介质名称',
  `os_id` int(11) NOT NULL COMMENT '操作系统-数据字典',
  `os_version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作系统版本',
  `os_bit` enum('32位','64位','其他') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '系统位数(32位,64位,其他)',
  `cpu_cores` int(4) NULL DEFAULT NULL COMMENT '所需cpu核数',
  `min_disk` double(14, 4) NULL DEFAULT NULL COMMENT '磁盘大小',
  `min_disk_unit` tinyint(1) NULL DEFAULT NULL COMMENT '磁盘大小 单位kb/mb/gb/tb/pb/eb',
  `min_mem` double(14, 4) NULL DEFAULT NULL COMMENT '所需内存',
  `min_mem_unit` tinyint(1) NULL DEFAULT NULL COMMENT '内存大小 单位kb/mb/gb/tb/pb/eb',
  `org_id` int(11) NULL DEFAULT NULL COMMENT '所属部门id',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '所属单位id',
  `admin_id` int(11) NOT NULL COMMENT '软件保管人id 即staffid',
  `deploy_status` tinyint(2) NULL DEFAULT 0 COMMENT '部署状态 0-未部署1-已部署',
  `producer_id` int(11) NULL DEFAULT NULL COMMENT '制造商-数据字典id',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供货商-数据字典id',
  `service_id` int(11) NULL DEFAULT NULL COMMENT '服务商-数据字典id',
  `purchase_date` date NULL DEFAULT NULL COMMENT '购买日期',
  `effective_date` date NULL DEFAULT NULL COMMENT '授权有效期',
  `cd_key` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'cdkey',
  `authorized_num` int(11) NULL DEFAULT NULL COMMENT '授权数量',
  `user_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户编码',
  `user_account` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户账号',
  `description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'system' COMMENT '创建人 ',
  `gmt_create` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'system' COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`soft_id`) USING BTREE,
  INDEX `software_foreign_key_producer`(`producer_id`) USING BTREE,
  INDEX `software_foreign_key_name`(`name`) USING BTREE,
  INDEX `software_foreign_key_type`(`type`) USING BTREE,
  INDEX `software_foreign_key_staff`(`admin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '软件表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_software_cluster
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_software_cluster`;
CREATE TABLE `cmdb_software_cluster`  (
  `cluster_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cluster_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群名称',
  `software_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群类型',
  `ci_mapping_key` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '映射键',
  `config_value` json DEFAULT NULL COMMENT '集群信息，json串',
  `cluster_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群编码',
  `cluster_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集群类型',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `online_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0 断链 1正常',
  `task_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`cluster_id`) USING BTREE,
  UNIQUE INDEX `cmdb_software_cluster_cluster_code_uindex`(`cluster_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 158017 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_software_cluster_node
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_software_cluster_node`;
CREATE TABLE `cmdb_software_cluster_node`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `cluster_id` bigint(20) NULL DEFAULT NULL COMMENT '集群id',
  `ci_instance_id` bigint(20) NULL DEFAULT NULL COMMENT '资源实例id',
  `node_role` tinyint(4) NULL DEFAULT NULL COMMENT '节点类型 0 管理节点 1 受控节点',
  `node_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点类型 rac',
  `task_id` int(11) NULL DEFAULT NULL COMMENT '任务id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 158028 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for cmdb_software_cluster_relation
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_software_cluster_relation`;
CREATE TABLE `cmdb_software_cluster_relation`  (
  `relation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `from_relation` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '初始集群关系节点',
  `to_relation` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '目标集群关系节点',
  PRIMARY KEY (`relation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 221464 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '集群关系' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for distribution_frame
-- ----------------------------
DROP TABLE IF EXISTS `distribution_frame`;
CREATE TABLE `distribution_frame`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `number` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号,自定义编号唯一硬件资源编码',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `brand` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `type` bigint(32) NULL DEFAULT NULL COMMENT '类型:0,光纤配线架/1,双绞线配线架',
  `interface_type` bigint(32) NULL DEFAULT NULL COMMENT '接口类别:0,超6类/1,六类/2,超5类',
  `interface_count` bigint(32) NULL DEFAULT NULL COMMENT '端口总数,6口/12口/24口/48口/96口',
  `port_row_number` bigint(32) NULL DEFAULT NULL COMMENT '端口排数',
  `port_list` varchar(2046) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '端口名列表',
  `height` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '高度,单位u',
  `production_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产日期',
  `install_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装日期',
  `manufacturer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产商',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供货商',
  `service_provider` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务商',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  `mode` int(5) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 218008 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for equipment_location
-- ----------------------------
DROP TABLE IF EXISTS `equipment_location`;
CREATE TABLE `equipment_location`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `equipment_id` bigint(32) NULL DEFAULT NULL COMMENT '设备id',
  `rack_id` bigint(32) NULL DEFAULT NULL COMMENT '机柜id,外键',
  `distribution_frame_id` bigint(32) NULL DEFAULT NULL COMMENT '配线架id,外键',
  `start_u` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开始U位',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS `flyway_schema_history`;
CREATE TABLE `flyway_schema_history`  (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `script` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checksum` int(11) NULL DEFAULT NULL,
  `installed_by` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `installed_on` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`) USING BTREE,
  INDEX `flyway_schema_history_s_idx`(`success`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for global_config
-- ----------------------------
DROP TABLE IF EXISTS `global_config`;
CREATE TABLE `global_config`  (
  `global_config_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置参数的记录id  产生方式：系统自动生成 组成字符： 数字 长度（字符数）：    20 规则：无',
  `key` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数的key，供其它部分调用  产生方式：手工录入或外部同步 组成字符： 英文、数字、“.”、“-”、“_” 长度（字符数）：    20 规则：无',
  `value` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数的具体值  产生方式：手工录入或外部同步 组成字符： 中文、英文、数字、符号 长度（字符数）：    255（80个汉字） 规则：无',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述参数的用途等  产生方式：手工录入或外部同步 组成字符： 中文、英文、数字、符号 长度（字符数）：    50 规则：无',
  `is_valid` tinyint(3) UNSIGNED NOT NULL COMMENT '参数的有效性状态.  产生方式：手工录入或外部同步 组成字符： 数字 长度（字符数）：   1 规则：无 1，有效 0，无效',
  `default_value` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数缺省值，是设计开发单位对该参数的默认设置，供客户化设置参考，不可以修改。  产生方式：手工录入或外部同步 组成字符： 中文、英文、数字、符号 长度（字符数）：    255（80个汉字） 规则：无',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `is_visible` tinyint(4) NULL DEFAULT 1 COMMENT '是否界面显示 0不可见1可见',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`global_config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '全局的系统配置参数，系统启动时加载。' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for job
-- ----------------------------
DROP TABLE IF EXISTS `job`;
CREATE TABLE `job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键索引',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务分组',
  `cron_string` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '定时任务的触发时间',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 372010 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定制化任务的信息存储' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for job_detail
-- ----------------------------
DROP TABLE IF EXISTS `job_detail`;
CREATE TABLE `job_detail`  (
  `detail_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增唯一主键索引',
  `job_id` bigint(20) NOT NULL COMMENT '对应的任务id',
  `data_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据键',
  `data_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '数据值',
  PRIMARY KEY (`detail_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 193010 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定制化任务的数据键值对存储' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for label
-- ----------------------------
DROP TABLE IF EXISTS `label`;
CREATE TABLE `label`  (
  `label_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标签的id  产生方式：系统生成 组成字符： 数字 长度（字符数）：    20 规则：无',
  `label_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签的显示名称  产生方式：手工录入或外部同步 组成字符： 中文、英文、数字 长度（字符数）：   10 规则：无',
  `label_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '/*标签的编码字符串 英文、数字*/',
  `label_status` tinyint(4) NOT NULL COMMENT '/*标签的状态*/',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `label_type_value` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签类型-编码,来源于数据字典',
  `label_type_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签类型-名称,来源于数据字典',
  PRIMARY KEY (`label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '标签，统一管理的各类标签' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for label_user
-- ----------------------------
DROP TABLE IF EXISTS `label_user`;
CREATE TABLE `label_user`  (
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户帐号id  产生方式：系统引入 组成字符： 数字 长度（字符数）：    20 规则：无',
  `label_id` bigint(20) UNSIGNED NOT NULL COMMENT '标签的id  产生方式：系统引入 组成字符： 数字 长度（字符数）：    20 规则：无'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for local_equipment_wiring
-- ----------------------------
DROP TABLE IF EXISTS `local_equipment_wiring`;
CREATE TABLE `local_equipment_wiring`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `equipment_location_id` bigint(32) NULL DEFAULT NULL COMMENT '设备id,外键',
  `port` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备端口',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for login_log
-- ----------------------------
DROP TABLE IF EXISTS `login_log`;
CREATE TABLE `login_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `loginid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tenant_id` bigint(20) NULL DEFAULT NULL,
  `user_action` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `action_result` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录结果，Y表示成功，N表示失败',
  `client_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '记录时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 230735 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户登录记录表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for machine_room
-- ----------------------------
DROP TABLE IF EXISTS `machine_room`;
CREATE TABLE `machine_room`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机房名称,省调备用机房',
  `no` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '序号,1',
  `building` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '建筑,A栋',
  `floor` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '楼层,1层',
  `length` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '长度,16',
  `width` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '宽度,24',
  `height` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '高度,2.6',
  `area` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '面积,40',
  `point` bigint(32) NULL DEFAULT NULL COMMENT '机房原点：0,西北角/1,西南角/2,东北角/3,东南角',
  `routing_mode` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '走线方式：上走线方式/下走线方式/其他',
  `air_mode` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送风方式,上送风方式/下送风方式/其他',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 220015 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for machine_room_area
-- ----------------------------
DROP TABLE IF EXISTS `machine_room_area`;
CREATE TABLE `machine_room_area`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区域名称,省调备用机柜区',
  `des` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区域描述',
  `machine_room_id` bigint(32) NULL DEFAULT NULL COMMENT '机房id,外键',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for machine_room_area_row
-- ----------------------------
DROP TABLE IF EXISTS `machine_room_area_row`;
CREATE TABLE `machine_room_area_row`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区域排名称,A排',
  `length` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '长度,16',
  `row_position` bigint(32) NULL DEFAULT NULL COMMENT '区域排方位',
  `width` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '宽度,24',
  `point_x` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '排原点横向距离,16',
  `point_z` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '排原点纵向距离,16',
  `machine_room_area_id` bigint(32) NULL DEFAULT NULL COMMENT '机房区域id,外键',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mdm_ip
-- ----------------------------
DROP TABLE IF EXISTS `mdm_ip`;
CREATE TABLE `mdm_ip`  (
  `ip_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ip唯一标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  `gateway` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网关地址',
  `oss_id` bigint(20) NULL DEFAULT NULL COMMENT '所属管理域Id',
  `oss_ip` bigint(20) NULL DEFAULT NULL COMMENT '所属管理域Ip',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ip地址',
  `ip_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip类型: ipv4,ipv6',
  `mask` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子网掩码',
  `vlan_id` bigint(20) NULL DEFAULT NULL COMMENT '所属vlanId',
  `domain_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所用域名',
  `network_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网络名称',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态',
  `source_uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用者uuid',
  `source_ci_id` bigint(20) NULL DEFAULT NULL COMMENT '使用者所属配置项id 如5物理机6虚拟机',
  `source_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用对象名称',
  `net_area` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所在分区',
  `latest_start_time` datetime(0) NULL DEFAULT NULL COMMENT '上次占用时间',
  `latest_release_time` datetime(0) NULL DEFAULT NULL COMMENT '上次释放时间',
  `gmt_update` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `balance_id` bigint(20) NULL DEFAULT NULL COMMENT '负载均衡id',
  `data_source` tinyint(1) NULL DEFAULT 0 COMMENT '数据源 0-自动发现 1-云平台同步',
  `host_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机类型',
  PRIMARY KEY (`ip_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 232887 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mdm_ip_his
-- ----------------------------
DROP TABLE IF EXISTS `mdm_ip_his`;
CREATE TABLE `mdm_ip_his`  (
  `his_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ip_id` bigint(20) NOT NULL COMMENT 'Ip表的IP标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '所属租户id',
  `domain_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用域名',
  `vlan_id` bigint(20) NULL DEFAULT NULL COMMENT '所属网段',
  `source_ci_id` bigint(20) NULL DEFAULT NULL COMMENT '使用者配置项id',
  `source_uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用者uuid',
  `source_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用者名称',
  `start_date` datetime(0) NULL DEFAULT NULL COMMENT '开始使用时间',
  `end_date` datetime(0) NULL DEFAULT NULL COMMENT '使用结束时间 - 此记录入库时间',
  PRIMARY KEY (`his_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'IP分配历史表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mdm_provider
-- ----------------------------
DROP TABLE IF EXISTS `mdm_provider`;
CREATE TABLE `mdm_provider`  (
  `provider_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'uuid',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '所属租户Id',
  `provider_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '厂商名称  产生方式：手工维护 组成字符：英文、数字、中文、符号 数据长度：50 规则：',
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '厂商全称',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商的描述信息  产生方式：手工维护 组成字符：英文、数字、中文、符号 数据长度：50 规则：',
  `linkman` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务联系人',
  `telephone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务联系人电话',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务联系人邮箱',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`provider_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '供应商、开发商等' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mdm_vlan
-- ----------------------------
DROP TABLE IF EXISTS `mdm_vlan`;
CREATE TABLE `mdm_vlan`  (
  `vlan_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'vlan的管理域id',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  `vlan_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'vlan名称',
  `vlan_type` tinyint(4) NULL DEFAULT NULL COMMENT '1 standard network 2other',
  `virtual_datacenter` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '虚拟中心的名称',
  `oss_id` bigint(20) NULL DEFAULT NULL COMMENT '所属管理域 云平台Id',
  `net_area` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'vlan所在网络区域，查字典',
  `net_address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网络地址 如192.168.0.0',
  `net_gateway` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'vlan的网关',
  `net_mask` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'vlan的子网掩码',
  `enabled` tinyint(4) NULL DEFAULT 1 COMMENT '1启用 0停用 default 1',
  `data_source` tinyint(1) NULL DEFAULT 0 COMMENT '数据源 0-自动发现 1-云平台同步',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`vlan_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_type` tinyint(1) NOT NULL COMMENT '消息类型 1. 中断2. 告警  3. 资源运行属性变更4. 资源管理属性变更 5. 运营管理属性变更',
  `user_status` json NULL COMMENT '用户读取状态  0. 未读 1.已读',
  `message_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息详情',
  `message_jump_info` json NULL COMMENT '消息跳转详情',
  `message_change_data` json NULL COMMENT '消息变更详情',
  `operator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人 如果是系统自动操作，则用户为system，如果是登录系统的其他用户操作，则是登录用户名称',
  `report_time` datetime(0) NOT NULL COMMENT '消息上报时间',
  `alarm_type` tinyint(1) NULL DEFAULT NULL COMMENT '告警级别 1.紧急告警 2.严重告警 3.次要告警 4. 警告告警',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_time`(`report_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2142502 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_certificate
-- ----------------------------
DROP TABLE IF EXISTS `monitor_certificate`;
CREATE TABLE `monitor_certificate`  (
  `certificate_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `host_id` bigint(20) NOT NULL COMMENT '主机id',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '凭证类型',
  `config` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '凭证信息内容  json',
  PRIMARY KEY (`certificate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 247767 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主机-凭证表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_certificate_template
-- ----------------------------
DROP TABLE IF EXISTS `monitor_certificate_template`;
CREATE TABLE `monitor_certificate_template`  (
  `template_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '凭证类型',
  `config` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '凭证内容 json',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`template_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '凭证模板' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_device
-- ----------------------------
DROP TABLE IF EXISTS `monitor_device`;
CREATE TABLE `monitor_device`  (
  `uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主机的唯一id',
  `host_ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主机ip',
  `provider` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '厂商',
  `device_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备类型',
  `ci_mapping_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源分类映射',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_device_config
-- ----------------------------
DROP TABLE IF EXISTS `monitor_device_config`;
CREATE TABLE `monitor_device_config`  (
  `uuid` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'uuid,设备唯一识别',
  `host_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备IP',
  `collect_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '采集时间',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备类型：防火墙，路由器等',
  `config_value` json NULL COMMENT '配置文件详情',
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `idx_host_ip`(`uuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_device_config_history
-- ----------------------------
DROP TABLE IF EXISTS `monitor_device_config_history`;
CREATE TABLE `monitor_device_config_history`  (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `host_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `collect_time` datetime(0) NULL DEFAULT NULL,
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `config_value` json NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_discovery_history
-- ----------------------------
DROP TABLE IF EXISTS `monitor_discovery_history`;
CREATE TABLE `monitor_discovery_history`  (
  `history_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '历史id',
  `discovery_id` bigint(20) NULL DEFAULT NULL COMMENT '定时任务id',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '执行结果:3执行成功,2执行失败',
  `discovery_device_num` int(11) NULL DEFAULT NULL COMMENT '发现设备数量',
  `discovery_time` timestamp(0) NULL DEFAULT NULL COMMENT '同步时间',
  `discovery_error_msg` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '同步失败原因',
  `discovery_type` tinyint(4) NULL DEFAULT NULL COMMENT '发现类型:1 IP扫描 2主机部署',
  `discovery_model` tinyint(4) NULL DEFAULT NULL COMMENT '触发机制:1 人工 2 自动',
  `discovery_msg` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '执行结果',
  `discovery_endtime` timestamp(0) NULL DEFAULT NULL COMMENT '执行完成时间',
  PRIMARY KEY (`history_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自动同步历史' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_discovery_schedule
-- ----------------------------
DROP TABLE IF EXISTS `monitor_discovery_schedule`;
CREATE TABLE `monitor_discovery_schedule`  (
  `discovery_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `discovery_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `execute_strategy` json NULL COMMENT '执行策略',
  `schedule_range` json NULL COMMENT '任务扫描范围',
  `discovery_type` tinyint(4) NOT NULL COMMENT 'type  0 : once 1 : job',
  `schedule_status` tinyint(4) NULL DEFAULT NULL COMMENT '执行状态,0 未执行,1 执行中,2 执行成功,3 执行失败',
  `schedule_enable` tinyint(4) NULL DEFAULT NULL COMMENT '是否启用，0未启用，1启用',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'job 组信息',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'job 标识',
  `pre_execute_time` timestamp(0) NULL DEFAULT NULL COMMENT '上次执行时间',
  `pre_end_time` timestamp(0) NULL DEFAULT NULL COMMENT '上次执行结束时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`discovery_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131008 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务详情' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_discovery_type
-- ----------------------------
DROP TABLE IF EXISTS `monitor_discovery_type`;
CREATE TABLE `monitor_discovery_type`  (
  `disc_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '系统自动生成的唯 一id  产生方式：系统自动生成 组成字符： 数字 长度（字符数）：    20 规则：无,',
  `disc_type_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工具名称，产生方式：手工录入或外部同步 组成字符： 中文、英文、符号 长度（字符数）：    64 规则：无',
  `type` tinyint(1) NOT NULL COMMENT '工具类型，产生方式：系统预置，组成字符： 数字，长度（字符数）：1, 规则：\n            1 - 监控采集工具 ',
  `extend_attrs` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`disc_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '发现方式' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_host
-- ----------------------------
DROP TABLE IF EXISTS `monitor_host`;
CREATE TABLE `monitor_host`  (
  `host_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机唯一uuid',
  `host_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机ip',
  `hostname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机名称',
  `deploy_status` tinyint(4) NULL DEFAULT NULL COMMENT '部署状态（0 未配置，1 已配置，2 部署失败 3 已部署）',
  `deploy_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部署类型',
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机品牌',
  `host_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机类型',
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '设备类型',
  `found_time` datetime(0) NULL DEFAULT NULL COMMENT '发现时间',
  `deploy_time` datetime(0) NULL DEFAULT NULL COMMENT '部署时间',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '资源分类id',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `updater` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `host_ip_mask` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `host_os` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机操作系统',
  `host_ostype` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主机操作系统类型',
  `disconnect_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0 断链  1 正常',
  `network_segment` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网段',
  `task_id` bigint(20) NULL DEFAULT NULL,
  `retry_count` int(11) NULL DEFAULT NULL COMMENT '重试次数',
  `pre_lock_time` timestamp(0) NULL DEFAULT NULL COMMENT '上次锁定时间',
  PRIMARY KEY (`host_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 454131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主机表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_host_category
-- ----------------------------
DROP TABLE IF EXISTS `monitor_host_category`;
CREATE TABLE `monitor_host_category`  (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类编码',
  `category_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `category_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '分类的类型 0非叶子分类 1叶子分类',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `parent_category_id` bigint(20) NOT NULL COMMENT '父分类id',
  `display_order` smallint(6) NOT NULL COMMENT '显示顺序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者 ',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `is_predefined` tinyint(1) NULL DEFAULT 0 COMMENT '是否预置记录, 1:是/0:否，默认:0，预置记录无法编辑删除',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主机分类' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_host_management_info
-- ----------------------------
DROP TABLE IF EXISTS `monitor_host_management_info`;
CREATE TABLE `monitor_host_management_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `host_id` bigint(20) NOT NULL COMMENT '主机id',
  `host_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主机编码\n',
  `hostname` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主机名称',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `mac_address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'mac地址',
  `related_equipment_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联设备名称',
  `related_host_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联主机编码',
  `version` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '版本（针对软件）',
  `maintain_department_id` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运维部门id\n',
  `maintain_owner_id` bigint(20) NULL DEFAULT NULL COMMENT '运维负责人id',
  `device_serial` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备序列号',
  `login_account` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登陆账户',
  `port` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '端口',
  `access_address` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访问地址',
  `deploy_date` datetime(0) NULL DEFAULT NULL COMMENT '部署日期',
  `usage` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用途',
  `functional_zone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属功能区',
  `comment` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `install_date` datetime(0) NULL DEFAULT NULL COMMENT '安装日期',
  `last_deploy_result` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上次部署结果  时间或状态',
  `device_id` int(11) NULL DEFAULT 0 COMMENT '设备主键',
  `device_status` tinyint(2) NULL DEFAULT 0 COMMENT '设备状态 0:未定 1:已确定台帐设备 2:无台帐设备 3:有类似设备',
  `is_virtual` tinyint(2) NULL DEFAULT NULL COMMENT '是否虚拟',
  `data_info` json NULL COMMENT '采集数据',
  `uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `disconnect_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0 断链 1正常',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `host_id`(`host_id`) USING BTREE,
  UNIQUE INDEX `monitor_host_management_info_uuid_uindex`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145048 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '主机管理信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_ip_manage
-- ----------------------------
DROP TABLE IF EXISTS `monitor_ip_manage`;
CREATE TABLE `monitor_ip_manage`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `company_id` bigint(20) NULL DEFAULT NULL COMMENT '该网段对应的单位id',
  `range_info` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该网段的信息,格式为ip/掩码位数',
  `mask` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该网段的掩码',
  `range_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该网段的名称',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '记录用户录入的网段信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_ip_range
-- ----------------------------
DROP TABLE IF EXISTS `monitor_ip_range`;
CREATE TABLE `monitor_ip_range`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `task_id` int(11) NULL DEFAULT NULL COMMENT '该网段对应的任务id',
  `start_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该网段的起始ip',
  `end_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该网段的结束ip',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156370 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '记录已扫描的网段信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_network_scan_host
-- ----------------------------
DROP TABLE IF EXISTS `monitor_network_scan_host`;
CREATE TABLE `monitor_network_scan_host`  (
  `uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主机的唯一id',
  `host_ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主机ip',
  `collect_time` datetime(0) NULL DEFAULT NULL,
  `os` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作系统',
  `ports` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '端口列表,JSON格式'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '扫描到的主机列表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_phytopo
-- ----------------------------
DROP TABLE IF EXISTS `monitor_phytopo`;
CREATE TABLE `monitor_phytopo`  (
  `id` int(4) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `phytopo_taskid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该拓扑任务对应的id',
  `phytopo_detail` blob NULL COMMENT '该拓扑任务对应结果',
  `phytopo_status` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '该拓扑任务当前状态，一共有running、completed、error三种状态',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `device_status` blob NULL COMMENT '物理拓扑设备状态信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物理拓扑图' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_search_keys
-- ----------------------------
DROP TABLE IF EXISTS `monitor_search_keys`;
CREATE TABLE `monitor_search_keys`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `search_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '高级搜索可用key',
  `special_element` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'key的特殊字段,元素名/处理类型,2为数组字段,4为版本字段,8为容量字段',
  `tips` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对该key的描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `search_key`(`search_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '主机高级搜索可用键信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_setting
-- ----------------------------
DROP TABLE IF EXISTS `monitor_setting`;
CREATE TABLE `monitor_setting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一自增id',
  `big_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '大类型  设备转台账:device2cmdb',
  `small_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '小类型  设备类型:交换机等',
  `config_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '配置值',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '监控系统配置表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_software_config
-- ----------------------------
DROP TABLE IF EXISTS `monitor_software_config`;
CREATE TABLE `monitor_software_config`  (
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'uuid,软件唯一标识',
  `host_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `collect_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '采集时间',
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '软件类型：tomcat/apache/mysql等',
  `config_value` json NULL COMMENT '配置文件详情',
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `idx_host_ip`(`uuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_software_config_history
-- ----------------------------
DROP TABLE IF EXISTS `monitor_software_config_history`;
CREATE TABLE `monitor_software_config_history`  (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `host_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `collect_time` datetime(0) NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `config_value` json NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for monitor_task
-- ----------------------------
DROP TABLE IF EXISTS `monitor_task`;
CREATE TABLE `monitor_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `task_id` bigint(20) NULL DEFAULT NULL COMMENT '任务id',
  `discovery_id` bigint(20) NULL DEFAULT NULL,
  `task_type` tinyint(4) NULL DEFAULT NULL COMMENT '该扫描任务的类型',
  `task_status` tinyint(4) NULL DEFAULT NULL COMMENT '该任务当前状态 1.正在执行 2.执行成功 3.执行失败',
  `task_range` json NULL COMMENT '扫描任务范围',
  `task_msg` json NULL COMMENT '扫描任务结果',
  `task_change_msg` json NULL COMMENT '扫描任务更新信息',
  `task_begin_time` timestamp(0) NULL DEFAULT NULL COMMENT '扫描任务开始时间',
  `task_end_time` timestamp(0) NULL DEFAULT NULL COMMENT '扫描任务结束时间',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uquser`(`task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 166262 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '记录扫描任务' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for mount_point
-- ----------------------------
DROP TABLE IF EXISTS `mount_point`;
CREATE TABLE `mount_point`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装点名称,安装点1',
  `machine_room_area_row_id` bigint(32) NULL DEFAULT NULL COMMENT '机房区域排id,外键',
  `point_x` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装点横向距离,16',
  `point_z` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装点纵向距离,16',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for oauth_client_details
-- ----------------------------
DROP TABLE IF EXISTS `oauth_client_details`;
CREATE TABLE `oauth_client_details`  (
  `client_id` varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `resource_ids` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `client_secret` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `scope` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `authorized_grant_types` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `web_server_redirect_uri` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `authorities` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `access_token_validity` int(11) NULL DEFAULT NULL,
  `refresh_token_validity` int(11) NULL DEFAULT NULL,
  `additional_information` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `autoapprove` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`client_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `operation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '操作日志标识',
  `operation_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作日志类型',
  `operator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作人员',
  `operator_id` bigint(20) NOT NULL COMMENT '操作人员标识',
  `operation_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '操作时间',
  `content` varchar(2056) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作内容',
  `obj_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作对象类型',
  `obj_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作对象id/id列表',
  `obj_content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '操作对象实例',
  `service_url` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务URL',
  `service_method` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务方法',
  `business_type` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务名称',
  `operation_result` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作结果',
  `module_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模块名',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`operation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72003 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for ops_grade_template
-- ----------------------------
DROP TABLE IF EXISTS `ops_grade_template`;
CREATE TABLE `ops_grade_template`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `classification` tinyint(4) NOT NULL COMMENT '0 运维项目  1 维保项目',
  `service_quality_score` double NOT NULL DEFAULT 0 COMMENT '服务质量得分',
  `project_management_score` double NOT NULL DEFAULT 0 COMMENT '项目管理得分',
  `project_management_detail` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目管理详情',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评分模板' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for ops_project_score
-- ----------------------------
DROP TABLE IF EXISTS `ops_project_score`;
CREATE TABLE `ops_project_score`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int(11) NOT NULL COMMENT '项目id',
  `score` double NULL DEFAULT NULL COMMENT '总评分',
  `first_quarter_score` double NULL DEFAULT NULL COMMENT '一季度评分',
  `first_score_record` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '一季度评分记录',
  `second_quarter_score` double NULL DEFAULT NULL COMMENT '二级度评分',
  `third_score_record` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '三级度评分记录',
  `third_quarter_score` double NULL DEFAULT NULL COMMENT '三季度评分',
  `second_score_record` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '二季度评分记录',
  `forth_quarter_score` double NULL DEFAULT NULL COMMENT '四季度评分',
  `forth_score_record` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '四季度评分记录',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_project_id`(`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185927 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '运维项目评分' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for oss_server
-- ----------------------------
DROP TABLE IF EXISTS `oss_server`;
CREATE TABLE `oss_server`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '管理域标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '所属管理域Id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理域名称',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `token` varchar(1256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '令牌',
  `client_cert` varchar(3000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'client-certificate-data',
  `client_key` varchar(3000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'client-key-data',
  `http` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ip` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `port` int(11) NULL DEFAULT NULL,
  `uri` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `region_id` int(11) NULL DEFAULT NULL COMMENT '区域',
  `software_server_id` bigint(20) NULL DEFAULT NULL COMMENT '软件服务器标识',
  `platform_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '虚拟化技术类型：取值来自数据字典，vcenter，openstatck，kvm等',
  `hypervisor_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态： 0：正常 1：已删除',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `connect_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '连接方式',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ixfk_oss_server_software_server`(`software_server_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '虚拟化平台的管理服务器' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for oss_server_property
-- ----------------------------
DROP TABLE IF EXISTS `oss_server_property`;
CREATE TABLE `oss_server_property`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `oss_server_id` bigint(20) NOT NULL COMMENT '管理域Id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '属性名称',
  `value` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '属性值',
  `description` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '中文名称或描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for panel_distribution
-- ----------------------------
DROP TABLE IF EXISTS `panel_distribution`;
CREATE TABLE `panel_distribution`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `equipment_location_id` bigint(32) NULL DEFAULT NULL COMMENT '配线架设备id',
  `port` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配线架端口',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for poam
-- ----------------------------
DROP TABLE IF EXISTS `poam`;
CREATE TABLE `poam`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` json NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for power_pack
-- ----------------------------
DROP TABLE IF EXISTS `power_pack`;
CREATE TABLE `power_pack`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `mount_point_id` bigint(32) NULL DEFAULT NULL COMMENT '安装点id,外键',
  `number` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号,自定义编号唯一硬件资源编码',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电源名称',
  `position` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装位置',
  `brand` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `power_pack_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电源类型,UPS/市电',
  `duration` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '持续时间',
  `production_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产日期',
  `install_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装日期',
  `rated_voltage` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定电压,220V',
  `rated_current` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定电流,24V',
  `rated_power` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '额定功率,750W',
  `manufacturer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产商',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供货商',
  `service_provider` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务商',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_information_contract
-- ----------------------------
DROP TABLE IF EXISTS `project_information_contract`;
CREATE TABLE `project_information_contract`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合同编号',
  `contract_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合同名称',
  `contract_signed_date` date NOT NULL COMMENT '合同签订时间',
  `contract_amount` decimal(12, 6) NOT NULL COMMENT '合同签订金额',
  `information_project_plan_id` int(11) NOT NULL COMMENT '信息化项目计划id，外键，不允许删除',
  `implementation` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '实施情况',
  `project_phase` tinyint(1) NULL DEFAULT NULL COMMENT '项目阶段 0: 未启动 1:部署实施 2: 上线试运行 3:试运行验收 4: 正式验收',
  `is_share_expenses` tinyint(1) NULL DEFAULT NULL COMMENT '是否分摊费 1是 0否',
  `is_problem` tinyint(1) NULL DEFAULT NULL COMMENT '项目是否存在问题 1是 0否',
  `problem_details` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题明细 如果存在问题，则必填',
  `promotion_measures` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '推进措施',
  `IRS_start_time` date NULL DEFAULT NULL COMMENT 'IRS项目启动时间',
  `start_time` date NULL DEFAULT NULL COMMENT '项目实际启动时间',
  `IRS_commissioning_time` date NULL DEFAULT NULL COMMENT 'IRS项目上线试运行时间',
  `commissioning_time` date NULL DEFAULT NULL COMMENT '项目实际上线试运行时间',
  `IRS_acceptance_time` date NULL DEFAULT NULL COMMENT 'IRS项目验收时间',
  `acceptance_time` date NULL DEFAULT NULL COMMENT '项目实际验收时间',
  `software_and_hardware_arrival_time` date NULL DEFAULT NULL COMMENT '软硬件到货时间',
  `archiving_time` date NULL DEFAULT NULL COMMENT '资料归档时间',
  `contractor_company_id` int(11) NULL DEFAULT NULL COMMENT '中标厂商id，外键，不允许删除',
  `implementer_id` int(11) NULL DEFAULT NULL COMMENT '实施厂商id，外键，不允许删除',
  `actual_attendance` int(11) NULL DEFAULT NULL COMMENT '项目实际到场人数',
  `agreed_attendance` int(11) NULL DEFAULT NULL COMMENT '项目约定到场人数',
  `contractor_id` int(11) NULL DEFAULT NULL COMMENT '乙方项目经理,外键，不允许删除',
  `owner_id` int(11) NULL DEFAULT NULL COMMENT '甲方项目经理,外键，不允许删除',
  `owner_construction_department_id` int(11) NULL DEFAULT NULL COMMENT '甲方项目建设部门,外键，不允许删除',
  `owner_responsible_department_id` int(11) NULL DEFAULT NULL COMMENT '甲方项目责任部门,外键，不允许删除',
  `recorded_cost` decimal(12, 6) NULL DEFAULT NULL COMMENT '入账成本',
  `payment_ratio` decimal(5, 2) NULL DEFAULT NULL COMMENT '已支付比例',
  `payment_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '支付金额',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_information_plan`(`information_project_plan_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_contractor_company_`(`contractor_company_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_contractor_id`(`contractor_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_owner_id`(`owner_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_owner_construction`(`owner_construction_department_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_owner_responsible`(`owner_responsible_department_id`) USING BTREE,
  INDEX `project_information_contract_foreign_key_implementer_id`(`implementer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_information_equipment
-- ----------------------------
DROP TABLE IF EXISTS `project_information_equipment`;
CREATE TABLE `project_information_equipment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '信息化项目合同id,外键，关联删除',
  `equipment_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设备类型',
  `brand` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设备品牌',
  `model` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设备型号',
  `unit_price` decimal(8, 6) NOT NULL COMMENT '单价',
  `number` int(11) NULL DEFAULT NULL COMMENT '设备数量',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_information_equipment_foreign_key_project_id`(`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_information_plan
-- ----------------------------
DROP TABLE IF EXISTS `project_information_plan`;
CREATE TABLE `project_information_plan`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目编号，项目编号与项目编码其一为必填',
  `project_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目编码，项目编号与项目编码其一为必填',
  `project_year` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目年度',
  `project_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名称',
  `project_type` tinyint(1) NULL DEFAULT NULL COMMENT '项目类型 0: 营销自建1:信息化统建 2: 信息化自建',
  `project_create_time` date NOT NULL COMMENT '项目创建时间',
  `classification` tinyint(1) NULL DEFAULT NULL COMMENT '项目分类 0:服务类 1:采购类',
  `project_department_id` int(11) NULL DEFAULT NULL COMMENT '项目部门id, 外键，不允许删除',
  `final_planned_capital_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '最终计划资本性金额',
  `final_planned_cost_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '最终计划成本性金额',
  `final_planned_total_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '最终计划总金额',
  `release_plan_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下达计划文号',
  `project_hardware_funds` decimal(12, 6) NULL DEFAULT NULL COMMENT '项目硬件资金',
  `project_software_funds` decimal(12, 6) NULL DEFAULT NULL COMMENT '项目软件资金',
  `project_development_funds` decimal(12, 6) NULL DEFAULT NULL COMMENT '项目开发资金',
  `project_implementation_funds` decimal(12, 6) NULL DEFAULT NULL COMMENT '项目实施资金',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_information_plan_foreign_key_project_department_id`(`project_department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_information_system
-- ----------------------------
DROP TABLE IF EXISTS `project_information_system`;
CREATE TABLE `project_information_system`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '信息化项目合同id,外键，关联删除',
  `system_id` int(11) NOT NULL COMMENT '系统id ，外键，不允许删除',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_information_system_foreign_key_project_id`(`project_id`) USING BTREE,
  INDEX `project_information_system_foreign_key_system_id`(`system_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_operation_and_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `project_operation_and_maintenance`;
CREATE TABLE `project_operation_and_maintenance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合同编号',
  `project_year` int(11) NOT NULL COMMENT '项目年度',
  `project_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名称',
  `contract_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合同名称',
  `classification` tinyint(1) NULL DEFAULT NULL COMMENT '项目分类 运维合同0，维保合同1',
  `owner_id` int(11) NULL DEFAULT NULL COMMENT '甲方项目经理,外键，不允许删除',
  `contractor_company_id` int(11) NULL DEFAULT NULL COMMENT '中标厂商id，外键，不允许删除',
  `contractor_id` int(11) NULL DEFAULT NULL COMMENT '甲方项目经理,外键，不允许删除',
  `signed_date` date NOT NULL COMMENT '签订时间',
  `actual_attendance` int(11) NULL DEFAULT NULL COMMENT '合同实际到场人数',
  `agreed_attendance` int(11) NULL DEFAULT NULL COMMENT '合同约定到场人数',
  `workload` int(11) NULL DEFAULT NULL COMMENT '工作量(人天)',
  `discount_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '折扣率',
  `unit_price` decimal(8, 6) NULL DEFAULT NULL COMMENT '单价(万)',
  `estimated_price` decimal(12, 6) NULL DEFAULT NULL COMMENT '暂估价',
  `project_department_id` int(11) NULL DEFAULT NULL COMMENT '项目部门id, 外键，不允许删除',
  `purchase_number` int(11) NULL DEFAULT NULL COMMENT '采购订单号',
  `plan_price` decimal(12, 6) NULL DEFAULT NULL COMMENT '计划金额',
  `implementer_id` int(11) NULL DEFAULT NULL COMMENT '实施厂商',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_operation_and_maintenance_foreign_key_owner_id`(`owner_id`) USING BTREE,
  INDEX `project_operation_and_maintenance_foreign_key_contractor_company`(`contractor_company_id`) USING BTREE,
  INDEX `project_operation_and_maintenance_foreign_key_project_department`(`project_department_id`) USING BTREE,
  INDEX `project_operation_and_maintenance_foreign_key_implementer_id`(`implementer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_operation_and_maintenance_object
-- ----------------------------
DROP TABLE IF EXISTS `project_operation_and_maintenance_object`;
CREATE TABLE `project_operation_and_maintenance_object`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '运维项目id，外键，关联删除',
  `system_id` int(11) NOT NULL COMMENT '系统id，外键，不允许删除',
  `planned_amount` decimal(10, 4) NULL DEFAULT NULL COMMENT '计划金额',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_operation_and_maintenance_object_foreign_key_project_id`(`project_id`) USING BTREE,
  INDEX `project_operation_and_maintenance_object_foreign_key_system_id`(`system_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99071 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_performance_assessment
-- ----------------------------
DROP TABLE IF EXISTS `project_performance_assessment`;
CREATE TABLE `project_performance_assessment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '运维项目id,外键，关联删除',
  `quarter` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '季度：一 二三四',
  `workload` int(11) NULL DEFAULT NULL COMMENT '工作量(人*天)',
  `assessment_score` int(11) NULL DEFAULT NULL COMMENT '考核得分',
  `settlement_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '结算金额',
  `invoice_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '开票金额',
  `invoice_time` date NULL DEFAULT NULL COMMENT '挂账时间',
  `payment_amount` decimal(12, 6) NULL DEFAULT NULL COMMENT '支付金额',
  `payment_time` date NULL DEFAULT NULL COMMENT '支付时间',
  `deduction` decimal(12, 6) NULL DEFAULT NULL COMMENT '扣款',
  `deduction_reasion` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扣款原因',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_performance_assessment_foreign_key_project_id`(`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 158073 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for project_person_relationship
-- ----------------------------
DROP TABLE IF EXISTS `project_person_relationship`;
CREATE TABLE `project_person_relationship`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_person_id` int(11) NOT NULL COMMENT '人员id, 外键，关联删除',
  `information_contract_id` int(11) NULL DEFAULT NULL COMMENT '信息化项目id，外键，不允许删除',
  `operation_and_maintenance_project_id` int(11) NULL DEFAULT NULL COMMENT '运维服务项目id，外键，不允许删除',
  `project_role` tinyint(1) NULL DEFAULT NULL COMMENT '项目角色 0：项目经理 1：开发人员 2：实施人员 3：业务顾问 4：运维人员',
  `entry_project_time` date NULL DEFAULT NULL COMMENT '离开项目时间，实际精确到月，需要自己再转换',
  `leave_project_time` date NULL DEFAULT NULL COMMENT '进入项目时间，实际精确到月，需要自己再转换',
  `workplace` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作地点',
  `service_department_id` int(11) NULL DEFAULT NULL COMMENT '服务对象，外键，不允许删除',
  `evaluation` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '人员评价',
  `score` tinyint(1) NULL DEFAULT NULL COMMENT '人员定级 0: A 1:B 2:C 3:D',
  `creator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `project_person_relationship_foreign_key_project_person_id`(`project_person_id`) USING BTREE,
  INDEX `project_person_relationship_foreign_key_information_project_id`(`information_contract_id`) USING BTREE,
  INDEX `project_person_relationship_foreign_key_project`(`operation_and_maintenance_project_id`) USING BTREE,
  INDEX `project_person_foreign_key_service_department_id`(`service_department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for prometheus_monitor_object
-- ----------------------------
DROP TABLE IF EXISTS `prometheus_monitor_object`;
CREATE TABLE `prometheus_monitor_object`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prometheus_server_id` int(11) NOT NULL COMMENT '普罗米修斯服务器id',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '监控对象地址',
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '监控对象类型',
  `sys_url` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '对应业务系统地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30050 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for prometheus_server
-- ----------------------------
DROP TABLE IF EXISTS `prometheus_server`;
CREATE TABLE `prometheus_server`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '服务器名称',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '访问地址',
  `port` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '端口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `blob_data` blob NULL,
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `calendar_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `calendar` blob NOT NULL,
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cron_expression` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `time_zone_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `entry_id` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `instance_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `fired_time` bigint(13) NOT NULL,
  `sched_time` bigint(13) NOT NULL,
  `priority` int(11) NOT NULL,
  `state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `job_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `job_class_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_durable` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_update_data` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_data` blob NULL,
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `lock_name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `instance_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_checkin_time` bigint(13) NOT NULL,
  `checkin_interval` bigint(13) NOT NULL,
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `repeat_count` bigint(7) NOT NULL,
  `repeat_interval` bigint(12) NOT NULL,
  `times_triggered` bigint(10) NOT NULL,
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `str_prop_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `str_prop_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `str_prop_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `int_prop_1` int(11) NULL DEFAULT NULL,
  `int_prop_2` int(11) NULL DEFAULT NULL,
  `long_prop_1` bigint(20) NULL DEFAULT NULL,
  `long_prop_2` bigint(20) NULL DEFAULT NULL,
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL,
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL,
  `bool_prop_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `bool_prop_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `job_group` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `next_fire_time` bigint(13) NULL DEFAULT NULL,
  `prev_fire_time` bigint(13) NULL DEFAULT NULL,
  `priority` int(11) NULL DEFAULT NULL,
  `trigger_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `trigger_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `start_time` bigint(13) NOT NULL,
  `end_time` bigint(13) NULL DEFAULT NULL,
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `misfire_instr` smallint(2) NULL DEFAULT NULL,
  `job_data` blob NULL,
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for rack
-- ----------------------------
DROP TABLE IF EXISTS `rack`;
CREATE TABLE `rack`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `mount_point_id` bigint(32) NULL DEFAULT NULL COMMENT '安装点id,外键',
  `number` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号,自定义编号唯一硬件资源编码',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机柜名称',
  `position` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机柜所在位置',
  `brand` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '型号',
  `production_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产日期',
  `install_date` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装日期',
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机柜类型,服务器机柜，网络柜，存储机柜，小型机机柜，配线柜',
  `depth` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '深度,700mm',
  `height` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '高度,2米',
  `width` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '宽度,800mm',
  `bearing` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '承重,1500KG',
  `weight` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '重量,100KG',
  `capacity` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '容量,42U',
  `used_capacity` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '已用容量,10U',
  `manufacturer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产商',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供货商',
  `service_provider` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务商',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 250005 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `display_order` bigint(32) NULL DEFAULT NULL COMMENT '角色展示顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for search_condition
-- ----------------------------
DROP TABLE IF EXISTS `search_condition`;
CREATE TABLE `search_condition`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `condition_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '条件名称',
  `type` tinyint(2) NOT NULL COMMENT '类型 0 主机 1 台账',
  `condition_content` json NULL COMMENT '条件内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122017 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '主机台账条件表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for software_server
-- ----------------------------
DROP TABLE IF EXISTS `software_server`;
CREATE TABLE `software_server`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '软件服务器标识：数据库自增',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '软件服务器名称',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `server_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '服务器ip地址',
  `server_port` int(11) NOT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识',
  `pem_path` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'pem路径',
  `ssh_user` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ssh用户名',
  `ssh_pwd` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ssh密码',
  `ssh_port` int(11) NULL DEFAULT NULL COMMENT 'ssh端口',
  `file_server_ip` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件服务器ip',
  `file_server_port` int(11) NULL DEFAULT NULL COMMENT '文件服务器端口',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '软件服务器状态： 0：正常 1：已删除',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '软件服务器' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for spring_session
-- ----------------------------
DROP TABLE IF EXISTS `spring_session`;
CREATE TABLE `spring_session`  (
  `session_id` char(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `creation_time` bigint(20) NOT NULL,
  `last_access_time` bigint(20) NOT NULL,
  `max_inactive_interval` int(11) NOT NULL,
  `principal_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`session_id`) USING BTREE,
  INDEX `spring_session_ix1`(`last_access_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for spring_session_attributes
-- ----------------------------
DROP TABLE IF EXISTS `spring_session_attributes`;
CREATE TABLE `spring_session_attributes`  (
  `session_id` char(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `attribute_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `attribute_bytes` blob NULL,
  PRIMARY KEY (`session_id`, `attribute_name`) USING BTREE,
  INDEX `spring_session_attributes_ix1`(`session_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for switch_wiring
-- ----------------------------
DROP TABLE IF EXISTS `switch_wiring`;
CREATE TABLE `switch_wiring`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `equipment_location_id` bigint(32) NULL DEFAULT NULL COMMENT '交换机设备id,外键',
  `port` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交换机端口',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_account
-- ----------------------------
DROP TABLE IF EXISTS `sys_account`;
CREATE TABLE `sys_account`  (
  `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `eff_date` datetime(0) NULL DEFAULT NULL COMMENT '生效时间',
  `exp_date` datetime(0) NULL DEFAULT NULL COMMENT '到期时间 失效时间',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '账号类型 0正常 1临时账号',
  `loginid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户设置的登录名',
  `passwd` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户密码',
  `status` tinyint(3) UNSIGNED NOT NULL COMMENT '0正常 1禁用 2删除',
  `tenant_id` bigint(20) UNSIGNED NOT NULL COMMENT '租户的id',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `salt` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'kangpaas' COMMENT '盐值',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 296007 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户帐户，仅为登录相关的必要信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_agent
-- ----------------------------
DROP TABLE IF EXISTS `sys_agent`;
CREATE TABLE `sys_agent`  (
  `agent_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'agent自增id',
  `agent_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'agent名称',
  `object_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件存储object_id，用以下载对应文件',
  `file_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件名',
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件类型',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Agent描述信息',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`agent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api`  (
  `api_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'api记录的id',
  `display_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'api显示名称',
  `key` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'api的引用名',
  `url` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'url以rootcontext开始',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求方式',
  `is_accessable` tinyint(3) UNSIGNED NOT NULL COMMENT '外部系统的访问权限',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'api功能的描述',
  `is_valid` tinyint(3) UNSIGNED NOT NULL COMMENT '1,有效 0，无效',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`api_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统内部具备的api，restful风格' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_auth
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth`;
CREATE TABLE `sys_auth`  (
  `auth_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '权限标识',
  `auth_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限名称',
  `auth_type` tinyint(4) NOT NULL COMMENT '权限类型： 0：菜单权限 1：功能权限 2：数据权限',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限说明',
  `parent_id` bigint(20) NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`auth_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 701441001 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限表，分为菜单权限，功能权限，数据权限等' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_code
-- ----------------------------
DROP TABLE IF EXISTS `sys_code`;
CREATE TABLE `sys_code`  (
  `syscodeid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'uuid ,做为对外引用的key',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '代码名称，内部识别的',
  `value` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '代码的值，对外展现的',
  `is_valid` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '是否有效，默认有效 0：无效 1：有效',
  `syscodecategoryid` bigint(20) UNSIGNED NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT 0 COMMENT '数据字典的删除状态:\'1\':已删除,\'0\':未删除',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`syscodeid`) USING BTREE,
  INDEX `ixfk_syscode_syscodecategory`(`syscodecategoryid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统内部key-value类代码' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_code_category
-- ----------------------------
DROP TABLE IF EXISTS `sys_code_category`;
CREATE TABLE `sys_code_category`  (
  `syscodecategoryid` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'uuid',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称  产生方式：手工维护 组成字符：英文、数字、中文 数据长度：50 规则：',
  `is_valid` tinyint(1) UNSIGNED NOT NULL COMMENT '该分类是有效  产生方式：手工维护 组成字符：0，1 数据长度：1 规则： 0：无效 1：有效',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `display_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示名称',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据字典分类描述',
  `deleted` tinyint(4) NOT NULL DEFAULT 0 COMMENT '数据字典的删除状态:\'1\':已删除,\'0\':未删除',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`syscodecategoryid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统内的key-value类型代码分类目录' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_company`;
CREATE TABLE `sys_company`  (
  `company_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单位主键',
  `company_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位的名称（中文或英文）',
  `company_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '单位代号',
  `staff_id` bigint(20) NULL DEFAULT NULL COMMENT '负责人id',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '电话',
  `bank_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行',
  `bank_account` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户账号',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '单位状态，规则： 0：正常 1，停用',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `station_array` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '岗位主键id列表',
  `displayorder` tinyint(3) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '单位显示顺序。0表示最靠前，数字越小，优先度越高',
  `company_type` tinyint(1) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '单位类型：0-内部单位/1-外部单位',
  `address` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位地址',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `company_level` tinyint(1) NULL DEFAULT 1 COMMENT '单位级别:1-一级单位 2-二级单位 3-三级单位',
  `parent_id` int(11) NULL DEFAULT 0 COMMENT '上级单位主键, 一级单位为0',
  `link_line` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '连接线 单位层级关系 -分割',
  `manufacturer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '厂商类型id 来自数据字典, 逗号分割',
  PRIMARY KEY (`company_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127002 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工作单位表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单记录的id',
  `auth_id` bigint(20) NULL DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单的英文名',
  `menu_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '菜单还是按钮 1菜单 0按钮',
  `display_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单的界面显示名称',
  `url` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单或页面的url',
  `display_flag` tinyint(1) NULL DEFAULT 1 COMMENT '菜单是否展示  1：展示 0：不展示， 默认：1',
  `display_order` tinyint(3) UNSIGNED NOT NULL COMMENT '菜单在页面上的显示顺序。数值越小，菜单顺序越靠前。',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父菜单，最上级为0',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`menu_id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 701411001 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单，主要代表ui界面上显示的各个按钮，及按钮代表的页面' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api`  (
  `rel_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `api_id` bigint(20) UNSIGNED NOT NULL COMMENT 'api的id',
  `menu_id` bigint(20) UNSIGNED NOT NULL COMMENT '菜单的id',
  PRIMARY KEY (`rel_id`) USING BTREE,
  INDEX `fk_menuapi_api`(`api_id`) USING BTREE,
  INDEX `idx_menuapi_api`(`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_module
-- ----------------------------
DROP TABLE IF EXISTS `sys_module`;
CREATE TABLE `sys_module`  (
  `module_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '模块标识',
  `module_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模块代码',
  `module_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模块名称',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`module_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统模块，定义kangpaas的微服务模块代号' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_org
-- ----------------------------
DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org`  (
  `org_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '部门的id',
  `org_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门的名称（中文或英文）',
  `org_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门的代码',
  `staff_id` bigint(20) NULL DEFAULT NULL COMMENT '负责人id',
  `phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '负责人',
  `company_id` bigint(20) NULL DEFAULT NULL COMMENT '单位主键',
  `station_array` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '岗位主键id列表',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '所有上级部门',
  `status` tinyint(3) UNSIGNED NULL DEFAULT 0 COMMENT '0：正常 1，停用',
  `link_line` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门连接线(包含层级,以-分割,例如: 1-2-3-或1-2-3-4-)',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `displayorder` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '数字越小，优先度越高',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `outside_key` varchar(127) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `directory` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`org_id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '企业内部的部门组织，做为用户在企业内的所属组织部门' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_position
-- ----------------------------
DROP TABLE IF EXISTS `sys_position`;
CREATE TABLE `sys_position`  (
  `position_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '职务id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '职务名称',
  `company_id` bigint(20) NULL DEFAULT NULL COMMENT '单位主键',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`position_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '职务表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色的id   产生方式：系统自动生成 组成字符： 数字 长度（字符数）：    20 规则：无',
  `role_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色的显示名称  产生方式：手工录入 组成字符： 中文、英文、数字 长度（字符数）：    20 规则：无',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色的简单描述  产生方式：手工录入 组成字符： 中文、英文、数字 长度（字符数）：    100 规则：无',
  `is_predefined` tinyint(3) UNSIGNED NOT NULL COMMENT '用于表示该角色是否是系统预设。如果是系统预设，则不能在界面上进行修改。  产生方式：手工录入 组成字符： 数字 长度（字符数）：   1 规则：无 1：表示系统预设 0：表示客户定义',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `display_order` bigint(20) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色，权限的集合' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_role_auth
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_auth`;
CREATE TABLE `sys_role_auth`  (
  `rel_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `auth_id` bigint(20) NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL COMMENT '角色的id  产生方式：系统引入 组成字符： 数字 长度（字符数）：    20 规则：无',
  PRIMARY KEY (`rel_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 134091 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色权限关系表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_staff
-- ----------------------------
DROP TABLE IF EXISTS `sys_staff`;
CREATE TABLE `sys_staff`  (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '人员id',
  `company_id` bigint(20) NULL DEFAULT NULL COMMENT '单位主键',
  `org_id` bigint(20) NULL DEFAULT NULL COMMENT '部门主键',
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '姓名',
  `staff_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '工号',
  `owner_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '内部' COMMENT '归属:内部/外部',
  `gender` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'M' COMMENT '性别，M表示男性，F表示女性',
  `nationality` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '民族',
  `marital_status` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '婚姻状况 未婚/已婚/离异',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '0标识可用，1标识禁用',
  `email` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '邮件',
  `country` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '国家',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '电话',
  `telephone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机',
  `education` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '学历',
  `english_level` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '外语水平',
  `school` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '毕业院校',
  `major` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '毕业专业',
  `home_address` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '家庭住址',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '描述',
  `station_id` bigint(20) NULL DEFAULT NULL COMMENT '岗位主键',
  `position_id` bigint(20) NULL DEFAULT NULL COMMENT '职务主键',
  `link_line` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属部门连接线不含单位(包含层级,以_分割,例如: 1_2_3或1_2_3_4)',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `native_place` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '籍贯',
  `id_card_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `social_security_company` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '社保单位',
  `social_security_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '社保号',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `part_work_time` date NULL DEFAULT NULL COMMENT '参加工作时间',
  PRIMARY KEY (`staff_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '人员表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_station
-- ----------------------------
DROP TABLE IF EXISTS `sys_station`;
CREATE TABLE `sys_station`  (
  `station_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '岗位类型 0-技术岗 1-管理岗',
  `company_id` bigint(20) NULL DEFAULT NULL COMMENT '单位主键',
  `org_id` bigint(20) NULL DEFAULT NULL COMMENT '部门主键-顶层部门的id',
  `creator` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `gmt_create` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `gmt_modified` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`station_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '崗位' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帐号的id',
  `staff_id` bigint(20) NULL DEFAULT NULL COMMENT '人员id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的姓名',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '用户状态 0 正常 1停用',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的邮箱',
  `phone` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的手机',
  `rtx_account` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '腾讯通号码',
  `job_title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `department_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '所在部门',
  `role_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '角色的id',
  `tenant_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `outside_key` varchar(127) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `work_group_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '所属工作组id',
  `logo` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `fk_user_role`(`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 360003 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_user_message_auth
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_message_auth`;
CREATE TABLE `sys_user_message_auth`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `auth_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限名称',
  `receive_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收方式：1 站内信 2 短信 3 邮件',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_auth`(`user_id`, `auth_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 213061 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `rel_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`rel_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 192007 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for system_alert
-- ----------------------------
DROP TABLE IF EXISTS `system_alert`;
CREATE TABLE `system_alert`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `alert_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '告警id',
  `alert_source_id` varchar(180) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '告警源标识id,唯一识别一个告警源的标识，对主机设备是sn,对业务系统则是业务系统名称，对平台系统是由ip+port生成的uuid，对原子系统是ip+port生成的uuid',
  `instance` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原始IP+port',
  `alert_source_type` tinyint(4) NOT NULL COMMENT '告警源类型 1. 主机设备，2. 业务系统 3. 平台系统 4. 原子系统',
  `alert_level` tinyint(4) NOT NULL COMMENT '告警级别 1. 一级告警，2.二级告警，3.三级告警，4.四级告警,以及 0.告警恢复，要求每一类告警都必须配置对应的告警恢复',
  `source_display_info` json NULL COMMENT '告警源 json',
  `alert_message` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对告警的描述信息',
  `report_time` datetime(0) NOT NULL COMMENT '告警上报时间,到秒',
  `recovery_time` datetime(0) NULL DEFAULT NULL COMMENT '告警恢复时间，到秒',
  `recovery_status` tinyint(4) NOT NULL DEFAULT 2 COMMENT '恢复状态 0:通过0级告警上报恢复，1:通过非0级告警上报级别跃迁恢复，2:未恢复，默认值 2',
  `usage_rate` double NULL DEFAULT NULL COMMENT '当前使用率',
  `is_hit` tinyint(2) NOT NULL COMMENT '是否命中对应告警源',
  `primary_key` int(11) NULL DEFAULT NULL COMMENT '查询用主键',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_alert_source_id_report_time`(`alert_source_id`, `report_time`) USING BTREE,
  INDEX `idx_alert_source_id_type_report_time`(`alert_source_id`, `alert_source_type`, `report_time`) USING BTREE,
  UNIQUE INDEX `alert_id`(`alert_id`, `alert_source_id`, `alert_source_type`, `report_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 600917 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统告警信息分时表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运维团队名称',
  `des` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `display_order` bigint(32) NULL DEFAULT NULL COMMENT '运维组展示顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for teamasset
-- ----------------------------
DROP TABLE IF EXISTS `teamasset`;
CREATE TABLE `teamasset`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(32) NULL DEFAULT NULL COMMENT '运维团队id',
  `asset_id` bigint(32) NULL DEFAULT NULL COMMENT '资产表id',
  `asset_type` bigint(32) NULL DEFAULT NULL COMMENT '资产类型,0资源,1平台系统,2业务系统',
  `asset_category` bigint(32) NULL DEFAULT NULL COMMENT '资源中资产类型所属类目',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_team_id`(`team_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for teammember
-- ----------------------------
DROP TABLE IF EXISTS `teammember`;
CREATE TABLE `teammember`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(32) NULL DEFAULT NULL COMMENT '运维团队表id',
  `role_id` bigint(32) NULL DEFAULT NULL COMMENT '角色表id',
  `role_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `user_id` bigint(32) NULL DEFAULT NULL COMMENT '用户表id',
  `display_order` bigint(32) NULL DEFAULT NULL COMMENT '角色展示顺序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_display`(`team_id`, `display_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125048 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant`  (
  `tenant_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '产生方式：系统自动生成 组成字符：纯数字 最大长度：20位数字',
  `tenant_group` tinyint(4) NOT NULL DEFAULT 1 COMMENT '租户分组 特殊情况 目前对应南网为 0 省公司 1市公司',
  `account` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '租户帐号，与用户帐号配合使用。  租户帐号，一般由：企业统一信用证代码、身份证号、组织机构代码、组织部门id。  如果用在企业内部，以组织部门id做为租户帐号，并且在租户帐号界面，以选择方式（输入用户名后，提供筛选后的备选租户，不同租户内部用户可以重名）  产生方式：手工录入 组成字符：支持中文、英文、数字 长度：    20个字符',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '租户名称，来自于组织名、企业名或个人名。  产生方式：手工录入 组成字符：支持中文、英文、数字 长度：    20个字符',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对租户的简单介绍  产生方式：手工录入 组成字符：支持中文、英文、数字、符号 长度（字符数）：    1000 规则：无',
  `admin_user` bigint(20) UNSIGNED NOT NULL COMMENT '租户的管理用户。租户创建时，同时生成的默认用户。具有租户内的最高权限。  租户管理员用户的accountid  产生方式：系统引入 组成字符： 数字 长度（字符数）：    20 规则：无',
  `status` tinyint(3) UNSIGNED NOT NULL COMMENT '租户的状态.   产生方式：手工设置 组成字符： 数字 长度（字符数）：    1 规则： 0：表示正常状态 1：表示非正常状态 2：...',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `parent_tenant` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '有层级关系时的父层级租户id',
  `resource_quota` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '资源配额， 可以用来购买计算资源，如CPU，内存，存储等\n产生方式：手工设置\n组成字符： 数字\n单位：分 (前端展示需要转换)',
  `logo` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业logo图标路径',
  PRIMARY KEY (`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '租户，指相互独立的责任实体  指it复杂环境下，资源共享情景下，不同企业共用资源时，不同的企业，需以租户的方式进行资源隔离，及分别计费。' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for testaa
-- ----------------------------
DROP TABLE IF EXISTS `testaa`;
CREATE TABLE `testaa`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for user_message_count
-- ----------------------------
DROP TABLE IF EXISTS `user_message_count`;
CREATE TABLE `user_message_count`  (
  `user_id` int(11) NOT NULL,
  `read_num` int(11) NULL DEFAULT NULL,
  `unread_num` int(11) NULL DEFAULT NULL,
  `read_interrupt` int(11) NULL DEFAULT NULL,
  `unread_interrupt` int(11) NULL DEFAULT NULL,
  `read_alarm` int(11) NULL DEFAULT NULL,
  `unread_alarm` int(11) NULL DEFAULT NULL,
  `read_resource_operation` int(11) NULL DEFAULT NULL,
  `unread_resource_operation` int(11) NULL DEFAULT NULL,
  `read_resource_management` int(11) NULL DEFAULT NULL,
  `unread_resource_management` int(11) NULL DEFAULT NULL,
  `read_operation_management` int(11) NULL DEFAULT NULL,
  `unread_operation_management` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for vm_snapshot
-- ----------------------------
DROP TABLE IF EXISTS `vm_snapshot`;
CREATE TABLE `vm_snapshot`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '镜像标识',
  `uuid` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `oss_server_id` bigint(20) NOT NULL,
  `platform_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '虚拟化技术',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板名称',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `os_version` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '未知',
  `mem_size_total` bigint(50) NOT NULL,
  `storage_size_total` bigint(50) NULL DEFAULT 0,
  `vcpu_count` int(3) NOT NULL,
  `folder_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime(0) NULL DEFAULT NULL,
  `updater` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gmt_modified` datetime(0) NULL DEFAULT NULL,
  `image_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '镜像类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '虚拟机模板或镜像' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for wiring_relation
-- ----------------------------
DROP TABLE IF EXISTS `wiring_relation`;
CREATE TABLE `wiring_relation`  (
  `id` bigint(32) NOT NULL AUTO_INCREMENT,
  `local_equipment_wiring_id` bigint(32) NULL DEFAULT NULL COMMENT '本地设备配线id,外键',
  `panel_distribution_id_list` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配线架配线id列表,外键',
  `switch_wiring_id` bigint(32) NULL DEFAULT NULL COMMENT '交换机配线id,外键',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '数据添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '数据更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;


DROP TABLE IF EXISTS `resource_audit`;
CREATE TABLE `resource_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `resource_type` tinyint(2) NOT NULL COMMENT '1 台账 2 业务系统',
  `resource_id` int(11) DEFAULT NULL COMMENT '资源id',
  `display_type` varchar(32) NOT NULL COMMENT '展示名称',
  `operate_type` tinyint(4) NOT NULL COMMENT '操作类型 1 新增 2 编辑 3导入',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 未审核 1 审核通过 2 审核不通过',
  `execute_result` tinyint(2) DEFAULT NULL COMMENT '执行结果 1 成功 0 失败 2 执行中',
  `refuse_reason` varchar(128) DEFAULT NULL COMMENT '不通过原因',
  `auditor` varchar(32) DEFAULT NULL COMMENT '审核人',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `failure_reason` json DEFAULT NULL COMMENT '失败原因',
  `operator` varchar(32) NOT NULL COMMENT '申请人',
  `apply_time` datetime NOT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `resource_audit_uidx_aso` (`apply_time`,`status`,`operator`) USING BTREE,
  KEY `resource_audit_uidx_sae` (`status`,`auditor`,`execute_result`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COMMENT='资源审核';


DROP TABLE IF EXISTS `resource_audit_appsys_temp`;
CREATE TABLE `resource_audit_appsys_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `audit_id` int(11) NOT NULL COMMENT '审核id',
  `index` int(11) DEFAULT NULL COMMENT '导入记录序列',
  `system_name_id` int(11) NOT NULL COMMENT '系统名称,id,来自分组',
  `owning_system_id` int(11) NOT NULL COMMENT '所属系统，数据字典',
  `business_type_id` int(11) DEFAULT NULL COMMENT '业务类型，数据字典',
  `system_version` varchar(20) DEFAULT NULL COMMENT '系统版本号',
  `system_type` enum('测试系统','生产系统') DEFAULT NULL COMMENT '测试系统、生产系统',
  `current_status_id` int(11) DEFAULT NULL COMMENT '当前状态id,数据字典',
  `update_date` date DEFAULT NULL COMMENT '版本更新日期',
  `system_online_time` date DEFAULT NULL COMMENT '系统上线时间',
  `system_logout_time` date DEFAULT NULL COMMENT '系统下线时间',
  `deploy_way_id` int(11) DEFAULT NULL COMMENT '部署方式,数据字典',
  `access_address` varchar(128) NOT NULL COMMENT '访问地址',
  `network` enum('内网','外网') DEFAULT NULL COMMENT '内网/外网',
  `system_level_id` int(11) DEFAULT NULL COMMENT '系统等级,数据字典',
  `construction_type_id` int(11) DEFAULT NULL COMMENT '建设类型,数据字典',
  `software_ids` varchar(256) DEFAULT NULL COMMENT '使用软件ids,以逗号隔开',
  `description` varchar(256) DEFAULT NULL COMMENT '描述',
  `intake_i6000_monitor` tinyint(2) DEFAULT NULL COMMENT '是否纳入i6000监控',
  `filing_in_i6000` tinyint(2) DEFAULT NULL COMMENT '是否在i6000备案',
  `filing_code` varchar(64) DEFAULT NULL COMMENT 'i6000备案编号',
  `access_property_monitor` tinyint(2) DEFAULT NULL COMMENT '是否接入性能检测',
  `third_party_security_assessment` tinyint(2) DEFAULT NULL COMMENT '第三方安全测评',
  `evaluate_company_vendor_id` int(11) DEFAULT NULL COMMENT '测评厂商',
  `evaluate_report_code` varchar(64) DEFAULT NULL COMMENT '测评报告编号',
  `security_level_id` int(11) DEFAULT NULL COMMENT '等级保护安全等级,数据字典',
  `security_level_evaluation_date` date DEFAULT NULL COMMENT '等级保护测评日期',
  `occupy_company_id` int(11) DEFAULT NULL COMMENT '使用部门,来自company,id',
  `occupy_org_id` int(11) DEFAULT NULL COMMENT '使用部门,来自org,id',
  `system_vendor_id` int(11) DEFAULT NULL COMMENT '系统实施厂商,id',
  `system_vendor_contacts` varchar(20) DEFAULT NULL COMMENT '系统实施厂商联系方式',
  `outsourcing_maintain_company_id` int(11) DEFAULT NULL COMMENT '外委运维厂商,来自company,id',
  `outsourcing_maintain_org_id` int(11) DEFAULT NULL COMMENT '外委运维厂商,来自org,id',
  `outsourcing_maintain_contacts_id` int(11) DEFAULT NULL COMMENT '外委运维联系人,id',
  `outsourcing_maintain_contacts` varchar(20) DEFAULT NULL COMMENT '外委运维联系人联系方式',
  `business_charge_company_id` int(11) DEFAULT NULL COMMENT '业务主管部门,来自company,id',
  `business_charge_org_id` int(11) DEFAULT NULL COMMENT '业务主管部门,来自org,id',
  `business_director_id` int(11) NOT NULL COMMENT '业务负责人,id',
  `business_director_contacts` varchar(20) DEFAULT NULL COMMENT '业务负责人联系方式',
  `maintain_company_id` int(11) DEFAULT NULL COMMENT '运维部门,来自company,id',
  `maintain_org_id` int(11) DEFAULT NULL COMMENT '运维部门,来自org,id',
  `maintainer_id` int(11) NOT NULL COMMENT '运维责任人',
  `maintainer_contacts` varchar(20) DEFAULT NULL COMMENT '运维责任人联系方式',
  `is_monitor` tinyint(2) NOT NULL DEFAULT '0' COMMENT '是否监控',
  `app_system_data` json DEFAULT NULL COMMENT '业务系统数据',
  PRIMARY KEY (`id`),
  KEY `resource_audit_appsys_aa` (`audit_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='应用系统';


DROP TABLE IF EXISTS `resource_audit_asset_temp`;
CREATE TABLE `resource_audit_asset_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `audit_id` int(11) NOT NULL COMMENT '审核id',
  `index` int(11) DEFAULT NULL COMMENT '记录id',
  `asset_extend_key` varchar(64) NOT NULL COMMENT 'key值',
  `asset_extend_value` json DEFAULT NULL COMMENT 'value值',
  `asset_extend_template` json DEFAULT NULL COMMENT '模值',
  PRIMARY KEY (`id`),
  KEY `resource_audit_asset_tmp_aa` (`audit_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1821 DEFAULT CHARSET=utf8mb4 COMMENT='资产扩展数据';

SET FOREIGN_KEY_CHECKS = 1;
