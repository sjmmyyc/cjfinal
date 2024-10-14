/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.Controller

public class UserController <: Controller{
    public func index(){
        this.renderText("user index...")
    }

    public func list(){
        this.renderText("user list...")
    }
}