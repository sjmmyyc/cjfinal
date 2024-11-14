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
package cjfinal.plugin.cron

import cjfinal.plugin.IPlugin

/**
 * CronPlugin.定时任务调度插件
 */
public class CronPlugin <: IPlugin{

    private var _isStarted = false
    private var _scheduler = Scheduler.get()

    /**
     * 添加定时任务
     */
    public func addTask(exprStr: String, task: Task): Unit{
        task.cronExpr = CronExpr(exprStr)
        _scheduler.addTask(task)
    }

     /**
     * 启动插件
     */
    public override func start(): Bool{
        if(_isStarted){
            return true
        }
        _scheduler.start()
        _isStarted = true
        return true
    }

    /**
     * 停止插件
     */
    public override func stop(): Bool{
        _scheduler.stop()
        _isStarted = false
        return true
    }
}