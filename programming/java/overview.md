# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.注解（annotation）（需要配合 反射 使用）](#1注解annotation需要配合-反射-使用)
        - [（1）内置注解](#1内置注解)
        - [（2）元注解（负责注解其他注解）](#2元注解负责注解其他注解)
        - [（3）自定义注解](#3自定义注解)
        - [（4）与反射的结合](#4与反射的结合)
      - [2.反射 (本质: 根据字符串获取对象)](#2反射-本质-根据字符串获取对象)

<!-- /code_chunk_output -->

### 概述

#### 1.注解（annotation）（需要配合 反射 使用）
不是程序本身，可以对程序作出解释，可以被其他程序读取
格式：`@<Annotation_name>(<key1>=<value1>)`

##### （1）内置注解

|内置注解|说明|
|-|-|
|`@Override`|用于覆盖某个方法（如果不存在该方法则报错）|
|`@Deprecated`|表示该方法被废弃|
|`@SupressWarnings`|抑制警告|

#####（2）元注解（负责注解其他注解）

|元注解|说明|
|-|-|
|`@Target`|指定该注解可以在哪里使用（比如：类、方法等）|
|`@Retention`|描述注解的生命周期，即在什么级别注解仍然存在（SOURCE < CLASS < RUNTIME）|
|`@Document`|表示是否将此注解生成在JAVAdoc中|
|`@Inherited`|子类可以继承父类的注解|

##### （3）自定义注解
```java
public @interface <Annotation_name> {
  <arg_type> <arg_name>()
}
```

##### （4）与反射的结合
通过反射获取到对象的注解信息
然后执行相应的操作

#### 2.反射 (本质: 根据字符串获取对象)
使java成为准动态语言
从一个对象或者包名等得到某个类的完整结构

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException {

        //获取class对象
        Class c1 = Class.forName("com.bongli.test.User");

        //获取该class对象的名称
        System.out.println(c1.getName());
        System.out.println(c1.getSimpleName());

        //获取该class对象的所有属性
        Field[] fields = c1.getDeclaredFields();
        for (Field field : fields) {
            System.out.println(field);
        }

        //获取该class对象的所有方法
        Method[] methods = c1.getDeclaredMethods();
        for (Method method :  methods) {
            System.out.println(method);
        }

        //获取该class对象的构造器
        Constructor constructor = c1.getDeclaredConstructor(int.class, String.class, int.class);
        //通过构造器 实例化该class对象
        User user2 = (User)constructor.newInstance(19, "liyi", 1111);
        Method getName = c1.getDeclaredMethod("getName");
        getName.invoke(user2);
        }
    }
}
```
