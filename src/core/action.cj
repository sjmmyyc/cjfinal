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
    private var _path: ?String = None
    private var _controller: ?Controller = None
    private var _controllerName: ?String = None
    // 表示controller中的哪个方法
    private var _method: ?InstanceFunctionInfo = None
    // 参数
    private var _param: Array<String> = []

    /**
     * 将url解析为Action类，解析失败抛出NotFoundException
     */
    public init(ctx: HttpContext){
        let url = ctx.request.url
        (this._path, _controller) = Routes.get(url)
        if(let Some(path) <- this._controller){
            this._controller?.ctx = ctx
            let conInfo = TypeInfo.of(this._controller.getOrThrow())
            this._controllerName = conInfo.qualifiedName
            this._method = getMethodAndParams(conInfo)
        }
    }

    /**
     * 解析将要调用Controller的方法的名称和传入参数
     */
    private func getMethodAndParams(conInfo: TypeInfo): ?InstanceFunctionInfo{
        let fullPath = this._controller.getOrThrow().ctx.request.url.path
        // 将controllerPath部分移除
        var action = fullPath[this._path.getOrThrow().size..]
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
                        getParam(nodes[1])
                    }
                    return fun
                }
            }
        }
        // 没找到，则默认为index
        action = "index"
        for(fun in conInfo.instanceFunctions){
            if(fun.name == action){
                if(nodes.size > 0){
                    getParam(nodes[0])
                }
                return fun
            }
        }
        return None
    }

    /**
     * 解析传入的参数
     */
    private func getParam(params: String): Unit{
        var temp = params
        // 去掉头尾的“-”
        while(temp.startsWith("-")){
            temp = temp[1..]
        }
        while(temp.endsWith("-")){
            temp = temp[..temp.size - 1]
        }
        let paramList = temp.split("-")
        this._param = paramList
    }

    /**
     * 是否是有效的Action
     */
    public prop isValid: Bool{
        get(){
            if(let None <- this._path){
                return false
            }else if(let None <- this._method){
                return false
            }else{
                return true
            }
        }
    }

    public prop controller: Controller{
        get(){
            this._controller.getOrThrow()
        }
    }

    public prop path: String{
        get(){
            this._path.getOrThrow()
        }
    }

    public prop controllerName: String{
        get(){
            this._controllerName.getOrThrow()
        }
    }

    /**
     * 获取方法名称
     */
    public prop method: String{
        get(){
            this._method.getOrThrow().name
        }
    }

    public prop params: Array<String>{
        get(){
            this._param
        }
    }
}