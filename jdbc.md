# 1 JDBC快速入门

## 1-1 jdbc的概念

* JDBC（Java DataBase Connectivity,java数据库连接）是一种用于==执行SQL语句的Java API==，可以为多种关系型数据库提供统一访问，它是由一组用Java语言编写的类和接口组成的。

## 1-2 jdbc的本质

* 其实就是java官方提供的一套规范(接口)。用于帮助开发人员快速实现不同关系型数据库的连接！

## 1-3 jdbc的快速入门程序

* 实现步骤
  * (1) 注册驱动
  * (2) 获取连接
  * (3) 获取执行者对象
  * (4) 执行sql语句，并接收返回结果
  * (5) 处理结果
  * (6) 释放资源

```java
public class JDBCTest01 {
    public static void main(String[] args) throws Exception{
        //(1) 导入jar包
        //(2) 注册驱动
        Class.forName("com.mysql.jdbc.Driver");
        
        //(3) 获取连接
        Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/jdbc_test_db1", "root", "root");
        
        //(4) 获取执行者对象
        Statement stat = con.createStatement();
        
        //(5) 执行sql语句，并接收返回结果
        String sql = "SELECT * FROM user";
        ResultSet rs = stat.executeQuery(sql);
        
        //(6) 处理结果
        while (rs.next()){
            System.out.println(rs.getInt("id") + "\t" + rs.getString("name"));
        }

        //(7) 释放资源
        con.close();
        stat.close();
        con.close();
    }
}
```

```
DCSR 地产商人
```

# 2 JDBC功能类详解

## 2-1 DriverManager

### 2-1-1 注册驱动相关 

* **注册驱动**:(告诉程序该使用哪一个数据库驱动)

`Class DriverManager`

| 成员方法签名                                | 返回值 | 说明                                 |
| ------------------------------------------- | ------ | ------------------------------------ |
| static void `registerDriver(Driver driver)` | void   | 注册与给定的驱动程序 `DriverManager` |

* 那么？为什么上面我们用的是？

```java
//(2) 注册驱动
Class.forName("com.mysql.jdbc.Driver");
```

* 通过查看源码发现：在`com.mysql.jdbc.Driver`类中存在静态代码块

```java
static {
	try {
		java.sql.DriverManager.registerDriver(new Driver());
	} catch (SQLException E) {
		throw new RuntimeException("Can't register driver!");
	}
}
```

* 所以，我们只需要使用一下这个类即可，不用再调用一次 `registerDriver(Driver driver)` 

### 2-1-2 获取数据库连接

| 成员方法签名                                                 | 返回值     | 说明                                                         |
| ------------------------------------------------------------ | ---------- | ------------------------------------------------------------ |
| static Connection `getConnection(String url, String user, String password)` | Connection | 尝试建立与给定数据库URL的连接。其中url格式：==jdbc:mysql://ip地址(域名):端口号/数据库名称== |

## 2-2 Connection

### 2-2-1 获取执行者对象

`Interface Connection`

|                   成员方法签名                   |      返回值       |                             说明                             |         理解         |
| :----------------------------------------------: | :---------------: | :----------------------------------------------------------: | :------------------: |
|          Statement `createStatement()`           |     Statement     |    创建一个 `Statement`对象，用于将SQL语句发送到数据库。     |  获取普通执行者对象  |
| PreparedStatement `prepareStatement(String sql)` | PreparedStatement | 创建一个 `PreparedStatement`对象，用于将参数化的SQL语句发送到数据库。 | 获取预编译执行者对象 |

### 2-2-2 事务相关

`Interface Connection`

|               成员方法签名               | 返回值 |                             说明                             |                理解                 |
| :--------------------------------------: | :----: | :----------------------------------------------------------: | :---------------------------------: |
| void `setAutoCommit(boolean autoCommit)` |  void  |            将此连接的自动提交模式设置为给定状态。            | 开启事务。参数为false，则开启事务。 |
|             void `commit()`              |  void  | 使自上次提交/回滚以来所做的所有更改都将永久性，并释放此 `Connection`对象当前持有的任何数据库锁。 |              提交事务               |
|            void `rollback()`             |  void  | 撤消在当前事务中所做的所有更改，并释放此 `Connection`对象当前持有的任何数据库锁。 |              回滚事务               |

## 2-3 Statement

* **执行者对象**：执行sql语句的对象

`Interface Statement`

|             成员方法签名             |  返回值   | 说明                                                         | 理解                                                         |
| :----------------------------------: | :-------: | :----------------------------------------------------------- | :----------------------------------------------------------- |
|   int  `executeUpdate(String sql)`   |    int    | 执行给定的SQL语句，这可能是 `INSERT` ， `UPDATE` ，或  `DELETE`语句，或者不返回任何内容，如SQL DDL语句的SQL语句。 | **返回值int**：返回影响的行数。<br />**参数sql**：可以执行insert、update、delete语句。 |
| ResultSet `executeQuery(String sql)` | ResultSet | 执行给定的SQL语句，该语句返回单个 `ResultSet`对象。          | **返回值ResultSet**：封装查询的结果。<br /> **参数sql**：可以执行select语句。 |

## 2-4 ResultSet

* **结果集对象**

`Interface ResultSet`

|   成员方法签名   | 返回值  | 说明                           | 理解                                                         |
| :--------------: | :-----: | :----------------------------- | :----------------------------------------------------------- |
| boolean `next()` | boolean | 将光标从当前位置向前移动一行。 | 有数据返回true，并将索引向下移动一行 <br />没有数据返回false |
|  T getT("列名")  |    T    | T代表数据类型                  | 无                                                           |

# 3 JDBC案例

* 使用JDBC完成对student表的CRUD

## 3-1 数据准备

```mysql
USE jdbc_test_db1;

-- 创建学生表
CREATE TABLE student(
sid INT PRIMARY KEY AUTO_INCREMENT,	-- 学生id
name VARCHAR(32),										-- 学生姓名
age INT,														-- 学生年龄
birthday DATE												-- 学生出生年月日
);

-- 插入数据
INSERT INTO student VALUES
(NULL,'张三',23,'1999-09-23'),
(NULL,'李四',24,'1998-08-10'),
(NULL,'王五',25,'1996-06-06'),
(NULL,'赵六',26,'1994-10-20');

SELECT * FROM student;
```

完成数据准备后的学生表:

![image-20230216151934635](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230216151937.png)

## 3-2 自定义Student实体类

- Student类，成员变量对应表中的列
- 注意：==所有的基本数据类型需要使用包装类==，以防null值无法赋值

```java
public class Student {
    //(1) 私有化成员变量
    private Integer sid;
    private String name;
    private Integer age;
    private Date birthday;
    ...省略标准实体类的常规代码
}
```

## 3-3 需求实现

### 3-3-1 需求一：查询所有学生信息

![image-20230216164127292](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230216164145.png)

#### 持久层代码

`class StudentDaoImpl`

```java
public class StudentDaoImpl implements StudentDao {
    /**
     * 查询所有学生信息
     * @return
     */
    @Override
    public ArrayList<Student> findAll() {
        ArrayList<Student> list = new ArrayList<>();
        Connection con = null;
        Statement stat = null;
        ResultSet rs = null;

        try {
            //(1) 注册驱动
            Class.forName("com.mysql.jdbc.Driver");
            //(2) 获取数据库连接
            con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/jdbc_test_db1", "root", "root");
            //(3) 获取执行者对象
            stat = con.createStatement();
            //(4) 执行sql语句，并接收返回的结果集
            String sql = "SELECT * FROM student";
            rs = stat.executeQuery(sql);
            //(5) 处理结果集
            while (rs.next()) {
                Integer sid = rs.getInt("sid");
                String name = rs.getString("name");
                Integer age = rs.getInt("age");
                Date birthday = rs.getDate("birthday");
                //封装Student对象
                Student stu = new Student(sid, name, age, birthday);
                //将Student对象保存到集合当中
                list.add(stu);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(6) 释放资源
            if(con!=null){
                try {
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if(stat!=null){
                try {
                    stat.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if(rs!=null){
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return list;
    }
}
```

