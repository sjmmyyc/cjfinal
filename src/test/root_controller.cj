/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{Controller, Before}

@Before["cjfinal.test.ControllerInterceptor"]
public class RootController <: Controller{
    public func index(){
        this.renderText("index")
    }
}