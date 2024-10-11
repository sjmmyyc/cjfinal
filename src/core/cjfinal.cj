/*
 * Copyright (c) 杨云超 2024-2024. All rights reserved.
 */
package cjfinal.core

import net.http.{
    Server,
    ServerBuilder,
    HttpContext
}
import log.LogLevel
import std.time.MonoTime
import cjfinal.config.{
    CJFinalConfig,
    Constants
}

/**
 * CJFinal服务器类
 */
public class CJFinal{
    // 注意，修改版本号时，应将cjpm.toml文件中的版本号一并修改
    public static let version = "0.0.1"

    private static let me: CJFinal = CJFinal()

    private var _config: ?CJFinalConfig = None
    private let _constants: Constants = Constants()

    private var server: ?Server = None

    public init(){}

    /**
     * 启动服务器
     */
    public static func start(config: CJFinalConfig, port: Int64){
        let startTime = MonoTime.now()
        me.config = config
        me.config.configConstants(me.constants)
        
        me.create(port)
        let endTime = MonoTime.now()
        println("Total cost: ${endTime - startTime}")
        me.server?.serve()
    }

    /**
     * 创建服务并将所有请求归一处理
     */
    private func create(port: Int64): Unit{
        println("Welcom to use CJFinal Framework, current version is: ${version}")
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
        println("${ctx.request.url}")
        ctx.responseBuilder.body("欢迎使用CJFinal ${version} ^_^")
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
}