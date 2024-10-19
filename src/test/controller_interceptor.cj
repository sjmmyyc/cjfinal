/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{Interceptor, Controller, Invocation}

public class ControllerInterceptor <: Interceptor{

    public func say(){
        println("我是控制器级的拦截器")
    }

    public func intercept(inv: Invocation): Unit{
        println("Controller Level Before")
        inv.invoke()
        println("Controller Level After")
    }
}