#### 业务层代码

`Class StudentServiceImpl`

```java
public class StudentServiceImpl implements StudentService{
    private StudentDao dao = new StudentDaoImpl();
    /**
     * 查询所有学生信息
     * @return
     */
    @Override
    public ArrayList<Student> findAll() {
        return dao.findAll();
    }
}  
```

#### 控制层代码

`Class StudentController`

```java
public class StudentController {
    private StudentService service = new StudentServiceImpl();
    /**
     * 查询所有学生信息（控制层测试）
     */
    @Test
    public void findAll() {
        ArrayList<Student> list = service.findAll();
        for (Student stu : list) {
            System.out.println(stu);
        }
    }
}
```

### 3-3-2 需求二：根据id查询学生信息

#### 持久层代码

`class StudentDaoImpl`

```java
//下面只放关键代码了，完整的太长了
/**
     * 根据id找学生
     *
     * @param id
     * @return Student对象
     */
    @Override
    public Student findById(Integer id) {
        Student stu = null;
        Connection con = null;
        Statement stat = null;
        ResultSet rs = null;

        try {
            //(1) 注册驱动 DriverManager
            Class.forName("com.mysql.jdbc.Driver");
            //(2) 获得数据库连接对象 Connection

            con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/jdbc_test_db1", "root", "root");
            //(3) 创建执行者对象 Statement

            stat = con.createStatement();
            //(4) 执行sql语句，并接受返回的结果集
            String sql = "SELECT * FROM student WHERE sid = " + id;
            rs = stat.executeQuery(sql);
            //(5) 处理结果集
            while (rs.next()) {
                Integer sid = rs.getInt("sid");
                String name = rs.getString("name");
                Integer age = rs.getInt("age");
                Date birthday = rs.getDate("birthday");
                stu = new Student(sid, name, age, birthday);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(6) 释放资源
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
            if (stat != null) {
                try {
                    stat.close();
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
        }
        return stu;
    }
```

#### 业务层代码

`Class StudentServiceImpl`

```java
    /**
     * 根据id找学生
     * @param id
     * @return Student对象
     */
    @Override
    public Student findById(Integer id) {
        return dao.findById(id);
    }
```

#### 控制层代码

`Class StudentController`

```java
    /**
     * 根据id找学生
     */
    @Test
    public void findById() {
        Student stu = service.findById(5);
        System.out.println(stu);
    }
```

### 3-3-3 需求三：添加学生信息

#### 持久层代码

`class StudentDaoImpl`

```java
    /**
     * 插入一条学生信息到数据库
     * @param stu
     * @return
     */
    @Override
    public int insert(Student stu) {
        int result = 0;
        Connection con = null;
        Statement stat = null;

        try {
            //DCSR
            //(1) 注册驱动 DriverManager
            Class.forName("com.mysql.jdbc.Driver");
            //(2) 获取数据库连接 Connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc_test_db1", "root", "root");
            //(3) 获取执行者对象 Statement
            stat = con.createStatement();
            //(4) 执行sql语句 获得Result值
            //(4.1) 这里日期需要格式化为yyyy-MM-dd的格式
            //(4.2) public SimpleDateFormat(String pattern)构造一个 SimpleDateFormat 使用给定的模式和默认的日期格式
            //final String `format(Date date)` 将日期格式化成日期/时间字符串格式化(从 Date 到 String)
            java.util.Date date = stu.getBirthday();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String birthday = sdf.format(date);
            String sql = "INSERT INTO student VALUES" +
                    "(" + stu.getSid() + ",'" + stu.getName() + "'," + stu.getAge() + ",'" + birthday + "')";
            result = stat.executeUpdate(sql);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }

            try {
                stat.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        return result;
    }
```

#### 业务层代码

`Class StudentServiceImpl`

```java
    /**
     * 插入一条给定的学生信息
     * @param stu
     * @return
     */
    @Override
    public int insert(Student stu) {
        return dao.insert(stu);
    }
```

#### 控制层代码

`Class StudentController`

```java
    /**
     * 插入一条学生信息
     */
    @Test
    public void insert() {
        Student stu = new Student(5, "周七", 27, new Date());
        int result = service.insert(stu);
        if (result != 0) {
            System.out.println("插入成功，影响了" + result + "行。");
        } else {
            System.out.println("发生了错误，插入失败。");
        }
    }
```

### 3-3-4 需求四：修改学生信息

#### 持久层代码

`class StudentDaoImpl`

```java
	/**
     * 用给出的Student对象更新数据库中的数据
     * @param stu
     * @return
     */
    @Override
    public int update(Student stu) {
        int result = 0;
        Connection con = null;
        Statement stat = null;

        try {
            //DCSR
            //(1) 注册驱动 DriverManager
            Class.forName("com.mysql.jdbc.Driver");
            //(2) 获取数据库连接 Connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc_test_db1", "root", "root");
            //(3) 获取执行者对象 Statement
            stat = con.createStatement();
            //(4) 执行sql语句 获得Result值
            //(4.1) 这里日期需要格式化为yyyy-MM-dd的格式
            //(4.2) public SimpleDateFormat(String pattern)构造一个 SimpleDateFormat 使用给定的模式和默认的日期格式
            //final String `format(Date date)` 将日期格式化成日期/时间字符串格式化(从 Date 到 String)
            java.util.Date date = stu.getBirthday();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String birthday = sdf.format(date);
            String sql = "UPDATE student SET sid = " + stu.getSid()
                    + ",name = '" + stu.getName() + "',age = " + stu.getAge() + ",birthday = '" + birthday
                    +"' WHERE sid = " + stu.getSid();
            result = stat.executeUpdate(sql);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }

            try {
                stat.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        return result;
    }
```

#### 业务层代码

`class StudentServiceImpl`

```java
    /**
     * 用给出的Student对象更新数据库中的数据
     * @param stu
     * @return
     */
    @Override
    public int update(Student stu) {
        return dao.update(stu);
    }
```

#### 控制层代码

`class StudentController`

```java
    /**
     * 用给出的Student对象更新数据库中的数据
     */
    @Test
    public void update(){
        Student stu = new Student(5, "三月七", 18, new Date());
        int result = service.update(stu);
        if (result != 0) {
            System.out.println("修改成功，影响了" + result + "行。");
        } else {
            System.out.println("发生了错误，修改失败。");
        }
    }
```

### 3-3-5 需求五：删除指定id的学生信息

#### 持久层代码

`class StudentDaoImpl`

```java
    /**
     * 删除student表中指定id的一条学生数据
     * @param id
     * @return
     */
    @Override
    public int delete(Integer id) {
        int result = 0;
        Connection con = null;
        Statement stat = null;

        try {
            //DCSR
            //(1) 注册驱动 DriverManager
            Class.forName("com.mysql.jdbc.Driver");
            //(2) 获取数据库连接 Collection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc_test_db1","root","root");
            //(3) 获取执行者对象 Statement
            stat = con.createStatement();
            //(4) 执行者执行sql语句 获取ResultSet/result
            result = stat.executeUpdate("DELETE FROM student WHERE sid = " + id);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            try {
                stat.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        return result;
    }
```

#### 业务层代码

`class StudentServiceImpl`

```java
    /**
     * 删除student表中指定id的一条学生数据
     * @param id
     * @return
     */
    @Override
    public int delete(Integer id) {
        return dao.delete(id);
    }
```

#### 控制层代码

`class StudentController`

```java
    /**
     * 删除student表中指定id的一条学生数据
     */
    @Test
    public void delete(){
        int result = service.delete(5);
        if (result!=0){
            System.out.println("修改成功，影响了" + result + "行。");
        }else{
            System.out.println("发生了错误，修改失败。");
        }
    }
```

# 4 JDBC工具类

<a href="#7-6" id="4">从7-6来的，点击返回</a>

## 4-1 引入

