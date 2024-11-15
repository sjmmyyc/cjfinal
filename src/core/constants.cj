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
package cjfinal.core

import cjfinal.config.Config
import log.{LogLevel}

/**
 * CJFinal运行时常量
 */
public class Constants{

    // 是否开发模式
    public mut prop devMode: Bool{
        set(value){
            Config.DEV_MODE = value
        }
        get(){
            return Config.DEV_MODE
        }
    }

    public mut prop uploadPath: String{
        set(value){
            Config.UPLOAD_PATH = value
        }
        get(){
            return Config.UPLOAD_PATH
        }
    }

    // 最大上传文件大小
    public mut prop maxUploadSize: Int {
        set(value){
            Config.MAX_UPLOAD_SIZE = value
        }
        get(){
            return Config.MAX_UPLOAD_SIZE
        }
    }

    // 上传文件缓冲区大小，最低为128
    public mut prop uploadBufferCapacity: Int{
        set(value){
            var v = value
            if(v < 128){
                v = 128
            }
            Config.UPLOAD_BUFFER_CAPACITY = v
        }
        get(){
            return Config.UPLOAD_BUFFER_CAPACITY
        }
    }

    /**
     * 日志打印的七个级别，级别从低到高分别为 OFF、 FATAL、ERROR、WARN、INFO、DEBUG、TRACE、ALL。
     * 只有级别小于等于指定打印级别的日志条目会被打印到输出流中
     */
    public mut prop logLevel: String{
        set(value){
            let v = value.toAsciiLower()
            match(v){
                case "all" => Config.LOG_LEVEL = LogLevel.ALL
                case "trace" => Config.LOG_LEVEL = LogLevel.TRACE
                case "debug" => Config.LOG_LEVEL = LogLevel.DEBUG
                case "info" => Config.LOG_LEVEL = LogLevel.INFO
                case "warn" => Config.LOG_LEVEL = LogLevel.WARN
                case "error" => Config.LOG_LEVEL = LogLevel.ERROR
                case "fatal" => Config.LOG_LEVEL = LogLevel.FATAL
                case "off" => Config.LOG_LEVEL = LogLevel.OFF
                case _ => Config.LOG_LEVEL = LogLevel.ALL
            }
        }
        get(){
            return Config.LOG_LEVEL.name
        }
    }
}