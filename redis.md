| 章节                   | 了解/重点    | 操作？       | 理解？       |
| ---------------------- | ------------ | ------------ | ------------ |
| 1. Redis入门           | **（了解）** | **（操作）** |              |
| 2. 数据类型            | **（重点）** | **（操作）** | **（理解）** |
| 3. 常用指令            |              | **（操作）** |              |
| 4. Jedis               | **（重点）** | **（操作）** |              |
| 5. 持久化              | **（重点）** |              | **（理解）** |
| 6. 数据删除与淘汰策略  |              |              | **（理解）** |
| 7. 主从复制            | **（重点）** | **（操作）** | **（理解）** |
| 8. 哨 兵               | **（重点）** | **（操作）** | **（理解）** |
| 9. Cluster集群方案     | **（重点）** | **（操作）** | **（理解）** |
| 10. 企业级缓存解决方案 | **（重点）** |              | **（理解）** |
| 11. 性能指标监控       | **（了解）** |              |              |

学习目标

目标1：能够说出NoSQL的概念，redis的应用场景，能够完成redis的下载安装与启动以及一些常用的配置

目标2：能够说出redis常用的5种数据类型，对应这些数据类型的基本操作，应用场景及对应的解决方案

目标3：能够说出redis中常用的一些基本指令

目标4：能够使用jedis完成客户端应用程序的开发

目标5：能够说出redis数据持久化的两种方式，各自相关的操作配置及指令，以及两种方式的优缺点比较

# 1 Redis 简介

在这个部分，我们将学习以下3个部分的内容，分别是：

◆ Redis 简介（NoSQL概念、Redis概念）

◆ Redis 的下载与安装

◆ Redis 的基本操作

## 1.1 NoSQL概念

### 1.1.1 问题现象

在讲解NoSQL的概念之前呢，我们先来看一个现象：

#### （1）问题现象

每年到了过年期间，大家都会自觉自发的组织一场活动，叫做春运！以前我们买票都是到火车站排队，后来呢有了12306，有了他以后就更方便了，我们可以在网上买票，但是带来的问题，大家也很清楚，春节期间买票进不去，进去了刷不着票。什么原因呢，人太多了！

![](img\12306-淘宝.png)

除了这种做铁路的，它系统做的不专业以外，还有马爸爸做的淘宝，它面临一样的问题。淘宝也崩，也是用户量太大！作为我们整个电商界的东哥来说，他第一次做图书促销的时候，也遇到了服务器崩掉的这样一个现象，原因同样是因为用户量太大！![](img\京东翻车案.png)

#### （2）现象特征

再来看这几个现象，有两个非常相似的特征：

第一，用户比较多，海量用户

第二，高并发

这两个现象出现以后，对应的就会造成我们的服务器瘫痪。核心本质是什么呢？其实并不是我们的应用服务器，而是我们的关系型数据库。关系型数据库才是最终的罪魁祸首！

#### （3）造成原因

什么样的原因导致的整个系统崩掉的呢：

1.性能瓶颈：磁盘IO性能低下

关系型数据库菜。存取数据的时候和读取数据的时候他要走磁盘IO。磁盘这个性能本身是比较低的。

2.扩展瓶颈：数据关系复杂，扩展性差，不便于大规模集群

我们说关系型数据库，它里面表与表之间的关系非常复杂，不知道大家能不能想象一点，就是一张表，通过它的外键关联了七八张表，这七八张表又通过她的外件，每张又关联了四五张表。你想想，查询一下，你要想拿到数据，你就要从A到B、B到C、C到D的一直这么关联下去，最终非常影响查询的效率。同时，你想扩展下，也很难!

#### （4）解决思路

面对这样的现象，我们要想解决怎么版呢。两方面：

一，降低磁盘IO次数，越低越好。

二，去除数据间关系，越简单越好。

降低磁盘IO次数，越低越好，怎么搞？我不用你磁盘不就行了吗？于是，内存存储的思想就提出来了，我数据不放到你磁盘里边，放内存里，这样是不是效率就高了。

第二，你的数据关系很复杂，那怎么办呢？干脆简单点，我断开你的关系，我不存关系了，我只存数据，这样不就没这事了吗？

把这两个特征一合并一起，就出来了一个新的概念：NoSQL

### 1.1.2 NoSQL的概念

#### （1）概念

NoSQL：即 Not-Only SQL（ 泛指非关系型的数据库），作为关系型数据库的补充。 作用：应对基于海量用户和海量数据前提下的数据处理问题。

他说这句话说的非常客气，什么意思呢？就是我们数据存储要用SQL，但是呢可以不仅仅用SQL，还可以用别的东西，那别的东西叫什么呢？于是他定义了一句话叫做NoSQL。这个意思就是说我们存储数据，可以不光使用SQL，我们还可以使用非SQL的这种存储方案，这就是所谓的NoSQL。

#### （2）特征

**可扩容，可伸缩。**SQL数据关系过于复杂，你扩容一下难度很高，那我们Nosql 这种的，不存关系，所以它的扩容就简单一些。

**大数据量下高性能。**包数据非常多的时候，它的性能高，因为你不走磁盘IO，你走的是内存，性能肯定要比磁盘IO的性能快一些。

**灵活的数据模型、高可用。**他设计了自己的一些数据存储格式，这样能保证效率上来说是比较高的，最后一个高可用，我们等到集群内部分再去它！

#### （3）常见 Nosql 数据库

目前市面上常见的Nosql产品：Redis、memcache、HBase、MongoDB

#### （4）应用场景-电商为例

我们以电商为例，来看一看他在这里边起到的作用。

第一类，在电商中我们的基础数据一定要存储起来，比如说商品名称，价格，生产厂商，这些都属于基础数据，这些数据放在MySQL数据库。

第二类，我们商品的附加信息，比如说，你买了一个商品评价了一下，这个评价它不属于商品本身。就像你买一个苹果，“这个苹果很好吃”就是评论，但是你能说很好吃是这个商品的属性嘛？不能这么说，那只是一个人对他的评论而已。这一类数据呢，我们放在另外一个地方，我们放到MongoDB。它也可以用来加快我们的访问，他属于NoSQL的一种。

第三，图片内的信息。注意这种信息相对来说比较固定，他有专用的存储区，我们一般用文件系统来存储。至于是不是分布式，要看你的系统的一个整个   瓶颈   了？如果说你发现你需要做分布式，那就做，不需要的话，一台主机就搞定了。

第四，搜索关键字。为了加快搜索，我们会用到一些技术，有些人可能了解过，像分ES、Lucene、solr都属于搜索技术。那说的这么热闹，我们的电商解决方案中还没出现我们的redis啊！注意第五类信息。

第五，热点信息。访问频度比较高的信息，这种东西的第二特征就是它具有波段性。换句话说他不是稳定的，它具有一个时效性的。那么这类信息放哪儿了，放到我们的redis这个解决方案中来进行存储。

具体的我们从我们的整个数据存储结构的设计上来看一下。

![](img\电商场景解决方案.png)

我们的基础数据都存MySQL,在它的基础之上，我们把它连在一块儿，同时对外提供服务。向上走，有一些信息加载完以后,要放到我们的MongoDB中。还有一类信息，我们放到我们专用的文件系统中（比如图片），就放到我们的这个搜索专用的，如Lucene、solr及集群里边，或者用ES的这种技术里边。那么剩下来的热点信息，放到我们的redis里面。

## 1.2 Redis概念

### 1.2.1 redis概念

**概念**：Redis (REmote DIctionary Server) 是用 C 语言开发的一个开源的高性能键值对（key-value）数据库。

**特征**：

（1）数据间没有必然的关联关系；

（2）内部采用单线程机制进行工作；

（3）高性能。官方提供测试数据，50个并发执行100000 个请求,读的速度是110000 次/s,写的速度是81000次/s。

（4）多数据类型支持

* 字符串类型 string

* 列表类型   list 

* 散列类型 hash  

* 集合类型 set 

* 有序集合类型 zset/sorted_set 

（5）支持持久化，可以进行数据灾难恢复

### 1.2.2 redis的应用场景

（1）为**热点数据加速查询**（主要场景）。如热点商品、热点新闻、热点资讯、推广类等高访问量信息等。

（2）**即时信息查询**。如排行榜、各类网站访问统计、公交到站信息、在线人数信息（聊天室、网站）、设备信号等。

（3）**时效性信息控制**。如验证码控制、投票控制等。

（4）分布式数据共享。如分布式集群架构中的 session 分离

（5）消息队列

## 1.3 Redis 的下载与安装

### 1.3.1 Redis 的下载与安装

本课程所示，均基于 Center OS7 安装Redis。

下载安装包：

```bash
wget http://download.redis.io/releases/redis-5.0.0.tar.gz
```

解压安装包：

```bash
tar –xvf redis-5.0.0.tar.gz
```

Redis初次安装时执行make或make install命令报错：【gcc:命令未找到】

**在联网的情况下执行命令：**yum install gcc-c++

编译（在解压的目录中执行）：

```bash
make
```

安装（在解压的目录中执行）：

```bash
make install
```



一些文件的作用：

redis.conf redis 核心配置文件

redis-check-dump RDB文件检查工具（快照持久化文件）

redis-check-aof AOF文件修复工具

## 1.4 Redis 启动

### 1.4.1 Redis服务器启动

① 启动服务器——参数启动

```bash
redis-server --port ${port}
```

***范例***

```bash
redis-server --port 6379
```

② 启动服务器——配置文件启动

```bash
redis-server ${配置文件名}
```

***范例***

```bash
redis-server redis.conf
```

***windows版本***

```bash
在redis根目录下进cmd/powershell
redis-server redis.windows.conf
```



### 1.4.2 Redis客户端启动

启动客户端

```bash
redis-cli [-h host] [-p port]
```

范例

```bash
redis-cli –h 61.129.65.248 –p 6384
```

注意：服务器启动指定端口使用的是--port，客户端启动指定端口使用的是-p。-的数量不同。

***windows版本***

```
redis-cli
```



### 1.4.3 Redis基础环境设置约定

创建配置文件存储目录

```bash
mkdir conf
```

创建服务器文件存储目录（包含日志、数据、临时配置文件等）

