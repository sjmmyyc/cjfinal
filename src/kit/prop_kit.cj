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

import std.convert.Parsable

import cjfinal.exception.NotFoundException

/**
 * 配置文件读取工具
 */
public class PropKit{

    private static var props: ?Prop = None

    private init(){}

    /**
     * 选择使用哪个配置文件
     * @param path应为相对于程序根目录的相对路径
     * eg:
     * PropKit.use("config.txt")
     * var name = PropKit.get("name")
     * var password = PropKit.get("password")
     */
    public static func use(path: String): Prop{
        let p = Prop(path)
        props = p
        return p
    }

    /**
     * 获取配置项的值，返回String类型的值
     * @throw NotFoundException 当没有设置要读取的配置文件，或没找到相关配置项时招聘该异常
     */
    public static func get(key: String): String{
        var result = ""
        if(let Some(p) <- props){
            if(let Some(v) <- p.get(key)){
                result = v
            }else{
                throw NotFoundException('Configuration item "${key}" was not found.')
            }
        }else{
            throw NotFoundException("You have not loaded any configuration information yet, please use PropKit.user(file) to load configuration file")
        }
        return result
    }

    /**
     * 获取配置项的值，并将其转换成Bool类型返回
     * @throw NotFoundException 当没有设置要读取的配置文件，或没找到相关配置项时招聘该异常
     */
    public static func getTo<T>(key: String): T where T <: Parsable<T>{
        return T.parse(get(key))
    }

    /**
     * 获取配置项的值，返回String类型，发生任何异常，将返回传入的default值
     */
    public static func getByDefault(key: String, default: String): String{
        var result = default
        try{
            result = get(key)
        }catch(e: Exception){}
        return result
    }

    /**
     * 获取配置项的值，并将其转换成T类型返回，发生任何异常，将返回传入的default值
     */
    public static func getByDefaultTo<T>(key: String, default: T): T where T <: Parsable<T>{
        var result = default
        try{
            result = T.parse(get(key))
        }catch(e: Exception){}
        return result
    }
}