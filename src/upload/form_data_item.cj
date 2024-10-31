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

    private var _header: String = ""
    private var _name: String = ""
    private var _value: String = ""

    private var _file: ?UploadFile = None
    
    public init(source: Array<Byte>, uploadPath: String){
        let arr = source.split("\r\n\r\n".toArray())
        this._header = String.fromUtf8(arr[0])
        this._name = this.getName()
        if(let Some(filename) <- this.getFilename()){
            this._value = filename
            let contentType = this.getContentType()
            // 获取系统配置中的上传目录
            var path = Config.UPLOAD_PATH
            // 拼接目录为 SysUploadPath/UserDefPath
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
                file.write(arr[1])
            }
            this._file = UploadFile(this._name, path, filename, filename, contentType)
        }else{
            this._value = this.getValue(arr[1])
        }
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

    /**
     * 获取值，调用此方法前，需确认getFilename()方法返回None
     */
    private func getValue(data: Array<Byte>): String{
        return String.fromUtf8(data)
    }

    private func getContentType(): String{
        var arr = this._header.split("\r\n")
        return arr[1][14..]
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