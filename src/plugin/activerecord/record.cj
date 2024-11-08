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
import std.time.DateTime
import std.io.InputStream
import std.math.numeric.Decimal
import std.database.sql.{SqlDbType, SqlNullableBigInt, SqlNullableBinary, SqlNullableBlob, SqlNullableBool, 
        SqlNullableByte, SqlNullableChar, SqlNullableClob, SqlNullableDate, SqlNullableDecimal, SqlNullableDouble,
        SqlNullableInteger, SqlNullableInterval, SqlNullableReal, SqlNullableSmallInt, SqlNullableTime, 
        SqlNullableTimestamp, SqlNullableTimeTz, SqlNullableVarBinary, SqlNullableVarchar}

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

    public func setBigInt(column: String, value: ?Int): Record{
        _columns.put(column, SqlNullableBigInt(value))
        return this
    }

    public func setBinary(column: String, value: ?Array<Byte>): Record{
        _columns.put(column, SqlNullableBinary(value))
        return this
    }

    public func setBlob(column: String, value: ?InputStream): Record{
        _columns.put(column, SqlNullableBlob(value))
        return this
    }

    public func setBool(column: String, value: ?Bool): Record{
        _columns.put(column, SqlNullableBool(value))
        return this
    }

    public func setByte(column: String, value: ?Int8): Record{
        _columns.put(column, SqlNullableByte(value))
        return this
    }

    public func setChar(column: String, value: ?String): Record{
        _columns.put(column, SqlNullableChar(value))
        return this
    }

    public func setClob(column: String, value: ?InputStream): Record{
        _columns.put(column, SqlNullableClob(value))
        return this
    }

    public func setDate(column: String, value: ?DateTime): Record{
        _columns.put(column, SqlNullableDate(value))
        return this
    }

    public func setDecimal(column:String, value: ?Decimal): Record{
        _columns.put(column, SqlNullableDecimal(value))
        return this
    }

    public func setDouble(column: String, value: ?Float64): Record{
        _columns.put(column, SqlNullableDouble(value))
        return this
    }

    public func setInteger(column: String, value: ?Int32): Record{
        _columns.put(column, SqlNullableInteger(value))
        return this
    }

    public func setInterval(column: String, value: ?Duration): Record{
        _columns.put(column, SqlNullableInterval(value))
        return this
    }

    public func setReal(column: String, value: ?Float32): Record{
        _columns.put(column, SqlNullableReal(value))
        return this
    }

    public func setSmallInt(column: String, value: ?Int16): Record{
        _columns.put(column, SqlNullableSmallInt(value))
        return this
    }

    public func setTime(column: String, value: ?DateTime): Record{
        _columns.put(column, SqlNullableTime(value))
        return this
    }

    public func setTimestamp(column: String, value: ?DateTime): Record{
        _columns.put(column, SqlNullableTimestamp(value))
        return this
    }

    public func setDateTime(column: String, value: ?DateTime): Record{
        setTimestamp(column, value)
        return this
    }

    public func setTimeTz(column: String, value: ?DateTime): Record{
        _columns.put(column, SqlNullableTimeTz(value))
        return this
    }

    public func setVarBinary(column: String, value: ?Array<Byte>): Record{
        _columns.put(column, SqlNullableVarBinary(value))
        return this
    }

    public func setVarchar(column: String, value: ?String): Record{
        _columns.put(column, SqlNullableVarchar(value))
        return this
    }
}