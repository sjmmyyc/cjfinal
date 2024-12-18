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

import net.http.HttpContext
import encoding.url.{URL, Form}
import cjfinal.exception.NotFoundException
import cjfinal.aop.{Before, Clear}
import cjfinal.kit.ObjectKit
import std.reflect.{TypeInfo, InstanceFunctionInfo}
import std.collection.ArrayList

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
    private let _interceptors: Array<Interceptor>

    private init(path: String, con: Controller, controllerName: String, method: InstanceFunctionInfo, interceptors: Array<Interceptor>){
        this._path = path
        this._controller = con
        this._controllerName = controllerName
        this._method = method
        this._interceptors = interceptors
    }

    /**
     * 将url解析为Action类，解析失败返回Option<Action>.None
     */
    public static func get(ctx: HttpContext): ?Action{
        var result: ?Action = None
        let url = ctx.request.url
        var path: ?String
        var controller : ?Controller
        (path, controller) = Routes.get(url)
        if(let Some(con) <- controller){
            con.ctx = ctx
            con.form = ctx.request.form
            
            let conInfo = TypeInfo.of(con)
            let controllerName = conInfo.qualifiedName
            var methodOpt: ?InstanceFunctionInfo
            var params: Array<String>
            (methodOpt, params) = getMethodAndParams(path.getOrThrow(), con, conInfo)
            if(let Some(method) <- methodOpt){
                con.param = params
                var interceptors = ArrayList<Interceptor>()
                // 获取全局拦截器
                interceptors.appendAll(CJFinal.me.interceptors.interceptors)
                // 清除拦截器
                removeInterceptors(interceptors, conInfo)
                // 获取controller级的拦截器
                interceptors.appendAll(findInterceptors(conInfo))
                // 清除上层拦截器
                removeInterceptors(interceptors, method)
                // 获取method级拦截器
                interceptors.appendAll(findInterceptors(method))
                
                result = Action(path.getOrThrow(), con, controllerName, method, interceptors.toArray())
            }
        }
        return result
    }

    /**
     * 调用Action，拦截器将生效
     */
    public func invoke(): Unit{
        Invocation(this).invoke()
    }

    /**
     * 调用Action方法，拦截器不生效
     */
    public func call(): Unit{
        this._method.apply(this._controller)
    }

    /**
     * 根据传入的typeInfo获取套在其上的拦截器列表
     */
    private static func findInterceptors(typeInfo: TypeInfo): Array<Interceptor>{
        let list = ArrayList<Interceptor>()
        if(let Some(anno) <- typeInfo.findAnnotation<Before>()){
            for(str in anno.get()){
                if(let Some(intcept) <- (ObjectKit.new(str) as Interceptor)){
                    list.append(intcept)
                }
            }
        }
        return list.toArray()
    }

    /**
     * 控制器级：移除拦截器
     */
    private static func removeInterceptors(interceptors: ArrayList<Interceptor>, conInfo: TypeInfo): Unit{
        if(let Some(anno) <- conInfo.findAnnotation<Clear>()){
            let its = anno.get()
            if(its.size == 0){
                interceptors.clear()
            }else {
                for(str in anno.get()){
                    interceptors.removeIf({intcept =>
                        return TypeInfo.of(intcept).qualifiedName == str
                    })
                }
            }
        }
    }

    /**
     * 根据传入的InstanceFunctionInfo获取套在其上的拦截器列表
     */
    private static func findInterceptors(funcInfo: InstanceFunctionInfo): Array<Interceptor>{
        let list = ArrayList<Interceptor>()      
        if(let Some(anno) <- funcInfo.findAnnotation<Before>()){
            for(str in anno.get()){
                if(let Some(intcept) <- (ObjectKit.new(str) as Interceptor)){
                    list.append(intcept)
                }
            }
        }
        return list.toArray()
    }

    /**
     * 方法级：移除拦截器
     */
    private static func removeInterceptors(interceptors: ArrayList<Interceptor>, funcInfo: InstanceFunctionInfo): Unit{
        if(let Some(anno) <- funcInfo.findAnnotation<Clear>()){
            let its = anno.get()
            if(its.size == 0){
                // 移除全部
                interceptors.clear()
            }else{
                for(str in its){
                    interceptors.removeIf({intcept =>
                        return TypeInfo.of(intcept).qualifiedName == str
                    })
                }
            }
        }
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
            this.controller.param
        }
    }

    public prop interceptors: Array<Interceptor>{
        get(){
            this._interceptors
        }
    }

    public prop form: Form{
        get(){
            this._controller.form
        }
    }
}