```bash
mkdir data
```

创建快速访问链接

```bash
ln -s redis-5.0.0 redis
```

## 1.5 配置文件与常用配置

### 1.5.1 服务器端配置

设置服务器以守护进程的方式运行，开启后服务器控制台中将打印服务器运行信息（同日志内容相同）

yes：在后台运行/守护进程模式

no（默认）：前台模式

```bash
daemonize yes|no
```

绑定主机地址

```bash
bind 127.0.0.1
```

设置服务器端口

```bash
port 6379
```

设置服务器文件保存地址

```bash
dir ./
```

### 1.5.2  客户端配置

 服务器允许客户端连接最大数量，默认0，表示无限制。当客户端连接到达上限后，Redis会拒绝新的连接

```bash
maxclients count
```

客户端闲置等待最大时长，达到最大值后关闭对应连接。如需关闭该功能，设置为 0

```bash
timeout seconds
```

### 1.5.3  日志配置

设置服务器以指定日志记录级别

```bash
loglevel debug|verbose|notice|warning
```

日志记录文件名

```bash
logfile filename
```

注意：日志级别开发期设置为verbose即可，生产环境中配置为notice，简化日志输出量，降低写日志IO的频度。

## 1.6 Redis基本操作

### 1.6.1  命令行模式工具使用思考

功能性命令

帮助信息查阅 help

退出指令 ctrl+C

清除屏幕信息 clear

### 1.6.2  信息读写

设置 key，value 数据

```bash
set key value
```

***范例***

```bash
set name itheima
```

![image-20230321200555848](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230321200559.png)

根据 key 查询对应的 value，如果不存在，返回空（nil）

```bash
get key
```

***范例***

```bash
get name
```

![image-20230321200625174](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230321200627.png)



### 1.6.3  帮助信息

![image-20230321200719057](assets/image-20230321200719057.png)

获取命令帮助文档

```bash
help [command]
```



***范例***

```bash
help set
```

![image-20230321200947779](assets/image-20230321200947779.png)

获取组中所有命令信息名称

```bash
help [@group-name]
```

***范例***

```bash
help @string
```

![image-20230321201159070](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230321201202.png)

### 1.6.4  退出

#### ① 退出客户端

````bash
quit
exit
````

快捷键

```bash
Ctrl+C
```

#### ② 退出服务端

Redis服务端可以在前台模式或守护进程模式下运行。如果Redis以守护进程模式运行，则需要使用以下命令来停止Redis服务：

```bash
redis-cli shutdown
```

这将向Redis服务发送一个关闭信号，Redis服务将从守护进程模式退出并停止服务。请注意，在使用此命令时，您需要具有足够的权限来停止Redis服务。

如果Redis以前台模式运行，则可以使用`Ctrl + C`组合键来停止服务。这将发送一个SIGINT信号给Redis服务，使其优雅地关闭并退出。





# 2 数据类型与指令

在这个部分，我们将学习一共要学习三大块内容，首先需要了解一下数据类型，接下来将针对着我们要学习的数据类型进行逐一的讲解，如string、hash、list、set等，最后我们通过一个案例来总结前面的数据类型的使用场景。

## 2.1  数据存储类型介绍

### 2.1.1  业务数据的特殊性

在讲解数据类型之前，我们得先思考一个问题，数据类型既然是用来描述数据的存储格式的，如果你不知道哪些数据未来会进入到我们来的redis中，那么对应的数据类型的选择，你就会出现问题，我们一块来看一下：

#### （1）原始业务功能设计

* **秒杀**。他这个里边数据变化速度特别的快，访问量也特别的高，用户大量涌入以后都会针对着一部分数据进行操作，这一类要记住。

* **618活动**。对于我们京东的618活动、以及天猫的双11活动，相信大家不用说都知道这些数据一定要进去，因为他们的访问频度实在太高了。

* **排队购票**。我们12306的票务信息。这些信息在原始设计的时候，他们就注定了要进redis。

#### （2）运营平台监控到的突发高频访问数据

* 此类平台临时监控到的这些数据，比如说现在出来的一个八卦的信息，这个新闻一旦出现以后呢，顺速的被围观了，那么这个时候，这个数据就会变得访量特别高，那么这类信息也要进入进去。

#### （3）高频、复杂的统计数据

* **在线人数**。比如说直播现在很火，直播里边有很多数据，例如在线人数。进一个人出一个人，这个数据就要跳动，那么这个访问速度非常的快，而且访量很高，并且它里边有一个复杂的数据统计，在这里这种信息也要进入到我们的redis中。

* **投票排行榜**。投票投票类的信息他的变化速度也比较快，为了追求一个更快的一个即时投票的名次变化，这种数据最好也放到redis中。

### 2.1.2  Redis 数据类型(5种常用)

基于以上数据特征我们进行分析，最终得出来我们的Redis中要设计 5种 数据类型：

string、hash、list、set

*sorted_set/zset（应用性较低）*

## 2.2  string 数据类型基本操作

在学习第一个数据类型之前，先给大家介绍一下，在随后这部分内容的学习过程中，我们每一种数据类型都分成三块来讲：首先是讲下它的基本操作，接下来讲一些它的扩展操作，最后我们会去做一个小的案例分析。

### 2.2.1 Redis 数据存储格式

在学习string这个数据形式之前，我们先要明白string到底是修饰什么的。我们知道redis 自身是一个 Map，其中所有的数据都是采用 key : value 的形式存储。

对于这种结构来说，我们用来存储数据一定是一个值前面对应一个名称。我们通过名称来访问后面的值。按照这种形势，我们可以对出来我们的存储格式。前面这一部分我们称为key。后面的一部分称为value，而==我们的数据类型，他一定是修饰value的==。

![](img\redis存储空间.png)

数据类型指的是存储的数据的类型，也就是 value 部分的类型，==key 部分永远都是字符串。==

### 2.2.2  string 类型

（1）存储的数据：单个数据，最简单的数据存储类型，也是最常用的数据存储类型。

string，他就是存一个字符串儿，注意是value那一部分是一个字符串，它是redis中最基本、最简单的存储数据的格式。

（2）存储数据的格式：一个存储空间保存一个数据

每一个空间中只能保存一个字符串信息，这个信息里边如果是存的纯数字，他也能当数字使用，我们来看一下，这是我们的数据的存储空间。

（3）存储内容：通常使用字符串，如果字符串以整数的形式展示，可以作为数字操作使用

![](img\redis存储空间2.png)

一个key对一个value，而这个itheima就是我们所说的string类型，当然它也可以是一个纯数字的格式。

### 2.2.3  string 类型数据的基本操作

#### （1）基础指令

**添加/修改数据添加/修改数据**

```bash
127.0.0.1:6379> set name tan
OK
```

**获取数据**

```
127.0.0.1:6379> get name
"tan"
```

**删除数据**

```
127.0.0.1:6379> del k2
(integer) 1
127.0.0.1:6379> get k2
(nil)
```

**判定性地添加数据**

```bash
127.0.0.1:6379> setnx k4 v4
(integer) 1
127.0.0.1:6379> setnx k4 v5
(integer) 0
```

**添加/修改多个数据**

```
127.0.0.1:6379> mset k1 v1 k2 v2 k3 v3
```

**获取多个数据**

```
127.0.0.1:6379> mget k1 k2
1) "v1"
2) "v2"
```

**获取数据字符个数（字符串长度）**

```
127.0.0.1:6379> strlen k1
(integer) 2
```

**追加信息到原始信息后部**（如果原始信息存在就追加，否则新建）

```
127.0.0.1:6379> get k4
"v4"
127.0.0.1:6379> append k4 v5
(integer) 4
127.0.0.1:6379> get k4
"v4v5"
```

#### （2）单数据操作与多数据操作的选择之惑

即 set 与 mset 的关系。这对于这两个操作来说，没有什么你应该选哪个，而是他们自己的特征是什么，你要根据这个特征去比对你的业务，看看究竟适用于哪个。

![](img\set.png)

假如说这是我们现在的服务器，他要向redis要数据的话，它会发出一条指令。那么当这条指令发过来的时候，比如说是这个set指令过来，那么它会把这个结果返回给你，这个时候我们要思考这里边一共经过了多长时间。

首先，发送set指令要时间，这是网络的一个时间，接下来redis要去运行这个指令要消耗时间，最终把这个结果返回给你又有一个时间，这个时间又是一个网络的时间，那我们可以理解为：一个指令发送的过程中需要消耗这样的时间.

但是如果说现在不是一条指令了，你要发3个set的话，还要多长时间呢？对应的发送时间要乘3了，因为这是三个单条指令,而运行的操作时间呢，它也要乘3了，但最终返回的也要发3次，所以这边也要乘3。

于是我们可以得到一个结论：单指令发3条它需要的时间，假定他们两个一样，是6个网络时间加3个处理时间，如果我们把它合成一个mset呢，我们想一想。

假如说用多指令发3个指令的话，其实只需要发一次就行了。这样我们可以得到一个结论，多指令发3个指令的话，其实它是两个网络时间加上3个redis的操作时间，为什么这写一个小加号呢，就是因为毕竟发的信息量变大了，所以网络时间有可能会变长。

那么通过这张图，你就可以得到一个结论，我们单指令和多指令他们的差别就在于你发送的次数是多还是少。当你影响的数据比较少的时候，你可以用单指令，也可以用多指令。*但是一旦这个量大了，你就要选择多指令了，他的效率会高一些。*

#### （3）小结

* string存储结构
* 数据操作
  * set、mset、del、setnx、append
* 查询操作
  * get、mget、strlen

## 2.3  string 类型数据的扩展操作

### 2.3.1  string 类型数据的扩展操作

下面我们来看一组string的扩展操作，分成两大块：一块是*对数字进行操作的*，第二块是*对我们的key的时间进行操作的。*

**设置数值数据:增加指定范围的值**

```bash
incr key
incrby key increment
incrbyfloat key increment
```

***举例***

