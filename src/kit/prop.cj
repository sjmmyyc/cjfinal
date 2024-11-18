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
package cjfinal.kit

import cjfinal.exception.NotFoundException

import std.collection.HashMap
import std.io.StringReader
import std.fs.{File, OpenOption}

/**
 * Prop用于读取配置文件
 */
public class Prop{

    // 从配置文件中读取的信息都以键值对儿的形式保存在此
    private let kv = HashMap<String, String>()

    /**
     * 构造器
     * @param path 配置文件的相对路径，相对于当前运行目录
     */
    public init(path: String){
        if(File.exists(path)){
            read(path)
        }else{
            throw NotFoundException('File "${path}" not found!')
        }
    }

    /**
     * 追加配置文件，方便在开发模式和生产模式中使用不同的配置文件
     */
    public func appendIfExist(path: String): Prop{
        if(File.exists(path)){
            read(path)
        }
        return this
    }

    /**
     * 获取配置项的值，如果没有相关配置项，返回None
     */
    public func get(key: String): ?String{
        return this.kv.get(key)
    }

    /**
     * 读取配置文件，并将信息存储起来
     */
    private func read(path: String){
        // try-with-resource块，结束时自动释放文件
        try(file = File(path, OpenOption.Open(true, false))){
            let reader = StringReader(file)
            while(let Some(line) <- reader.readln()){
                // 只有当不是空白行，且以“//”开始的行，才进行处理
                if(line.trimAscii().size != 0 && !line.startsWith("//")){
                    // 将line以“=”分割
                    let list = line.split("=")
                    this.kv.put(list[0].trimAscii(), list[1].trimAscii())
                }
            }
        }
    }
}