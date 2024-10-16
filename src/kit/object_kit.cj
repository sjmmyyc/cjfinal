/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.kit

import std.reflect.{TypeInfo, ClassTypeInfo}
/**
 * 对象工具
 */
public class ObjectKit{

    /**
     * 通过(字符串表示的)类名称来创建类对象
     * eg:
     * let a: classA = ObjectKit.new("packagename.className") as ClassA
     */
    public static func new(typeName: String, parameterTypes: Array<TypeInfo>): Any{
        let classInfo = (TypeInfo.get(typeName) as ClassTypeInfo).getOrThrow()
        let aConstruct = classInfo.getConstructor(parameterTypes)
        return aConstruct.apply()
    }
}