```bash
127.0.0.1:6379> set num 11
OK
127.0.0.1:6379> incr num
(integer) 12
127.0.0.1:6379> incr num
(integer) 13
127.0.0.1:6379> decr num
(integer) 12
127.0.0.1:6379> get num
"12"
127.0.0.1:6379> incrby num 1000
(integer) 1012
127.0.0.1:6379> incrbyfloat num 12.59
"1024.5899999999999"
```

**设置数值数据:减少指定范围的值**

```bash
decr key
decrby key increment
```

**设置数据具有指定的生命周期**

```bash
setex key seconds value
psetex key milliseconds value
```

***举例***

```bash
127.0.0.1:6379> setex code 10 456123
OK
127.0.0.1:6379> get code
"456123"
127.0.0.1:6379> get code
"456123"
127.0.0.1:6379> get code
(nil)
```



### 2.3.2  string 类型数据操作的注意事项

(1) 数据操作不成功的反馈与数据正常操作之间的差异

表示运行结果是否成功

(integer) 0  → false                 失败

(integer) 1  → true                  成功

表示运行结果值

(integer) 3  → 3                        3个

(integer) 1  → 1                         1个

(2) 数据未获取到时，对应的数据为（nil），等同于null

(3) 数据最大存储量：512MB

(4) string在redis内部存储默认就是一个字符串，当遇到增减类操作  incr，decr  时会转成数值型进行计算

(5) 按数值进行操作的数据，如果原始数据不能转成数值，或超越了redis 数值上限范围，将报错 9223372036854775807（java中Long型数据最大值，Long.MAX_VALUE） 

(6) redis所有的操作都是原子性的，采用单线程处理所有业务，命令是一个一个执行的，因此无需考虑并发带来的数据影响

## 2.4 string 应用场景与key命名约定

### 2.4.1  应用场景

它的应用场景在于：主页高频访问信息显示控制，例如 新浪微博大V主页显示粉丝数与微博数量。

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322102813.png)

我们来思考一下：这些信息是不是你进入大V的页面儿以后就要读取这写信息的啊，那这种信息一定要存储到我们的redis中，因为他的访问量太高了！那这种数据应该怎么存呢？我们来一块儿看一下方案！

### 2.4.2  解决方案

（1）在redis中为大V用户设定用户信息，以用户主键和属性值作为key，后台设定定时刷新策略即可。

```markdown
eg:	user:id:3506728370:fans		→	12210947
eg:	user:id:3506728370:blogs	→	6164
eg:	user:id:3506728370:focuses	→	83
```

（2）也可以使用json格式保存数据

```markdown
eg:	user:id:3506728370    →	{“fans”：12210947，“blogs”：6164，“ focuses ”：83 }
```

（3） key 的设置约定

数据库中的热点数据key命名惯例

|       | **表名** | **主键名** | 主键值    | **字段名** |
| ----- | -------- | ---------- | --------- | ---------- |
| eg1： | order    | id         | 29437595  | name       |
| eg2： | equip    | id         | 390472345 | type       |
| eg3： | news     | id         | 202004150 | title      |

## 2.5  hash 的基本操作

下面我们来学习第二个数据类型hash。

### 2.5.1  数据存储的困惑

对象类数据的存储如果具有较频繁的更新需求操作会显得笨重！

在正式学习之前，我们先来看一个关于数据存储的困惑：

![](img\hash存储.png)

比如说前面我们用以上形式存了数据，如果我们用单条去存的话，它存的条数会很多。但如果我们用json格式，它存一条数据就够了。问题来了，假如说现在粉丝数量发生变化了，你要把整个值都改了。但是用单条存的话就不存在这个问题，你只需要改其中一个就行了。这个时候我们就想，有没有一种新的存储结构，能帮我们解决这个问题呢。

我们一块儿来分析一下：

![](img\数据.png)

如上图所示：单条的话是对应的数据在后面放着。仔细观察：我们看左边是不是长得都一模一样啊，都是对应的表名、ID等的一系列的东西。我们可以将右边红框中的这个区域给他封起来。

那如果要是这样的形式的话，如下图，我们把它一合并，并把右边的东西给他变成这个格式，这不就行了吗？

![](img\hash数据.png)

这个图其实大家并不陌生，第一，你前面学过一个东西叫hashmap不就这格式吗？第二，redis自身不也是这格式吗？那是什么意思呢？注意，这就是我们要讲的第二种格式，hash。

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322095731.png)

在右边对应的值，我们就存具体的值，那左边儿这就是我们的key。问题来了，那中间的这一块叫什么呢？这个东西我们给他起个名儿，叫做field字段。那么右边儿整体这块儿空间我们就称为hash，也就是说hash是存了一个key value的存储空间。

### 2.5.2  hash 类型

新的存储需求：对一系列存储的数据进行编组，方便管理，典型应用存储对象信息

需要的存储结构：一个存储空间保存多个键值对数据

hash类型：底层使用哈希表结构实现数据存储

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322102640.png)

如上图所示，这种结构叫做hash，左边一个key，对右边一个存储空间。这里要明确一点，右边这块儿存储空间叫hash，也就是说hash是指的一个数据类型，他指的不是一个数据，是这里边的一堆数据，那么它底层呢，是用hash表的结构来实现的。

值得注意的是：

如果field数量较少，存储结构优化为类数组结构

如果field数量较多，存储结构使用HashMap结构

### 2.5.3  hash 类型数据的基本操作

**添加/修改数据**

```bash
hset key field value
```

***举例***

```bash
127.0.0.1:6379> hset user:123 name tan
(integer) 1
127.0.0.1:6379> hset user:123 age 12
(integer) 1
```

**获取数据**

```bash
hget key field
hgetall key
```

*举例*

```bash
127.0.0.1:6379> hget user:123 age
"12"
127.0.0.1:6379> hgetall user:123
1) "name"
2) "tan"
3) "age"
4) "12"
//注意这里。键在1，3，5等奇数位；值在2，4等偶数位
```

**删除数据**

```bash
hdel key field1 [field2]
```

*举例*

```
127.0.0.1:6379> hdel user:123 age
(integer) 1
127.0.0.1:6379> hgetall user:123
1) "name"
2) "tan"
```



**设置field的值，如果该field存在则不做任何操作**

```bash
hsetnx key field value
```



**添加/修改多个数据**

```bash
hmset key field1 value1 field2 value2 …
```

*举例*
 ```
 127.0.0.1:6379> hmset user:123 a a1 b b1 c c1
 OK
 127.0.0.1:6379> hgetall user:123
 1) "name"
 2) "tan"
 3) "a"
 4) "a1"
 5) "b"
 6) "b1"
 7) "c"
 8) "c1"
 ```



**获取多个数据**

```bash
hmget key field1 field2 …
```

```
127.0.0.1:6379> hmget user:123 a b
1) "a1"
2) "b1"
```

   

**获取哈希表中字段的数量**

```bash
hlen key
```

```bash
127.0.0.1:6379> hlen user:123
(integer) 4
```

获取哈希表中是否存在指定的字段

```bash
hexists key field
```

## 2.6  hash 的拓展操作

在看完hash的基本操作后，我们再来看他的拓展操作，他的拓展操作相对比较简单：

### 2.6.1  hash 类型数据扩展操作

**获取哈希表中所有的字段名或字段值**

```
hkeys key
hvals key
```

```
127.0.0.1:6379> hkeys htest
1) "a"
2) "b"
127.0.0.1:6379> hvals htest
1) "213"
2) "456"
```



**设置指定字段的数值数据增加指定范围的值**

```
hincrby key field increment
hincrbyfloat key field increment
```

```bash
127.0.0.1:6379> hincrby htest a 100
(integer) 223
127.0.0.1:6379> hincrby htest a -10
(integer) 213
```



### 2.6.2  hash类型数据操作的注意事项

（1）hash类型中value只能存储字符串，不允许存储其他数据类型，不存在嵌套现象。如果数据未获取到，对应的值为（nil）。

（2）每个 hash 可以存储 232 - 1 个键值对

​		hash类型十分贴近对象的数据存储形式，并且可以灵活添加删除对象属性。但hash设计初衷不是为了存储大量对象而设计 的，切记不可滥用，更不可以将hash作为对象列表使用。

（3）hgetall 操作可以获取全部属性，如果内部field过多，遍历整体数据效率就很会低，hgetall有可能成为数据访问瓶颈。



## 2.7  hash 应用场景

### 2.7.1  应用场景

双11活动日，销售手机充值卡的商家对移动、联通、电信的30元、50元、100元商品推出抢购活动，每种商品抢购上限1000  张。

![](img\hash应用.png)

也就是商家有了，商品有了，数量有了。最终我们的用户买东西就是在改变这个数量。那你说这个结构应该怎么存呢？对应的商家的ID作为key，然后这些充值卡的ID作为field，最后这些数量作为value。而我们所谓的操作是其实就是*hincrby*这个操作，只不过你传负值就行了。看一看对应的解决方案：

### 2.7.2  解决方案

以商家id作为key

将参与抢购的商品id作为field

将参与抢购的商品数量作为对应的value

```bash
127.0.0.1:6379> hmset id:001 c30 1000 c50 1000 c100 1000
OK
127.0.0.1:6379> hgetall id:001
1) "c30"
2) "1000"
3) "c50"
4) "1000"
5) "c100"
6) "1000"
```

抢购时使用降值的方式控制产品数量

```bash
127.0.0.1:6379> hincrby id:001 c50 -2
(integer) 998
127.0.0.1:6379> hgetall id:001
1) "c30"
2) "1000"
3) "c50"
4) "998"
5) "c100"
6) "1000"
```

注意：实际业务中还有超卖等实际问题，这里不做讨论

## 2.8  list 基本操作

前面我们存数据的时候呢，单个数据也能存，多个数据也能存，但是这里面有一个问题，我们存多个数据用hash的时候它是没有顺序的。我们平时操作，实际上数据很多情况下都是有顺序的，那有没有一种能够用来存储带有顺序的这种数据模型呢，list就专门来干这事儿。

### 2.8.1  list 类型

**数据存储需求**：存储多个数据，并对数据进入存储空间的顺序进行区分

**需要的存储结构**：一个存储空间保存多个数据，且通过数据可以体现进入顺序

**list类型**：保存多个数据，**底层使用双向链表存储结构实现**

先来通过一张图，回忆一下顺序表、链表、双向链表。

