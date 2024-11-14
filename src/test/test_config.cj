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

import cjfinal.test.task.{MyTask, SecondTask}
import cjfinal.core.{CJFinalConfig, Constants, Routes, Interceptors, Handlers, Plugins}
import cjfinal.kit.PropKit
import cjfinal.plugin.database.DatasourcePlugin
import cjfinal.plugin.activerecord.ActiveRecordPlugin
import cjfinal.test.controller.{RootController, UserController}
import cjfinal.test.interceptor.GlobalInterceptor
import cjfinal.test.handler.{CORSHandler, TestHandler}
import log.{LogLevel, getGlobalLogger}
import cjfinal.plugin.cron.{CronPlugin}

public class TestConfig <: CJFinalConfig{

    private let logger = getGlobalLogger([("name", "main")])

    public func configConstants(me: Constants): Unit{
        PropKit.use("./configs/config").appendIfExist("./configs/config-pro")
        me.devMode = PropKit.getByDefaultTo<Bool>("devMode", false)
        // me.uploadPath = "upload/image"
        // me.maxUploadSize = 50 * 1024 * 1024
        // me.uploadBufferCapacity = 64 * 1024
        me.logLevel = PropKit.get("logLevel")
    }

    public func configRoute(me: Routes): Unit{
        me.add("/", RootController())
        me.add("/user", UserController())
    }

    public func configInterceptor(me: Interceptors): Unit{
        me.add(GlobalInterceptor())
    }

    public func configPlugin(me: Plugins): Unit{
        let dp = DatasourcePlugin("mysql://192.168.1.9:3306", "cjtest", "root", "sjmmyyc1658")
        me.add(dp)
        let arp = ActiveRecordPlugin(dp)
        me.add(arp)

        let cp = CronPlugin();
        cp.addTask("* * * * *", MyTask());
        cp.addTask("*/2 * * * *", SecondTask())
        me.add(cp);
    }

    public func configHandler(me: Handlers): Unit{
        me.add(CORSHandler())
        me.add(TestHandler())
    }

    public func onStart(): Unit{
        logger.info("on server start...")
    }

    public func onStop(): Unit{
        logger.info("before server stop...")
    }
}