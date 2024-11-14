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

import std.time.DateTime

/**
 * Task.
 */
public abstract class Task{

    var _cornExpr: ?CronExpr = None

    var _nextExceteTime: ?DateTime = None

    var _nextTime: ?DateTime = None

    protected mut prop cronExpr: CronExpr{
        set(value){
            _cornExpr = value
            _nextTime = _cornExpr?.next(DateTime.now())
        }
        get(){
            return _cornExpr.getOrThrow()
        }
    }

    protected prop nextTime: DateTime{
        get(){
            return _nextTime.getOrThrow()
        }
    }

    /**
     * 以传入的时间更新下一次执行的时间
     */
    public func updateNextTime(date: DateTime): Unit{
        _nextTime = _cornExpr?.next(date)
    }

    public func run(): Unit
}