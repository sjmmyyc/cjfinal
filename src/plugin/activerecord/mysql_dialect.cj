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
package cjfinal.plugin.activerecord

import std.collection.ArrayList
import std.database.sql.{SqlDbType, SqlNullableVarchar, SqlNullableBigInt}
import std.reflect.TypeInfo

/**
 * MysqlDialect.
 */
public class MysqlDialect <: Dialect{

    public func forDbSave(sql: StringBuilder, tableName: String, record: Record, params: ArrayList<SqlDbType>): Unit{
        // 拼接sql
        sql.append("insert into `${tableName}`(")
        let keys = record.columns.keys()
        var index = 1
        for(key in keys){
            if(index < keys.size){
                sql.append("`${key}`, ")
            }else{
                sql.append("`${key}`) ")
            }
            index++
        }
        sql.append("values(")
        index = 1
        for(key in keys){
            if(index < keys.size){
                sql.append("?, ")
            }else{
                sql.append("?) ")
            }
            index++
        }
        // 计算params
        for(key in keys){
            params.append(record.columns.get(key).getOrThrow())
        }
    }

    public func forDbDelete(sql: StringBuilder, tableName: String, record: Record, params: ArrayList<SqlDbType>): Unit{
        // 拼接sql
        sql.append("delete from `${tableName}` where ")
        let keys = record.columns.keys()
        var index = 1
        for(key in keys){
            let value = record.columns.get(key).getOrThrow()   
            let isNone = isNone(value)
            if(index == 1){
                if(!isNone){
                    sql.append("`${key}`=?")
                }else{
                    sql.append("`${key}` is null")
                }
            }else{
                if(!isNone){
                    sql.append(" and `${key}`=?")
                }else{
                    sql.append(" and `${key}` is null")
                }
            }
            if(!isNone){
                params.append(record.columns.get(key).getOrThrow())
            }
            index++
        }
    }
}