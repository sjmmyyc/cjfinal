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
import serialization.serialization.{Serializable, DataModel, DataModelStruct, field, DataModelNull}

/**
 * Record.
 */
public class Record <: Serializable<Record>{

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

    public func serialize(): DataModel {
        var dms = DataModelStruct()
        for((name, sqlDbType) in _columns.toArray()){
            match(sqlDbType){
                case v: SqlNullableBigInt => dms.add(field<?Int>(name, v.value))
                case v: SqlNullableBool => dms.add(field<?Bool>(name, v.value))
                case v: SqlNullableByte => dms.add(field<?Int8>(name, v.value));
                case v: SqlNullableChar => dms.add(field<?String>(name, v.value))
                case v: SqlNullableDate => 
                    if(let Some(val) <- v.value){
                        dms.add(field<String>(name, val.toString("yyyy-MM-dd")))
                    }else{
                        dms.add(field<?String>(name, None))
                    }
                case v: SqlNullableDecimal => 
                    if(let Some(val) <- v.value){
                        dms.add(field<?Float64>(name, val.toFloat64()))
                    }else{
                        dms.add(field<?Float64>(name, None))
                    }
                case v: SqlNullableDouble => dms.add(field<?Float64>(name, v.value))
                case v: SqlNullableInteger => dms.add(field<?Int32>(name, v.value))
                case v: SqlNullableInterval => 
                    if(let Some(val) <- v.value){
                        dms.add(field<?Int>(name, val.toNanoseconds()))
                    }else{
                        dms.add(field<?Int>(name, None))
                    }
                case v: SqlNullableReal => dms.add(field<?Float32>(name, v.value))
                case v: SqlNullableSmallInt => dms.add(field<?Int16>(name, v.value))
                case v: SqlNullableTime => 
                    if(let Some(val) <- v.value){
                        dms.add(field<String>(name, val.toString("HH:mm:ss")))
                    }else{
                        dms.add(field<?String>(name, None))
                    }
                case v: SqlNullableTimestamp =>
                    if(let Some(val) <- v.value){
                        dms.add(field<String>(name, val.toString("yyyy-MM-dd HH:mm:ss")))
                    }else{
                        dms.add(field<?String>(name, None))
                    }
                case v: SqlNullableTimeTz =>
                    if(let Some(val) <- v.value){
                        dms.add(field<String>(name, val.toString("yyyy-MM-dd HH:mm:ssOOOO")))
                    }else{
                        dms.add(field<?String>(name, None))
                    }
                case v: SqlNullableVarchar => dms.add(field<?String>(name, v.value))

                case v: SqlBigInt => dms.add(field<Int>(name, v.value))
                case v: SqlBool => dms.add(field<Bool>(name, v.value))
                case v: SqlByte => dms.add(field<Int8>(name, v.value));
                case v: SqlChar => dms.add(field<String>(name, v.value))
                case v: SqlDate => dms.add(field<String>(name, v.value.toString("yyyy-MM-dd")))
                case v: SqlDecimal => dms.add(field<Float64>(name, v.value.toFloat64()))
                case v: SqlDouble => dms.add(field<Float64>(name, v.value))
                case v: SqlInteger => dms.add(field<Int32>(name, v.value))
                case v: SqlInterval => dms.add(field<Int>(name, v.value.toNanoseconds()))
                case v: SqlReal => dms.add(field<Float32>(name, v.value))
                case v: SqlSmallInt => dms.add(field<Int16>(name, v.value))
                case v: SqlTime => dms.add(field<String>(name, v.value.toString("HH:mm:ss")))
                case v: SqlTimestamp => dms.add(field<String>(name, v.value.toString("yyyy-MM-dd HH:mm:ss")))
                case v: SqlTimeTz => dms.add(field<String>(name, v.value.toString("yyyy-MM-dd HH:mm:ssOOOO")))
                case v: SqlVarchar => dms.add(field<String>(name, v.value))
                case _ => ()
            }
        }
        return dms
    }
       
    public static func deserialize(_: DataModel): Record {
        // let dms = match(dm) {
        //     case data: DataModelStruct => data
        //     case _ => throw Exception("this data is not DataModelStruct")
        // }
        var obj = Record()
        
        // obj.name = String.deserialize(dms.get("name"))
        // obj.age = Int64.deserialize(dms.get("age"))
        // obj.total = Float64.deserialize(dms.get("total"))
        // obj.isStudent = Bool.deserialize(dms.get("isStudent"))
        // obj.auths = Array < String >.deserialize(dms.get("auths"))
        return obj
    }
}