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

# 添加依赖

1. 打开项目中的 `cjpm.toml` 文件，在 `[dependencies]` 下面加入CJFinal的依赖：
  ```
    [dependencies]
        // ... 其它依赖
        cjfinal = { git = "https://gitcode.com/CoderKevin/cjfinal.git", tag = "v0.1.0", output-type = "static"}

    [package]
        ... // 以下内容省略
  ```
2. 添加依赖后，不要忘记执行 `cjpm update` 更新依赖包

# 1. 快速上手
## 1.1 CJFinal下开发
1. 创建文件 `src/core/test_config.cj` 并打开，输入以下代码：
```
// src/core/test_config.cj
package test.core

import cjfinal.core.{CJFinalConfig, Constants, Interceptors, Routes, Handlers}

public class TestConfig <: CJFinalConfig{

    public func configConstants(me: Constants): Unit{
        me.devMode = true   // 是否开发模式
    }
    public func configInterceptor(_: Interceptors): Unit{}
    public func configRoute(_: Routes): Unit{}
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
3. 但这个时候，我们并没有配置任何路由，接下来创建文件 `src/controller/root_controller.cj`，并输入以下代码
```
// src/controller/root_controller.cj
package test.controller

import cjfinal.core.Controller

public class RootController <: Controller{

    public func index(): Unit{
		// 向用户返回一段文本
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
    // 如果访问“http://localhost/index",就会调用RootController.index()方法
    me.add("/", RootController())
}
```
6. 运行程序，并打开浏览器，输入 `localhost/index`，将会在页面上看到 `Hello CJFinal`。恭喜你！你已经上手CJFinal框架了！
## 1.2 CJFinal下部署
待更新...

# 2. CJFinalConfig
## 2.1 概述
基于CJFinal的web项目需要创建一个继承自 `CJFinalConfig` 类的子类，该类用于对整个web项目进行配置。

`CJFinalConfig` 子类需要实现四个抽象方法，如下所示：
```
public class TestConfig <: CJFinalConfig{
	public func configConstants(me: Constants): Unit{}
	public func configRoute(me: Routes): Unit{}
	public func configInterceptor(me: Interceptors): Unit{}
	public func configHandler(me: Handlers): Unit{}
}
```

## 2.2 configConstants(..)
此方法用来配置CJFinal常量值，如开发模式常量 `devMode` 的配置，如下代码是一些常用的配置：
```
public func configConstants(me: Constants): Unit{
	// 配置开发模式，true为开发模式
	me.devMode = true
}
```
在开发模式下，CJFinal会对每次请求输出报告，如输出本次请求的URL、Controller、Method、Interceptor以及请求所携带的参数。
## 2.3 configRoute(..)
此方法用来配置访问路由：
```
public func configRoute(me: Routes): Unit{
	me.add("/", RootController())
	me.add("/user", UserController())
}
```
访问 `http://localhost/hello` 将调用 `RootController.hello()` 方法<br/>
访问 `http://localhost/user/info` 将调用 `UserController.info()` 方法

## 2.4 configInterceptor(..)
该方法用于配置全局拦截器
```
public func configInterceptor(me: Interceptors): Unit{
	me.add(FirstInterceptor())
	me.add(SecondInterceptor())
	me.add(ThirdInterceptor())
}
```
全局拦截器可配置多个，按配置顺序链式执行。关于如何实现拦截器，请移步后面的 `AOP` 章节
## 2.5 configHandler(..)
此方法用来配置CJFinal的Handler，Handler可以接管所有web请求，并对应用拥有完全的控制权，可以很方便地实现更高层的功能性扩展。CJFinal的核心层也是通过实现了一个ActionHander来开发的。
```
public func configHandler(me: Handlers): Unit{
	me.add(CorsHandler())
	me.add(TestHandler())
}
```
Handler可以配置多个，按配置顺序链式执行。例如，我们可以实现一个CorsHander来支持跨域请求：
```
public class CorsHandler <: Handler{
    
    public func handle(ctx: HttpContext): Unit{
        let response = ctx.responseBuilder
        response.header("Access-Control-Allow-Origin", "*");
		response.header("Access-Control-Allow-Methods", "OPTIONS,GET,PUT,POST,DELETE");
        var time = 2592000;	 // 默认缓存时间设置为30天
        if(PropKit.getByDefaultTo<Bool>("devMode", false)) {
			// 如果是开发模式，设置为10秒
			time = 10;
		}
		// 设置缓存时间
		response.header("Access-Control-Max-Age", time.toString());
		response.header("Access-Control-Allow-Headers", "Accept,Origin,DNT,X-Custom-Header,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Last-Modified");

		// 注意，这一步非常关键，会将业务交由下一个Handler去处理
		// 因此开发者可通过业务逻辑来控制请求是否继续向后执行
        this.next.handle(ctx)
    }
}
```
# 3. Controller

## 3.1 概述
`Controller` 是CJFinal核心类之一，该类作为MVC模式中的控制器。基于CJFinal的Web应用的控制器需要继承该类。`Controller` 是定义 `Action` 方法的地点，是组织 `Action` 的一种方式，一个 `Controller` 可以包含多个 `Action`。`Controller` 是线程安全的。

## 3.2 Action
在 `Controller` 中定义的 `public` 方法称为 `Action`。`Action` 是请求的最小单位。`Action` 方法必须在 `Controller` 中定义，且必须是 `public` 可见性。
```
// 假设UserController绑定到“/user”目录下
public class UserController <: Controller{

    public func index(): Unit{
		let user = User()
        this.renderJson(user)
    }

	public func list(): Unit{
		this.renderText("This is user list...")
	}
}
```
以上代码代码定义了两个 `Action`。一个 `index`， 一个 `list`。<br/>
通过 `http://localhost/user/index` 访问 `UserController.index()` 方法，如访问 `index`，可在请求链接中省略 `index`，写成这样： `http://localhost/user` <br/>
通过 `http://localhost/user/list` 访问 `UserController.list()` 方法

## 3.3 get/getArray
`Controller` 提供了一系列方法用于从请求中获取参数。总共分为两种类型的请求参数，一种是常规http请求中的键值对参数（请求中?号之后的参数或表单参数），一种是CJFinal提供的便捷式参数。

### 3.3.1. 获取常规http请求参数
|方法调用|返回值|
|:-|:-|
| get("title") | 获取“title”的参数值，返回值为 `String` 类型，如果没有，则返回空字符串 |
| getTo\<T>("age") | 泛型方法，获取“age”的参数值，返回值类型为传入的泛型类型，如果没有或转换失败，抛出 `IllegalArgumentException` 异常 |
| getArray("students") | 获取“students”的参数值，返回值为 `Array<String>` 类型 |
| getArrayTo\<Float64>("cost") | 泛型方法，获取“cost”的参数值，返回值类型为传入的泛型类型，如果转换失败，抛出 `IllegalArgumentException` 异常 |

### 3.3.2. 获取CJFinal便捷请求参数
如：`http://localhost/user/list/1-2-3` 中的 `1-2-3`，就指的是便捷参数，多个参数之间用 `-` 分隔，通过以下方法获取，需传入索引号，注意，索引号以 `0` 开始。
|方法调用|返回值|
|:-|:-|
| getParam(0) | 获取第一个参数，返回值为 `String` 类型 |
| getParamTo\<T>(1) | 泛型方法，获取第二个参数，返回值类型为传入的泛型类型 |

## 3.4 render方法
`render` 系列方法用于简化向用户返回数据的方法
```
// 渲染纯文本
renderText("Hello CJFianl")

// 渲染HTML，传入的是HTML格式的字符串
renderHtml("<p></p>")

// 渲染Json，传入的是可被转化成json对象
renderJson<T>(obj: Serializable<T>)
```

# 4. AOP
待更新...

# 5. Db + Record
待实现...

# 6. RedisPlugin
待实现...

# 7. CronPlugin
待实现...

# 8. Validator
待实现...

# 9. Json转换
待更新...

# 10. CJFinal架构扩展
待实现...