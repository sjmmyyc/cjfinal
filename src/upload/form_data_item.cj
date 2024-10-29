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
import std.fs.{exists, File, OpenOption, Directory}

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

    private var _file: ?UploadFile = None
    
    public init(source: Array<Byte>, uploadPath: String){
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
            let arr = source.split("\r\n\r\n".toArray())
            this._header = String.fromUtf8(arr[0])
            this._name = this.getName()
            let filename = this.getFilename()
            this._value = filename
            let contentType = this.getContentType()
            var path = Config.UPLOAD_PATH
            if(uploadPath.startsWith("/")){
                path = path + uploadPath
            }else{
                path = path + "/" + uploadPath
            }
            if(!path.endsWith("/")){
                path += "/"
            }
            if(!exists(path)){
                Directory.create(path, recursive: true)
            }
            
            try(file = File(path + filename, OpenOption.CreateOrTruncate(false))){
                file.write(arr[1][..arr[1].size - 2])
            }
            this._file = UploadFile(this._name, path, filename, filename, contentType)
        }
    }

    private func getName(): String{
        let arr = this._header.split(";")
        let nameField = arr[1].trim()
        return nameField[6..nameField.size-1]
    }

    private func getFilename(): String {
        var arr = this._header.split("\r\n")
        arr = arr[0].split(";")
        let filename = arr[2].trim()
        return filename[10..filename.size-1]
    }

    private func getContentType(): String{
        var arr = this._header.split("\r\n")
        return arr[1][10..]
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