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
            .set("varcharCol", "Kevin")
            .set("intCol", 12)
            .set("doubleCol", 10.1)
            .set("decimalCol", Decimal(20.2))
            .set("dataCol", now)
            .set("timeCol", now)
            .set("datatimeCol", now)
            .set("boolCol", false)
        let result = Db.save("simple", test)
        this.renderText("add. lastInsertId: ${result.lastInsertId} rowCount: ${result.rowCount}")
    }

    @Clear[""]
    public func del(){
        let record = Record()
            .set("varcharCol", Option<String>.None)
        let result = Db.delete("simple", record)
        this.renderHtml("delete. lastInsertId: ${result.lastInsertId} rowCount: ${result.rowCount}")
    }

    @Clear[""]
    public func update(){
        let now = DateTime.now()
        let test = Record()
            .set("id", 20)
            .set("varcharCol", Option<String>.None)
            .set("intCol", Option<Int>.None)
            .set("doubleCol", 100.1)
            .set("decimalCol", Decimal(202.2))
            .set("dataCol", Option<DateTime>.None)
            .set("timeCol", now)
            .set("datatimeCol", now)
            .set("boolCol", false)
        let result = Db.update("simple", test)
        // let result = Db.update("update simple set intCol=? where id=?", Option<Int>.None, 9)
        this.renderText("update. lastInsertId: ${result.lastInsertId} rowCount: ${result.rowCount}")
    }

    @Clear[""]
    public func get(){
        try{
            let record = Db.findFirst("select * from simple where id=?", 21)
            let id = record.get<Int32>("id")
            let varcharCol = record.get<String>("varcharCol")
            let intCol = record.get<Int32>("intCol")
            this.renderText("id: ${id}\nvarcharCol: ${varcharCol}\nintCol: ${intCol}")
        }catch(e: Exception){
            e.printStackTrace()
        }
    }
}