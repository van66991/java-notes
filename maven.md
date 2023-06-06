# 1 为什么使用Maven

```
更好的管理jar包
```

| 使用maven之前/之后 | 获取jar包                                            | 添加jar包                                                    |
| ------------------ | ---------------------------------------------------- | ------------------------------------------------------------ |
| 使用maven之前      | 自行在网络中下载jar包，效率较低                      | 将jar复制到项目工程中，AddAsLibrary，相对浪费存储空间        |
| 使用maven之后      | 统一在一个地址下载资源jar包（阿里云镜像服务器等...） | jar包统一存储Maven本地仓库，使用坐标方式将jar包从仓库引入到项目中 |

![image-20230220131442044](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220131445.png)

* 使用Maven便于解决jar包**冲突及依赖**问题

# 2 什么是Maven

- Maven是一款自动化构建工具，专注服务于Java平台的 **项目构建** 和 **依赖管理** 。
- 依赖管理：jar之间的依赖关系，jar包管理问题统称为依赖管理
- **项目构建**：项目构建不等同于项目创建
  - 项目构建是一个过程（7步骤组成），项目创建是瞬间完成的
    1. 清理：mvn clean
    2. 编译：mvn compile
    3. 测试：mvn test
    4. 报告：
    5. 打包：mvn package
    6. 安装：mvn install
    7. 部署：

# 3 Maven安装与配置

## 3-1 Maven准备

> 注意：IDEA2019.1.x 最高支持Maven的3.6.0

- 下载地址：http://maven.apache.org/
- Maven底层使用Java语言编写的，所有需要配置JAVA_HOME环境变量及Path
- 将Maven解压**非中文无空格**目录下
- 配置**MAVEN_HOME**环境变量及Path
- 输入【cmd】,进入命令行窗口，输入**【mvn   -v】** ，检查Maven环境是否搭建成功

## 3-2 Maven基本配置

- （1）**打开Maven配置文件。**位置：maven根目录/conf/settings.xml

- （2）**设置本地仓库**（默认：用户家目录/.m2/repository）

  ```xml
  <!-- localRepository
     | The path to the local repository maven will use to store artifacts.
     |
     | Default: ${user.home}/.m2/repository
    <localRepository>/path/to/local/repo</localRepository>
    -->
  <localRepository>E:\devtools\maven\local-repository</localRepository>
  ```

  ```
  就用默认的也挺好，减少问题
  ```

  

- （3）**设置阿里云镜像服务器**

  ```xml
  <mirrors>
      <!-- mirror
       | Specifies a repository mirror site to use instead of a given repository. The repository that
       | this mirror serves has an ID that matches the mirrorOf element of this mirror. IDs are used
       | for inheritance and direct lookup purposes, and must be unique across the set of mirrors.
       |
      <mirror>
        <id>mirrorId</id>
        <mirrorOf>repositoryId</mirrorOf>
        <name>Human Readable Name for this Mirror.</name>
        <url>http://my.repository.com/repo/path</url>
      </mirror>
       -->
  <mirror>
          <id>nexus-aliyun</id>
          <mirrorOf>central</mirrorOf>
          <name>Nexus aliyun</name>
          <url>http://maven.aliyun.com/nexus/content/groups/public</url>
  </mirror>
  </mirrors>
  ```

- （4）**设置使用JDK版本（1.8/JDK8）**

  ```xml
  <profiles>
  <profile>
        <id>jdk-1.8</id>
        <activation>
          <activeByDefault>true</activeByDefault>
          <jdk>1.8</jdk>
        </activation>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
        </properties>
  </profile>
  </profiles>
  ```

## 3-3 Maven工程目录结构

> 约束>配置>代码

- ==**Maven工程目录结构约束**==
  - 项目名
    - src（源代码）
      - main（主程序代码）
        - java（java源代码）
        - resources（配置文件代码）
      - test（测试代码）
        - java（测试代码）
    - pom.xml（Maven配置）

## 3-4 Maven常用命令行命令

- **cmd进入项目名根目录**
- 清理：mvn clean 
- 编译：mvn compile
- 测试：mvn test-compile
- 测试：mvn test
- 打包：mvn package
- 安装：mvn install

# 4 Maven与IDEA整合

## 4-1 将Maven整合到IDEA中

### 4-1-1 Settings设置Maven基本信息

![image-20220320104957163](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220141317.png)

![image-20220320105010404](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220141319.png)

## 4-2 常见错误

### 4-2-1 两个Settings导致的错误

```
注意！！！！
有一个坑
IDEA新建项目的时候走的不是Settings，而是File-->New Project Settings-->Settings for New Projects...
这两个设置是独立的，都要设置一遍！！！
```

![image-20230220144252860](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220144255.png)

# 5 Maven核心概念

## 5-1 Maven的POM

* **POM全称**：Project Object Model【项目对象模型】，将项目封装为对象模型，便于使用Maven管理【构建】项目

* *pom.xml* 常用标签

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <!--    设置父工程坐标-->
    <parent>
        <artifactId>maven_demo</artifactId>
        <groupId>com.atguigu</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>maven_helloworld</artifactId>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

## 5-2 Maven约定的目录结构

- 项目名
  - src【java源代码】
    - main【java主程序代码】
      - java【java代码】
      - resources【配置文件代码】
    - test【测试代码】
      - java【测试java代码】
  - pom.xml【POM配置文件代码】
  - target【编译后目录结构】

## 5-3 Maven的生命周期

