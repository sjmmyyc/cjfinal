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

import log.{Logger, LogLevel, Attr, LogRecord, setGlobalLogger}
import std.sync.{AtomicBool}
import std.time.DateTime
import std.io.{OutputStream, BufferedOutputStream}
import std.collection.ArrayList
import cjfinal.config.CmdColor

/**
 * CJFinalLogger.
 */
public class CJFinalLogger <: Logger{
    
    private let _w: CJFinalLogWriter
    private var _level = LogLevel.INFO
    private var _closed = AtomicBool(false)
    private let _bo: BufferedOutputStream<OutputStream>
    private let _attrs = ArrayList<Attr>()

    public mut prop level: LogLevel{
        set(value){
            _level = value
        }
        get(){
            return _level
        }
    }

    public init(output: OutputStream){
        _bo = BufferedOutputStream<OutputStream>(output)
        _w = CJFinalLogWriter(_bo)
    }

    public func withAttrs(attrs: Array<Attr>): Logger{
        if(attrs.size > 0){
            _attrs.appendAll(attrs)
        }
        return this
    }

    /**
     * log
     */
    public func log(level: LogLevel, msg: String, attrs: Array<Attr>): Unit{
        if(this.enabled(level)){
            let record = LogRecord(DateTime.now(), level, msg, attrs)
            log(record)
        }
    }

    /**
     * lazy
     */
    public func log(level: LogLevel, msg: () -> String, attrs: Array<Attr>): Unit{
        if(this.enabled(level)){
            let record = LogRecord(DateTime.now(), level, msg(), attrs)
            log(record)
        }
    }

    public func log(record: LogRecord): Unit{
        // write level
        // _w.writeKey("level")
        match(record.level.name){
            case "INFO" => _w.writeString("${CmdColor.white}[ INFO]")
            case "DEBUG" => _w.writeString("${CmdColor.cyan}[DEBUG]")
            case "ERROR" => _w.writeString("${CmdColor.red}[ERROR]")
            case "WARN" => _w.writeString("${CmdColor.yellow}[ WARN]")
            case "TRACE" => _w.writeString("${CmdColor.blue}[TRACE]")
            case "FATAL" => _w.writeString("${CmdColor.purple}[FATAL]")
            case _ => ()
        }
        _w.writeString(" ")
        // write time
        // _w.writeKey("time")
        _w.writeString("[${record.time.toString("yyyy-MM-dd HH:mm:ss.S")}]")
        _w.writeString(" ")
        // write message
        // _w.writeKey("msg")
        _w.writeString(record.message)
        _w.writeString(" ")
        // write source

        // write attrs
        for (i in 0..record.attrs.size) {
            let attr = record.attrs[i]
            _w.writeKey(attr[0])
            _w.writeValue(attr[1])
            if (i < record.attrs.size - 1) {
                _w.writeString(" ")
            }
        }
        _w.writeString("${CmdColor.white}\n")
        _bo.flush()
    }

    public func isClosed(): Bool{
        return _closed.load()
    }

    public func close(): Unit{
        if(isClosed()){
            return
        }
        _closed.store(true)
    }
}