* 在写第三章的案例时，我们不难发现，在持久层的代码中，每一个需求中我们都要==重复的写数据库的注册驱动、连接数据库、释放资源的代码==，产生了大量的冗余代码。
* 那么？怎么去解决呢？
* -->我们把冗余重复的代码抽取出来，封装成一个工具类 `class JDBCUtils`

## 4-2 工具类的抽取

### 4-2-1 配置文件(在src下创建config.properties)

```properties
driverClass=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/jdbc_test_db1
username=root
password=root
```

### 4-2-2 工具类

* **抽取步骤：**
  * （1）私有化构造方法
  * （2）私有化声明配置信息变量
  * （3）静态代码块 -- 实现加载配置文件和注册驱动
  * （4）静态成员方法
    * 获取数据库连接
    * 释放资源

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-16 23:29
 * @FileName: JDBCUtils
 * @Description: TODO JDBC工具类
 */
public class JDBCUtils {
    //（1）私有化构造方法
    private JDBCUtils() {
    }

    //（2）私有化静态声明配置信息变量
    private static String driverClass;
    private static String url;
    private static String username;
    private static String password;
    private static Connection con;

    //（3）静态代码块 -- 实现加载配置文件和注册驱动
    static {
        try {
            //通过类加载器返回配置文件的字节流
            InputStream is = JDBCUtils.class.getClassLoader().getResourceAsStream("config.properties");
            //创建Properties集合，加载流对象的信息
            Properties prop = new Properties();
            prop.load(is);
            //获取信息为变量赋值
            driverClass = prop.getProperty("driverClass");
            url = prop.getProperty("url");
            username = prop.getProperty("username");
            password = prop.getProperty("password");

            //注册驱动
            Class.forName(driverClass);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //（4）静态成员方法

    /**
     * 获取数据库连接
     * @return Connection
     */
    public static Connection getConnection(){
        try {
            con = DriverManager.getConnection(url,username,password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    /**
     * 释放JDBC资源
     * @param con
     * @param stat
     * @param rs
     */
    public static void close(Connection con, Statement stat, ResultSet rs){
        if(con!=null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(stat!=null) {
            try {
                stat.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(rs!=null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 释放JDBC资源
     * @param con 
     * @param stat
     */
    public static void close(Connection con,Statement stat){
        close(con,stat,null);
    }

}
```

```
上面的代码重点是
1、工具类的特点：静态居多
2、静态代码块中的加载配置文件（！）
```

# 5 解决注入攻击并优化第三章案例

## 5-1 注入攻击的问题

* 在登录界面，输入一个错误的用户名或密码，也可以登录成功

![06](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217125557.png)

* **发生原因：**`Statement`执行者对象在执行sql语句时，将一部分内容当做查询条件来执行了

## 5-2 解决注入攻击的问题

* 使用预编译执行者 PreparedStatement

* 预编译sql语句的执行者对象。在执行sql语句之前，将sql语句进行提前编译。明确sql语句的格式后，就不会改变了。剩余的内容都会认为是参数！==sql语句中参数使用?作为占位符==

* 有关类、接口：

  `Interface Connection`

| 成员方法签名                                     | 返回值            | 说明                                                         |
| ------------------------------------------------ | ----------------- | ------------------------------------------------------------ |
| PreparedStatement `prepareStatement(String sql)` | PreparedStatement | 创建一个 `PreparedStatement`对象，用于将参数化的SQL语句发送到数据库。 |

​	`Interface PreparedStatement`

| 成员方法签名                             | 返回值 | 说明                                                         |
| ---------------------------------------- | ------ | ------------------------------------------------------------ |
| void `setXxx(int parameterIndex, Xxx x)` | void   | 将指定的参数设置为Xxx对象。<br />参数1：?的位置编号(编号从1开始)<br />参数2：?的实际参数 |

## 5-3 工具类+PreparedStatement优化第三章案例

### 5-3-1 工具类

```java
public class JDBCUtils {
    //（1）私有化构造方法
    private JDBCUtils() {
    }

    //（2）私有化静态声明配置信息变量
    private static String driverClass;
    private static String url;
    private static String username;
    private static String password;
    private static Connection con;
    

    /**
     * （3）静态代码块 -- 实现加载配置文件和注册驱动
     */
    static {
        try {
            //通过类加载器返回配置文件的字节流
            InputStream is = JDBCUtils.class.getClassLoader().getResourceAsStream("config.properties");
            //创建Properties集合，加载流对象的信息
            Properties prop = new Properties();
            prop.load(is);
            //获取信息为变量赋值
            driverClass = prop.getProperty("driverClass");
            url = prop.getProperty("url");
            username = prop.getProperty("username");
            password = prop.getProperty("password");
            //注册驱动
            Class.forName(driverClass);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //（4）静态成员方法

    /**
     * 获取数据库连接
     * @return Connection
     */
    public static Connection getConnection(){
        try {
            con = DriverManager.getConnection(url,username,password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    /**
     * 释放JDBC资源
     * @param con
     * @param pstm
     * @param rs
     */
    public static void close(Connection con, PreparedStatement pstm, ResultSet rs){
        if(con!=null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(pstm!=null) {
            try {
                pstm.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(rs!=null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 释放JDBC资源
     * @param con
     * @param pstm
     */
    public static void close(Connection con,PreparedStatement pstm){
        close(con,pstm,null);
    }

}
```

### 5-3-2 查询指定id的学生信息

* ==下面只举两个需求，其它类似==

#### 持久层代码

`class StudentDaoImpl`

```java
    /**
     * 根据id找学生
     * @param id
     * @return Student对象
     */
    @Override
    public Student findById(Integer id) {
        Student stu = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            //(1) 注册驱动 DriverManager
            //(2) 获得数据库连接对象 Connection
            con = JDBCUtils.getConnection();
            //(3) 创建预编译执行者对象 Statement/PreparedStatement
            String sql = "SELECT * FROM student WHERE sid = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            //(4) 执行sql语句，并接受返回的结果集
            rs = pstm.executeQuery();
            //(5) 处理结果集
            while (rs.next()) {
                Integer sid = rs.getInt("sid");
                String name = rs.getString("name");
                Integer age = rs.getInt("age");
                Date birthday = rs.getDate("birthday");
                stu = new Student(sid, name, age, birthday);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(6) 释放资源
            JDBCUtils.close(con, pstm, rs);
        }
        return stu;
    }
```

#### 业务层代码

`class StudentServiceImpl`

```java
    /**
     * 根据id找学生
     * @param id
     * @return Student对象
     */
    @Override
    public Student findById(Integer id) {
        return dao.findById(id);
    }
```

#### 控制层代码

`class StudentController`

```java
    /**
     * 根据id找学生
     */
    @Test
    public void findById() {
        Student stu = service.findById(2);
        System.out.println(stu);
    }
```

### 5-3-3 用给出的Student对象更新数据库中的数据

#### 持久层代码

`class StudentDaoImpl`

```java
    /**
     * 用给出的Student对象更新数据库中的数据
     * @param stu
     * @return 被影响的行数
     */
    @Override
    public int update(Student stu) {
        int result = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        try {
            //(1) 注册驱动 DriverManager
            //(2) 获取数据库连接 Connection
            con = JDBCUtils.getConnection();
            //(3) 获取执行者对象 Statement
            //(4) 执行sql语句 获得Result值
            //(4.1) 这里日期需要格式化为yyyy-MM-dd的格式
            //(4.2) public SimpleDateFormat(String pattern)构造一个 SimpleDateFormat 使用给定的模式和默认的日期格式
            //(4.3) final String `format(Date date)` 将日期格式化成日期/时间字符串格式化(从 Date 到 String)
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String birthday = sdf.format(stu.getBirthday());
            String sql = "UPDATE student SET name = ?,age = ?,birthday = ? WHERE sid = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, stu.getName());
            pstm.setInt(2,stu.getAge());
            pstm.setString(3,birthday);
            pstm.setInt(4,stu.getSid());
            result = pstm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(6) 释放资源
            JDBCUtils.close(con, pstm);
        }
        return result;
    }
```

#### 业务层代码

`class StudentServiceImpl`

```java
    /**
     * 用给出的Student对象更新数据库中的数据
     * @param stu
     * @return 被影响的行数
     */
    @Override
    public int update(Student stu) {
        return dao.update(stu);
    }
```

#### 控制层代码

`class StudentServiceImpl`

```java
    /**
     * 用给出的Student对象更新数据库中的数据
     */
    @Test
    public void update(){
        Student stu = new Student(5, "三月七", 18, new Date());
        int result = service.update(stu);
        if (result != 0) {
            System.out.println("修改成功，影响了" + result + "行。");
        } else {
            System.out.println("发生了错误，修改失败。");
        }
    }
```

# 6 事务管理

# 7 数据库连接池

## 7-1 连接池概述

### 7-1-1 背景

* 数据库连接是一种关键的、有限的、昂贵的资源，这一点在多用户的网页应用程序中体现得尤为突出。
* 对数据库连接的管理能显著影响到整个应用程序的伸缩性和健壮性，影响到程序的性能指标。数据库连接池正是针对这个问题提出来的。

### 7-1-2 数据库连接池的概念

* 数据库连接池==负责分配、管理和释放数据库连接==，它允许应用程序==重复使用==一个现有的数据库连接，而不是再重新建立一个。这项技术能明显提高对数据库操作的性能。

```
就不用来一个请求创建一个连接了
```

![image-20230217151013021](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217151016.png)

## 7-2 自定义数据库连接池

### 7-2-1 DataSource接口

* java.sql.DataSource：数据源(数据库连接池)。java官方提供的数据库连接池规范(接口)

* 如果先完成数据库连接池技术，就必须实现DataSource接口

- 核心功能 ：获取数据库连接对象：Connection `getConnection()`;

### 7-2-2 自定义连接池

#### 步骤

* （1）自定义连接池类
* （2）定义集合容器，用于保存多个数据库连接对象
* （3）静态代码块，生成10个数据库连接保存到集合中
* （4）重写getConnection方法
* （5）定义getSize方法，用于获取容器的大小并返回

#### MyDataSource类

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 15:22
 * @FileName: MyDataSource
 * @Description: TODO 自定义数据库连接池
 */
public class MyDataSource implements DataSource {

    //(1)定义集合容器，用于保存多个数据库连接对象
    //***获取线程安全的ArrayList
    private static List<Connection> pool = Collections.synchronizedList(new ArrayList<>());

    //(2)静态代码块，生成10个数据库连接保存到集合中
    static {
        for (int i = 1; i <= 10; i++) {
            Connection con = JDBCUtils.getConnection();
            pool.add(con);
        }
    }

    //(3)重写getConnection方法
    //(4)定义getSize方法，用于获取容器的大小并返回
    public int getSize() {
        return pool.size();
    }

    /**
     * 核心
     *
     * @return
     * @throws SQLException
     */
    @Override
    public Connection getConnection() throws SQLException {
        if (pool.size() > 0) {
            Connection con = pool.remove(0);
            return con;
        } else {
            throw new RuntimeException("数据库连接池中连接数量已用尽...");
        }
    }
    
    //其它重写方法在这省略
}
```

#### 测试类

```java
public class MyDataSourceTest {
    public static void main(String[] args) throws Exception {
        //D创建连接池对象
        MyDataSource ds = new MyDataSource();

        System.out.println("使用之前的连接数量：" + ds.getSize());//10
        //通过连接池对象去获取一个连接对象C
        Connection con = ds.getConnection();



        //查询学生表的全部信息S
        String sql = "SELECT * FROM student;";
        PreparedStatement pstm = con.prepareStatement(sql);
        //执行sql语句获取结果集
        ResultSet rs = pstm.executeQuery();
        //处理结果集
        while (rs.next()) {
            int sid = rs.getInt("sid");
            String name = rs.getString("name");
            int age = rs.getInt("age");
            Date birthday = rs.getDate("birthday");
            System.out.println("" + sid + "\t" + name + "\t" + age + "\t" + birthday);
        }

        //释放资源
        rs.close();
        pstm.close();
        con.close();//用完以后还是关闭连接了，没有归还给连接池

        System.out.println("使用之后的连接数量：" + ds.getSize());//9

    }
}
```

## 7-3 归还连接的四种方式

### 7-3-1 继承方式（行不通）

#### 思路步骤

在 `class MyDataSourceTest` 中

```java
System.out.println(con.getClass());//class com.mysql.jdbc.JDBC4Connection
```

我们找到了连接的具体实现类com.mysql.jdbc.JDBC4Connection

* （1）定义一个类，继承JDBC4Connection
* （2）定义Connection连接对象和容器对象（连接池）的成员变量
* （3）通过有参构造方法为成员变量赋值
* （4）**重写close方法，完成归还连接

#### 尝试实现

```java
public class MyConnection extends JDBC4Connection {//（1）定义一个类，继承JDBC4Connection
    //（2）定义Connection连接对象和容器对象（连接池）的成员变量
    private Connection con;
    private List<Connection> pool;

    //（3）通过有参构造方法为成员变量赋值
    public MyConnection(String hostToConnectTo, int portToConnectTo, Properties info, String databaseToConnectTo, String url, Connection con, List<Connection> pool) throws SQLException {
        super(hostToConnectTo, portToConnectTo, info, databaseToConnectTo, url);
        this.con = con;
        this.pool = pool;
    }

    //（4）**重写close方法，完成归还连接
    @Override
    public void close() throws SQLException {
        pool.add(con);
    }
}
```

#### 存在问题

自定义的工具类中

![image-20230217163138111](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217163143.png)

而不是我们自定义继承的MyConnection。

我们虽然自定义了一个子类，完成了归还连接的操作。但是DriverManager获取的还是JDBC4Connection这个对象，并不是我们的子类对象。而我们又不能整体去修改驱动包中类的功能！

### 7-3-2 装饰（包装）设计模式

#### 思路步骤

* （1）定义一个类，实现Connection接口

* （2）定义连接对象和连接池容器对象的成员变量
* （3）通过有参构造方法为成员变量赋值
* （4）==重写close方法，完成归还连接==
* （5）==剩余方法 还是调用原来的连接对象中的功能即可==

#### 实现

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 16:37
 * @FileName: MyConnection2
 * @Description: TODO  装饰设计模式解决归还对象问题
 * (1) 定义一个类，实现Connection接口
 * (2) 定义连接对象和连接池容器对象的成员变量
 * (3) 通过有参构造方法为成员变量赋值
 * (4) 重写close方法，完成归还连接
 * (5) 剩余方法 还是调用原来的连接对象中的功能即可
 */
public class MyConnection2 implements Connection {//(1) 定义一个类，实现Connection接口
    //（2） 定义连接对象和连接池容器对象的成员变量
    private Connection con;
    private List<Connection> pool;

    //（3） 通过有参构造方法为成员变量赋值
    public MyConnection2(Connection con, List<Connection> pool) {
        this.con = con;
        this.pool = pool;
    }

    //（4）重写close方法，完成归还连接
    @Override
    public void close() throws SQLException {
        pool.add(con);
    }

    //(5) 剩余方法 还是调用原来的连接对象中的功能即可
    @Override
    public Statement createStatement() throws SQLException {
        return con.createStatement();
    }
    
    ...其他方法如法炮制
```

```
这种设计模式可以让人联想到 IO流的包装类 -- 缓冲流
```

#### 使用效果

在 `MyDataSource` 中,作如下修改

```java
    /**
     * 核心!!!!!!!!
     *
     * @return
     * @throws SQLException
     */
    @Override
    public Connection getConnection() throws SQLException {
        if (pool.size() > 0) {
            //装饰（包装）一下
            Connection con = pool.remove(0);
            MyConnection2 mc2 = new MyConnection2(con, pool);
            return mc2;
        } else {
            throw new RuntimeException("数据库连接池中连接数量已用尽...");
        }
    }
```

![image-20230217171157186](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217171202.png)

#### 存在问题

实现接口必须重写它的全部方法，方法一多累都累死了！

### 7-3-3 适配器设计模式

#### 思路

* 提供一个适配器类，实现Connection接口，将所有功能进行实现(除了close方法)
* 自定义连接类只需要继承这个适配器类，重写需要改进的close()方法即可！

```
适配器（Adapter）就可以理解成一个中间类
```

#### 步骤

* (1) 定义一个适配器类，实现Connection接口。
* (2) 定义Connection连接对象的成员变量。
* (3) 通过有参构造方法完成对成员变量的赋值
* (4) 重写所有方法(除了close)，调用mysql驱动包的连接对象完成即可
* (5) 定义一个连接类，继承适配器类。
* (6) 定义Connection连接对象和连接池容器对象的成员变量，并通过有参构造进行赋值
* (7) 重写close方法，完成归还连接
* (8) 在自定义连接池中，将获取的连接对象通过自定义连接对象进行包装

#### 实现

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 17:26
 * @FileName: MyAdapter
 * @Description: TODO 适配器设计模式实现归还连接操作
 * (1) 定义一个适配器类，实现Connection接口。
 * (2) 定义Connection连接对象的成员变量。
 * (3) 通过有参构造方法完成对成员变量的赋值
 * (4) 重写所有方法(除了close)，调用mysql驱动包的连接对象完成即可
 * (5) 定义一个连接类，继承适配器类。
 * (6) 定义Connection连接对象和连接池容器对象的成员变量，并通过有参构造进行赋值
 * (7) 重写close0方法，完成归还连接
 * (8) 在自定义连接池中，将获取的连接对象通过自定义连接对象进行包装
 */
public abstract class MyAdapter implements Connection {//(1) 定义一个适配器类，实现Connection接口。
    //(2) 定义Connection连接对象的成员变量。
    private Connection con;
    //(3) 通过有参构造方法完成对成员变量的赋值
    public MyAdapter(Connection con) {
        this.con = con;
    }

    //(4) 重写所有方法(除了close)，调用mysql驱动包的连接对象完成即可
    @Override
    public Statement createStatement() throws SQLException {
        return con.createStatement();
    }
    
    ...其他方法如法炮制
}
```

```
这里要注意 适配器类的一些特性
1、只是作为目的的一种中间手段。帮助连接类精简代码。
2、这里加了abstract关键字，适配器类一般都是抽象类。
3、适配器类实现接口，重写目的类继承适配器类
```

```java
public class MyConnection3 extends MyAdapter{//(5) 定义一个连接类，继承适配器类。
    //(6) 定义Connection连接对象和连接池容器对象的成员变量，并通过有参构造进行赋值
    private Connection con;
    private List<Connection> pool;

    public MyConnection3(Connection con, List<Connection> pool) {
        super(con);
        this.con = con;
        this.pool = pool;
    }

    //(7) 重写close方法，完成归还连接
    @Override
    public void close() throws SQLException {
        pool.add(con);
    }
}
```

#### 使用效果

![image-20230217193452075](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217193455.png)

#### 存在问题

自定义连接类虽然很简洁了，但适配器类还是我们自己编写的，也比较麻烦

### 7-3-4 动态代理方式

#### 动态代理

* **概念**：==在不改变目标对象方法的情况下对方法进行增强==，是反射的灵活应用
* **组成**：(1) 被代理对象 ：真实的对象（2）代理对象：内存中的一个对象0

- **要求(前提条件)**：代理对象必须和被代理对象实现相同的接口
- **实现**：Proxy.newProxyInstance

#### 动态代理案例

**1-代码准备**

```java
public interface StudentI {
    void eat(String name);
    void study();
}

public class Student implements StudentI{
    @Override
    public void eat(String name){
        System.out.println("学生吃" + name);
    }

    @Override
    public void study(){
        System.out.println("在家自学");
    }
}
```

**2-动态代理实现**

```java
public class Test {
    public static void main(String[] args) {
        Student stu = new Student();
//        stu.eat("米饭");
//        stu.study();
        /**
         * 要求：在不改动Student类中任何代码的前提下，通过study方法输出一句话：来黑马学习
         * @param 类加载器 和被代理对象使用相同的类加载器
         * @param 接口类型Class数组  和被代理对象使用相同接口
         * @param 代理规则 完成代理增强的功能
         */
        StudentI proxyStu = (StudentI)Proxy.newProxyInstance(stu.getClass().getClassLoader(), new Class[]{StudentI.class}, new InvocationHandler() {
            /**
             * 执行Student类所有的方法都会经过invoke方法，对method方法判断：如果是study，则对其增强，如果不是，调用学生对象原有的功能即可
             * @param proxy
             * @param method 反射中的知识
             * @param args
             * @return
             * @throws Throwable
             */
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                if(method.getName().equals("study")){
                    System.out.println("来黑马学习");
                    return null;
                }else{
                    return method.invoke(stu,args);
                }
            }
        });
        proxyStu.eat("米饭");
        proxyStu.study();

    }
}
```

#### 思路

* 我们可以通过Proxy来完成对Connection实现类对象的代理
* 代理过程中判断如果执行的是close方法，就将连接归还连接池中。如果是其他方法则调用连接对象原来的功能即可。

#### 步骤

* （1）定义一个类，实现DataSource接口
* （2）定义一个容器，用于保存多个Connection连接对象
* （3）定义静态代码块，通过JDBC不具类获取10个连接保存到容器中
* （4）重写getConnection方法，从容器中获取一个连接
* （5）通过 Proxy代理，如果是close 方法，就将连接归还池中。如果是其他方法则调用原有功能
* （6）定义getSize方法，用于获取容器的大小并返回

#### 实现

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 15:22
 * @FileName: MyDataSource
 * @Description: TODO 自定义数据库连接池
 */
public class MyDataSource implements DataSource {//（1）定义一个类，实现DataSource接口

    //(2)定义集合容器，用于保存多个数据库连接对象
    //***获取线程安全的ArrayList
    private static List<Connection> pool = Collections.synchronizedList(new ArrayList<>());

    //(3)静态代码块，生成10个数据库连接保存到集合中
    static {
        for (int i = 1; i <= 10; i++) {
            Connection con = JDBCUtils.getConnection();
            pool.add(con);
        }
    }


    //(6)定义getSize方法，用于获取容器的大小并返回
    public int getSize() {
        return pool.size();
    }


    @Override
    public Connection getConnection() throws SQLException {
        if (pool.size() > 0) {
            //(4)重写getConnection方法,从容器中获取一个连接
            Connection con = pool.remove(0);
            //(5)通过 Proxy代理，如果是close 方法，就将连接归还池中。如果是其他方法则调用原有功能
            Connection proxyCon = (Connection) Proxy.newProxyInstance(con.getClass().getClassLoader(), new Class[]{Connection.class}, new InvocationHandler() {
                /**
                 * 执行Connection实现类连接对象所有的方法都会经过invoke，
                 * 如果是close方法，归还连接
                 * 如果不是，直接执行连接对象原有的功能即可
                 * @param proxy
                 * @param method
                 * @param args
                 * @return
                 * @throws Throwable
                 */
                @Override
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    if(method.getName().equals("close")){
                        pool.add(con);
                        return null;
                    }else{
                        return method.invoke(con,args);
                    }
                }
            });

            return proxyCon;
        } else {
            throw new RuntimeException("数据库连接池中连接数量已用尽...");
        }
    }
    ...其它方法省略
}
```

#### 存在问题

自己写的连接池技术终归不够完善，功能也不够强大

## 7-4 C3P0连接池

### 7-4-1 C3P0使用步骤和注意事项

* （1）导入jar包
* （2）导入配置文件到src目录下
* （3）创建C3P0连接池对象
* （4）获取数据库连接进行使用

注意：==C3P0的配置文件会自动加载，但是必须叫 c3p0-config.xml或c3p0-config.properties==

### 7-4-2 步骤详解

* **（1）导入jar包**

![image-20230217211922435](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217211926.png)

1 - 导入这俩导到模块目录下的libs文件夹下

2 - Add As Library

![image-20230217212225832](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217212228.png)



* **（2）导入配置文件到src目录下**

![image-20230217212451301](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217212453.png)



* **（3）创建C3P0连接池对象**
* **（4）获取数据库连接进行使用**

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 21:30
 * @FileName: C3P0Test
 * @Description: TODO 使用c3p0连接池
 */
public class C3P0Test {
    public static void main(String[] args) throws Exception {
        //(1) 创建c3p0的数据库连接对象
        DataSource dataSource = new ComboPooledDataSource();

        //(2) 通过连接池对象获取数据库连接   (注册驱动 DriverManager 获取数据库连接 Connection)
        Connection con = dataSource.getConnection();

        ResultSet rs = null;
        PreparedStatement pstm = null;
        try {
            //(3) 获取预编译执行者对象 Statement/PreparedStatement
            String sql = "SELECT * FROM student";

            pstm = con.prepareStatement(sql);
            //(4) 执行sql语句，并接收返回的结果集 ResultSet/result

            rs = pstm.executeQuery();
            //(5) 处理结果集
            while (rs.next()) {
                Integer sid = rs.getInt("sid");
                String name = rs.getString("name");
                Integer age = rs.getInt("age");
                Date birthday = rs.getDate("birthday");
                System.out.println("" + sid + "\t" + name + "\t" + age + "\t" + birthday);
                /*//封装Student对象
                Student stu = new Student(sid, name, age, birthday);
                //将Student对象保存到集合当中
                list.add(stu);*/
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(6) 释放资源
            JDBCUtils.close(con, pstm, rs);
        }
    }
}

```

### 7-4-3 验证C3P0的连接池特性

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-17 22:04
 * @FileName: C3P0Test2
 * @Description: TODO
 */
public class C3P0Test2 {
    public static void main(String[] args) throws Exception {
        //(1) 创建c3p0的数据库连接对象 D
        DataSource dataSource = new ComboPooledDataSource();
        //(2) 获取连接池中的连接 C
        for (int i = 1; i <= 11; i++) {
            Connection con = dataSource.getConnection();
            System.out.println(i + ": " + con);
            if (i == 5) {
                con.close();
            }
        }
    }
}
```

验证了：

* 最大连接数10
* 连接池的连接归还特性
* 超时时间3秒

![image-20230217235401836](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230217235404.png)



## 7-5 Druid连接池

### 7-5-1 Druid使用步骤和注意事项

* （1）导入jar包
* （2）编写配置文件，放在src目录下
* （3）通过Properties集合加载配置文件
* （4）通过Druid连接池工厂类获取数据库连接池对象
* （5）获取数据库连接，进行使用

**注意**：Druid连接池 需要Properties集合加载配置文件，不像c3p0默认加载

### 7-5-2 步骤详解

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 0:00
 * @FileName: DruidTest
 * @Description: TODO 测试Druid开源连接池
 */
public class DruidTest {
    public static void main(String[] args) throws Exception {
        //(1) 获取配置文件的IO流对象
        InputStream is = DruidTest.class.getClassLoader().getResourceAsStream("druid.properties");
        //(2) 通过Properties集合，加载配置文件
        Properties prop = new Properties();
        prop.load(is);

        //(3) 通过Druid连接池工厂类获取数据库连接对象
        DataSource dataSource = DruidDataSourceFactory.createDataSource(prop);
        Connection con = dataSource.getConnection();

        //(4) S R
        ResultSet rs = null;
        PreparedStatement pstm = null;
        try {
            //(4.1) 获取预编译执行者对象 Statement/PreparedStatement
            pstm = con.prepareStatement("SELECT * FROM student");
            //(4.2) 执行sql语句，并接收返回的结果集 ResultSet/result
            rs = pstm.executeQuery();
            //(4.3) 处理结果集
            while (rs.next()) {
                Integer sid = rs.getInt("sid");
                String name = rs.getString("name");
                Integer age = rs.getInt("age");
                Date birthday = rs.getDate("birthday");
                System.out.println("" + sid + "\t" + name + "\t\t" + age + "\t" + birthday);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(5) 释放资源
            JDBCUtils.close(con, pstm, rs);
        }
    }
}
```

## 7-6 抽取DataSource连接池工具类

* 和<a href="#4" id="7-6">第四章</a>同样地，我们在学完数据库连接池的技术后也可以==为连接池（DataSource）抽取一个工具类。==
* **总体思路：**
  * 1）私有构造方法
  * 2）声明数据源变量(静态)
  * 3）静态代码块，完成配置文件的加载和获取数据库连接池对象
  * 4）提供一个获取数据库连接的方法
  * 5）提供一个获取数据库连接池对象的方法
  * 6）释放资源

### 7-6-1 示例代码

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 0:32
 * @FileName: DataSourceUtils
 * @Description: TODO 数据库连接池的工具类
 */
public class DataSourceUtils {
    //(1) 私有构造方法
    private DataSourceUtils() {
    }

    //(2) 声明数据源变量
    private static DataSource dataSource;

    //(3) 静态代码块，完成配置文件的加载和获取数据库连接池对象
    static {
        try {
            //完成配置文件的加载
            InputStream is = DataSourceUtils.class.getClassLoader().getResourceAsStream("druid.properties");
            Properties prop = new Properties();
            prop.load(is);
            dataSource = DruidDataSourceFactory.createDataSource(prop);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //(4) 提供一个获取数据库连接的方法
    public static Connection getConnection() {
        Connection con = null;
        try {
            con = dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    //(5) 提供一个获取数据库连接池对象的方法
    public static DataSource getDataSource() {
        return dataSource;
    }

    //(6) 释放资源
    public static void close(Connection con, Statement stat, ResultSet rs) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (stat != null) {
            try {
                stat.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void close(Connection con, Statement stat) {
        close(con, stat, null);
    }

}
```

### 7-6-2 在测试类中使用工具类

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 0:53
 * @FileName: DruidTest2
 * @Description: TODO 连接池工具类的测试
 */
public class DruidTest2 {
    public static void main(String[] args) throws Exception{
        //1.通过连接池工具类去获取一个连接 C
        Connection con = DataSourceUtils.getConnection();

        //2.获取执行者对象 S
        PreparedStatement pstm = con.prepareStatement("SELECT * FROM student");

        //3.执行者对象执行sql语句返回结果集 R
        ResultSet rs = pstm.executeQuery();

        //4.处理结果集
        while(rs.next()){
            System.out.println(rs.getInt("sid") + ":" + rs.getString("name"));
        }
        //5.释放资源
        DataSourceUtils.close(con,pstm,rs);
    }
}
```

可以看到，代码变得十分简洁。

# 8 手写JDBC框架（JDBCTemplate）

## 8-1 框架的背景

### 8-1-1 dao持久层的重复代码

- 定义必要的信息、获取数据库的连接、释放资源都是重复的代码！
- ==而我们最终的核心功能仅仅只是执行一条sql语句而已啊！==
- 所以我们可以抽取出一个JDBC模板类，来封装一些方法(update、query)，专门帮我们执行增删改查的sql语句！
- ==将之前那些重复的操作，都抽取到模板类中的方法里。==就能大大简化我们的使用步骤！

### 8-1-2 数据库的源信息

- DataBaseMetaData(了解)：数据库的源信息
  - java.sql.DataBaseMetaData：封装了整个数据库的综合信息
  - 例如：
    - String getDatabaseProductName()：获取数据库产品的名称
    - int getDatabaseProductVersion()：获取数据库产品的版本号
- **ParameterMetaData：参数的源信息**
  - java.sql.ParameterMetaData：封装的是==预编译执行者对象==（S）中每个参数的类型和属性
  - 这个对象可以通过预编译执行者对象中的getParameterMetaData()方法来获取
  - **核心功能**：
    - int getParameterCount()：获取sql语句中参数的个数
- **ResultSetMetaData：结果集的源信息**
  - java.sql.ResultSetMetaData：封装的是结果集对象中列的类型和属性
  - 这个对象可以通过结果集对象中的getMetaData()方法来获取
  - **核心功能：**
    - int getColumnCount()：获取列的总数
    - String getColumnName(int i)：获取列名

## 8-2 框架的编写

### 8-2-1 框架类中的增删改update方法

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 14:23
 * @FileName: JDBCTemplate
 * @Description: TODO JDBC自定义框架：模板类
 */
public class JDBCTemplate {
    //(1) 定义私有化参数变量（数据源(连接池)、连接对象、执行者对象、结果集对象）
    private DataSource dataSource;
    private Connection con;
    private PreparedStatement pst;
    private ResultSet rs;

    //(2) 通过有参构造为数据源赋值
    public JDBCTemplate(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    //(3) 定义update方法。 参数：sql语句、sql语句中的参数

    public int update(String sql, Object... params) {
        //(4) 定义int类型变量，用于接收增删改后影响的行数
        int result = 0;

        try {
            //(5) 通过数据源获取一个数据库连接
            con = dataSource.getConnection();
            //(6) 通过数据库连接对象（C）获取执行者对象（S），并对sql语句进行预编译
            pst = con.prepareStatement(sql);

            //(7) 想拿到SQL语句中?的数量，和params的数量比较
            //(7) 通过执行者对象获取参数的源信息对象
            ParameterMetaData pmd = pst.getParameterMetaData();
            //(8) 通过参数源信息对象获取参数的个数
            int count = pmd.getParameterCount();

            if (count != params.length) {//(9) 判断参数数量是否一致
                throw new RuntimeException("参数个数不匹配！");
            }

            //(10) 为sql语句占位符赋值
            for (int i = 0; i < params.length; i++) {
                pst.setObject(i + 1, params[i]);
            }
            //(11) 执行sql语句
            result = pst.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(12) 释放资源
            DataSourceUtils.close(con,pst);
        }
        return result;
    }
}
```

### 8-2-2 增删改的测试

* 白盒测试 模拟DAO层
* 可以看到：dao层的代码由于框架的抽取也变得简单了很多。
* 只需要提供sql语句与?参数的Object[]数组即可

```java
private JDBCTemplate template = new JDBCTemplate(DataSourceUtils.getDataSource());

    /**
     * 新增数据的测试
     */
    @Test
    public void insert() {
        String sql = "INSERT INTO student VALUES (?,?,?,?)";
        Object[] params = {5,"王八",28,"1998-09-08"};
        int result = template.update(sql, params);
        if(result!=0){
            System.out.println("插入数据成功，影响了" + result + "行");
        }else {
            System.out.println("插入失败！发生了错误！");
        }

    }

    /**
     * 修改数据的测试
     */
    @Test
    public void update(){
        String sql = "UPDATE student SET name = ?, age = ?, birthday = ? WHERE sid = ?;";
        Object[] params = new Object[]{"周七",18,"2000-04-16",5};
        int result = template.update(sql, params);
        if(result!=0){
            System.out.println("修改数据成功，影响了"+ result +"行");
        }else{
            System.out.println("插入失败！发生了错误！");
        }
    }

    /**
     * 删除数据的测试
     */
    @Test
    public void delete(){
        String sql = "DELETE FROM student WHERE sid = ?";
        Object[] params = {5};
        int result = template.update(sql, params);
        if(result!=0){
            System.out.println("删除数据成功，影响了"+ result +"行");
        }else{
            System.out.println("插入失败！发生了错误！");
        }
    }
```

### 8-2-3 框架类中的查询方法总体思路

查询的方法相较于增删改，遇到的情况会比较多变，有可能会查一条数据，有可能会查多条数据，也有可能只是查询一个值。

![image-20230218161635337](https://tansihao6033.oss-cn-hangzhou.aliyuncs.com/img/20230218161637.png)

所以，在框架中，我们还将引入处理结果集的Handler的概念。

### 8-2-4 处理结果集的接口

* 定义泛型接口`ResultSetHandler<T>`
* 定义用户处理结果集的泛型方法<T> T handler(ResultSet rs )

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 16:27
 * @FileName: ResultSetHandler
 * @Description: TODO 用于处理结果集方式的接口
 */
public interface ResultSetHandler<T> {
    <T> T handler(ResultSet rs);
}
```

### 8-2-5 查询单条记录并封装到Student对象

* 首先，要写一个`BeanHandler<T>`类实现`ResultSetHandler<T>`接口

`BeanHandler<T>`类的实现思路

* （1）定义一个类，实现ResultSetHandler接口
* （2）定义Class对象类型变量
* （3）通过有参构造为变量赋值
* （4）重写handler方法。用户将一条记录封装到自定义对象中
* （5）声明自定义对象类型
* （6）通过反射对象的newInstance()方法，为自定义对象赋值
* （7）if判断结果集中是否有数据
* （8）通过结果集对象获取结果集源信息的对象
* （9）通过结果集源信息对象获取列数
* （10）通过循环遍历列数
* （11）通过结果集源信息对象获取列的名称
* （12）通过列名获取该列的数据
* （13）创建属性描述器对象,将获取到的值通过该对象的set方法进行赋值
* （14）返回封装好的对象T bean

#### Handler实现类

`Class BeanHandler`

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 21:05
 * @FileName: BeanHandler
 * @Description: TODO 传入结果集将一条记录封装到自定义对象中
 */
public class BeanHandler<T> implements ResultSetHandler<T>{//(1) 定义一个类，实现ResultSetHandler接口
    //(2) 定义Class对象类型变量
    private Class<T> beanClass;

    //(3) 通过有参构造为变量赋值
    public BeanHandler(Class<T> beanClass){
        this.beanClass = beanClass;
    }

    //(4) 重写handler方法。用户将一条记录封装到自定义对象中

    /**
     *
     * @param rs 结果集
     * @return 封装完的对象T bean
     */
    @Override
    public T handler(ResultSet rs) {
        //(5) 声明自定义对象类型
        T bean = null;

        try {
            //(6) 通过反射对象的newInstance()方法，为自定义对象赋值
            bean = beanClass.newInstance();
            //(7) 判断结果集中是否有数据
            if(rs.next()){
                //(8) 通过结果集对象获取结果集源信息的对象
                ResultSetMetaData metaData = rs.getMetaData();
                //(9) 通过结果集源信息对象获取列数
                int count = metaData.getColumnCount();
                //(10) 通过循环遍历列数
                for (int i = 1; i <= count; i++) {
                    //(11) 通过结果集源信息对象获取列的名称
                    String columnName = metaData.getColumnName(i);
                    //(12) 通过列名获取该列的数据
                    Object value = rs.getObject(columnName);
                    //(13) 创建属性描述器对象,将获取到的值通过该对象的set方法进行赋值
                    PropertyDescriptor pd = new PropertyDescriptor(columnName.toLowerCase(),beanClass);
                    //(13) 获取"columnName"属性的set方法
                    Method writeMethod = pd.getWriteMethod();
                    //(13) 执行set方法，给成员变量赋值
                    writeMethod.invoke(bean,value);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //(14) 返回封装好的对象T bean
        return bean;
    }
}
```

#### 框架模板类中queryForObject

`Class JDBCTemplate`

```java
 /**
     * 查询：用于将一条记录封装成自定义对象并返回
     * @param sql
     * @param rsh
     * @param params
     * @param <T> 可变类型
     * @return 封装完的单个对象T
     */
    public <T> T queryForObject(String sql, ResultSetHandler<T> rsh,Object...params){
        //(4) 定义可变类型变量，用于接收处理结果集后的对象
        T obj = null;

        try {
            //(5) 通过数据源获取一个数据库连接
            con = dataSource.getConnection();
            //(6) 通过数据库连接对象（C）获取执行者对象（S），并对sql语句进行预编译
            pst = con.prepareStatement(sql);

            //(7) 想拿到SQL语句中?的数量，和params的数量比较
            //(7) 通过执行者对象获取参数的源信息对象
            ParameterMetaData pmd = pst.getParameterMetaData();
            //(8) 通过参数源信息对象获取参数的个数
            int count = pmd.getParameterCount();

            if (count != params.length) {//(9) 判断参数数量是否一致
                throw new RuntimeException("参数个数不匹配！");
            }

            //(10) 为sql语句占位符赋值
            for (int i = 0; i < params.length; i++) {
                pst.setObject(i + 1, params[i]);
            }
            //(11) 执行sql语句并返回结果集
            rs = pst.executeQuery();
            //(12) 处理结果集
            obj = rsh.handler(rs);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(12) 释放资源
            DataSourceUtils.close(con,pst,rs);
        }
        return obj;
    }
```

#### 测试类

```java
    /**
     *  查询一条数据的测试
     */
    @Test
    public void queryForObject(){
        String sql = "SELECT * FROM student WHERE sid = ?";
        Student stu = template.queryForObject(sql, new BeanHandler<>(Student.class), 3);
        System.out.println(stu.toString());
    }
```

### 8-2-6 查询多条数据，封装为Student对象并添加到集合返回

思路都大同小异，不再赘述

#### Handler实现类

`Class BeanListHandler<T>`

```java
/**
 * @Author: Administrator
 * @Date: 2023-02-18 21:05
 * @FileName: BeanListHandler
 * @Description: TODO ResultSetHandler<T>实现类2 用于查询多条数据，封装为Student对象并添加到集合返回
 */
public class BeanListHandler<T> implements ResultSetHandler<T>{//(1) 定义一个类，实现ResultSetHandler接口
    //(2) 定义Class对象类型变量
    private Class<T> beanClass;

    //(3) 通过有参构造为变量赋值
    public BeanListHandler(Class<T> beanClass){
        this.beanClass = beanClass;
    }

    //(4) 重写handler方法。用户将多条记录封装到自定义对象中并添加到集合返回

    /**
     * 用户将多条记录封装到自定义对象中并添加到集合返回
     * @param rs 结果集
     * @return 封装对象的集合
     */
    @Override
    public List<T> handler(ResultSet rs) {
        //(5) 声明集合对象类型
        List<T> list = new ArrayList<>();
        try {
            //(6) 判断结果集中是否有数据
            while(rs.next()){
                //(7) 创建传递参数的对象，为自定义对象赋值
                // 理解：Student stu = new Student()
                T bean = beanClass.newInstance();
                //(8) 通过结果集对象获取结果集源信息的对象
                // 理解：根本不知道结果集rs里面的具体情况，所以必须要借助结果集源信息获取一些必要的信息（有几列，每列叫什么，每列的数据类型）
                ResultSetMetaData metaData = rs.getMetaData();
                //(9) 通过结果集源信息对象获取列数
                int count = metaData.getColumnCount();
                //(10) 通过循环遍历列数
                for (int i = 1; i <= count; i++) {
                    //(11) 通过结果集源信息对象获取列的名称
                    String columnName = metaData.getColumnName(i);
                    //(12) 通过列名获取该列的数据
                    Object value = rs.getObject(columnName);
                    //(13) 创建属性描述器对象,将获取到的值通过该对象的set方法进行赋值
                    // 理解：13点是反射的知识 beanClass终究是clazz对象，不是所需要的正常的java对象，要通过另类的方法获取属于clazz对象的getset方法，
                    PropertyDescriptor pd = new PropertyDescriptor(columnName.toLowerCase(),beanClass);
                    //(13) 获取"columnName"属性的set方法
                    Method writeMethod = pd.getWriteMethod();
                    //(13) 执行set方法，给成员变量赋值
                    writeMethod.invoke(bean,value);
                }
                //(14) 将封装完的对象保存到集合中
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //(15) 返回集合
        return list;
    }
}
```

#### 框架模板类

`Class JDBCTemplate`

```java
    /**
     * 查询：用于将多条记录封装成自定义对象集合并返回
     * @param sql
     * @param rsh
     * @param params
     * @param <T>
     * @return
     */
    public <T> List<T> queryForList(String sql, ResultSetHandler<T> rsh, Object...params){
        //(4) 定义可变类型对象集合，用于接收处理结果集后的对象
        ArrayList<T> list = new ArrayList<>();

        try {
            //(5) 通过数据源获取一个数据库连接
            con = dataSource.getConnection();
            //(6) 通过数据库连接对象（C）获取执行者对象（S），并对sql语句进行预编译
            pst = con.prepareStatement(sql);

            //(7) 想拿到SQL语句中?的数量，和params的数量比较
            //(7) 通过执行者对象获取参数的源信息对象
            ParameterMetaData pmd = pst.getParameterMetaData();
            //(8) 通过参数源信息对象获取参数的个数
            int count = pmd.getParameterCount();

            if (count != params.length) {//(9) 判断参数数量是否一致
                throw new RuntimeException("参数个数不匹配！");
            }

            //(10) 为sql语句占位符赋值
            for (int i = 0; i < params.length; i++) {
                pst.setObject(i + 1, params[i]);
            }
            //(11) 执行sql语句并返回结果集
            rs = pst.executeQuery();
            //(12) 处理结果集
            list = rsh.handler(rs);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(12) 释放资源
            DataSourceUtils.close(con,pst,rs);
        }
        return list;
    }
```

#### 测试类

```java
    /**
     * 查询多条内容的测试
     */
    @Test
    public void queryForList(){
        String sql = "SELECT * FROM student WHERE sid > ?";
        List<Student> list = template.queryForList(sql, new BeanListHandler<>(Student.class),2);
        for (Student stu:list) {
            System.out.println(stu.toString());
        }
    }
```

### 8-2-7 查询一个聚合函数的结果集，返回一个Long类型的值

思路都大同小异，不再赘述

#### Handler实现类

`class ScalarHandler<T>`

```java
public class ScalarHandler<T> implements ResultSetHandler<T>{//(1) 定义一个类实现ResultSetHandler<T>接口

    @Override
    public Long handler(ResultSet rs) {//(2) 重写handler()方法，用于返回一个聚合函数的查询结果
        //(3) 定义Long类型变量
        Long value = null;
        try {
            //(4) 判断结果集中是否有数据
            if(rs.next()){
                //(5) 通过结果集对象获取结果集源信息对象
                ResultSetMetaData metaData = rs.getMetaData();

                //(6) 通过结果集源信息对象 获取第一列的列名
                String columnName = metaData.getColumnName(1);
                //(7) 根据列名获取这一列的值
                value = rs.getLong(columnName);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //(8) 返回结果
        return value;
    }
}
```

#### 框架模板类

`Class JDBCTemplate`

```java
/**
     * 查询：查询一个聚合函数的结果集，返回一个Long类型的值
     * @param sql
     * @param rsh
     * @param params
     * @return
     */
    public Long queryForScalar(String sql,ResultSetHandler<Long> rsh,Object...params){
        //(4) 定义Long类型变量，用于接收聚合函数返回的值
        Long value = null;

        try {
            //(5) 通过数据源获取一个数据库连接
            con = dataSource.getConnection();
            //(6) 通过数据库连接对象（C）获取执行者对象（S），并对sql语句进行预编译
            pst = con.prepareStatement(sql);

            //(7) 想拿到SQL语句中?的数量，和params的数量比较
            //(7) 通过执行者对象获取参数的源信息对象
            ParameterMetaData pmd = pst.getParameterMetaData();
            //(8) 通过参数源信息对象获取参数的个数
            int count = pmd.getParameterCount();

            if (count != params.length) {//(9) 判断参数数量是否一致
                throw new RuntimeException("参数个数不匹配！");
            }

            //(10) 为sql语句占位符赋值
            for (int i = 0; i < params.length; i++) {
                pst.setObject(i + 1, params[i]);
            }
            //(11) 执行sql语句并返回结果集
            rs = pst.executeQuery();
            //(12) 处理结果集
            value = rsh.handler(rs);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //(12) 释放资源
            DataSourceUtils.close(con,pst,rs);
        }
        return value;
    }
```

#### 测试类

```java
    /**
     * 聚合函数的查询
     */
    @Test
    public void queryForScalar(){
        //String sql = "SELECT COUNT(*) FROM student";
        String sql = "SELECT AVG(age) FROM student";
        Long value = template.queryForScalar(sql, new ScalarHandler<>());
        System.out.println(value);
    }
```

