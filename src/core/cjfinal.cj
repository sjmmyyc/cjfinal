/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
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
        devPrintln("URL:\t\t${url}")
        // 记录匹配到的path
        var path = ""
        // 记录匹配到的Action
        var action = ""
        // 记录匹配到的Param
        var param = ""
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
                con.ctx = ctx
                let conInfo = TypeInfo.of(con)
                devPrintln("Controller:\t${path} ${conInfo}")
                action = getActionName(url, path)
                // 此时的action还不一定真是Action，得调用一下试试
                try{
                    // 假设action表示的正是Action
                    let funcInfo = conInfo.getInstanceFunction(action)
                    funcInfo.apply(con)
                }catch(e: Exception){
                    // 调用后发现action不是Action，则此Action将作为Param
                    action = "index"
                    let funcInfo = conInfo.getInstanceFunction(action)
                    funcInfo.apply(con)
                }
                devPrintln("Action:\t\t${action}")
                param = getParam(url, path, action)
                if(param != ""){
                    devPrintln("Param:\t\t${param}")
                }
                // ctx.responseBuilder.body("欢迎使用CJFinal ${version} ^_^")
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

    /**
     * 根据URL和ControllerPath，获取Action名称
     */
    private func getActionName(url: URL, controllerPath: String): String{
        let fullPath = url.path
        // 将controllerPath部分移除
        var action = fullPath[controllerPath.size..]
        // 如果是以“/”打头，把这个打头的“/”也去掉
        if(action.startsWith("/")){
            action = action[1..]
        }
        let nodes = action.split("/")
        if(nodes.size == 0){
            // 表示URL中无后续参数了，直接将Action定向到index
            action = "index"
        }else{
            // 表示URL中有后续参数，将node[1]做为Action
            action = nodes[0]
        }
        return action
    }

    /**
     * 根据URL、controllerPath、action获取Param
     */
    private func getParam(url: URL, controllerPath: String, action: String): String{
        var param = ""
        var path = url.path
         // 将controllerPath部分移除
        path = path[controllerPath.size..]
        // 如果是以“/”打头，把这个打头的“/”也去掉
        if(path.startsWith("/")){
            path = path[1..]
        }
        // 如果是以“/”结尾，把这个结尾处的“/”去掉
        if(path.endsWith("/")){
            path = path[0..(path.size - 1)]
        }
        let nodes = path.split("/")
        if(nodes.size > 0){
            param = nodes[nodes.size - 1]
            if(param == action){
                param = ""
            }
        }else{
            param = ""
        }
        return param
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