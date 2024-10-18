/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.Interceptor
import cjfinal.core.Controller

public class ControllerInterceptor <: Interceptor{

    public func before(_: Controller): Bool{
        println("Controller level Before")
        return true
    }

    public func after(_: Controller): Bool{
        println("Controller level After")
        return true
    }
}