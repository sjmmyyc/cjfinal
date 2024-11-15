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

import encoding.url.{URL, Form}
import net.http.{Server, ServerBuilder, HttpContext, HttpStatusCode}
import std.collection.{Map, HashMap, HashSet, ArrayList}
import std.reflect.TypeInfo
import cjfinal.config.Config

/**
 * ActionHandler
 * 用于处理一切请求，将请求解析为Action对象
 */
public class ActionHandler <: Handler{

    public func handle(ctx: HttpContext): Unit{
        if(let Some(action) <- Action.get(ctx)){
            action.invoke()
            if(Config.DEV_MODE){
                println("------------------------------ Action Handler ------------------------------")
                println("URL:\t\t${ctx.request.url}")
                println("Controller:\t[${action.path}] ${action.controllerName}")
                println("Method:\t\t${action.method}")
                if(action.interceptors.size > 0){
                    print("Interceptors:\t")
                    var index = 0
                    for(interceptor in action.interceptors){
                        let info = TypeInfo.of(interceptor)
                        if(index == 0){
                            println("${info}")
                        }else{
                            println("\t\t${info}")
                        }
                        index++
                    }
                }
                if(action.params.size != 0){
                    println("Param(Request):\t${action.params}")
                }
                if(!action.form.isEmpty()){
                    println("Param(Form):\t${getFormString(action.form)}")
                }
                println("------------------------------------ End -----------------------------------\n")
            }
        }else{
            println("request: ${ctx.request.url} is not found.")
            let responst = ctx.responseBuilder
            responst.status(HttpStatusCode.STATUS_NOT_FOUND)
            responst.body("404 - Not Found")
        }
    }

    /**
     * 将请求中的Form参数以字符串形式展现
     */
    private func getFormString(form: Form): String{
        var str = ""
        // 从url中获取参数的Key数组
        for((key, count) in getFormKeys(form)){
            if(count == 1){
                str += key + "=" + (form.get(key).getOrDefault({=>""})) + " "
            }else{
                str += key + "=" + (form.getAll(key).toString()) + " "
            }
        }
        return str
    }

    /**
     * 解析请求参数
     * @return Map<String, Int64> String表示Key，Int64表示Key出现的次数
     */
    private func getFormKeys(form: Form): Map<String, Int64>{
        let set = HashSet<String>()
        let paramStr = form.toEncodeString()
        let params = paramStr.split("&")
        var keyStr = ""
        for(p in params){
            let key = p.split("=")[0]
            set.put(key)
            keyStr += key + ","
        }
        if(keyStr.endsWith(",")){
            keyStr = keyStr[..keyStr.size-1]
        }
        let map = HashMap<String, Int64>()
        for(key in set){
            map.put(key, getCount(key, keyStr))
        }
        return map
    }

    private func getCount(query: String, sourceStr: String): Int64{
        var count = 0
        for(str in sourceStr.split(",") where str == query){
            count++
        }
        return count
    }
}