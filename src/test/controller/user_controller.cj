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
package cjfinal.test.controller

import cjfinal.core.Controller
import cjfinal.aop.Clear
import cjfinal.plugin.activerecord.{Record, Db}
import std.time.DateTime
import std.database.sql.{SqlNullableDouble, SqlNullableDecimal, SqlNullableDate, SqlNullableTime, SqlNullableTimestamp}
import std.math.numeric.Decimal

public class UserController <: Controller{
    public func index(){
        this.renderText("user index...")
    }

    public func list(){
        this.renderText("user list...")
    }

    @Clear[""]
    public func add(){
        let now = DateTime.now()
        let test = Record()
            .setString("varcharCol", None)
            .setBigInt("intCol", 12)
            .setFloat64("doubleCol", 10.1)
            .setDecimal("decimalCol", Decimal(20.2))
            .setDate("dataCol", None)
            .setTime("timeCol", now)
            .setDateTime("datatimeCol", now)
            .setBool("boolCol", false)
        let result = Db.save("simple", test)
        this.renderText("add user...${result.lastInsertId}")
    }

    @Clear[""]
    public func del(){
        
    }
}