/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import net.http.HttpContext
import encoding.url.URL
import cjfinal.exception.NotFoundException
import std.reflect.{TypeInfo, InstanceFunctionInfo}

/**
 * Action
 */
public class Action{

    // 表示绑定到controller的目录
    private let _path: String
    private let _controller: Controller
    private let _controllerName: String
    // 表示controller中的哪个方法
    private let _method: InstanceFunctionInfo
    // 参数
    private let _params: Array<String>

    private init(path: String, controller: Controller, controllerName: String, method: InstanceFunctionInfo, params: Array<String>){
        this._path = path
        this._controller = controller
        this._controllerName = controllerName
        this._method = method
        this._params = params
    }

    /**
     * 将url解析为Action类，解析失败返回Option<Action>.None
     */
    public static func get(ctx: HttpContext): ?Action{
        let url = ctx.request.url
        var path: ?String
        var controller : ?Controller
        (path, controller) = Routes.get(url)
        if(let Some(con) <- controller){
            con.ctx = ctx
            let conInfo = TypeInfo.of(con)
            let controllerName = conInfo.qualifiedName
            var methodOpt: ?InstanceFunctionInfo
            var params: Array<String>
            (methodOpt, params) = getMethodAndParams(path.getOrThrow(), con, conInfo)
            if(let Some(method) <- methodOpt){
                return Action(path.getOrThrow(), con, controllerName, method, params)
            }else{
                return None
            }
        }else{
            return None
        }
    }

    /**
     * 调用
     */
    public func invoke(): Unit{
        this._method.apply(this._controller)
    }

    /**
     * 解析将要调用Controller的方法的名称和传入参数
     */
    private static func getMethodAndParams(path: String, controller: Controller, conInfo: TypeInfo): (?InstanceFunctionInfo, Array<String>){
        let fullPath = controller.ctx.request.url.path
        var params: Array<String> = []
        // 将controllerPath部分移除
        var action = fullPath[path.size..]
        // 如果是以“/”打头，把这个打头的“/”也去掉
        if(action.startsWith("/")){
            action = action[1..]
        }
        let nodes = action.split("/")
        if(nodes.size > 0){
            // 表示URL中有后续参数，将node[0]做为Action
            action = nodes[0]
            // 但是此时action并不一定就是Controller里面的某个方法，还需要再判断
            for(fun in conInfo.instanceFunctions){
                if(fun.name == action){
                    if(nodes.size > 1 && nodes[1] != ""){
                        params = getParam(nodes[1])
                    }
                    return (fun, params)
                }
            }
        }
        // 没找到，则默认为index
        action = "index"
        for(fun in conInfo.instanceFunctions){
            if(fun.name == action){
                if(nodes.size > 0){
                    params = getParam(nodes[0])
                }
                return (fun, params)
            }
        }
        return (None, params)
    }

    /**
     * 解析传入的参数
     */
    private static func getParam(params: String): Array<String>{
        var temp = params
        // 去掉头尾的“-”
        while(temp.startsWith("-")){
            temp = temp[1..]
        }
        while(temp.endsWith("-")){
            temp = temp[..temp.size - 1]
        }
        let paramList = temp.split("-")
        return paramList
    }

    public prop controller: Controller{
        get(){
            this._controller
        }
    }

    public prop path: String{
        get(){
            this._path
        }
    }

    public prop controllerName: String{
        get(){
            this._controllerName
        }
    }

    /**
     * 获取方法名称
     */
    public prop method: String{
        get(){
            this._method.name
        }
    }

    public prop params: Array<String>{
        get(){
            this._params
        }
    }
}