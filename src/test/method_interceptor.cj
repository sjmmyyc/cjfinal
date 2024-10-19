package cjfinal.test

import cjfinal.core.Interceptor
import cjfinal.core.Controller

public class MethodInterceptor <: Interceptor{

    public func before(_: Controller): Bool{
        println("Method level Before")
        return true
    }

    public func after(_: Controller): Bool{
        println("Method level After")
        return true
    }
}