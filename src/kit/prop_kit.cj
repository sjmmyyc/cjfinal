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
        let props = Prop(path)
        if(let None <- PropKit.props){
            PropKit.props = props
        }
        return props
    }

    public static func getBool(key: String): ?Bool{
        var result: ?Bool = None
        if(let Some(p) <- (PropKit.props)){
            if(let Some(v) <- p.get(key)){
                result = Bool.parse(v)
            }
        }
        return result
    }

    public static func getBoolByDefault(key: String, default: Bool): Bool{
        let value = getBool(key)
        if(let Some(v) <- value){
            return Bool.parse(v.toString())
        }else{
            return default
        }
    }
}