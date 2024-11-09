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

import cjfinal.config.Config
import net.http.{Server, ServerBuilder, HttpContext}
import log.LogLevel
import std.time.MonoTime
import std.process.Process
import std.fs.{File, OpenOption}
import std.console.Console
import std.posix.SIGINT
import std.reflect.TypeInfo

// void (*signal(int sig, CFunc<(Int32) -> Unit>))(int)
type SignalHandler = CFunc<(Int32) -> Unit>

foreign func signal(signum: Int32, handler: SignalHandler): SignalHandler

/**
 * CJFinal服务器类
 */
public class CJFinal{
    // 注意，修改版本号时，应将cjpm.toml文件中的版本号一并修改
    public static let version = "0.2.10"

    public static let me: CJFinal = CJFinal()

    private var _config: ?CJFinalConfig = None
    private var _constants = Constants()
    private var _routes = Routes()
    private var _plugins = Plugins()
    private var _handlers = Handlers()
    // 全局拦截器工具
    private var _interceptors = Interceptors()

    private var server: ?Server = None

    private static var isRun = true

    private init(){}

    /**
     * 启动服务器
     */
    public static func start(config: CJFinalConfig, port: Int64){
        let startTime = MonoTime.now()
        unsafe{
            signal(SIGINT, { _ => isRun = false})
        }
        println("Welcom to use \u{1b}[32mCJFinal\u{1b}[0m Web Framework, current version is: \u{1b}[32m${version}\u{1b}[0m")
        me.config = config
        me.config.configConstants(me.constants)
        me.config.configInterceptor(me._interceptors)
        me.config.configRoute(me._routes)
        me.config.configPlugin(me._plugins)
        me.config.configHandler(me.handlers)
        me.create(port)
        me.server?.afterBind({ => me.config.onStart()})
        me.server?.onShutdown({ => me.config.onStop()})
        me.startPlugins()
        let endTime = MonoTime.now()
        println("Total cost: ${Float64((endTime - startTime).toNanoseconds()) / 1e9}s")
        spawn{
            me.server?.serve()
        }
        while(isRun){}
        me.server?.closeGracefully()
        me.stopPlugins()
    }

    /**
     * 创建服务并将所有请求归一处理
     */
    private func create(port: Int64): Unit{
        this.server = ServerBuilder()
            .addr("127.0.0.1")
            .port(UInt16(port))
            .distributor(RequestDistributor())
            .maxRequestBodySize(Config.MAX_UPLOAD_SIZE)
            .build()
        println("\u{1b}[32mListen: http://127.0.0.1:${port}\u{1b}[0m")
        // 关闭默认日志
        this.server?.logger.level = LogLevel.OFF
        this.server?.distributor.register("/", globalHandler)
    }

    private func startPlugins(): Unit{
        for(plugin in me._plugins.pluginList){
            print("Plugin: start ${TypeInfo.of(plugin).name}...")
            if(plugin.start()){
                println("\u{1b}[32mSuccess\u{1b}[0m")
            }else{
                println("\u{1b}[31mFailed\u{1b}[0m")
            }
        }
    }

    private func stopPlugins(): Unit{
        let reversePlugins = me._plugins.pluginList.toArray()
        reversePlugins.reverse()
        for(plugin in reversePlugins){
            print("Plugin: stop ${TypeInfo.of(plugin).name}...")
            if(plugin.stop()){
                println("\u{1b}[32mSuccess\u{1b}[0m")
            }else{
                println("\u{1b}[31mFailed\u{1b}[0m")
            }
        }
    }

    /**
     * http请求的全局处理器
     */
    private func globalHandler(ctx: HttpContext): Unit{
        HandlerFactory.getHandler(this._handlers.handlerList, ActionHandler()).handle(ctx)
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

    public prop handlers: Handlers{
        get(){
            return this._handlers
        }
    }

    public prop plugins: Plugins{
        get(){
            this._plugins
        }
    }
}