# CJFinal极速Web框架

为什么叫**极速框架**？因为**学习成本非常低**，**3分钟**上手，**2小时**干项目，**1天**精通Web服务开发。

<font color=red>**特别鸣谢**</font>[**JFinal**](https://www.jfinal.com)，采用**仓颉**来临摹一款类似的框架。考虑到**前后端分离**已成现下最流行的方式，因此**CJFinal**不会实现渲染HTML页面及相关功能，是的，**CJFinal**只适合写**API**（一切都以**返回Json为目的**）。**CJFinal**目前仍处于探索开发阶段，现已来到了**0.1.0**版本，欢迎大家体验。

# 模块划分及进度

| 模块名称| 完成度 | 描述 |
|:-:|:-:|:-|
| CJFinalConfig |  <font color=green>[v] 已完成</font>  | 通过继承CJFinalConfig类，对整个Web项目进行配置 |
| Handler | <font color=green>[v] 已完成</font> | 服务器接收到的所有请求，都先交由Handler来处理。<br/>CJFinal自身也是基于Handler的子类ActionHander来完成框架主要功能的 |
| Controller | <font color=green>[v] 已完成</font> | 通过继承Controller类，其中的public方法将通过URL请求直接驱动，完成业务逻辑 |
| AOP | <font color=green>[v] 已完成</font> | CJFinal专注AOP最核心的目标，将概念减少到极致<br/>仅有三个概念：Interceptor、Before、Clear，并且无需引入IOC也无需使用啰嗦的XML |
| Json转换 | <font color=green>[v] 已完成</font> | CJFinal通过在class或struct定义前加上@Json宏，使其具备可被自动解析成Json的功能 |
| 文件上传/下载 | <font color=red>[*] 进行中</font> | 该功能将作为Controller中的方法提供给大家，可轻松实现文件上传或下载功能 |
| Validator | [ ] 待完成 | 校验组件，在Validator类中将提供非常方便的校验方法，学习简单，使用方便 |
| 插件化 | [ ] 待完成 | CJFinal后续功能将采用插件化的方式进行扩展，大家也可以为CJFinal开发插件，方便更多人<br/>但目前尚未实现插件扩展的功能，敬请期待... |
| MySQLPlugin | [ ] 待完成 | 将以插件的形式，首先支持MySQL数据库连接 |
| Db + Record | [ ] 待完成 | Db和Record将作为CJFinal的核心类，届时会有丰富的数据库操作功能 |
| CronPlugin | [ ] 待完成 | 将以插件的形式提供定时任务功能 |
| RedisPlugin| [ ] 待完成 | 将以插件的形式提供对Redis的支持 |

# 开发环境
## Windows
1. 确保已安装仓颉编译器 `cjc 0.56.4` 版本
2. 创建项目目录，如 `E:/cjworks/test` （注：这里的项目名称为`test`），打开控制台，并进入到 `E:/cjworks/test` 目录下
3. 输入 `cjpm init` 并回车，初始化项目
4. 此时可用自己熟悉的IDE打开项目，接着打开项目中的 `cjpm.toml` 文件
5. 在 `dependencies` 下面加入CJFinal的依赖，添加完成后， `cjpm.toml` 文件将如下所示
  ```
    [dependencies]
        cjfinal = { git = "https://gitcode.com/CoderKevin/cjfinal.git", tag = "v0.1.0", output-type = "static"}

    [package]
        ... // 以下内容省略
  ```
6. 在控制台中，进入到源码目录，执行 `cjpm update`，接着执行 `cjpm run`，此时，如果看到控制台打印的 `hello world`，则表示配置正确。那么，恭喜你，CJFinal已经正式融入到你的项目中了

# 快速开始
1. 创建文件 `src/core/test_config.cj` 并打开，输入以下代码：
```
// src/core/test_config.cj
package test.core

import cjfinal.core.{CJFinalConfig, Constants, Interceptors, Routes, Handlers}

/**
 * 每个CJFinal工程，必有一个继承自CJFinalConfig的类，用于配置整个项目
 * 需要实现以下几个方法
 */
public class TestConfig <: CJFinalConfig{
    /**
     * 用于配置运行时常量
     */
    public func configConstants(me: Constants): Unit{
        me.devMode = true   // 是否开发模式
    }

    /**
     * 用于配置拦截器
     */
    public func configInterceptor(_: Interceptors): Unit{}

    /**
     * 用于配置路由
     */
    public func configRoute(_: Routes): Unit{}

    // 用于配置插件，configPlugin()暂未实现

    /**
     * 用于配置Handler
     */
    public func configHandler(_: Handlers): Unit{}
}
```
2. 接下来，打开 `src/main.cj`,输入以下代码
```
// src/main.cj
package test

import cjfinal.core.CJFinal
import test.core.TestConfig

main(): Int64 {
    // 启动CJFinal服务
    // 第一个参数正是上一步创建的类的对象，第二个参数表示要监听的端口号
    CJFinal.start(TestConfig(), 80)
    return 0
}
```
3. 此时，如果运行，将会在控制台看到如下信息：
```
// Console
E:\CJWorks\test>cjpm run
Welcom to use CJFinal Framework, current version is: 0.1.0
Set devMode = true
Total cost: 0.417500s
```
4. 但这个时候，我们并没有配置任何路由，接下来创建文件 `src/controller/root_controller.cj`，并输入以下代码
```
// src/controller/root_controller.cj
package test.controller

import cjfinal.core.Controller

/**
 * 根目录控制器
 */
public class RootController <: Controller{

    /**
     * 控制器内的pulic方法，将通过url直接驱动
     */
    public func index(): Unit{
        this.renderText("Hello CJFinal")
    }
}
```
5. 有了控制器，就该到Config类中去配置一下了，打开`src/core/test_config.cj`，将 `configRoute()`方法补充一下：
```
// src/core/test_config.cj代码片段
/**
 * 配置路由
 */
public func configRoute(me: Routes): Unit{
    // 注意，要在文件头部导入一下：import test.controller.RootController
    // 这样，就将RootController控制器绑定到了“/”目录上
    // 如果访问“/index",就会调用RootController类的public func index()方法
    me.add("/", RootController())
}
```
6. 运行程序，并打开浏览器，输入 `localhost/index`，将会在页面上看到 `Hello CJFinal`。恭喜你！你已经上手CJFinal框架了！