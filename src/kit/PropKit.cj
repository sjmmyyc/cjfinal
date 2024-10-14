/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
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
        if(let Some(p) <- PropKit.props){
            if(let Some(v) <- p.get(key)){
                return Bool.parse(v)
            }else{
                return None
            }
        }else{
            return None
        }
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