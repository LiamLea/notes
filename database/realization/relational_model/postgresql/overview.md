# postgrelsql

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [postgrelsql](#postgrelsql)
    - [基本概念](#基本概念)
      - [1.相关文件和目录](#1相关文件和目录)
        - [（1）数据目录](#1数据目录)
        - [（2）配置文件](#2配置文件)
        - [（3）hba（host-based authencation）配置文件](#3hbahost-based-authencation配置文件)
        - [（4）ident_file（用户名映射）](#4ident_file用户名映射)
      - [1.安装注意事项](#1安装注意事项)
    - [基础操作](#基础操作)
      - [1.登录postgres](#1登录postgres)
      - [2.创建操作](#2创建操作)
      - [3.查询](#3查询)
        - [(1) list users and roles](#1-list-users-and-roles)
      - [4.授权](#4授权)
      - [5.check roles and privileges](#5check-roles-and-privileges)
        - [(1) check user and role](#1-check-user-and-role)
        - [(2) check privileges of a role](#2-check-privileges-of-a-role)

<!-- /code_chunk_output -->

### 基本概念

#### 1.相关文件和目录
##### （1）数据目录
`/var/lib/pgsql/11/data`

##### （2）配置文件
`postgresql.conf`，一般在数据目录下

##### （3）hba（host-based authencation）配置文件
`pg_hba`，一般在数据目录下

##### （4）ident_file（用户名映射）
`pg_indent.conf`，一般在数据目录下


#### 1.安装注意事项
* 安装postgresql后会创建postgres用户和数据库
* postgres用户为该postgresql的管理员，所以只有切换为postgres用户才能操作postgresql数据库

***

### 基础操作

#### 1.登录postgres
* 以超级管理员身份登录
```shell
su - postgres
psql
```
* 普通登录
```shell
psql -h 主机ip -U 用户名 -d 数据库名
```

#### 2.创建操作
* 创建数据库
```shell
create database <DATABASSE>;
```

#### 3.查询
```shell
  \l            #list，显示所有的数据库
  \d            #display，显示所有的可见的table、view等
  \c xx         #connect，连接数据库、表等等

  \d *          #显示所有table、view等（即使不可见）
  \d *.*        #显示所有table、view等，及其里面的内容
```

##### (1) list users and roles
```sql
SELECT * FROM pg_user;
SELECT * FROM pg_roles;
``` 

#### 4.授权
**注意**：当导入表时，没有用指定用户的身份导入，权限可能有问题

```sql
CREATE DATABASE test_db;

\c test_db;

CREATE USER migrator WITH PASSWORD 'pw123';
alter schema public owner to migrator;

CREATE ROLE Write_Read;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO Write_Read;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO Write_Read;
GRANT SELECT, Usage ON ALL SEQUENCES IN SCHEMA public TO Write_Read;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO Write_Read;

CREATE ROLE Only_Read;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO Only_Read;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO Only_Read;

CREATE USER dbUserA WITH PASSWORD 'pw123';
GRANT Write_Read TO dbUserA;

CREATE USER dbUserB WITH PASSWORD 'pw123';
GRANT Only_Read TO dbUserB;






CREATE ROLE DDL_Change;
GRANT CREATE,USAGE ON SCHEMA public TO DDL_Change;
GRANT ALTER,DROP ON ALL TABLES IN SCHEMA public TO DDL_Change;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT CREATE,USAGE ON SCHEMA TO DDL_Change; 
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALTER,DROP ON TABLES TO DDL_Change; 
GRANT DDL_Change TO migrator;
```

* example

```SQL
CREATE DATABASE aiops;
\c aiops

-- Revoke the CREATE privilege and only grant it to necessary roles later.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- create base role and grant privileges later
CREATE ROLE aiops_readonly WITH NOLOGIN;
CREATE ROLE aiops_readwrite WITH NOLOGIN;

/*
  create developer user
*/
CREATE USER aiops_developers;
-- log all SQL statements executed by the user
ALTER ROLE aiops_developers SET log_statement TO 'all';
-- use an IAM policy for IAM database access for the user
GRANT rds_iam TO aiops_developers;
GRANT aiops_readonly to aiops_developers;

/*
  create sre_dba user
*/
CREATE USER sre_dba WITH CREATEROLE;
-- mod logs all ddl statements, plus data-modifying statements
ALTER ROLE sre_dba SET log_statement TO 'mod';
-- use an IAM policy for IAM database access for the user
GRANT rds_iam TO sre_dba WITH ADMIN OPTION;
-- WITH ADMIN OPTION: the sre_dba can assign this role to others
GRANT aiops_readwrite TO sre_dba WITH ADMIN OPTION;
GRANT aiops_readonly TO sre_dba WITH ADMIN OPTION;

/*
  create migrator user
*/
CREATE USER aiops_migrator;
-- log all SQL statements executed by the user
ALTER ROLE aiops_migrator SET log_statement TO 'all';
-- use an IAM policy for IAM database access for the user
GRANT rds_iam TO aiops_migrator;
-- Grant the revoked CREATE privilege
GRANT CREATE on SCHEMA public to aiops_migrator;

/*
  grant privileges
  use the migrator to create tables which is owned by the migrator so the migrator has all privileges of all tables
*/
-- switch role
SET ROLE aiops_migrator;

-- grant read privileges of the tables created by the migrator to readonly user
ALTER DEFAULT PRIVILEGES FOR ROLE aiops_migrator IN SCHEMA public GRANT SELECT ON TABLES TO aiops_readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE aiops_migrator IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO aiops_readonly;
-- grant read and write privileges of the tables created by the migrator to readwrite user
ALTER DEFAULT PRIVILEGES FOR ROLE aiops_migrator IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO aiops_readwrite;
ALTER DEFAULT PRIVILEGES FOR ROLE aiops_migrator IN SCHEMA public GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO aiops_readwrite;
```

#### 5.check roles and privileges

##### (1) check user and role

* connect pgsql -> Server Objects -> roles
  * icon with a hat is a role, otherwise is a user

##### (2) check privileges of a role
* `<database>` -> information_schema -> views
  * `role_table_grants`
    * check permissions of every role on every table
  * `role_usage_grants`
    * check permissions of every role on every sequence (public/sequences)
* `<database>` -> pg_catalog -> tables
  * `pg_default_acl`
    * check default privileges of an database
* `<database>` -> pg_catalog -> views
  * `pg_tables`
    * check the owner of every table