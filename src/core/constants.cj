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

    public mut prop logLevel: LogLevel{
        set(value){
            Config.LOG_LEVEL = value
        }
        get(){
            return Config.LOG_LEVEL
        }
    }
}