/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{Interceptor, Controller, Invocation}

public class MethodInterceptor <: Interceptor{

    public func intercept(inv: Invocation): Unit{
        println("Method Level Before")
        inv.invoke()
        println("Method Level After")
    }
}