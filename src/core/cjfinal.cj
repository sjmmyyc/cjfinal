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

import cjfinal.config.{Config, CmdColor}
import cjfinal.logger.CJFinalLogger
import log.setGlobalLogger
import net.http.{Server, ServerBuilder, HttpContext}
import log.{LogLevel, getGlobalLogger, Logger}
import std.time.MonoTime
import std.process.Process
import std.fs.{File, OpenOption}
import std.console.Console
import std.posix.SIGINT
import std.reflect.TypeInfo
import std.fs.{exists, Directory}

// void (*signal(int sig, CFunc<(Int32) -> Unit>))(int)
type SignalHandler = CFunc<(Int32) -> Unit>

foreign func signal(signum: Int32, handler: SignalHandler): SignalHandler

/**
 * CJFinal服务器类
 */
public class CJFinal{
    // 注意，修改版本号时，应将cjpm.toml文件中的版本号一并修改
    public static let version = "0.3.1"

    public static let me: CJFinal = CJFinal()

    private let logger = getGlobalLogger([("name", "main")])

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
        
        me.config = config
        me.config.configConstants(me.constants)
        let logger = initGlobalLogger()
        logger.info("Welcom to use ${CmdColor.green}CJFinal${CmdColor.white} Web Framework, current version is: ${CmdColor.green}${version}${CmdColor.white}")
        me.config.configInterceptor(me._interceptors)
        me.config.configRoute(me._routes)
        me.config.configPlugin(me._plugins)
        me.config.configHandler(me.handlers)
        me.create(port)
        me.server?.afterBind({ => me.config.onStart()})
        me.server?.onShutdown({ => me.config.onStop()})
        me.startPlugins()
        let endTime = MonoTime.now()
        logger.info("Total cost: ${Float64((endTime - startTime).toNanoseconds()) / 1e9}s")
        spawn{
            me.server?.serve()
        }
        while(isRun){}
        me.server?.closeGracefully()
        me.stopPlugins()
    }

    /**
     * 初始化全局Logger
     */
    private static func initGlobalLogger(): Logger{
         let logger: CJFinalLogger = if(Config.DEV_MODE){
            CJFinalLogger(Console.stdOut)
        }else{
            if(!exists("logs")){
                Directory.create("logs")
            }
            CJFinalLogger(File("logs/log.txt", OpenOption.CreateOrAppend))
        }
        logger.level = Config.LOG_LEVEL
        // 注册为全局Logger,在需要用到的地方仅需getGlobalLogger([("nae", "main")])获取logger对象即可
        setGlobalLogger(logger)
        return logger
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
        logger.info("${CmdColor.green}Listen: http://127.0.0.1:${port}${CmdColor.white}")
        // 关闭默认日志
        this.server?.logger.level = LogLevel.OFF
        this.server?.distributor.register("/", globalHandler)
    }

    private func startPlugins(): Unit{
        for(plugin in me._plugins.pluginList){
            if(plugin.start()){
                logger.info("Plugin: start ${TypeInfo.of(plugin).name}...${CmdColor.green}Success${CmdColor.white}")
            }else{
                logger.info("Plugin: start ${TypeInfo.of(plugin).name}...${CmdColor.red}Failed${CmdColor.white}")
            }
        }
    }

    private func stopPlugins(): Unit{
        let reversePlugins = me._plugins.pluginList.toArray()
        reversePlugins.reverse()
        for(plugin in reversePlugins){
            if(plugin.stop()){
                logger.info("Plugin: stop ${TypeInfo.of(plugin).name}...${CmdColor.green}Success${CmdColor.white}")
            }else{
                logger.info("Plugin: stop ${TypeInfo.of(plugin).name}...${CmdColor.red}Failed${CmdColor.white}")
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