![顺序表、链表、双向链表](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322111622.png)

list对应的存储结构是什么呢？里边存的这个东西是个列表，他有一个对应的名称。就是key存一个list的这样结构。对应的基本操作，你其实是可以想到的。

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322111805.png)

来看一下，因为它是双向的，所以他左边右边都能操作，它对应的操作结构两边都能进数据。这就是链表的一个存储结构。往外拿数据的时候怎么拿呢？通常是从一端拿，当然另一端也能拿。如果两端都能拿的话，**这就是个双端队列，两边儿都能操作**。如果只能从一端进一端出，这个模型咱们前面了解过，叫做栈。



### 2.8.2 list 类型数据基本操作

最后看一下他的基本操作

**添加/修改数据**

```bash
lpush key value1 [value2] ……
rpush key value1 [value2] ……
```

*举例*

```
lpush list1 zs ls ww zl
(integer) 4
```



**获取数据**

```bash
lrange key start stop
lindex key index
llen key
```

```bash
127.0.0.1:6379> lrange list1 0 3
1) "zl"
2) "ww"
3) "ls"
4) "zs"
127.0.0.1:6379> lrange list1 0 -1
1) "zl"
2) "ww"
3) "ls"
4) "zs"

127.0.0.1:6379> lindex list1 0
"zl"

127.0.0.1:6379> llen list1
(integer) 4
```



**获取并移除数据**

```bash
lpop key
rpop key
```

```
127.0.0.1:6379> lpop list1
"hehe"
```



## 2.9  list 扩展操作

### 2.9.1  list 类型数据扩展操作

**移除指定数据**

```
lrem key count value //删除count个value
```

```
127.0.0.1:6379> lpush list2 a b c d e f g
(integer) 7
127.0.0.1:6379> lrange list2 0 -1
1) "g"
2) "f"
3) "e"
4) "d"
5) "c"
6) "b"
7) "a"
127.0.0.1:6379> lrem list2 1 c //删除一个c
(integer) 1
127.0.0.1:6379> lrange list2 0 -1
1) "g"
2) "f"
3) "e"
4) "d"
5) "b"
6) "a"
```



**规定时间内获取并移除数据 **

```
blpop key1 [key2] timeout //就是等个${timeout}秒钟 如果有就删除
brpop key1 [key2] timeout
```



```bash
127.0.0.1:6379> lpush a a1
(integer) 1
127.0.0.1:6379> blpop a 10
1) "a"
2) "a1"
127.0.0.1:6379> blpop a 10
(nil)
(10.01s)
127.0.0.1:6379> lrange a  0 -1
(empty list or set)
```



### 2.9.2  list 类型数据操作注意事项

（1）list中保存的数据都是string类型的，数据总容量是有限的，最多232 - 1 个元素(4294967295)。

（2）list具有索引的概念，但是操作数据时通常以队列的形式进行入队出队操作，或以栈的形式进行入栈出栈操作

（3）获取全部数据操作结束索引设置为-1

（4）list可以对数据进行分页操作，通常第一页的信息来自于list，第2页及更多的信息通过数据库的形式加载



## 2.10 list 应用场景

### 2.10.1  应用场景

企业运营过程中，系统将产生出大量的运营数据，如何保障多台服务器操作日志的统一顺序输出？

![](img\list应用.png)

假如现在你有多台服务器，每一台服务器都会产生它的日志，假设你是一个运维人员，你想看它的操作日志，你怎么看呢？打开A机器的日志看一看，打开B机器的日志再看一看吗？这样的话你会可能会疯掉的！因为左边看的有可能它的时间是11:01，右边11:02，然后再看左边11:03，它们本身是连续的，但是你在看的时候就分成四个文件了，这个时候你看起来就会很麻烦。能不能把他们合并呢？答案是可以的！怎么做呢？

建立起redis服务器。当他们需要记日志的时候，记在哪儿,全部发给redis。等到你想看的时候，通过服务器访问redis获取日志。然后得到以后，就会得到一个完整的日志信息。那么这里面就可以获取到完整的日志了，依靠什么来实现呢？就依靠我们的list的模型的顺序来实现。进来一组数据就往里加，谁先进来谁先加进去，它是有一定的顺序的。

### 2.10.2  解决方案

* 依赖list的数据具有顺序的特征对信息进行管理

* 使用队列模型解决多路信息汇总合并的问题

* 使用栈模型解决最新消息的问题

```bash
127.0.0.1:6379> rpush logs a:out
(integer) 1
127.0.0.1:6379> rpush logs b:out
(integer) 2
127.0.0.1:6379> rpush logs a:print
(integer) 3
127.0.0.1:6379> rpush logs c:in
(integer) 4
127.0.0.1:6379> lrange logs 0 -1
1) "a:out"
2) "b:out"
3) "a:print"
4) "c:in"
```



## 2.11  set 基本操作

### 2.11.1 set类型

新的存储需求：存储大量的数据，在查询方面提供更高的效率

需要的存储结构：能够保存大量的数据，高效的内部存储机制，便于查询

set类型：与hash存储结构完全相同，仅存储键，不存储值（nil），并且值是不允许重复的

![](img\set模型.png)

通过这个名称，大家也基本上能够认识到和我们Java中的set完全一样。我们现在要存储大量的数据，并且要求提高它的查询效率。用list这种链表形式，它的查询效率是不高的，那怎么办呢？这时候我们就想，有没有高效的存储机制。其实前面咱讲Java的时候说过hash表的结构就非常的好，但是这里边我们已经有hash了，他做了这么一个设定，干嘛呢，他把hash的存储空间给改一下，右边你原来存数据改掉,全部存空，那你说数据放哪儿了？放到原来的filed的位置，也就在这里边存真正的值，那么这个模型就是我们的set 模型。

==**set类型**：与hash存储结构完全相同，仅存储键，不存储值（nil），并且值是不允许重复的。==

看一下它的整个结构：

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322164902.png)

### 2.11.2 set类型数据的基本操作

**添加数据**

```bash
sadd key member1 [member2]
```

**获取全部数据**

```bash
smembers key
```

```bash
127.0.0.1:6379> sadd set1 a
(integer) 1
127.0.0.1:6379> sadd set1 b
(integer) 1
127.0.0.1:6379> sadd set1 a
(integer) 0

127.0.0.1:6379> smembers set1 //加了两个a一个b但是查出来a、b（其实就是set集合的特点 无重复无序）
1) "b"
2) "a"
```



**删除数据**

```bash
srem key member1 [member2]
```

```powershell
127.0.0.1:6379> smembers set1
1) "c"
2) "a"
3) "b"
4) "d"
5) "w"
127.0.0.1:6379> srem set1 a
(integer) 1
127.0.0.1:6379> smembers set1
1) "d"
2) "c"
3) "w"
4) "b"
```



**获取集合数据总量**

```bash
scard key
```

```powershell
127.0.0.1:6379> scard set1
(integer) 1
```



**判断集合中是否包含指定数据**

```bash
sismember key member
```

```powershell
127.0.0.1:6379> sismember set1 c
(integer) 0
127.0.0.1:6379> sismember set1 a
(integer) 0
127.0.0.1:6379> sismember set1 b
(integer) 1
```



**随机获取集合中指定数量的数据**

```bash
srandmember key [count]
```

```powershell
127.0.0.1:6379> srandmember set1 3
1) "b"
2) "w"
3) "d"
```



**随机获取集中的某个数据并将该数据移除集合**

```bash
spop key [count]
```

## 2.12  set 类型数据的扩展操作

### 2.12.1  set 类型数据的扩展操作

**求两个集合的交、并、差集**

```
sinter key1 [key2 …]  
sunion key1 [key2 …]  
sdiff key1 [key2 …]
```

![image-20230322194131558](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322194134.png)

```powershell
127.0.0.1:6379> sinter set1 set2
1) "d"
2) "c"
127.0.0.1:6379> sunion set1 set2
1) "c"
2) "w"
3) "a"
4) "z"
5) "b"
6) "y"
7) "x"
8) "d"
127.0.0.1:6379> sdiff set1 set2
1) "b"
2) "w"
```



**求两个集合的交、并、差集并存储到指定集合中**

```
sinterstore destination key1 [key2 …]  
sunionstore destination key1 [key2 …]  
sdiffstore destination key1 [key2 …]
```

**将指定数据从原始集合中移动到目标集合中**

```
smove source destination member
```

通过下面一张图回忆一下交、并、差

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322193235.png)

### 2.12.2  set 类型数据操作的注意事项

* set 类型不允许数据重复，如果添加的数据在 set 中已经存在，将只保留一份。

* set 虽然与hash的存储结构相同，但是无法启用hash中存储值的空间。



## 2.13  set 应用场景

### 2.13.1  set应用场景

#### （1）黑名单

* 资讯类信息类网站追求高访问量，但是由于其信息的价值，往往容易被不法分子利用，通过爬虫技术，快速获取信息，个别特种行业网站信息通过爬虫获取分析后，可以转换成商业机密进行出售。例如第三方火车票、机票、酒店刷票代购软件，电商刷评论、刷好评。

* 同时爬虫带来的伪流量也会给经营者带来错觉，产生错误的决策，有效避免网站被爬虫反复爬取成为每个网站都要考虑的基本问题。在基于技术层面区分出爬虫用户后，需要将此类用户进行有效的屏蔽，这就是黑名单的典型应用。

**ps:** 不是说爬虫一定做摧毁性的工作，有些小型网站需要爬虫为其带来一些流量。

#### （2）白名单

* 对于安全性更高的应用访问，仅仅靠黑名单是不能解决安全问题的，此时需要设定可访问的用户群体，依赖白名单做更为苛刻的访问验证。

### 2.13.2  解决方案

* 基于经营战略设定问题用户发现、鉴别规则

* 周期性更新满足规则的用户黑名单，加入set集合

* 用户行为信息达到后与黑名单进行比对，确认行为去向

黑名单过滤IP地址：应用于开放游客访问权限的信息源

黑名单过滤设备信息：应用于限定访问设备的信息源

黑名单过滤用户：应用于基于访问权限的信息源

## 2.14  实践案例

### 2.14.1 业务场景

