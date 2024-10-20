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

import std.reflect.{TypeInfo, ClassTypeInfo, InfoNotFoundException}
/**
 * 对象工具
 */
public class ObjectKit{

    /**
     * 通过(字符串表示的)类名称来创建类对象
     * eg:
     * let a: ClassA = ObjectKit.new("packagename.className") as ClassA
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