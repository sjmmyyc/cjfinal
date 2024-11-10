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

import std.collection.{Map, HashMap}
import std.database.sql.*
import std.reflect.TypeInfo
import std.convert.Parsable

/**
 * Record.
 */
public class Record{

    private let _columns: Map<String, SqlDbType> = HashMap<String, SqlDbType>()

    public prop columns: Map<String, SqlDbType>{
        get(){
            return _columns
        }
    }

    public func set(column: String, value: Any): Record{
        _columns.put(column, DbKit.toSqlDbType(value))
        return this
    }

    public func set(column: String, value: SqlDbType): Record{
        _columns.put(column, value)
        return this
    }

    public func getNullable<T>(column: String): ?T{
        if(let Some(sqlDbType) <- columns.get(column)){
            return DbKit.getValue<T>(sqlDbType)
        }else{
            return None
        }
    }

    public func get<T>(column: String): T{
        if(let Some(val) <- getNullable<T>(column)){
            return val
        }else{
            throw NoneValueException("${column}'s value is None.")
        }
    }
}