使用微信的过程中，当微信接收消息后，会默认将最近接收的消息置顶，当多个好友及关注的订阅号同时发送消息时，该排序会不停的进行交替。同时还可以将重要的会话设置为置顶。一旦用户离线后，再次打开微信时，消息该按照什么样的顺序显示。

我们分析一下：

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322194539.png)

100这台手机代表你。而200、300、400这三台代表你好友的手机。在这里有一些东西需要交代一下，因为我们每个人的都会对自己的微信中的一些比较重要的人设置会话置顶，将他的那条对话放在最上面。我们假定这个人有两个会话置顶的好友，分别是400和500，而这里边就包含400.

下面呢，我们就来发这个消息，第一个发消息的是300，他发了个消息给100。发完以后，这个东西应该怎么存储呢？在这里面一定要分开，记录置顶的这些人的会话，对应的会话显示顺序和非置顶的一定要分两。

这里面我们创建两个模型，一个是普通的，一个是置顶的，而上面的这个置顶的用户呢，我们用set来存储，因为不重复。而下面这些因为有顺序，很容易想到用list去存储,不然你怎么表达顺序呢？

![](img\300.png)

那当300发给消息给100以后，这个时候我们先判定你在置顶人群中吗？不在,那好，300的消息对应的顺序就应该放在普通的列表里边。而在这里边，我们把300加进去。第一个数据也就是现在300。

![](img\400.png)

接下来400，发了个消息。判断一下，他是需要置顶的，所以400将进入list的置顶里边放着。当前还没有特殊的地方。

![](img\200.png)

再来200发消息了，和刚才的判定方法一样，先看在不在置顶里，不在的话进普通，然后在普通里边把200加入就行了，OK，到这里目前还没有顺序变化。

接下来200又发消息过来，同一个人给你连发了两条，那这个时候200的消息到达以后，先判断是否在置顶范围，不在，接下来他要放在list普通中，这里你要注意一点，因为这里边已经有200，所以进来以后先干一件事儿，把200杀掉，没有200，然后再把200加进来，那你想一下，现在这个位置顺序是什么呢？就是新的都在右边，对不对？

还记得我们说list模型，如果是一个双端队列，它是可以两头进两头出。当然我们双端从一头进一头出，这就是栈模型，现在咱们运用的就是list模型中的栈模型。

![](img\3002.png)

现在300发消息，先判定他在不在，不在，用普通的队列，接下来按照刚才的操作，不管你里边原来有没有300，我先把300杀掉，没了，200自然就填到300的位置了，他现在是list里面唯一一个，然后让300进来，注意是从右侧进来的，那么现在300就是最新的。

![](img\分析.png)

那么到这里呢，我们让100来读取消息。你觉得这个消息顺序应该是什么样的？首先置顶的400有一个，他跑在最上面，然后list普通如果出来的话，300是最新的消息，而200在他后面的。用这种形式，我们就可以做出来他的消息顺序来。

### 2.14.2  解决方案

看一下最终的解决方案：

依赖list的数据具有顺序的特征对消息进行管理，将list结构作为栈使用

置顶与普通会话分别创建独立的list分别管理

当某个list中接收到用户消息后，将消息发送方的id从list的一侧加入list（此处设定左侧）

多个相同id发出的消息反复入栈会出现问题，在入栈之前无论是否具有当前id对应的消息，先删除对应id

推送消息时先推送置顶会话list，再推送普通会话list，推送完成的list清除所有数据
消息的数量，也就是微信用户对话数量采用计数器的思想另行记录，伴随list操作同步更新





### 2.14.4  数据类型总结

总结一下，在整个数据类型的部分，我们主要介绍了哪些内容：

首先我们了解了一下数据类型，接下来针对着我们要学习的数据类型，进行逐一讲解了string、hash、list、set等，最后通过一个案例总结了一下前面的数据类型的使用场景。





# 3 常用指令

在这部分中呢，我们学习两个知识，第一个是key的常用指令，第二个是数据库的常用指令。和前面我们学数据类型做一下区分，前面你学的那些指令呢，都是针对某一个数据类型操作的，现在学的都是对所有的操作的，来看一下，我们在学习Key的操作的时候，我们先想一下的操作我们应该学哪些东西:

## 3.1  key 操作分析

### 3.1.1  key 应该设计哪些操作？

key是一个字符串，通过key获取redis中保存的数据

对于key自身状态的相关操作，例如：删除，判定存在，获取类型等

对于key有效性控制相关操作，例如：有效期设定，判定是否有效，有效状态的切换等

对于key快速查询操作，例如：按指定策略查询key

### 3.1.2  key 基本操作

**删除指定key**

```bash
del key
```

```
127.0.0.1:6379> del name
(integer) 1
```



**获取key是否存在**

```bash
exists key
```

```powershell
127.0.0.1:6379> exists name
(integer) 1
127.0.0.1:6379> exists jjj
(integer) 0
```



**获取key的类型**

```bash
type key
```

```
127.0.0.1:6379> type name
string
```



**排序**

```bash
sort
```

```powershell
127.0.0.1:6379> sort list2 alpha
1) "a"
2) "b"
3) "d"
4) "e"
5) "f"
6) "g"
```



**改名**

```powershell
rename key newkey
renamenx key newkey
```

### 3.1.3  key 扩展操作（时效性控制）

**为指定key设置有效期**

```bash
expire key seconds
pexpire key milliseconds
expireat key timestamp
pexpireat key milliseconds-timestamp
```

```powershell
127.0.0.1:6379> expire expire:test 20
(integer) 1
127.0.0.1:6379> ttl expire:test
(integer) 11
127.0.0.1:6379> ttl expire:test
(integer) 2
127.0.0.1:6379> ttl expire:test
(integer) -2
```



**获取key的有效时间**

```bash
ttl key //-1 指永久 -2 指这个键不存在
pttl key
```

```powershell
127.0.0.1:6379> ttl expire:test
(integer) -1
127.0.0.1:6379> ttl b2
(integer) -2
127.0.0.1:6379> setex cc 100 123
OK
127.0.0.1:6379> ttl cc
(integer) 96
127.0.0.1:6379> pttl cc
(integer) 78931
```



**切换key从时效性转换为永久性**

```bash
persist key
```

### 3.1.4  key 扩展操作（查询模式）

**查询key**

```bash
keys pattern
```

**查询模式规则**

  \* 匹配任意数量的任意符号     

  ? 配合一个任意符号	

  [] 匹配一个指定符号

```bash
keys *   		查询所有
keys it*     	查询所有以it开头
keys *heima    	查询所有以heima结尾
keys ??heima    查询所有前面两个字符任意，后面以heima结尾 查询所有以
keys user:?     user:开头，最后一个字符任意
keys u[st]er:1  查询所有以u开头，以er:1结尾，中间包含一个字母，s或t
```





## 3.2  数据库指令

### 3.2.1  key 的重复问题

在这个地方我们来讲一下数据库的常用指令，在讲这个东西之前，我们先思考一个问题：

假如说你们十个人同时操作redis，会不会出现key名字命名冲突的问题。

一定会，为什么?

因为你的key是由程序而定义的。你想写什么写什么，那在使用的过程中大家都在不停的加，早晚有一天他会冲突的。

redis在使用过程中，伴随着操作数据量的增加，会出现大量的数据以及对应的key。

那这个问题我们要不要解决？要！怎么解决呢？我们最好把数据进行一个分类，除了命名规范我们做统一以外，如果还能把它分开，这样是不是冲突的机率就会小一些了，这就是咱们下面要说的解决方案！

### 3.2.2  解决方案

==redis为每个服务提供有16个数据库，编号从0到15==

每个数据库之间的数据相互独立

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322204945.png)

![image-20230322205031484](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322205034.png)

在对应的数据库中划出一块区域，说他就是几，你就用 “几” 那块，同时，其他的这些都可以进行定义，一共是16个，这里边需要注意一点，他们这16个共用redis的内存。没有说谁大谁小，也就是说数字只是代表了一块儿区域，区域具体多大未知。这是数据库的一个分区的一个策略！

### 3.2.3   数据库的基本操作

**切换数据库**

```
select index
```

**其他操作**

```
ping
```

### 3.2.4  数据库扩展操作

**数据移动**

```
move key db
```

```
127.0.0.1:6379[1]> move name 0
(integer) 1
```



**数据总量**

```
dbsize
```

```powershell
127.0.0.1:6379> dbsize
(integer) 0
```



**数据清除**

```
flushdb  
flushall
```

```powershell
127.0.0.1:6379> flushall
OK
```



# 4 Jedis

在学习完redis后，我们现在就要用Java来连接redis了，也就是我们的这一章要学的Jedis了。在这个部分，我们主要讲解以下3个内容：

HelloWorld（Jedis版）

Jedis简易工具类开发

可视化客户端

## 4.1  Jedis简介

### 4.1.1  编程语言与redis

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322210129.png)

对于我们现在的数据来说，它是在我们的redis中，而最终我们是要做程序。那么程序就要和我们的redis进行连接。干什么事情呢？两件事：程序中有数据的时候，我们要把这些数据全部交给redis管理。同时，redis中的数据还能取出来，回到我们的应用程序中。那在这个过程中，在Java与redis之间打交道的这个东西就叫做Jedis.简单说，Jedis就是提供了Java与redis的连接服务的，里边有各种各样的API接口，你可以去调用它。

除了Jedis外，还有没有其他的这种连接服务呢？其实还有很多，了解一下：

Java语言连接redis服务 Jedis（SpringData、Redis 、 Lettuce）

其它语言：C 、C++ 、C# 、Erlang、Lua 、Objective-C 、Perl 、PHP 、Python 、Ruby 、Scala

### 4.1.2  准备工作

#### (1) 导依赖

下载地址：https://mvnrepository.com/artifact/redis.clients/jedis

```xml
<dependency>
<groupId>redis.clients</groupId>
<artifactId>jedis</artifactId>
<version>2.9.0</version>
</dependency>
```

#### (2) 客户端连接redis

连接redis

```java
Jedis jedis = new Jedis("localhost", 6379);
```

操作redis

```java
jedis.set("name", "itheima");  
jedis.get("name");
```

