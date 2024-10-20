/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 *
 * CJFinal is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *      http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 *
 *      Mulan Permissive Software License，Version 2
 *
 * Mulan Permissive Software License，Version 2 (Mulan PSL v2)
 * January 2020 http://license.coscl.org.cn/MulanPSL2
 */
package cjfinal.core

import encoding.url.URL
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
    // 全局拦截器工具
    private var _interceptors = Interceptors()

    private var server: ?Server = None

    private init(){}

    /**
     * 启动服务器
     */
    public static func start(config: CJFinalConfig, port: Int64){
        let startTime = MonoTime.now()
        println("Welcom to use \u{1b}[32mCJFinal\u{1b}[0m Framework, current version is: \u{1b}[32m${version}\u{1b}[0m")
        me.config = config
        me.config.configConstants(me.constants)
        me.config.configRoutes(me.routes)
        me.config.configInterceptor(me._interceptors)
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
        if(let Some(action) <- Action.get(ctx)){
            devPrintln("------------------------------ Request Info ------------------------------")
            devPrintln("URL:\t\t${ctx.request.url}")
            devPrintln("Controller:\t[${action.path}] ${action.controllerName}")
            devPrintln("Action:\t\t${action.method}")
            if(action.interceptors.size > 0){
                devPrint("Interceptors:\t")
                var index = 0
                for(interceptor in action.interceptors){
                    let info = TypeInfo.of(interceptor)
                    if(index == 0){
                        devPrintln("${info}")
                    }else{
                        devPrintln("\t\t${info}")
                    }
                    index++
                }
            }
            if(action.params.size != 0){
                devPrintln("Param:\t\t${action.params}")
            }
            devPrintln("----------------------------------- End ----------------------------------\n")
            action.invoke()
        }else{
            println("request: ${ctx.request.url} is not found.")
            let responst = ctx.responseBuilder
            responst.status(HttpStatusCode.STATUS_NOT_FOUND)
            responst.body("404 - Not Found")
        }
    }

    /**
     * 开发模式下才打印的信息
     */
    public static func devPrintln(msg: String){
        if(Config.DEV_MODE){
            println(msg)
        }
    }

    public static func devPrint(msg: String){
        if(Config.DEV_MODE){
            print(msg)
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

    public prop interceptors: Interceptors{
        get(){
            return this._interceptors
        }
    }
}