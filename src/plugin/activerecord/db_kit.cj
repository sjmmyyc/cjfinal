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

import std.collection.{Map, HashMap, ArrayList}
import std.math.numeric.Decimal
import std.time.DateTime
import std.database.sql.*
import std.reflect.TypeInfo

/**
 * DbKit用于管理多数据源和其配置信息
 */
public class DbKit{

    public static let MAIN_CONFIG_NAME = "main"
    private static let configs: Map<String, Config> = HashMap<String, Config>()
    
    /**
     * 添加数据源配置
     */
    public static func addConfig(name: String, config: Config): Unit{
        configs.put(name, config)
        // 如果此时只有一个数据源配置项，便将其设置为Db的主DbPro
        if(configs.size == 1){
            Db.setMain(config)
        }
    }

    /**
     * 获取数据源配置
     */
    public static func getConfig(name: String): Config{
        return configs.get(name).getOrThrow()
    }

    /**
     * 移除数据源配置
     */
    public static func removeConfig(name: String): Config{
        let config = configs.remove(name).getOrThrow()
        Db.removeDbPro(config)
        return config
    }

    /**
     * 将Any类型的值转换成SqlDbType类型
     * @Throw UnsupportedException - 无法转换时抛出该异常
     */
    public static func toSqlDbType(value: Any): SqlDbType{
        match(value){
            case v: String => SqlVarchar(v)
            case v: Int8 => SqlByte(v)
            case v: Int16 => SqlSmallInt(v)
            case v: Int32 => SqlInteger(v)
            case v: Int64 => SqlBigInt(v)
            case v: Float32 => SqlReal(v)
            case v: Float64 => SqlDouble(v)
            case v: Decimal => SqlDecimal(v)
            case v: DateTime => SqlTimestamp(v)
            case v: Bool => SqlBool(v)

            case v: ?String => SqlNullableVarchar(v)
            case v: ?Int8 => SqlNullableByte(v)
            case v: ?Int16 => SqlNullableSmallInt(v)
            case v: ?Int32 => SqlNullableInteger(v)
            case v: ?Int64 => SqlNullableBigInt(v)
            case v: ?Float32 => SqlNullableReal(v)
            case v: ?Float64 => SqlNullableDouble(v)
            case v: ?Decimal => SqlNullableDecimal(v)
            case v: ?DateTime => SqlNullableTimestamp(v)
            case v: ?Bool => SqlNullableBool(v)
            case _ => throw UnsupportedException("Unsupported type ${TypeInfo.of(value)}")
        }
    }
    
    /**
     * 将Array<Any>转换成ArrayList<SqlDbType>
     */
    public static func getSqlDbTypeList(params: ArrayList<Any>): ArrayList<SqlDbType>{
        let list = ArrayList<SqlDbType>()
        for(param in params){
            list.append(DbKit.toSqlDbType(param))
        }
        return list
    }

    /**
     * 根据Array<ColumnInfo>获取Array<SqlDbType>
     */
    public static func getSqlDbTypeList(columnInfoArray: Array<ColumnInfo>): Array<SqlDbType>{
        let list = ArrayList<SqlDbType>()
        for(columnInfo in columnInfoArray){
            match(columnInfo.typeName){
                case "SqlNullableBigInt" | "SqlBigInt" => list.append(SqlNullableBigInt(None))
                case "SqlNullableBlob" | "SqlBlob" => list.append(SqlNullableBlob(None))
                case "SqlNullableBool" | "SqlBool" => list.append(SqlNullableBool(None))
                case "SqlNullableByte" | "SqlByte" => list.append(SqlNullableByte(None))
                case "SqlNullableChar" | "SqlChar" => list.append(SqlNullableChar(None))
                case "SqlNullableClob" | "SqlClob" => list.append(SqlNullableClob(None))
                case "SqlNullableDate" | "SqlDate" => list.append(SqlNullableDate(None))
                case "SqlNullableDecimal" | "SqlDecimal" => list.append(SqlNullableDecimal(None))
                case "SqlNullableDouble" | "SqlDouble" => list.append(SqlNullableDouble(None))
                case "SqlNullableInteger" | "SqlInteger" => list.append(SqlNullableInteger(None))
                case "SqlNullableInterval" | "SqlInterval" => list.append(SqlNullableInterval(None))
                case "SqlNullableReal" | "SqlReal" => list.append(SqlNullableReal(None))
                case "SqlNullableSmallInt" | "SqlSmallInt" => list.append(SqlNullableSmallInt(None))
                case "SqlNullableTime" | "SqlTime" => list.append(SqlNullableTime(None))
                case "SqlNullableTimestamp" | "SqlTimestamp" => list.append(SqlNullableTimestamp(None))
                case "SqlNullableTimeTz" | "SqlTimeTz" => list.append(SqlNullableTimeTz(None))
                case "SqlNullableVarBinary" | "SqlVarBinary" => list.append(SqlNullableVarBinary(None))
                case "SqlNullableVarchar" | "SqlVarchar" => list.append(SqlNullableVarchar(None))
                case _ => throw UnsupportedException("Unsupported type ${columnInfo.typeName}")
            }
        }
        return list.toArray()
    }

    /**
     * 获取传入的SqlDbType类型的值
     */
    public static func getValue<T>(sqlDbType: SqlDbType): ?T{
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
    }
}