关闭redis连接

```java
jedis.close();
```



### 4.1.3 代码实现

创建：com.itheima.JedisTest

```java
@Test
public void testJedis() {

    Jedis jedis  = new Jedis("127.0.0.1",6379);

    //jedis.set("name","tsh");

    //String hello = jedis.get("hello");
    //log.info(hello);

    //jedis.lpush("list01","1","2","3");

    List<String> list = jedis.lrange("list01", 0, -1);
    for (String s : list) {
        log.info(s);
    }

    jedis.sadd("set1","abc","add","tjdf");
    log.info("set1的长度为：" + jedis.scard("set1"));

    jedis.close();
}
```



## 4.2  Jedis简易工具类开发

前面我们做的程序还是有点儿小问题，就是我们的Jedis对象的管理是我们自己创建的，真实企业开发中是不可能让你去new一个的，那接下来咱们就要做一个工具类，简单来说，就是做一个创建Jedis的这样的一个工具。



### 4.2.1  基于连接池获取连接

**JedisPool**：	Jedis提供的连接池技术 

**poolConfig**: 	连接池配置对象 

**host**:				redis服务地址

**port**:				redis服务端口号



用到的JedisPool的构造器如下：

```java
public JedisPool(GenericObjectPoolConfig poolConfig, String host, int port) {
this(poolConfig, host, port, 2000, (String)null, 0, (String)null);
}
```

### 4.2.2  封装连接参数

创建jedis的配置文件：jedis.properties

```properties
jedis.host=127.0.0.1  
jedis.port=6379  
jedis.maxTotal=50  
jedis.maxIdle=10
```

### 4.2.3  加载配置信息

 创建JedisUtils：com.itheima.util.JedisUtils，使用静态代码块初始化资源

```java
public class JedisUtils {
    private static int maxTotal;
    private static int maxIdel;
    private static String host;
    private static int port;
    private static JedisPoolConfig jpc;
    private static JedisPool jp;

    static {
        //加载配置文件
        ResourceBundle bundle = ResourceBundle.getBundle("redis");
        maxTotal = Integer.parseInt(bundle.getString("redis.maxTotal"));
        maxIdel = Integer.parseInt(bundle.getString("redis.maxIdel"));
        host = bundle.getString("redis.host");
        port = Integer.parseInt(bundle.getString("redis.port"));
        
        //Jedis连接池配置
        jpc = new JedisPoolConfig();
        jpc.setMaxTotal(maxTotal);
        jpc.setMaxIdle(maxIdel);
        jp = new JedisPool(jpc,host,port);
    }

}
```

### 4.2.4  获取连接

 对外访问接口，提供jedis连接对象，连接从连接池获取，在JedisUtils中添加一个获取jedis的方法：getJedis

```java
public static Jedis getJedis(){
	return jp.getResource();
}
```



# 5 持久化

下面呢，进入到持久化的学习。这部分内容理解的东西多，操作的东西少。在这个部分，我们将讲解四个东西：

* 持久化简介

* RDB

* AOF

* RDB与AOF区别



## 5.1  持久化简介

### 5.1.1  场景-意外断电

不知道大家有没有遇见过，就是正工作的时候停电了，如果你用的是笔记本电脑还好，你有电池，但如果你用的是台式机呢，那恐怕就比较灾难了，假如你现在正在写一个比较重要的文档，如果你要使用的是word，这种办公自动化软件的话，他一旦遇到停电，其实你不用担心，因为它会给你生成一些其他的文件。

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322214747.png)

其实他们都在做一件事儿，帮你自动恢复，有了这个文件，你前面的东西就不再丢了。那什么是自动恢复呢？你要先了解他的整个过程。

我们说自动恢复，其实基于的一个前提就是他提前把你的数据给存起来了。你平常操作的所有信息都是在内存中的，而我们真正的信息是保存在硬盘中的，内存中的信息断电以后就消失了，硬盘中的信息断电以后还可以保留下来！

![](img\备份.png)

我们将文件由内存中保存到硬盘中的这个过程，我们叫做数据保存，也就叫做持久化。但是把它保存下来不是你的目的，最终你还要把它再读取出来，它加载到内存中这个过程，我们叫做数据恢复，这就是我们所说的word为什么断电以后还能够给你保留文件，因为它执行了一个自动备份的过程，也就是通过自动的形式，把你的数据存储起来，那么有了这种形式以后，我们的数据就可以由内存到硬盘上实现保存。

### 5.1.2  什么是持久化

(1) 什么是持久化

利用永久性存储介质将数据进行保存，在特定的时间将保存的数据进行恢复的工作机制称为持久化 。

持久化用于防止数据的意外丢失，确保数据安全性。

(2) 持久化过程保存什么？

我们知道一点，计算机中的数据全部都是二进制，如果现在我要你给我保存一组数据的话，你有什么样的方式呢，其实最简单的就是现在长什么样，我就记下来就行了，那么这种是记录纯粹的数据，也叫做快照存储，也就是它保存的是某一时刻的数据状态。

还有一种形式，它不记录你的数据，它记录你所有的操作过程，比如说大家用idea的时候，有没有遇到过写错了ctrl+z撤销，然后ctrl+y还能恢复，这个地方它也是在记录，但是记录的是你所有的操作过程，那我想问一下，操作过程，我都给你留下来了，你说数据还会丢吗？肯定不会丢，因为你所有的操作过程我都保存了。这种保存操作过程的存储，用专业术语来说可以说是日志，这是两种不同的保存数据的形式啊。

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322215221.png)



**总结：**

第一种：将当前数据状态进行保存，快照形式，存储数据结果，存储格式简单，关注点在数据。

第二种：将数据的操作过程进行保存，日志形式，存储操作过程，存储格式复杂，关注点在数据的操作过程。



## 5.2  RDB

### 5.2.1  save指令

手动执行一次保存操作

```
save
```



**save指令配置文件中相关配置**

设置本地数据库文件名，默认值为 dump.rdb，通常设置为dump-端口号.rdb

```
dbfilename filename
```

设置存储.rdb文件的路径，通常设置成存储空间较大的目录中，目录名称data

```
dir path
```

设置存储至本地数据库时是否压缩数据，默认yes，设置为no，节省 CPU 运行时间，但存储文件变大

```
rdbcompression yes|no
```

设置读写文件过程是否进行RDB格式校验，默认yes，设置为no，节约读写10%时间消耗，单存在数据损坏的风险

```
rdbchecksum yes|no
```



**save指令工作原理**

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322223237.png)

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322223242.png)

需要注意一个问题，来看一下，现在有四个客户端各自要执行一个指令，把这些指令发送到redis服务器后，他们执行有一个先后顺序问题，假定就是按照1234的顺序放过去的话，那会是什么样的？

记得redis是个单线程的工作模式，它会创建一个任务队列，所有的命令都会进到这个队列里边，在这儿排队执行，执行完一个消失一个，当所有的命令都执行完了，OK，结果达到了。

但是如果现在我们执行的时候save指令保存的数据量很大会是什么现象呢？

他会非常耗时，以至于影响到它在执行的时候，后面的指令都要等，所以说这种模式是不友好的，这是save指令对应的一个问题，当cpu执行的时候会阻塞redis服务器，直到他执行完毕，==所以说我们不建议大家在线上环境用save指令。==

### 5.2.2  bgsave指令***

之前我们讲到了当save指令的数据量过大时，单线程执行方式造成效率过低，那应该如何处理？

此时我们可以使用：**bgsave**指令，bg其实是background的意思，后台执行的意思

手动启动后台保存操作，但不是立即执行

```
bgsave
```



**bgsave指令相关配置**

后台存储过程中如果出现错误现象，是否停止保存操作，默认yes

```
stop-writes-on-bgsave-error yes|no
```

其他

```
dbfilename filename  
dir path  
rdbcompression yes|no  
rdbchecksum yes|no
```

**bgsave指令工作原理**

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322223449.png)

当执行bgsave的时候，客户端发出bgsave指令给到redis服务器。注意，这个时候服务器马上回一个结果告诉客户端后台已经开始了，与此同时它会创建一个子进程，使用Linux的fork函数创建一个子进程，让这个子进程去执行save相关的操作，此时我们可以想一下，我们主进程一直在处理指令，而子进程在执行后台的保存，它会不会干扰到主进程的执行吗？

答案是不会，所以说**bgsave才是主流方案**。子进程开始执行之后，它就会创建RDB文件把它存起来，操作完以后他会把这个结果返回，也就是说bgsave的过程分成两个过程，第一个是服务端拿到指令直接告诉客户端开始执行了；另外一个过程是一个子进程在完成后台的保存操作，操作完以后回一个消息。

### 5.2.3 save配置自动执行

设置自动持久化的条件，满足限定时间范围内key的变化数量达到指定数量即进行持久化

```properties
save second changes
```

***参数***

second：监控时间范围

changes：监控key的变化量

***范例：***

```properties
save 900 1
save 300 10
save 60 10000
```

***其他相关配置：***

```properties
dbfilename filename
dir path
rdbcompression yes|no
rdbchecksum yes|no
stop-writes-on-bgsave-error yes|no
```



**save配置工作原理**

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322223716.png)

### 5.2.4 RDB三种启动方式对比

| 方式           | save指令 | bgsave指令 |
| -------------- | -------- | ---------- |
| 读写           | 同步     | 异步       |
| 阻塞客户端指令 | 是       | 否         |
| 额外内存消耗   | 否       | 是         |
| 启动新进程     | 否       | 是         |

**RDB特殊启动形式**

服务器运行过程中重启

```bash
debug reload
```

关闭服务器时指定保存数据

```bash
shutdown save
```

全量复制（在主从复制中详细讲解）



**RDB优点：**

- RDB是一个紧凑压缩的二进制文件，存储效率较高
- RDB内部存储的是redis在某个时间点的数据快照，非常适合用于数据备份，全量复制等场景
- RDB恢复数据的速度要比AOF快很多
- 应用：服务器中每X小时执行bgsave备份，并将RDB文件拷贝到远程机器中，用于灾难恢复。

**RDB缺点**

