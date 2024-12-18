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
import cjfinal.aop.{Clear, None}
import cjfinal.plugin.activerecord.{Record, Db}
import std.time.DateTime
import std.database.sql.{SqlNullableDouble, SqlNullableDecimal, SqlNullableDate, SqlNullableTime, SqlNullableTimestamp}
import std.math.numeric.Decimal
import std.collection.ArrayList

@None
public class UserController <: Controller{

    @None
    public func index(){
        this.renderText("user index...")
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
        // let now = DateTime.now()
        // let test = Record()
        //     .set("id", 20)
        //     .set("varcharCol", Option<String>.None)
        //     .set("intCol", Option<Int>.None)
        //     .set("doubleCol", 100.1)
        //     .set("decimalCol", Decimal(202.2))
        //     .set("dataCol", Option<DateTime>.None)
        //     .set("timeCol", now)
        //     .set("datatimeCol", now)
        //     .set("boolCol", false)
        // let result = Db.update("simple", test)
        let result = Db.update("update simple set boolCol=?", 1)
        this.renderText("update. lastInsertId: ${result.lastInsertId} rowCount: ${result.rowCount}")
    }

    @Clear[""]
    public func get(){
        let idVal = this.getParamTo<Int>(0)
        let record = Db.findFirst("select * from simple where id=?", idVal)
        // let id = record.get<Int32>("id")
        // let varcharCol = record.get<String>("varcharCol")
        // let intCol = record.get<Int32>("intCol")
        // let doubleCol = record.get<Float64>("doubleCol")
        // let decimalCol = record.get<Decimal>("decimalCol")
        // let dataCol = record.get<DateTime>("dataCol").toString("yyyy-MM-dd")
        // let timeCol = record.get<DateTime>("timeCol").toString("HH:mm:ss")
        // let datatimeCol = record.get<DateTime>("datatimeCol").toString("yyyy-MM-dd HH:mm:ss")
        // let boolCol = record.get<Bool>("boolCol")
        // this.renderText("id: ${id}\nvarcharCol: ${varcharCol}\nintCol: ${intCol}\ndoubleCol: ${doubleCol}\ndecimalCol: ${decimalCol}\ndataCol: ${dataCol}\ntimeCol: ${timeCol}\ndatatimeCol: ${datatimeCol}\nboolCol: ${boolCol}")
        this.renderJson(record)
    }

    @Clear[""]
    public func list(){
        let recordList = Db.find("select * from simple")
        // let result = StringBuilder()
        // for(record in recordList){
        //     let id = record.get<Int32>("id")
        //     let varcharCol = record.get<String>("varcharCol")
        //     let intCol = record.get<Int32>("intCol")
        //     let doubleCol = record.get<Float64>("doubleCol")
        //     let decimalCol = record.get<Decimal>("decimalCol")
        //     let dataCol = record.get<DateTime>("dataCol")
        //     let timeCol = record.get<DateTime>("timeCol")
        //     let datatimeCol = record.get<DateTime>("datatimeCol")
        //     let boolCol = record.get<Bool>("boolCol")
        //     result.append("id: ${id}\tvarcharCol: ${varcharCol}\tintCol: ${intCol}\tdoubleCol: ${doubleCol}\tdecimalCol: ${decimalCol}\tdataCol: ${dataCol}\ttimeCol: ${timeCol}\tdatatimeCol: ${datatimeCol}\tboolCol: ${boolCol}\n")
        // }
        // this.renderText(result.toString())
        this.renderJson(recordList)
    }

    @Clear[""]
    public func query(){
        // 获得单列列表
        // let list = Db.queryList<String>("select varcharCol from simple where boolCol is null")
        // this.renderText(list.toString())
        let count = Db.query<Int>("select count(*) from simple")
        this.renderText("count: ${count}")
    }

    @Clear[""]
    public func tx(){
        let result = Db.tx({ => 
            Db.update("update simple set doubleCol=?", 12)
            let record = Record().set("varcharCol", "Transaction")
            Db.save("simple", record)
            // 返回 true 提交，返回 false 回滚
            return false
        })
        this.renderText("Db.tx()..${result}")
    }

    @None
    public func page(){
        let pageNumber = this.getParamTo<Int>(0)
        let pageSize = this.getParamTo<Int>(1)
        let page = Db.paginate(pageNumber, pageSize, "select *", "from simple")
        this.renderJson(page)
    }
}