/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{CJFinalConfig, Constants, Routes}

public class TestConfig <: CJFinalConfig{

    public func configConstants(me: Constants): Unit{
        me.devMode = true
    }

    public func configRoutes(me: Routes): Unit{
        me.add("/", RootController())
        me.add("/user", UserController())
    }
}