[toc]



1 

好的，下面是一个使用QueryWrapper的案例集，包含了QueryWrapper的常用方法的签名和案例：

1. 等值查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("name", "张三");
List<User> userList = userDao.selectList(queryWrapper);
```

2. 模糊查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.like("name", "张%");
List<User> userList = userDao.selectList(queryWrapper);
```

3. 多条件查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("age", 20).like("name", "张%");
List<User> userList = userDao.selectList(queryWrapper);
```

4. 排序查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.orderByAsc("age");
List<User> userList = userDao.selectList(queryWrapper);
```

5. 分页查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("age", 20).like("name", "张%");
Page<User> page = new Page<>(1, 10); //查询第1页，每页10条记录
IPage<User> userPage = userDao.selectPage(page, queryWrapper);
List<User> userList = userPage.getRecords();
```

6. 条件组合查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.and(wrapper -> wrapper.eq("age", 20).like("name", "张%"))
    .or(wrapper -> wrapper.eq("age", 30).like("name", "李%"));
List<User> userList = userDao.selectList(queryWrapper);
```

7. 子查询

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.inSql("id", "select user_id from user_role where role_id = 1");
List<User> userList = userDao.selectList(queryWrapper);
```

8. 自定义SQL

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.apply("age = {0} and name like {1}", 20, "张%");
List<User> userList = userDao.selectList(queryWrapper);
```

9. Lambda表达式

```
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.lambda().eq(User::getAge, 20).like(User::getName, "张%");
List<User> userList = userDao.selectList(queryWrapper);
```

以上就是QueryWrapper的使用案例集，包含了QueryWrapper的常用方法的签名和案例。