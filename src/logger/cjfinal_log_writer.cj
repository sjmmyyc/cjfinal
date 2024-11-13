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
package cjfinal.logger

import log.{LogWriter, LogValue}
import std.time.DateTime
import std.io.OutputStream

/**
 * CJFinalLogWriter.
 */
public class CJFinalLogWriter <: LogWriter{

    private let out: OutputStream

    init(out: OutputStream){
        this.out = out
    }

    public func writeNone(): Unit {
        out.write("None".toArray())
    }
    public func writeInt(v: Int64): Unit {
        out.write(v.toString().toArray())
    }
    public func writeUInt(v: UInt64): Unit {
        out.write(v.toString().toArray())
    }
    public func writeBool(v: Bool): Unit {
        out.write(v.toString().toArray())
    }
    public func writeFloat(v: Float64): Unit {
        out.write(v.toString().toArray())
    }
    public func writeString(v: String): Unit {
        out.write(v.toArray())
    }
    public func writeDateTime(v: DateTime): Unit {
        out.write(v.toString().toArray())
    }
    public func writeDuration(v: Duration): Unit {
        out.write(v.toString().toArray())
    }
    public func writeException(v: Exception): Unit {
        out.write(v.toString().toArray())
    }
    public func writeKey(v: String): Unit {
        out.write(v.toString().toArray())
        out.write("=".toArray())
    }
    public func writeValue(v: LogValue): Unit {
        match (v) {
            case vv: String =>
                out.write("\"".toArray())
                out.write(vv.toArray())
                out.write("\"".toArray())
            case vv: ToString =>
                out.write("\"".toArray())
                out.write(vv.toString().toArray())
                out.write("\"".toArray())
            case _ =>
                out.write("\"".toArray())
                v.writeTo(this)
                out.write("\"".toArray())
        }
    }
    public func startArray(): Unit {
        out.write("[".toArray())
    }
    public func endArray(): Unit {
        out.write("]".toArray())
    }
    public func startObject(): Unit {
        out.write("{".toArray())
    }
    public func endObject(): Unit {
        out.write("}".toArray())
    }
}