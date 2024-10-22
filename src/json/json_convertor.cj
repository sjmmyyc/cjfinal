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

import std.collection.ArrayList
import std.ast.*

/**
 * JsonConvertor
 */
public class JsonConvertor{

    public let classId: Token
    let fields: ArrayList<JsonFieldConvertor>

    public init(classId: Token, vars: Array<VarDecl>){
        this.classId = classId
        this.fields = ArrayList<JsonFieldConvertor>()
        try{
            for(verDecl in vars){
                this.fields.append(JsonFieldConvertor(verDecl))
            }
        }catch(e: ASTException){
            println("被Json修饰的类或结构体中的变量，必须要显式的注明变量类型")
        }
    }

    /**
     * 生成serialize()方法
     */
    public func generateSerialize(): Tokens{
        var serFields = Tokens()
        for(f in this.fields){
            serFields += f.generateSerialize()
        }
        return quote(
            public func serialize(): DataModel {
                var dms = DataModelStruct()
                $(serFields)
                return dms
            }
        )
    }

    /**
     * 生成deserialize()方法
     */
    public func generateDeserialize(): Tokens{
        var deserFields = Tokens()
        for(f in fields){
            deserFields += f.generateDeserialize()
        }
        return quote(
            public static func deserialize(dm: DataModel): $(classId) {
                let dms = match(dm){
                    case data: DataModelStruct => data
                    case _ => throw Exception("this data is not DataModelStruct")
                }
                var obj = $(classId)()
                $(deserFields)
                return obj
            }
        )
    }
}