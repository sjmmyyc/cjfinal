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

import cjfinal.config.Config
import std.unicode.UnicodeExtension
import std.fs.{exists, File, OpenOption, Directory, removeIfExists}
import std.io.BufferedInputStream
import std.collection.ArrayList
import std.random.Random

/**
 * FormDataItem.
 * 将form-data表单提交的数据，按参数数量分割成多个Item，每个Item将被封装成该类对象
 */
public class FormDataItem{

    private var _header: String = ""
    private var _name: String = ""
    private var _value: String = ""
    private var _uploadPath: String = ""

    private var _uploadfile: ?UploadFile = None
    
    public init(header: Array<Byte>, uploadPath: String){
        this._header = String.fromUtf8(header)
        this._uploadPath = uploadPath
        this._name = this.getName()
    }


    private func getName(): String{
        let arr = this._header.split(";")
        let nameField = arr[1].trim()
        return nameField[6..nameField.size-1]
    }

    /**
     * 获取filename的值，如果不存在filename字段，返回None
     */
    private func getFilename(): ?String {
        var result: ?String = None
        var arr = this._header.split("\r\n")
        arr = arr[0].split(";")
        if(arr.size == 3){
            let filename = arr[2].trim()
            result = filename[10..filename.size - 1]
        }
        return result
    }

    public func getContentType(): String{
        var arr = this._header.split("\r\n")
        return arr[1][14..]
    }

    public prop name: String{
        get(){
            this._name
        }
    }

    public mut prop value: String{
        set(value){
            this._value = value
        }
        get(){
            this._value
        }
    }

    public prop filename: String{
        get(){
            return this.getFilename() ?? ""
        }
    }

    public prop isFile: Bool{
        get(){
            var result = false
            if(let Some(filename) <- this.getFilename()){
                result = true
            }
            return result
        }
    }

    public mut prop uploadFile: UploadFile{
        set(value){
            this._uploadfile = value
        }
        get(){
            return this._uploadfile.getOrThrow()
        }
    }

    public prop extName: String{
        get(){
            let arr = this.filename.split(".")
            if(arr.size == 1){
                return ""
            }else{
                return ".${arr[arr.size - 1]}"
            }
        }
    }
}