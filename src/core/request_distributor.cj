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

import net.http.{HttpRequestDistributor, HttpRequestHandler, HttpContext, FuncHandler}

/**
 * Http请求分发器
 * 由于仓颉默认实现不能将所有请求交由一个统一的handler来处理
 * 故重新实现HttpRequestDistributor接口，让所有请求都进入到统一入口
 */
public class RequestDistributor <: HttpRequestDistributor{
    // 无意义，只是为了屏蔽编译器的“unused variable”提示
    private var path: ?String
    // http请求处理器
    private var handler: ?HttpRequestHandler

    public init(){
        this.path = None
        this.handler = None
    }

    /**
     * 注意：该方法未实现，禁止调用
     */
    public func distribute(path: String): HttpRequestHandler{
        this.path = path
        return handler.getOrThrow()
    }

    /**
     * 注意：该方法无实际意义，仅仅是为了满足实现接口方法，调用时，参数path应该始终为“/”
     * 这样就将所有请求都交由handler来处理了
     */
    public func register(path: String, handler: (HttpContext) -> Unit): Unit{
        this.path = path
        this.register(path, FuncHandler(handler))
    }

    /**
     * 注意：该方法无实际意义，仅仅是为了满足实现接口方法，调用时，参数path应该始终为“/”
     * 这样就将所有请求都交由handler来处理了
     */
    public func register(path: String, handler: HttpRequestHandler): Unit{
        this.path = path
        this.handler = handler
    }
}