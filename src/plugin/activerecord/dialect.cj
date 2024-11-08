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
import std.database.sql.{SqlDbType, SqlNullableBigInt, SqlNullableVarchar, SqlNullableBinary, SqlNullableBlob, SqlNullableBool, SqlNullableByte, SqlNullableChar,
        SqlNullableClob, SqlNullableDate, SqlNullableDecimal, SqlNullableDouble, SqlNullableInteger, SqlNullableInterval, SqlNullableReal, SqlNullableSmallInt,
        SqlNullableTime, SqlNullableTimestamp, SqlNullableTimeTz, SqlNullableVarBinary}
import std.convert.Parsable
import std.reflect.TypeInfo

/**
 * Dialect.
 */
public abstract class Dialect{

    public func forDbSave(sql: StringBuilder, tableName: String, record: Record, params: ArrayList<SqlDbType>): Unit

    public func forDbDelete(sql: StringBuilder, tableName: String, record: Record, params: ArrayList<SqlDbType>): Unit

    func isNone(sqlType: SqlDbType): Bool{
        var isNone = false
        match(sqlType){
            case v: SqlNullableBigInt => if(v.value.isNone()){isNone = true}
            case v: SqlNullableBinary => if(v.value.isNone()){isNone = true}
            case v: SqlNullableBlob => if(v.value.isNone()){isNone = true}
            case v: SqlNullableBool => if(v.value.isNone()){isNone = true}
            case v: SqlNullableByte => if(v.value.isNone()){isNone = true}
            case v: SqlNullableChar => if(v.value.isNone()){isNone = true}
            case v: SqlNullableClob => if(v.value.isNone()){isNone = true}
            case v: SqlNullableDate => if(v.value.isNone()){isNone = true}
            case v: SqlNullableDecimal => if(v.value.isNone()){isNone = true}
            case v: SqlNullableDouble => if(v.value.isNone()){isNone = true}
            case v: SqlNullableInteger => if(v.value.isNone()){isNone = true}
            case v: SqlNullableInterval => if(v.value.isNone()){isNone = true}
            case v: SqlNullableReal => if(v.value.isNone()){isNone = true}
            case v: SqlNullableSmallInt => if(v.value.isNone()){isNone = true}
            case v: SqlNullableTime => if(v.value.isNone()){isNone = true}
            case v: SqlNullableTimestamp => if(v.value.isNone()){isNone = true}
            case v: SqlNullableTimeTz => if(v.value.isNone()){isNone = true}
            case v: SqlNullableVarBinary => if(v.value.isNone()){isNone = true}
            case v: SqlNullableVarchar => if(v.value.isNone()){isNone = true}
            case _ => throw UnsupportedException("Unsupported SqlDbType")
        }
        return isNone
    }
}