- Maven生命周期：按照顺序执行各个命令，Maven生命周期包含以下三个部分组成
  - Clean LifeCycle：在进行真正的构建之前进行一些清理工作。
  - **Default LifeCycle：构建的核心部分，编译，测试，打包，安装，部署等等。**
  - Site LifeCycle：生成项目报告，站点，发布站点。

```
编测打安部
鞭策答案部

生命周期的特点：点击后面的操作会把前面的也做了
```

![image-20230220154520584](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220154523.png)

## 5-4 Maven插件和目标

- **插件**：插件本质是由jar包和配置文件组成
- **目标**：每个插件都能实现多个功能，每个功能就是一个插件目标。

* Maven的生命周期和插件目标相互绑定，以完成某个具体的构建任务

  * **例如:** 

  * compile就是插件 maven-compiler-plugin 的一个功能（目标）; 

  * pre-clean 是插件 maven-clean-plugin 的一个目标 

## 5-5 Maven的仓库（重点）

### 5-5-1 仓库分类

- **本地仓库**：为当前计算机提供maven服务
- **远程仓库**：为其他计算机也可以提供maven服务
  - 私服：架设在当前局域网环境下，为当前局域网范围内的所有Maven工程服务。
  - 中央仓库：架设在Internet上，为全世界所有Maven工程服务。
  - 中央仓库的镜像：架设在各个大洲，为中央仓库分担流量。减轻中央仓库的压力，同时更快的响应用户请求。

### 5-5-2 仓库中的文件类型（jar包）

- Maven的插件
- **第三方框架或工具的jar包**
- 自研的项目或模块

## 5-6 Maven的坐标（重点）

- **作用：使用坐标引入jar包**

- 坐标由  ==g-a-v==  组成

  [1]**groupId**：公司或组织的域名倒序+当前项目名称

  [2]**artifactId**：当前项目的模块名称

  [3]**version**：当前模块的版本

- 注意

  - ==g-a-v：本地仓库jar包位置==
  - ==a-v：jar包全名==

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>
```

* 坐标应用
  - ==**坐标参考网址：http://mvnrepository.com**==

# 6 Maven的依赖管理

## 6-1 依赖范围scope

- 依赖范围语法：\<scope>
  - **compile**【默认值】：在main、test、Tomcat【服务器】下均有效。
  - **test**：只能在test目录下有效
    - junit
  - **provided**：在main、test下均有效，Tomcat【服务器】无效。
    - servlet-api

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>
```

## 6-2 依赖传递性

- **路径最短者优先【就近原则】**

![image-20230220164017743](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230220164022.png)

- **相同路径长度先声明者优先**

- 注意：Maven可以自动解决jar包之间的依赖问题

## 6-3 Maven中统一管理版本号

```xml
<properties>
    <spring-version>5.3.17</spring-version>
</properties>

<dependencies>
    <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>${spring-version}</version>
    </dependency>
    <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>${spring-version}</version>
    </dependency>
</dependencies>
```

# 7 Maven的继承和聚合

## 7-1 为什么需要继承

- 如子工程大部分都共同使用jar包，可以提取父工程中，使用【继承原理】在子工程中使用
- **父工程打包方式，必须是pom方式**

## 7-2 Maven继承方式一（不推荐）

- 在父工程中的pom.xml中导入jar包，在子工程（会自动出现）中统一使用。【所有子工程强制引入父工程jar包】
- **父工程打包方式，必须是pom方式**

- 示例代码

  ```xml
  <packaging>pom</packaging>
  
  <dependencies>
      <dependency>
          <groupId>junit</groupId>
          <artifactId>junit</artifactId>
          <version>4.12</version>
          <scope>test</scope>
      </dependency>
  </dependencies>
  ```

* 有不足，推荐方式二

## 7-3 Maven继承方式二（推荐）

- 在父工程中导入jar包
- **父工程打包方式，必须是pom方式**

```xml
<packaging>pom</packaging>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

```
这里要注意<dependencyManagement>标签只是声明依赖
真正引入的时刻在子工程显示调用（即写出）g-a的那一刻
```

* 在子工程的parent标签中添加`<relativePath>../pom.xml</relativePath>`

* 按需求选择是否继承父工程的jar包（子工程中不要 g-a-v 中的 v）

```xml
<parent>
    <artifactId>maven_demo</artifactId>
    <groupId>com.atguigu</groupId>
    <version>1.0-SNAPSHOT</version>
    <relativePath>../pom.xml</relativePath>
</parent>

<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
    </dependency>
</dependencies>
```

## 7-4 Maven的聚合

  - **优势：**只要将子工程聚合到父工程中，就可以实现效果：==安装或清除父工程时，子工程会进行同步操作。==

```
继承关系十分复杂的项目中，如果不进行Maven的聚合，会十分麻烦
```

  - 注意：Maven会按照==依赖顺序==自动安装子工程

- 父工程pom.xml中：

  ```xml
  <modules>
      <module>maven_helloworld</module>
      <module>HelloFriend</module>
      <module>MakeFriend</module>
  </modules>



# 8 Maven命令行实战

* 比较常用的（装杯）：

```bash
mvn -T 8 clean install -DskipTests=true
mvn -T 8 clean compile -DskipTests=true
//-T : +线程数，充分利用多核CPU资源
//-DskipTests=true ：跳过测试
```

* 检查有没有起作用：

```bash
mvn -version
```

* 根目录下指定模块编译

```bash
mvn clean install -am -pl ${模块路径} -DskipTests=true
```



  
