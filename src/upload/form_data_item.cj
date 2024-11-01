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

    private var _file: ?UploadFile = None
    
    public init(source: Array<Byte>, uploadPath: String){
        let arr = source.split("\r\n\r\n".toArray())
        this._header = String.fromUtf8(arr[0])
        this._name = this.getName()
        if(let Some(originFilename) <- this.getFilename()){
            this._value = originFilename
            this._file = this.createFile(uploadPath, arr[1])
        }else{
            this._value = this.getValue(arr[1])
        }
    }

    /**
     * 通过缓存文件来构造，一个缓存文件，表示一个文件数据块，包含header和content两部分
     */
    public init(filename: String, uploadPath: String){
        let dataList = ArrayList<Byte>()
        try(file = File(filename, OpenOption.Open(true, false))){
            let buff = BufferedInputStream<File>(file, Config.UPLOAD_BUFFER_CAPACITY)
            while(let Some(data) <- buff.readByte()){
                dataList.append(data)
                if(dataList.size > 4){
                    if(dataList.toArray()[dataList.size - 4..] == "\r\n\r\n".toArray()){
                        // 拿到header了
                        this._header = String.fromUtf8(dataList.toArray()[..dataList.size - 4])
                        this._name = this.getName()
                        this._value = this.getFilename().getOrThrow()
                        dataList.clear()
                        this._file = createFile(uploadPath, buff)
                    }
                }
            }
        }
        removeIfExists(filename)
    }

    /**
     * 创建文件
     * @param uploadPath - 上传目录
     */
    private func createFile(uploadPath: String, source: Array<Byte>): UploadFile{
        let path = this.calcPath(uploadPath)
        let filename = "${Random().nextUInt64()}${this.getExtName()}"
        try(file = File(path + filename, OpenOption.CreateOrTruncate(false))){
            file.write(source)
        }
        return UploadFile(this._name, path, filename, this._value, this.getContentType())
    }

    private func createFile(uploadPath: String, source: BufferedInputStream<File>): UploadFile{
        let path = this.calcPath(uploadPath)
        let filename = "${Random().nextUInt64()}${this.getExtName()}"
        try(file = File(path + filename, OpenOption.CreateOrTruncate(false))){
            let temp = Array<Byte>(Config.UPLOAD_BUFFER_CAPACITY, repeat: 0)
            while(source.read(temp) > 0){
                file.write(temp)
            }
        }
        return UploadFile(this._name, path, filename, this._value, this.getContentType())
    }

    private func getExtName(): String {
        let arr = this._value.split(".")
        var extName = ""
        if(arr.size >= 2){
            extName = ".${arr[arr.size-1]}"
        }
        return extName
    }

    private func calcPath(uploadPath: String): String{
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
        return path
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