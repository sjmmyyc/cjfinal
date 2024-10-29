/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 *
 * CJFinal is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *      http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 *
 *      Mulan Permissive Software License，Version 2
 *
 * Mulan Permissive Software License，Version 2 (Mulan PSL v2)
 * January 2020 http://license.coscl.org.cn/MulanPSL2
 */
package cjfinal.test

import cjfinal.core.{CJFinalConfig, Constants, Routes, Interceptors, Handlers}
import cjfinal.kit.PropKit
import cjfinal.test.controller.{RootController, UserController}
import cjfinal.test.interceptor.GlobalInterceptor
import cjfinal.test.handler.{CORSHandler, TestHandler}

public class TestConfig <: CJFinalConfig{

    public func configConstants(me: Constants): Unit{
        PropKit.use("./config/config").appendIfExist("./config/config-pro")
        me.devMode = PropKit.getByDefaultTo<Bool>("devMode", false)
    }

    public func configRoute(me: Routes): Unit{
        me.add("/", RootController())
        me.add("/user", UserController())
    }

    public func configInterceptor(me: Interceptors): Unit{
        me.add(GlobalInterceptor())
    }

    public func configHandler(me: Handlers): Unit{
        me.add(CORSHandler())
        me.add(TestHandler())
    }

    public func onStart(): Unit{
        println("on server start...")
    }

    public func onStop(): Unit{
        println("before server stop...")
    }
}