- RDB方式无论是执行指令还是利用配置，无法做到实时持久化，具有较大的可能性丢失数据
- bgsave指令每次运行要执行fork操作创建子进程，要牺牲掉一些性能
- Redis的众多版本中未进行RDB文件格式的版本统一，有可能出现各版本服务之间数据格式无法兼容现象



## 5.3  AOF

为什么要有AOF,这得从RDB的存储的弊端说起：

- 存储数据量较大，效率较低，基于快照思想，每次读写都是全部数据，当数据量巨大时，效率非常低
- 大数据量下的IO性能较低
- 基于fork创建子进程，内存产生额外消耗
- 宕机带来的数据丢失风险



那解决的思路是什么呢？

- 不写全数据，仅记录部分数据
- 降低区分数据是否改变的难度，改记录数据为记录操作过程
- 对所有操作均进行记录，排除丢失数据的风险



### 5.3.1 AOF概念

**AOF**(append only file) **持久化**：以独立日志的方式记录每次写命令，重启时再重新执行AOF文件中命令 达到恢复数据的目的。**与RDB相比可以简单理解为由记录数据改为记录数据产生的变化**

AOF的主要作用是解决了数据持久化的实时性，==目前已经是Redis持久化的主流方式==

**AOF写数据过程**

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230322225020.png)

**启动AOF相关配置**

开启AOF持久化功能，默认no，即不开启状态

```properties
appendonly yes|no
```

AOF持久化文件名，默认文件名为appendonly.aof，建议配置为appendonly-端口号.aof

```properties
appendfilename filename
```

AOF持久化文件保存路径，与RDB持久化文件保持一致即可

```properties
dir
```

AOF写数据策略，默认为everysec

```properties
appendfsync always|everysec|no
```



### 5.3.2 AOF执行策略

**AOF写数据三种策略(appendfsync)**

- **always**(每次）：每次写入操作均同步到AOF文件中数据零误差，性能较低，不建议使用。


- **everysec**（每秒）：每秒将缓冲区中的指令同步到AOF文件中，在系统突然宕机的情况下丢失1秒内的数据 数据准确性较高，性能较高，==建议使用，也是默认配置==


- **no**（系统控制）：由操作系统控制每次同步到AOF文件的周期，整体过程不可控



### 5.3.3 AOF重写

***场景：***AOF写数据遇到的问题，如果连续执行如下指令该如何处理

![](./img/2.png)

**什么叫AOF重写？**

随着命令不断写入AOF，文件会越来越大，为了解决这个问题，Redis引入了AOF重写机制压缩文件体积。AOF文件重写是将Redis进程内的数据转化为写命令同步到新AOF文件的过程。简单说就是将对同一个数据的若干个条命令执行结果转化成最终结果数据对应的指令进行记录。

**AOF重写作用**

- 降低磁盘占用量，提高磁盘利用率
- 提高持久化效率，降低持久化写时间，提高IO性能
- 降低数据恢复用时，提高数据恢复效率

**AOF重写规则**

- 进程内具有时效性的数据，并且数据已超时将不再写入文件


- 非写入类的无效指令将被忽略，只保留最终数据的写入命令

  - 如del key1、 hdel key2、srem key3、set key4 111、set key4 222等

  - 如select指令虽然不更改数据，但是更改了数据的存储位置，此类命令同样需要记录

- 对同一数据的多条写命令合并为一条命令

  - 如lpushlist1 a、lpush list1 b、lpush list1 c可以转化为：lpush list1 a b c。
  - 为防止数据量过大造成客户端缓冲区溢出，对list、set、hash、zset等类型，每条指令最多写入64个元素




**AOF重写方式**

- **手动重写**

```powershell
bgrewriteaof
```

**手动重写原理分析：**

![](./img/3.png)



- **自动重写**

```properties
auto-aof-rewrite-min-size size
auto-aof-rewrite-percentage percentage
```

自动重写触发条件设置

```properties
auto-aof-rewrite-min-size size
auto-aof-rewrite-percentage percent
```

自动重写触发比对参数（ 运行指令info Persistence获取具体信息 ）

```properties
aof_current_size  
aof_base_size
```

 自动重写触发条件公式：

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230323012516.png)





### 5.3.4 AOF工作流程及重写流程

![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230323012533.png)



![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230323012618.png)



![](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230323012651.png)





## 5.4  RDB与AOF区别

### 5.4.1 RDB与AOF对比（优缺点）

| 持久化方式   | RDB                | AOF                |
| ------------ | ------------------ | ------------------ |
| 占用存储空间 | 小（数据级：压缩） | 大（指令级：重写） |
| 存储速度     | 慢                 | 快                 |
| 恢复速度     | 快                 | 慢                 |
| 数据安全性   | 会丢失数据         | 依据策略决定       |
| 资源消耗     | 高/重量级          | 低/轻量级          |
| 启动优先级   | 低                 | 高                 |

### 5.4.2 RDB与AOF应用场景

RDB与AOF的选择之惑

- 对数据非常敏感，建议使用默认的AOF持久化方案

AOF持久化策略使用everysecond，每秒钟fsync一次。该策略redis仍可以保持很好的处理性能，当出现问题时，最多丢失0-1秒内的数据。

注意：由于AOF文件存储体积较大，且恢复速度较慢

- 数据呈现阶段有效性，建议使用RDB持久化方案

数据可以良好的做到阶段内无丢失（该阶段是开发者或运维人员手工维护的），且恢复速度较快，阶段 点数据恢复通常采用RDB方案

注意：利用RDB实现紧凑的数据持久化会使Redis降的很低，慎重



**综合比对**

- RDB与AOF的选择实际上是在做一种权衡，每种都有利有弊
- 如不能承受数分钟以内的数据丢失，对业务数据非常敏感，选用AOF
- 如能承受数分钟以内的数据丢失，且追求大数据集的恢复速度，选用RDB
- 灾难恢复选用RDB
- 双保险策略，同时开启 RDB和 AOF，重启后，Redis优先使用 AOF 来恢复数据，降低丢失数据的量



# 6 Redis在SpringBoot项目中的应用

## 6.0 项目背景

* 是我跟着枫哥做的一个入门的项目。内容是一个个人博客。
* 其中博客中各个page的浏览量是一个经常变动的数据。考虑针对浏览量采用redis+mysql配合处理的方式。

## 6.1 准备工作

### 6.1.1 RedisConfig类

* 配置redisTemplate
* 设置序列化方式
* 设置支持事务

```java
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.cache.RedisCacheWriter;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.*;


@Configuration
@EnableCaching
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {

        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();

        redisTemplate.setConnectionFactory(redisConnectionFactory);

        //创建一个json的序列化对象
        GenericJackson2JsonRedisSerializer jackson2JsonRedisSerializer = new GenericJackson2JsonRedisSerializer();
        //设置key序列化方式String
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        //设置value的序列化方式json
        redisTemplate.setValueSerializer(jackson2JsonRedisSerializer);
        //设置hash key序列化方式String
        redisTemplate.setHashKeySerializer(new StringRedisSerializer());
        //设置hash value序列化json
        redisTemplate.setHashValueSerializer(jackson2JsonRedisSerializer);

        // 设置支持事务
        redisTemplate.setEnableTransactionSupport(true);
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory){
        RedisCacheConfiguration redisCacheConfiguration = RedisCacheConfiguration.defaultCacheConfig();
        return RedisCacheManager
                .builder(RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory))
                .cacheDefaults(redisCacheConfiguration)
                .build();
    }

    @Bean
    public RedisSerializer<Object> redisSerializer() {
        //创建JSON序列化器
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        //必须设置，否则无法将JSON转化为对象，会转化成Map类型
        objectMapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
        return new GenericJackson2JsonRedisSerializer(objectMapper);
    }


}
```



### 6.1.2 人性化封装RedisCache类

* 相较于原生redisTemplate 更加易用
* 其实还可以包装出更多的

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundSetOperations;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.TimeUnit;

@SuppressWarnings(value = {"unchecked", "rawtypes"})
@Component
public class RedisCache {

    @Autowired
    public RedisTemplate redisTemplate;

    /**
     * 缓存基本的对象，Integer、String、实体类等
     * @param key   缓存的键值
     * @param value 缓存的值
     */
    public <T> void setCacheObject(final String key, final T value) {
        redisTemplate.opsForValue().set(key, value);
    }

    /**
     * 缓存基本的对象，Integer、String、实体类等
     * @param key      缓存的键值
     * @param value    缓存的值
     * @param timeout  时间
     * @param timeUnit 时间颗粒度
     */
    public <T> void setCacheObject(final String key, final T value, final Integer timeout, final TimeUnit timeUnit) {
        redisTemplate.opsForValue().set(key, value, timeout, timeUnit);
    }

    /**
     * 设置有效时间
     * @param key     Redis键
     * @param timeout 超时时间
     * @return true=设置成功；false=设置失败
     */
    public boolean expire(final String key, final long timeout) {
        return expire(key, timeout, TimeUnit.SECONDS);
    }

    /**
     * 设置有效时间
     * @param key     Redis键
     * @param timeout 超时时间
     * @param unit    时间单位
     * @return true=设置成功；false=设置失败
     */
    public boolean expire(final String key, final long timeout, final TimeUnit unit) {
        return redisTemplate.expire(key, timeout, unit);
    }

    /**
     * 获得缓存的基本对象。
     * @param key 缓存键值
     * @return 缓存键值对应的数据
     */
    public <T> T getCacheObject(final String key) {
        ValueOperations<String, T> operation = redisTemplate.opsForValue();
        return operation.get(key);
    }

    /**
     * 删除单个对象
     * @param key 缓存的键值
     */
    public boolean deleteObject(final String key) {
        return redisTemplate.delete(key);
    }

    /**
     * 删除集合对象
     * @param collection 多个对象
     * @return
     */
    public long deleteObject(final Collection collection) {
        return redisTemplate.delete(collection);
    }

    /**
     * 缓存List数据
     * @param key      缓存的键值
     * @param dataList 待缓存的List数据
     * @return 缓存的对象
     */
    public <T> long setCacheList(final String key, final List<T> dataList) {
        Long count = redisTemplate.opsForList().rightPushAll(key, dataList);
        return count == null ? 0 : count;
    }

