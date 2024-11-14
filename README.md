<div align="center">
<h1>CJFinal</h1>
</div>
<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.4.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.56.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-100%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/license-MulanPSL2.0-brightgreen" style="display: inline-block;" />
</p>

	文档与框架本身，有任何问题，请加QQ群：247445547。另招募合作伙伴一起完善框架，欢迎小伙伴加入^_^

# CJFinal极速Web框架

为什么叫**极速框架**？因为**学习成本非常低**，**3分钟**上手，**2小时**干项目，**1天**精通Web服务开发。

<font color=red>**特别鸣谢**</font>[**JFinal**](https://www.jfinal.com)，采用**仓颉**来临摹一款类似的框架。考虑到**前后端分离**已成现下最流行的方式，因此**CJFinal**不会实现渲染HTML页面及相关功能，是的，**CJFinal**只适合写**API**（一切都以**返回Json为目的**）。**CJFinal**目前仍处于探索开发阶段，欢迎大家体验。

# 模块划分及进度

| 模块名称| 完成度 | 描述 |
|:-:|:-:|:-|
| CJFinalConfig |  <font color=green>[√] 已完成</font>  | 通过继承CJFinalConfig类，对整个Web项目进行配置 |
| Handler | <font color=green>[√] 已完成</font> | 服务器接收到的所有请求，都先交由Handler来处理。<br/>CJFinal自身也是基于Handler的子类ActionHander来完成框架主要功能的 |
| Controller | <font color=green>[√] 已完成</font> | 通过继承Controller类，其中的public方法将通过URL请求直接驱动，完成业务逻辑 |
| AOP | <font color=green>[√] 已完成</font> | CJFinal专注AOP最核心的目标，将概念减少到极致<br/>仅有三个概念：Interceptor、Before、Clear，并且无需引入IOC也无需使用啰嗦的XML |
| Json转换 | <font color=green>[√] 已完成</font> | CJFinal通过在class或struct定义前加上@Json宏，使其具备可被自动解析成Json的功能 |
| 上传/下载 | <font color=green>[√] 已完成</font> | 文件上传用getFiles(..)/getFile(..)系列方法<br/>文件下载用renderFile(..)系列方法 |
| 插件化 | <font color=green>[√] 已完成</font> | CJFinal支持采用插件化的方式进行扩展 |
| DatasourcePlugin | <font color=green>[√] 已完成</font> | 数据库插件，支持仓颉官方PooledDatacource连接池，暂仅支持MySQL数据库 |
| ActiveRecordPlugin | <font color=green>[√] 已完成</font> | 延续 JFinal 的 Db+Record 模式，作为 CJFinal 操作数据库的核心模块 |
| CronPlugin | <font color=green>[√] 已完成</font> | 以插件的形式提供定时任务功能 |
| RedisPlugin| <font color=red>[▶] 进行中</font> | 将以插件的形式提供对Redis的支持 |
| Validator | [×] 待完成 | 校验组件，在Validator类中将提供非常方便的校验方法，学习简单，使用方便 |

# 添加依赖

1. 打开项目中的 `cjpm.toml` 文件，在 `[dependencies]` 下面加入CJFinal的依赖：
  ```
    [dependencies]
        // CJFinal依赖
        cjfinal = { git = "https://gitee.com/centmagic/cjfinal.git", tag = "v0.4.0", output-type = "static"}

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
    public func configPlugin(_: Plugins): Unit{}
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
仓颉目前无法交叉编译，因此，需要部署到哪个平台，就得到哪个平台下编译打包项目。部署CJFinal项目非常简单。

### 1.2.1 打包
```
cjpm build -o [your-project-name]
```

### 1.2.2 构建脚本
打包完成后，在项目的 `target/release/bin` 目录下会生成平台可执行程序。如果你的项目使用了外部文件，如图片、视频、配置文件等，打包命令并不会将其一并复制到 `target/release/bin` 下。此时，你可以手动将其复制过来，或者编写“构建脚本”，实现编译时自动复制外部文件的功能。“构建脚本”是仓颉自身的特性，查官方文档即可了解如何编写，非常简单好用。这里我们给出一个简单的示例：
```
// build.cj
import std.process.*
import std.fs.{Path, copy}

/**
 * 编译完成后的回调
 */
func stagePostBuild(): Int64{
    // 将config目录下的文件复制到打包目录中
    let source = Path("./config")
    let target = Path("./target/release/bin/config")
    copy(source, to: target, overwrite: true)
    return 0
}

main(): Int64{
    match(Process.current.arguments[0]){
        // Add operation here with format: "pre-"/"post-" + optionName
        // case "pre-build" => stagePreBuild()              // 编译前
        case "post-build" => stagePostBuild()               // 编译后
        // case "pre-clean" => stagePreClean()              // clean前
        // case "post-clean" => stagePostClean()            // clean后
        case _ => return 0
    }
}
```
注意：`build.cj` 要和 `cjpm.toml` 在同一级目录中。

### 1.2.3 运行
将 `target/release/bin` 目录复制到你期望的目录中，然后 `./your-porject-name` 即可运行程序。

### 1.2.4 退出

可使用 `Ctrl + C` 退出程序。在 `Linux` 下还可使用 `pkill -2 [your-program-name]` 向程序发送 `Ctrl + C` 信号来结束程序。

需要注意的是，通过以下方式关闭程序时，不会调用 `onStop()` 回调

1. 强制杀进程
2. 在 Windows 下直接关闭 cmd 窗口

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
此方法用来配置CJFinal常量值，如下代码是一些常用的配置：
```
import log.LogLevel

public func configConstants(me: Constants): Unit{

	// 配置开发模式，true为开发模式，默认为false
	me.devMode = true

    // 配置上传文件目录，默认为"upload"
    me.uploadPath = "upload/image"

    // 配置允许上传的最大尺寸，单位为字节，默认为2MB
    me.maxUploadSize = 50 * 1024 * 1024

    // 配置上传Buff管道大小，默认为64KB
    me.uploadBufferCapacity = 64 * 1024

    // 配置Log级别，默认为LogLevel.ALL
    // 日志打印的七个级别，级别从低到高分别为 OFF、 FATAL、ERROR、WARN、INFO、DEBUG、TRACE、ALL。
    // 只有级别小于等于指定打印级别的日志条目会被打印到输出流中
    // 日志级别字符串不区分大小写
    me.logLevel = "info"
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

## 2.5 configPlugin(..)
此方法用来配置CJFinal的Plugin，如下代码配置了Datasource数据库连接池插件与ActiveRecord数据库访问插件。通过以下的配置，可以在应用中使用ActiveRecord非常方便地操作数据库。
```
 public func configPlugin(me: Plugins): Unit{
    let dp = DatasourcePlugin("mysql://127.0.0.1:3306", "database", "username", "password")
    me.add(dp)
    let arp = ActiveRecordPlugin(dp)
    me.add(arp)
}
```

CJFinal插件架构是其主要扩展方式之一，可以方便地创建插件并应用到项目中去。

## 2.6 configHandler(..)
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

## 2.7 onStart() / onStop()回调
在 `CJFinalConfig` 继承类中可以添加 `onStart()` 与 `onStop()`，CJFinal 会在系统启动完成之后以及系统关闭之前分别回调这两个方法：
```
// 系统启动完成后回调
public func onStart(): Unit {}
    
// 系统关闭之前回调
// 注意：如果使用了 onStop() 回调，一定不要用强制杀进程的方式来终止程序，否则 onStop() 回调不会被执行
public func onStop(): Unit {}
```
这两个方法可以很方便地在项目启动后与关闭前让开发者有机会进行额外操作，如在系统启动后创建调度线程或在系统关闭前写回缓存。


## 2.8 PropKit读取配置
PropKit工具类用来读取外部键值对配置文件，PropKit可以极度方便地在系统任意时空使用，配置文件的格式如下：
```
// 假设有配置文件config.txt，与src目录属于同级关系
// =号前后可加空格，也可不加
// 配置文件内仅支持“//”形式的注释

userName = Kevin
email = abc@qq.com
devMode = true

// 日志级别
// 日志打印的七个级别，级别从低到高分别为 OFF、 FATAL、ERROR、WARN、INFO、DEBUG、TRACE、ALL
// 只有级别小于等于指定打印级别的日志条目会被打印到输出流中
// 日志级别值不区分大小写
logLevel = info
```
如下是 PropKit 代码示例：
```
// 需要引入以下包
// import cjfinal.kit.PropKit

// 将config.txt中的配置项缓存起来
PropKit.use("config.txt");

// 还可以这样写，用appendIfExist()方法加载开发环境的配置文件，如果存在，则加载，并更新缓存，如果不存在，啥也不干
// 这样做的好处是，避免了在开发环境和生产环境中频繁的切换配置文件，或因忘记切换配置文件导致意外发生
// 也就是说，开发环境下，可以只有config.txt文件，而生产环境下，只需要将config.txt复制一份，起名为config-pro.txt
// 然后生产环境中，就会用config-pro.txt中的配置项更新PropKit缓存，执行生产环境的配置
PropKit.use("config.txt").appendIfExist("config-pro.txt")

// 加载完配置文件后，就可以读取了
// 读取配置userName的值，get()方法返回的是字符串类型的值
let userName: String = PropKit.get("userName");

// 也可以使用getTo<T>()方法，将读取的值转换成T类型
let devMode: Bool = PropKit.getTo<Bool>("devMode");

// 读取name的值，如果不存在，返回传入的第二个参数，返回值为String类型
let name: String = getByDefault("name", "Kevin")

// 读取isGirl的值，如果不存在，返回传入的第二个参数，返回值为T类型
let isGirl: Bool = getByDefaultTo<Bool>("isGirl", true)
```
如果有多个配置文件，随时可以用PropKit.use()加载并缓存起来，但是要注意的是，多个配置文件中的key不要重复。如果重复，后加载的key值会覆盖掉前面的同名key值。

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
| getArrayTo\<T>("cost") | 泛型方法，获取“cost”的参数值，返回值类型为传入的泛型类型，如果转换失败，抛出 `IllegalArgumentException` 异常 |

### 3.3.2. 获取CJFinal便捷请求参数
如：`http://localhost/user/list/1-2-3` 中的 `1-2-3`，就指的是便捷参数，多个参数之间用 `-` 分隔，通过以下方法获取，需传入索引号，注意，索引号以 `0` 开始。
|方法调用|返回值|
|:-|:-|
| getParam(0) | 获取第一个参数，返回值为 `String` 类型 |
| getParamTo\<T>(1) | 泛型方法，获取第二个参数，返回值类型为传入的泛型类型 |

## 3.4 getFiles/getFile
在你的 `Controller` 中调用`getFiles(..)` 或 `getFile(..)`系列方法， 即可实现文件上传的功能。上传后的文件会统一被重命名，原文件名称可通过 `UploadFile` 对象获取。需要注意的是，对于 `form-data` 类型的表单，必须得先调用一次 `getFiles(..)` 或 `getFile(..)` 系列方法，才能在后续代码中调用 `get/getArray` 来获取请求中的参数。
```
public class UserController <: Controller{

	public func avatar(): Unit{
        // 获取上传文件列表
        let uploadFiles = this.getFiles()

        // 获取到的 uploadFiles 是 Array<UploadFile> 类型的
        for(uploadFile in uploadFiles){
            // UploadFile对象可直接通过以下方法打印信息
            println(uploadFile)
        }

        // 以下是其它几种形态的getFiles(..)
        // 注明限制上传的大小
        this.getFiles(maxPostSize)        

        // 注明上传文件的保存目录                
        this.getFiles(uploadPath)          

        // 注明保存目录和限制的大小                 
        this.getFiles(uploadPath, maxPostSize)                  

        // getFile()系列方法返回值为 UploadFile
        // 参数意义同上，只多了一个 parameterName，含意在这： <input type="file" name="[parameterName]"/>
        this.getFile(parameterName)
        this.getFile(parameterName, uploadPath)
        this.getFile(parameterName, maxPostSize)
        this.getFile(parameterName, uploadPath, maxPostSize)
        
		this.renderText("response info...")
	}
}
```
另外，`getFiles()` 和 `getFile()` 系列方法可能会抛出异常，建议使用 `try{}catch()` 块包裹。下面是几种异常出现时的含义：
```
ExceedingLimitException 表示上传的文件超出限制大小
FSException             表示上传文件在保存到服务器时，出现了文件重名的情况，这种情况概率极低
                        或者是创建文件或目录时，系统权限不够
```

## 3.5 render方法
`render` 系列方法是用于简化向用户返回数据的方法
```
// 渲染纯文本
renderText("Hello CJFianl")

// 渲染HTML，传入的是HTML格式的字符串
renderHtml("<p></p>")

// 渲染Json，T 类型必须为实现 Serializable<T> 接口的类
// 对于大多数普通类，可通过 @Json 宏为其自动添加实现 Serializable<T> 接口的能力，使用方法见“Json转换“部分
renderJson(obj: T)
renderJson(arr: ArrayList<T>)

// 渲染下载文件，参数为表示文件名称的字符串，可包含目录，如：path/path2/avatar.jpg，目录必须用“/”分隔
// 也可是绝对目录，如果是绝对目录请确定是否有访问权限
renderFile(file)

// 渲染下载文件，inputStream表示输入流, filename表示用户接收到的文件名
renderFile(inputStream, filename)
```

# 4. AOP
## 4.1 概述
CJFinal采用极速化的AOP设计，专注AOP最核心的目标，将概念减少到极致，仅有三个概念：Interceptor、Before、Clear，并且无需引入IOC也无需使用啰嗦的XML。

## 4.2 Interceptor
### 4.2.1 基本用法
`Interceptor` 可以对方法进行拦截，并提供机会在方法的前后添加切面代码，实现 `AOP` 的核心目标。`Interceptor` 接口仅仅定义了一个方法 `func intercept(inv: Invocation): Unit`。以下是简单示例：
```
import cjfinal.core.{Interceptor, Controller, Invocation}

public class MyInterceptor <: Interceptor{

    public func intercept(inv: Invocation): Unit{
		// let con = inv.getController() 可获得Controller对象
		// let ctx = con.ctx 可获取HttpContext对象
        println("Before")
		// 注意：必须调用 inv.invoke() 方法，才能将当前调用传递到后续的 Interceptor 与 Action。
        inv.invoke()
        println("After")
    }
}
```
以上代码中的 `MyInterceptor` 将拦截目标方法，并且在目标方法调用前后向控制台输出文本。inv.invoke() 这一行代码是对目标方法的调用，在这一行代码的前后插入切面代码可以很方便地实现AOP。

常见错误：有很多同学忘了调用 `inv.invoke()` 方法，造成 controller 中的 action 不会被执行。在此再次强调一次，一定要调用一次 `inv.invoke()`，除非是刻意不去调用剩下的拦截器与 action，这种情况仍然需要使用 inv.getController().render()/renderJson() 调用一下相关的 render() 方法为客户端响应数据。

### 4.2.2 全局共享，注意线程安全问题
需要注意的是，**被注册成全局拦截器**的时候，Interceptor 是**全局共享**的，因此，**全局拦截器需要保证其属性是全局安全的**，如下代码是错误的：
```
public class MyInterceptor <: Interceptor{

	private var value = 123

    public func intercept(inv: Invocation): Unit{
		// 当该拦截器被注册成全局拦截器时
		// 多线程将会并发访问 value 的值，造成错乱
		// 如果非全局拦截器，将会是线程安全的
		value++
		inv.invoke()
    }
}
```

## 4.3 @Before
`@Before` 注解用来对拦截器进行配置，该注解可配置class、method级别的拦截器，以下是代码示例：
```
import cjfinal.aop.Before

// 配置一个Class级别的拦截器，它将拦截本类中的所有方法
@Before["test.interceptor.ControllerInterceptor"]
public class RootController <: Controller{

	// 配置一个Method级别的拦截器，仅拦截本方法
    @Before["test.interceptor.MethodInterceptor"]
    public func index(){
        let obj = User()
        this.renderJson(obj)
    }
}
```
如上代码所示，`@Before` 可以将拦截器配置为class级别与method级别，前者将拦截本类中所有方法，后者仅拦截本方法。此外 `@Before`可以同时配置多个拦截器，由于当前仓颉语言特性所致，同时配置多个拦截器的写法如下：
```
// 这里仅演示Method级别的多个拦截器配置方法，class级别的多拦截器配置方法与此一致
// 本质是在@Befor[]的方括号中配置一个字符串，字符串应该是Interceptor类的完整类名（含包名）
@Before["""
	test.interceptor.MethodInterceptor1,
	test.interceptor.MethodInterceptor2,
	test.interceptor.MethodInterceptor3
"""]
```
全局拦截器的配置方法，请查阅 CJFinalConfig 章节的 configInterceptor(..) 小节

## 4.4 @Clear
拦截器从上到下依次分为global、class、method三个层次，`@Clear` 用于清除自身所处层次以上层的拦截器。`@Clear`配置在class、method 层级，因为global层级的拦截器没有清除的必要。

`@Clear` 用法记忆技巧：

* 一共有global、class、method 三层拦截器

* 清除只针对Clear本身所处层的向上所有层，本层与下层不清除

* 不带参数时清除所有拦截器，带参时清除参数指定的拦截器

```
import cjfinal.aop.Clear

// 清除所有上层拦截器，本层与下层不清除
@Clear[""]
public class RootController <: Controller{

	// 仅清除GlobalInterceptor拦截器
    @Clear["test.interceptor.GlobalInterceptor"]
    public func index(){
        let obj = User()
        this.renderJson(obj)
    }
}
```

# 5. ActiveRecordPlugin

## 5.1 概述
ActiveRecordPlugin 是 CJFinal 最核心的组成部分之一，提供了 Db + Record 模式，通过这种方式操作数据库，将极大地减少代码量，极大地提升开发效率。

该插件需要搭配 DatasourcePlugin 使用。DatasourcePlugin 是数据库连接池插件，目前仅支持 MySQL 数据库，并且使用时，需要依赖第三方 MySQL 驱动。因此需要在 `cjpm.toml` 中添加如下依赖：
```
[dependencies]
  # mysql驱动
  mysqlclient4cj = {git = "https://gitcode.com/weixin_64400442/mysqlclient4cj.git", branch="master"}
```
另外，使用该库还需要确定已安装OpenSSL 3.x以上版本，请自行查阅安装方法。Ubuntu 安装方法如下：
```
// 安装
$ sudo apt install libssl-dev

// 查看版本
$ openssl version
```
## 5.2 使用ActiveRecordPlugin
ActiveRecordPlugin 作为 CJFinal 的插件而存在，所以使用时需要在 CJFinalConfig 中配置该插件。

以下是示例代码：
```
// import part
import cjfinal.plugin.database.DatasourcePlugin
import cjfinal.plugin.activerecord.ActiveRecordPlugin

// configPlugin(..) part
public func configPlugin(me: Plugins): Unit{

    // 创建DatasourcePlugin插件实例dp
    let dp = DatasourcePlugin("mysql://127.0.0.1:3306", "database", "username", "password")

    // 将dp插件加入到CJFinal配置中
    me.add(dp)

    // 创建ActiveRecordPlugin插件实例arp，注意，需要传入dp
    let arp = ActiveRecordPlugin(dp)

    // 将arp插件加入到CJFinal配置中
    me.add(arp)
}
```
添加好插件以后，便可在项目中使用 Db + Record 模式操作数据库了。

## 5.3 Db + Record模式
### 5.3.1 常见用法
Db + Record 模式无需对数据库表进行映射，Record相当于一个通用的 Model。以下为 Db + Record 模式的一些常见用法：
```
// import part
import cjfinal.plugin.activerecord.{Record, Db, Page}

// 创建name为Jay,age为18的record对象，并添加到数据表user中
let user = Record().set("name", "Jay").set("age", 18);
Db.save("user", user)

// 如果数据库字段允许为null，可以这样添加空值
user.set("name", Option<String>.None)
user.set("age", Option<Int>.None)

// 删除时，会将record中的所有属性以 and 连接，做为判断条件
// 比如目前user中有name=Jay, age=18，将生成以下sql语句
// delete from user where name=Jay and age=18
Db.delete("user", user)

// 查询所有年龄大于18岁的user
let userList: ArrayList<Record> = Db.find("select * from user where age > ?", 18)
// 查询名字叫Jay的user
let user: Record = Db.findFirst("select * from user where name=?", "Jay")

// 分页查询年龄大于18的user，当前页码为1，每页10个user
let page: Page = Db.paginate(1, 10, "select *", "from user where age > ?", 18)

// 查询Jay的年龄
let age: Int = Db.query<Int>("select age from user where name=?", "Jay")
let age: ?Int = Db.queryNullable<Int>("select age from user where name=?", "Jay")
// 查询年龄大于18的所有人名
let nameList: ArrayList<String> = Db.queryList<String>("select name from user where age>?", 18)

// 从 record 中获取值
let name: String = user.get<String>("name")
let age: Int = user.get<Int>("age")

// 如果数据库字段允许为null，可通过以下方式获取值
let name: ?String = user.getNullable<String>("name")
let age: ?Int = user.getNullable<Int>("age")

// 更新数据，update以主键为条件对数据进行更新
Db.update("user", user)
// CJFinal默认表中的主键名称为"id"，如果不是，需要手动指定主键名称
Db.update("user", "primaryKey", user)
```

### 5.3.2 Db.query()和Db.find()区别
Db.find()系列方法一律将从数据库获取到的值封装成Record对象。

Db.query()系列方法只将数据原样返回，需要注意的是，Db.query()只支持单列查询，即 `select name from user` 这样，如果写成多列查询，如 `select name, age from user`， 将抛出 `IllegalArgumentException` 异常

### 5.3.3 渲染Json
`Record` 和 `Page` 类都已实现 `Serializable` 接口，可通过 `Controller` 的 `renderJson()` 方法，直接返回给前端，体验极度舒爽。
```
let user = Db.findFirst("select * from user where name=?", "Jay")
renderJson(user)

let page = Db.paginate(1, 10, "select *", "from user")
renderJson(page)

let userList = Db.find("select * from user")
renderJson(userList)
```

## 5.4 数据库事务处理
通过 Db.tx() 可轻松实现事务处理
```
Db.tx({ => 
    Db.update("update user set age=? where name=?", 12, "Jay")
    let user = Record().set("name", "Jolin").set("age", 18)
    Db.save("user", user)
    // 返回 true 提交，返回 false 回滚
    return true
})

// 还可以设置事务级别，函数原型如下
Db.tx(level: TransactionIsoLevel, () -> Bool)
```

## 5.5 多数据源支持
ActiveRecordPlugin支持多数据源。即在configPlugin()中可配置多个ActiveRecordPlugin，如下所示：
```
public func configPlugin(me: Plugins): Unit{
    let dp1 = DatasourcePlugin(..)
    me.add(dp1)
    // 不传入名称，将做为主要的数据源
    let arp1 = ActiveRecordPlugin(dp1)
    me.add(arp1)

    let dp2 = DatasourcePlugin(..)
    me.add(dp2)
    // 传入名称dp2，使用时必须先Db.use()
    let arp2 = ActiveRecordPlugin("dp2", dp2)
    me.add(arp2)
}

// 此时使用主源时，和上面介绍的方法一样，没有任何区别，但要使用dp2时，只需要use()一下，切换到另一数据源上去
let user = Record().set(..)
Db.use("dp2").save()
```
## 5.6 独立使用ActiveRecordPlugin
ActiveRecordPlugin可以独立于Web环境，在任何普通的仓颉程序中使用，使用方法极简单。以下是示例代码：
```
import encoding.json.{ToJson}
import cjfinal.plugin.database.DatasourcePlugin
import cjfinal.plugin.activerecord.ActiveRecordPlugin

main(){
    let dp = DatasourcePlugin("mysql://127.0.0.1:3306", "database", "username", "password")
    let arp = ActiveRecordPlugin(dp)

    // 与Web环境不同点在于，需要手动启动插件
    dp.start()
    arp.start()

    // 然后就可以使用了
    let user = Db.findFirst(..)
    println(user.serialize().toJson().asObject().toString())

    return 0
}
```
注意：ActiveRecordPlugin所依赖的其它插件也必须手动调用一下start()方法，如上例中的dp.start()。

# 6. RedisPlugin
待实现...

# 7. CronPlugin
## 7.1 概述
CronPlugin是JFinal内置的任务调度插件，通过使用CronPlugin可以使用通用的cron表达式极为便利的实现任务调度功能。

由于CronPlugin是作为CJFinal的插件而存在的，所以使用时需要在CJFinalConfig中配置，如下是配置代码：
```
let cp = CronPlugin();
// 每分钟执行一次，关于cron表达式详解，请看后面章节介绍
cp.addTask("* * * * *", MyTask());
me.add(cp);
```
以下是 `MyTask` 类的定义：
```
package cjfinal.test.task

import cjfinal.plugin.cron.Task
import log.getGlobalLogger

/**
 * MyTask需要继承自 cjfinal.plugin.cron.Task 抽象类，并且实现其抽象方法 run()
 */
public class MyTask <: Task{

    let logger = getGlobalLogger([("name", "main")])

    public func run(): Unit{
        logger.info("MyTask running...")
    }
}
```
## 7.2 cron表达式
cron 表达式用于定制调度规则。与 quartz 的 cron 表达式不同，CronPlugin 的 cron 表达式最多只允许五部分，每部分用空格分隔开来，这五部分从左到右依次表示分、时、天、月、周，其具体规则如下：

* 分 ：从 0 到 59

* 时 ：从 0 到 23

* 天 ：从 1 到 31，字母 L 可以表示月的最后一天

* 月 ：从 1 到 12

* 周 ：从 0 到 6，0 表示周日，6 表示周六

如上五部分的分、时、天、月、周又分别支持如下字符，其用法如下：

* 数字 n：表示一个具体的时间点，例如 5 * * * * 表示 5 分这个时间点时执行

* 逗号 , ：表示指定多个数值，例如 3,5 * * * * 表示 3 和 5 分这两个时间点执行

* 减号 -：表示范围，例如 1-3 * * * * 表示 1 分、2 分再到 3 分这三个时间点执行

* 星号 *：表示每一个时间点，例如 * * * * * 表示每分钟执行

* 除号 /：表示指定一个值的增加幅度。例如 */5表示每隔5分钟执行一次（序列：0:00, 0:05, 0:10, 0:15 等等）。再例如3-18/5 * * * * 是指在从3到18分钟值这个范围之中每隔5分钟执行一次（序列：0:03, 0:08, 0:13, 0:18, 1:03, 1:08 等等）。

在制定 cron 规则时，建议边对照上面的规则边制定表达式。以下列举几条合法的cron表达式：
```
0 0 * * *       // 每天0点执行一次
30 12 * * 1     // 每周1中午12点30分执行一次
0 9 L * *       // 每月最后一天的早上9点整执行一次
*/5 * * * *     // 每5分钟执行一次
0 0 15 * * *    // 每月15号0点执行一次
30 8-18/2 * * * // 每天早8点到晚上6点之间，每两个小时的30分执行一次
0 */2 * * *     // 每2小时执行一次
0 0 1,15,L * *  // 每月1号、15号、最后一天的0点执行一次
0 0 25-L/2 * *  // 每用25号到最后一天之间，每隔2天执行一次 
```

## 7.3测试cron表达式
建议使用 `CronExpr` 对象的 `test(..)` 方法对 cron 表达式进行测试，使用方法如下：
```
import cjfinal.plugin.cron.CronExpr
import std.time.DateTime

main(): Int64 {
    // 每月最后一天的早上9点
    let cronExpr = CronExpr("0 9 L * *")
    let now = DateTime.now()
    let formatStr = "yyyy-MM-dd HH:mm:ss.S"
    println("now:  ${now.toString(formatStr)}")
    // 将当时时间传递给test()，它会返回最近5次匹配时间
    let list = cronExpr.test(now)
    for((i, date) in list.iterator().enumerate()){
        println("${i+1}: ${date.toString(formatStr)}")
    }
    return 0
}
```
执行结果如下：
```
    now:  2024-11-14 14:23:46.951
    1: 2024-11-30 09:00:00.000
    2: 2024-12-31 09:00:00.000
    3: 2025-01-31 09:00:00.000
    4: 2025-02-28 09:00:00.000
    5: 2025-03-31 09:00:00.000
```

# 8. Validator
待实现...

# 9. Json转换
得益于仓颉本身的特性，CJFinal 实现了一个 `@Json` 非属性宏， 可以非常轻松的将 class 或 struct 对象转换成 Json，例如我们有个 `User` 类，除了正常声明类属性和类方法外，只需要再引入三个包和为类添加 `@Json` 宏，这个 `User` 类的对象便可轻松的被转换成 Json，或者从 Json 格式转换成 `User` 对象了。

注意：`@Json` 宏只能加在 class 或 struct 前
```
// 以下三个包必须要导入，否则会报错
import serialization.serialization.*
import encoding.json.*
import cjfinal.macros.Json

@Json
public class User{
	// 使用 @Json 宏还有一点需要注意，就是成员方法的类型必须要是显式指定，下面展示了一种错误写法
	// public var name = "张三"		错误示例，类型为隐式String，在宏展开阶段无法推导出其真实类型
    public var name: String = "张三"
    public var age: Int64 = 33
    public var total: Float64 = 10000.0
    public var isStudent: Bool = false
    public var auths: Array<String> = ["a", "b", "c"]
}
```
随后，在 Controller 类里面，就可以使用 `this.renderJson(..)` 将 `User` 对象渲染到 response 中返回给请求调用者，示例代码如下 ：
```
public class RootController <: Controller{

    public func index(){
        let obj = User()		// 声明User对象
        this.renderJson(obj)	// 返回给请求调用者
    }
}
```

# 10. Logger
在 CJFinal 中使用 Logger 功能非常简单，底层由仓颉SDK实现，无需依赖第三方包。看代码：
```
import log.getGlobalLogger

// 在任何需要使用log的地方getGlobalLogger()
// 固定写法，照抄即可
let logger = getGlobalLogger([("name", "main")])

// 然后就可像这样记录日志了
logger.info("info")
logger.debug("debug info")
logger.error("err info")
logger.fatal("fatal info")
logger.warn("warn info")
logger.trace("trace info")
```
需要说明一点的是，`devMode` 为 `true` 时，日志被打印到 `Console` 中，否则会被记录到 `logs/log.txt` 文件中。

另外，有时我们想对打印的内容设置不同的颜色，可以这么写：
```
import cjfinal.config.CmdColor

// 建议在变色信息后写上${CmdColor.white}，否则之后打印的信息颜色都会被改变
println("${CmdColor.red}message${CmdColor.white}")

logger.info("${CmdColor.green}message${CmdColor.white}")
```

使用 CJFinal 提供的 `CmdColor` 类来改变输出信息的颜色的好处是，在日志被写到文件时，不会带颜色信息，因为颜色信息只针对 Console 有效。这样，日志文件中将不会出现奇怪的字符。