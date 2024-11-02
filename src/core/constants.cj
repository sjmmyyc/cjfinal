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

/**
 * CJFinal运行时常量
 */
public class Constants{

    // 是否开发模式
    public mut prop devMode: Bool{
        set(value){
            Config.DEV_MODE = value
            println("Set \u{1b}[32mdevMode\u{1b}[0m = \u{1b}[32m${Config.DEV_MODE}\u{1b}[0m")
        }
        get(){
            return Config.DEV_MODE
        }
    }

    // 最大上传文件大小
    public mut prop maxUploadSize: Int {
        set(value){
            Config.MAX_UPLOAD_SIZE = value
            println("Set \u{1b}[32mmaxUploadSize\u{1b}[0m = \u{1b}[32m${Config.MAX_UPLOAD_SIZE / 1024 / 1024}MB\u{1b}[0m")
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
            println("Set \u{1b}[32muploadBufferCapacity\u{1b}[0m = \u{1b}[32m${Config.UPLOAD_BUFFER_CAPACITY / 1024}KB\u{1b}[0m")
        }
        get(){
            return Config.UPLOAD_BUFFER_CAPACITY
        }
    }
}