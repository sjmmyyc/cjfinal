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
macro package cjfinal.macros

import std.ast.*
import cjfinal.json.{JsonConvertor, VarDeclVisitor}

/**
 * 为class或struct添加转换Json的扩展，使用该宏时，有以下两点需要注意：
 * 1.必须引入以下包
 *     import serialization.serialization.*
 *     import encoding.json.*
 * 2.成员变量必须显式声明其类型
 *     let name = "Kevin"           // Wrong
 *     let name: String = "Kevin"   // Right
 */
public macro Json(input: Tokens): Tokens{
    let s: Decl = parseDecl(input)
    var jsonConvertor: JsonConvertor

    match(s){
        case d: ClassDecl => d
            let id = d.identifier
            let vistor = VarDeclVisitor()
            d.traverse(vistor)
            jsonConvertor = JsonConvertor(id, vistor.varDecls)
        case d: StructDecl => d
            let id = d.identifier
            let vistor = VarDeclVisitor()
            d.traverse(vistor)
            jsonConvertor = JsonConvertor(id, vistor.varDecls)
        case _ => throw UnsupportedException("Json only using to struct or class")
    }

    let serFunc = jsonConvertor.generateSerialize()
    let deserFunc = jsonConvertor.generateDeserialize()

    return input + quote(
        extend $(jsonConvertor.classId) <: Serializable<$(jsonConvertor.classId)> {
            $(serFunc)
            $(deserFunc)
        }
    )
}