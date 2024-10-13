/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.core

import net.http.{Server, ServerBuilder, HttpContext, HttpStatusCode}
import log.LogLevel
import std.time.MonoTime
import std.reflect.TypeInfo

/**
 * CJFinal服务器类
 */
public class CJFinal{
    // 注意，修改版本号时，应将cjpm.toml文件中的版本号一并修改
    public static let version = "0.0.1"

    public static let me: CJFinal = CJFinal()

    private var _config: ?CJFinalConfig = None
    private var _constants = Constants()
    private var _routes = Routes()

    private var server: ?Server = None

    private init(){}

    /**
     * 启动服务器
     */
    public static func start(config: CJFinalConfig, port: Int64){
        let startTime = MonoTime.now()
        println("Welcom to use CJFinal Framework, current version is: ${version}")
        me.config = config
        me.config.configConstants(me.constants)
        me.config.configRoutes(me.routes)
        me.create(port)
        let endTime = MonoTime.now()
        println("Total cost: ${Float64((endTime - startTime).toNanoseconds()) / 1000.0 / 1000.0}s")
        me.server?.serve()
    }

    /**
     * 创建服务并将所有请求归一处理
     */
    private func create(port: Int64): Unit{
        this.server = ServerBuilder()
            .addr("127.0.0.1")
            .port(UInt16(port))
            .distributor(RequestDistributor())
            .build()
        // 关闭默认日志
        this.server?.logger.level = LogLevel.OFF
        this.server?.distributor.register("/", globalHandler)
    }

    /**
     * http请求的全局处理器
     */
    private func globalHandler(ctx: HttpContext): Unit{
        let url = ctx.request.url
        devPrintln("------------------------------ Request Info ------------------------------")
        devPrintln("URL: ${url}")
        // 记录匹配到的path
        var path = ""
        // 记录匹配到的controller
        var controller: ?Controller = None
        (path, controller) = this.routes.get(url)
        // 判断controller是否为None
        match(controller){
            case None =>
                // 当没有匹配到Controller时，返回404状态
                ctx.responseBuilder.status(HttpStatusCode.STATUS_NOT_FOUND)
                ctx.responseBuilder.body("404 - Not Found")
                devPrintln("Controller: None")
            case Some(con) =>
                // 当匹配到Controller时
                devPrintln("Controller: ${TypeInfo.of(controller.getOrThrow())}")
                println("matched path: ${path}")
                ctx.responseBuilder.body("欢迎使用CJFinal ${version} ^_^")
        }
        devPrintln("----------------------------------- End ----------------------------------\n")
    }

    /**
     * 开发模式下才打印的信息
     */
    public static func devPrintln(msg: String){
        if(Config.DEV_MODE){
            println(msg)
        }
    }

    // CJFinal配置
    public mut prop config: CJFinalConfig{
        set(value){
            this._config = value
        }
        get(){
            return this._config.getOrThrow()
        }
    }

    // 常量配置
    public prop constants: Constants{
        get(){
            return this._constants
        }
    }

    // 路由
    public prop routes: Routes{
        get(){
            return this._routes
        }
    }
}