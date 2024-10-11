/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.test

import cjfinal.core.Controller

public class UserController <: Controller{
    public func info(){
        this.renderText("user info...")
    }
}