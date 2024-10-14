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
        try{
            PropKit.props.getOrThrow()
        }catch(e: Exception){
            PropKit.props = props
        }
        return props
    }

    public static func getBool(key: String): ?Bool{
        let value = props?.get(key)
        if(let Some(v) <- value){
            return Bool.parse(v.getOrThrow())
        }else{
            return None
        }
    }

    public static func getBoolByDefault(key: String, default: Bool): Bool{
        return false
    }
}