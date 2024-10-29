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
package cjfinal.upload
import std.unicode.UnicodeExtension

/**
 * FormDataItem.
 * 将form-data表单提交的数据，按参数数量分割成多个Item，每个Item将被封装成该类对象
 */
public class FormDataItem{
    // 原始数据
    private let _source: Array<Byte>

    private var _header: String = ""
    private var _name: String = ""
    private var _value: String = ""
    
    public init(source: Array<Byte>){
        this._source = source
        try{
            // 转换成utf8时，可能会抛出异常，如不抛出异常，表示是一般属性
            let sourceStr = String.fromUtf8(this._source)
            let arr = sourceStr.trim().split("\r\n")
            this._header = arr[0]
            this._name = getName()
            this._value = arr[2]
        }catch(e: IllegalArgumentException){
            // 抛出了异常，表示是上传文件
            println("File...")   
        }
    }

    private func getName(): String{
        let arr = this._header.split(";")
        let nameField = arr[1].trim()
        return nameField[6..nameField.size-1]
    }

    public prop name: String{
        get(){
            this._name
        }
    }

    public prop value: String{
        get(){
            this._value
        }
    }
}