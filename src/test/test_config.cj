/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.test

import cjfinal.core.{CJFinalConfig, Constants, Routes}
import cjfinal.kit.PropKit

public class TestConfig <: CJFinalConfig{

    public func configConstants(me: Constants): Unit{
        PropKit.use("./config/config").appendIfExist("./config/config-pro")
        me.devMode = PropKit.getBoolByDefault("devMode", false)
    }

    public func configRoutes(me: Routes): Unit{
        me.add("/", RootController())
        me.add("/user", UserController())
    }
}