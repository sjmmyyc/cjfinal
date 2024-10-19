/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.kit

import std.reflect.{TypeInfo, ClassTypeInfo, InfoNotFoundException}
/**
 * 对象工具
 */
public class ObjectKit{

    /**
     * 通过(字符串表示的)类名称来创建类对象
     * eg:
     * let a: classA = ObjectKit.new("packagename.className") as ClassA
     */
    public static func new(typeName: String): Any{
        try{
            let classInfo = (TypeInfo.get(typeName) as ClassTypeInfo).getOrThrow()
            return classInfo.construct()
        }catch(e: InfoNotFoundException){
            println(e)
        }
    }
}