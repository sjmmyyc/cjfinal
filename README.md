# CJFinal 极速Web框架
特别鸣谢[JFinal](https://www.jfinal.com)，采用仓颉来临摹一款类似的框架。考虑到前后端分离已成现下最流行的方式，因此CJFinal不会实现渲染HTML页面及相关功能，是的，CJFinal只适合写API，目前仍处于探索开发阶段，现已来了0.1.0版本，欢迎大家体验。

# 模块划分及进度

| 模块名称| 完成度 | 描述 |
|:-:|:-:|:-|
| CJFinalConfig |  [x] <font color=green>已完成</font>  | 基于CJFinal的web项目需要创建一个继承自CJFinalConfig类的子类，该类用于对整个Web项目进行配置 |
| Handler | [x] <font color=green>已完成</font> | CJFinal接收到的所有请求，都先交由Handler来处理。CJFinal自身也是基于Handler的子类ActionHander来完成框架主要功能的 |
| Controller | [x] <font color=green>已完成</font> | CJFinal通过继承Controller类，并在其中编写public方法，这些方法将通过URL请求直接驱动，完成业务逻辑 |
| AOP | [x] <font color=green>已完成</font> | CJFinal专注AOP最核心的目标，将概念减少到极致，仅有三个概念：Interceptor、Before、Clear，并且无需引入IOC也无需使用啰嗦的XML |
| Json转换 | [x] <font color=green>已完成</font> | CJFinal通过在class或struct定义前加上@Json宏，使其具备可被自动解析成Json的功能 |
| 文件上传/下载 | [ ] <font color=red>进行中</font> | 该功能将作为Controller中的方法提供给大家，可轻松实现文件上传或下载功能 |
| Validator | [ ] 未完成 | CJFinal的校验组件，在Validator类中提供了非常方便的校验方法，学习简单，使用方便 |
| 插件化扩展 | [ ] 未完成 | CJFinal后续功能将采用插件化的方式进行扩展，大家也可以为CJFinal开发插件，方便更多人。但目前尚未实现插件扩展的功能，敬请期待... |
| MySQLPlugin | [ ] 未完成 | 将以插件的形式，首先支持MySQL数据库连接 |
| Db + Record | [ ] 未完成 | Db类及配套的Record类将作为CJFinal的核心类提供给大家，将会有丰富的数据库操作功能 |
| CronPlugin | [ ] 未完成 | 将以插件的形式提供Cron内核的定时任务 |

# 体验方式
1. 确保已安装仓颉编译器 `cjc 0.56.4` 版本
2. 下载源码或直接克隆仓库到本地
3. 在控制台中，进入到源码目录，执行 `cjpm run`

`以依赖的方式使用本框架的方法，等框架再完善一些，测试一番后再来补上...（当然，熟悉仓颉的小伙伴一定知道怎么整）`

# 文档
可参考[JFinal](https://www.jfinal.com)文档，写法基本一致，个别不同的地方，可参考项目目录 `src/test/` 下的测试代码，有问题或建议，请到Issues提出