    /**
     * 获得缓存的list对象
     * @param key 缓存的键值
     * @return 缓存键值对应的数据
     */
    public <T> List<T> getCacheList(final String key) {
        return redisTemplate.opsForList().range(key, 0, -1);
    }

    /**
     * 缓存Set
     * @param key     缓存键值
     * @param dataSet 缓存的数据
     * @return 缓存数据的对象
     */
    public <T> BoundSetOperations<String, T> setCacheSet(final String key, final Set<T> dataSet) {
        BoundSetOperations<String, T> setOperation = redisTemplate.boundSetOps(key);
        Iterator<T> it = dataSet.iterator();
        while (it.hasNext()) {
            setOperation.add(it.next());
        }
        return setOperation;
    }

    /**
     * 获得缓存的set
     * @param key redis键
     * @return
     */
    public <T> Set<T> getCacheSet(final String key) {
        return redisTemplate.opsForSet().members(key);
    }

    /**
     * 缓存Map
     * @param key redis键
     * @param dataMap map
     */
    public <T> void setCacheMap(final String key, final Map<String, T> dataMap) {
        if (dataMap != null) {
            redisTemplate.opsForHash().putAll(key, dataMap);
        }
    }

    /**
     * 获得缓存的Map
     * @param key redis键
     * @return
     */
    public <T> Map<String, T> hashGetCacheMap(final String key) {
        return redisTemplate.opsForHash().entries(key);
    }

    /**
     * 往Hash中存入数据
     * @param key   Redis键
     * @param field Hash键
     * @param value 值
     */
    public <T> void  hashSetValue(final String key, final String field, final T value) {
        redisTemplate.opsForHash().put(key, field, value);
    }

    /**
     * Hash类型数据 指定field增加valueIncrement
     * @param key               redis键
     * @param field             hash键
     * @param valueIncrement    增值
     * @return
     */
    public Long hashIncrement(String key,String field,Long valueIncrement){
        return redisTemplate.opsForHash().increment(key,field,valueIncrement);
    }

    /**
     * 获取Hash中的数据
     * @param key   Redis键
     * @param field Hash键
     * @return Hash中的对象
     */
    public <T> T hashGetValue(final String key, final String field) {
        HashOperations<String, String, T> opsForHash = redisTemplate.opsForHash();
        return opsForHash.get(key, field);
    }

    /**
     * 判断Hash中是否有field
     * @param key   redis键
     * @param field hash键（field）
     * @return 
     */
    public Boolean hashHasField(String key,String field){
        return redisTemplate.opsForHash().hasKey(key,field);
    }


    /**
     * 删除Hash中的数据
     * @param key   redis键
     * @param field hash键
     */
    public void hashDelField(final String key, final String field) {
        HashOperations hashOperations = redisTemplate.opsForHash();
        hashOperations.delete(key, field);
    }

    /**
     * 获取多个Hash中的数据
     * @param key   Redis键
     * @param fields Hash键集合
     * @return Hash对象list集合
     */
    public <T> List<T> getMultiCacheMapValue(final String key, final Collection<Object> fields) {
        return redisTemplate.opsForHash().multiGet(key, fields);
    }

    /**
     * 获得缓存的基本对象列表
     * @param pattern 字符串前缀
     * @return 对象列表
     */
    public Collection<String> keys(final String pattern) {
        return redisTemplate.keys(pattern);
    }

    /**
     * 判断是否有这个key
     * @param key 键
     * @return true存在 false不存在
     */
    public Boolean hasKey(String key){
        return redisTemplate.hasKey(key);
    }

}
```



### 6.1.3 application.yml 配置

```yml
spring:
  redis:
    host: 192.168.10.250
    port: 6379
```



然后就可以愉快的使用了！



## 6.2 访问量的查询与增量

### 6.2.1 前端js代码

```js
//获得访客量，除文章显示界面外其他界面访客量通用
var pageName = window.location.pathname + window.location.search;
$.ajax({
    type:'get',
    url:'/getVisitorNumByPageName',
    dataType:'json',
    data:{
        pageName:pageName.substring(1)
    },
    success:function (data) {
        if(data['status'] == 103){
            $("#totalVisitors").html(0);
            $("#visitorVolume").html(0);
        } else {
            $("#totalVisitors").html(data['data']['totalVisitor']);
            $("#visitorVolume").html(data['data']['pageVisitor']);
        }
    },
    error:function () {
    }
});
```



### 6.2.2 Controller控制层接口

```java
@GetMapping(value = "/getVisitorNumByPageName")
public String getVisitorNumByPageName(
        @RequestParam("pageName") String pageName,
        HttpServletRequest request//omitted
) {
    //omitted: 判断是否为空，为空则赋给它约定好的pageName
    int index = pageName.indexOf("/");
    pageName = index == -1 ? "visitorVolume" : pageName;

    try {
        DataMap data = visitorService.getVisitorNumByPageName(pageName, request);
        return JsonResult.build(data).toJSON();

    } catch (Exception e) {
        log.error("ArticleController.publishArticle出错了...", e);
    }
    return JsonResult.fail(CodeType.SERVER_EXCEPTION).toJSON();
}
```



### 6.2.3 Service业务层

```java
@Override
public DataMap getVisitorNumByPageName(String pageName, HttpServletRequest request) {

    //获取当前访问页面的visitor
    Object visitorObj = request.getSession().getAttribute(pageName);
    String isVisited = visitorObj instanceof String ? (String) visitorObj : null;
    Long pageVisitorNum = null;
    Long totalVisitorNum = null;

    //omitted: 判断session生命周期中是否浏览过当前page，没浏览过则增加访问量
    if (isVisited == null) {
        //标记为访问过了
        request.getSession().setAttribute(pageName, "visited");

        //omitted: 增加当前页面的访问人数+1
        //omitted: 要用 redis -> sqlDB 逻辑链,如果redis未命中要去数据库查数据put到redis中
        if (!redisCache.hasKey("visitor")
                || !redisCache.hashHasField("visitor", pageName)
                || redisCache.hashGetValue("visitor", pageName) == null) {
            Visitor pageVisitor = visitorMapper.queryVisitorNumByPageName(pageName);
            long pageVisitorNum1 = pageVisitor.getVisitorNum();
            redisCache.hashSetValue("visitor", pageName, pageVisitorNum1);
        }
        pageVisitorNum = redisCache.hashIncrement("visitor", pageName, 1l);

        //omitted: 增加总访问人数+1
        //omitted: 要用 redis -> sqlDB 逻辑链,如果redis未命中要去数据库查数据put到redis中
        if (!redisCache.hasKey("visitor")
                || !redisCache.hashHasField("visitor", "totalVisitor")
                || redisCache.hashGetValue("visitor", "totalVisitor") == null) {
            Visitor totalVisitor = visitorMapper.queryTotalVisitor();
            long totalVisitorNum1 = totalVisitor.getVisitorNum();
            redisCache.hashSetValue("visitor", "totalVisitor", totalVisitorNum1);
        }
        totalVisitorNum = redisCache.hashIncrement("visitor", "totalVisitor", 1l);

    } else {//session中浏览过那就查询访问量
        if(redisCache.hashGetValue("visitor",pageName)==null){
            long visitorNum = visitorMapper.queryVisitorNumByPageName(pageName).getVisitorNum();
            redisCache.hashSetValue("visitor", pageName, visitorNum);
        }
        pageVisitorNum = Long.parseLong(redisCache.hashGetValue("visitor",pageName).toString());
        totalVisitorNum = Long.parseLong(redisCache.hashGetValue("visitor","totalVisitor").toString());
    }

    if (Objects.isNull(totalVisitorNum) || Objects.isNull(pageVisitorNum)) {
        return DataMap.fail(CodeType.SERVER_EXCEPTION);
    }

    JSONObject jsonObj = new JSONObject();
    jsonObj.put("totalVisitor", totalVisitorNum);
    jsonObj.put("pageVisitor", pageVisitorNum);

    return DataMap.success(CodeType.SUCCESS_STATUS).setData(jsonObj);
}
```



### 6.2.4 @Scheduled 定时任务Redis更新到数据库

```java
import com.tan.myblog.mapper.VisitorMapper;
import com.tan.myblog.model.Visitor;
import com.tan.myblog.redis.RedisCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: Administrator
 * @Date: 2023-04-05 4:03
 * @FileName: ScheduledTask
 * @Description: 定时器：用定时任务统计数据到redis中
 */
@Component
@EnableScheduling
public class ScheduledTask {

    @Autowired
    private VisitorMapper visitorMapper;

    @Autowired
    private RedisCache redisCache;


    /**
     * 每日凌晨4点统计数据
     */
    @Scheduled(cron = "0 0 4 * * ?")
    public void statisticsVisitorNum() {
        // 获取旧的总访问量
        Visitor visitor = visitorMapper.queryTotalVisitor();
        long oldVisitorNum = visitor.getVisitorNum();

        // 查询当前最新的访问量
        long newVisitorNum = Long.parseLong(redisCache.hashGetValue("visitor", "totalVisitor").toString());

        // 作差获取昨日访问量
        long yesterdayVisitor = newVisitorNum - oldVisitorNum;

        if (redisCache.hashHasField("visitor", "yesterdayVisitor")) {
            redisCache.hashSetValue("visitor", "yesterdayVisitor", yesterdayVisitor);
        } else {
            redisCache.hashSetValue("visitor", "yesterdayVisitor", oldVisitorNum);
        }

        // 将redis中所有访客记录更新到数据库中
        Map<String, Object> cacheMap = redisCache.hashGetCacheMap("visitor");

        for (Map.Entry<String, Object> entry : cacheMap.entrySet()) {
            String pageName = entry.getKey();
            Object visitorNumObj = entry.getValue();
            Integer visitorNum = visitorNumObj instanceof Integer ? (Integer) visitorNumObj : null;
            visitorMapper.updateVisitorNumByPageName(pageName, visitorNum);

            // 清除除了总访问量和昨日访问量外的所有redis中的数据
            if (!"totalVisitor".equals(pageName) && !"yesterdayVisitor".equals(pageName)){
                redisCache.hashDelField("visitor",pageName);
            }
        }
    }

}
```