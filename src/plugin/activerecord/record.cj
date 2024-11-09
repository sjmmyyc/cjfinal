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

    public func get<T>(column: String): ?T{
        if(let Some(sqlDbType) <- columns.get(column)){
            match(sqlDbType){
                case v: SqlVarchar => v.value as T
                case v: SqlByte => v.value as T
                case v: SqlSmallInt => v.value as T
                case v: SqlInteger => v.value as T
                case v: SqlBigInt => v.value as T
                case v: SqlReal => v.value as T
                case v: SqlDouble => v.value as T
                case v: SqlDecimal => v.value as T
                case v: SqlTimestamp => v.value as T
                case v: SqlTime => v.value as T
                case v: SqlDate => v.value as T

                case v: SqlNullableVarchar => if(let Some(val) <- v.value){(val as T).getOrThrow()}else{None}
                case v: SqlNullableByte =>
                    if(let Some(val) <- v.value){
                        if(TypeInfo.of<T>().name == "Bool"){
                            if(val == 0){
                                false as T
                            }else{
                                true as T
                            }
                        }else{
                            val as T
                        }
                    }else{
                        None
                    }
                case v: SqlNullableSmallInt => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableInteger => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableBigInt => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableReal => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableDouble => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableDecimal => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableTimestamp => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableTime => if(let Some(val) <- v.value){val as T}else{None}
                case v: SqlNullableDate => if(let Some(val) <- v.value){val as T}else{None}
                case _ => None
            }
        }else{
            None
        }
    }

}