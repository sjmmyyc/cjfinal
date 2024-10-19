/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{Interceptor, Controller, Invocation}

public class GlobalInterceptor <: Interceptor{

    public func intercept(inv: Invocation): Unit{
        println("Global Level Before")
        inv.invoke()
        println("Global Level After")
    }

    public func say(){
        println("我是全局级的拦截器")
    }
}