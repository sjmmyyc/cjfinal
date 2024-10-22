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
package cjfinal.json

import std.ast.*

/**
 * JsonFieldConvertor
 */
public class JsonFieldConvertor{

    protected let id: Token
    protected let idType: TypeNode

    public init(varDecl: VarDecl){
        this.id = varDecl.identifier
        this.idType = varDecl.declType
    }

    /**
     * 生成serialize()方法
     */
    public func generateSerialize(): Tokens{
        return quote(
            dms.add(field<$(idType)>($(id.value), $(id))))
    }

    /**
     * 生成deserialize()方法
     */
    public func generateDeserialize(): Tokens{
        return quote(
            obj.$(id) = $(idType).deserialize(dms.get($(id.value))))
    }
}