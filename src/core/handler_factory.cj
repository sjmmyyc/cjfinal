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


/**
 * HandlerFactory.
 *
 * CJFinal将所有的请求都交由Handler来处理，通过HandlerFactory来管理用户配置的Handler和CJFinal默认的ActionHandler
 */
public class HandlerFactory{

    private init(){}

    /**
     * 构造Handler链
     * @param handlerList: Handler数组
     * @param actionHandler: 永远作为Handler链中的最后一个节点
     */
    public static func getHandler(handlerList: Array<Handler>, actionHandler: Handler): Handler{
        var result: Handler = actionHandler
        var index = 0
        for(handler in handlerList){
            index++
            if(index < handlerList.size){
                handler.next = handlerList.get(index).getOrThrow()
                result = handler
            }else{
                handler.next = actionHandler
            }
        }
        return result
    }
}