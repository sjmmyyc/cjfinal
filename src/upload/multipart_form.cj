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

import net.http.{HttpRequest, HttpHeaders}
import encoding.url.Form
import std.convert.Parsable
import std.collection.{ArrayList, LinkedList}
import std.io.{BufferedInputStream, BufferedOutputStream}
import std.fs.{File, OpenOption}
import std.random.Random
import cjfinal.config.Config

/**
 * MultipartForm.
 * 将“multipart/form-data” 请求封装成对象。
 * 不可直接创建对象，需通过MultipartForm.get()方法获取该类对象
 */
public class MultipartForm{

    private let _contentType: String
    private let _request: HttpRequest
    private let _uploadPath: String
    // 允许的单文件最大尺寸
    private let _maxPostSize: Int

    private let _items = ArrayList<FormDataItem>()
    // 拼装用的临时数据存储单元
    private let _tempData = ArrayList<Byte>()

    private var _boundary: Array<Byte> = Array<Byte>()
    private var _isFirst = true             // 是否是第一次匹配
    private var _cacheFile: ?File = None    // 缓存文件，默认为空，表示不需要缓存
    private var _fileOutputStream: ?BufferedOutputStream<File> = None
    private var _filename: String = ""
    
    private init(req: HttpRequest, contentType: String, uploadPath: String, maxPostSize: Int){
        this._request = req
        this._uploadPath = uploadPath
        this._maxPostSize = maxPostSize
        this._contentType = contentType
        this._boundary = this.getBoundary()
        this.resolving()
    }

    /**
     * 解析请求，从请求中获取FormDataItem数组
     */
    private func resolving(): Unit{
        // 计算buffer的大小
        let buffLength = this.calcBufferedLength(capacity: Config.UPLOAD_BUFFER_CAPACITY)
        let buffer = BufferedInputStream(this._request.body, buffLength)
        while(let Some(byte) <- buffer.readByte()){
            this._tempData.append(byte)
            if(let Some(formItem) <- resolvingTempdata()){
                this._items.append(formItem)
            }
        }
        // cjc 0.56.4版本无法访问此方法，待cjc升级后再看情况吧
        // buffer.close()
    }

    /**
     * 从tempData中解析数据
     * @return Option<FormDataItem> - 如果没有解析到，返回None
     */
    private func resolvingTempdata(): ?FormDataItem{
        var result: ?FormDataItem = None
        // 如果还没读到开始位置的"--"
        if(this._isFirst){
            // 判断已读数据是否是boundary
            if(this._tempData.toArray() == this._boundary){
                this._tempData.clear()
                this._isFirst = false
            }
        }else{
            // 判断tempData长度是否大于boundary，如果小于boundary，说明还没到结束位置，什么也不用干 
            if(this._tempData.size >= this._boundary.size){
                // 判断已读取数据的结尾是否是boundary
                if(this._tempData.toArray()[this._tempData.size - this._boundary.size..] == this._boundary){
                    if(let Some(file) <- this._cacheFile){
                        // 数据被存储到缓存文件
                        this._fileOutputStream?.write(this._tempData.toArray()[..this._tempData.size - this._boundary.size - 2])
                        this._fileOutputStream?.flush()
                        this._fileOutputStream?.close()
                        this._fileOutputStream = None
                        this._cacheFile?.close()
                        this._cacheFile = None
                        result = FormDataItem("${Config.UPLOAD_PATH}/${this._filename}", this._uploadPath)
                        this._filename = ""
                    }else{
                        // 未被存储到缓存文件中
                        let data = this._tempData.toArray()[2..this._tempData.size - this._boundary.size - 2]
                        result = FormDataItem(data, this._uploadPath)
                    }
                    this._tempData.clear()
                }else{
                    // 说明结尾不是boundary，这时判断tempData是否大于缓冲临界值
                    if(this._tempData.size > Config.UPLOAD_BUFFER_CAPACITY){
                        if(let None <- this._cacheFile){
                            this._filename = "cache_${Random().nextUInt64()}"
                            this._cacheFile = File("${Config.UPLOAD_PATH}/${this._filename}", OpenOption.CreateOrAppend)
                            this._fileOutputStream = BufferedOutputStream<File>(this._cacheFile.getOrThrow(), Config.UPLOAD_BUFFER_CAPACITY)
                            // 将开始的\r\t移除
                            this._tempData.remove(0)
                            this._tempData.remove(0)
                        }
                        this._fileOutputStream?.writeByte(this._tempData.remove(0))
                    }
                }
            }
        }
        return result
    }

    private func getContentLength(): Int{
        return Int.parse(this._request.headers.getFirst("content-length") ?? "0")
    }

    /**
     * 计算Buffer的长度，可传入一个默认值
     * @param default! - 默认大小，如果不指定，默认为4096（4K）
     * @return - 当contentLength < capacity，返回contentLength，否则返回capacity
     */
    private func calcBufferedLength(capacity!: Int = 4096): Int{
        let contentLength = this.getContentLength()
        var len = 0;
        if(contentLength < capacity){
            len = contentLength
        }else{
            len = capacity
        }
        return len
    }

    private func getBoundary(): Array<Byte>{
        return "--${this._contentType["multipart/form-data; boundary=".size..]}".toArray()
    }

    /**
     * 根据请求信息获取MultipartForm对象，
     * 如果请求不是“multipart/form-data”类型，返回None
     * @param req - HttpRequest
     * @param uploadPath - 上传目录，相对目录
     * @param maxPostSize - 单文件最大容量限制
     */
    public static func get(req: HttpRequest, uploadPath: String, maxPostSize: Int): ?MultipartForm{
        var form: ?MultipartForm = None
        if(let Some(contentType) <- req.headers.getFirst("content-type")){
            if(contentType.startsWith("multipart/form-data")){
                form = MultipartForm(req, contentType, uploadPath, maxPostSize)
            }
        }
        return form
    }

    public prop form: Form{
        get(){
            let form = Form()
            for(item in this._items){
                form.add(item.name, item.value)
            }
            return form
        }
    }
}

/**
 * extend Array<Byte>.
 */
extend Array<Byte> {

    /**
     * 分割Array<Byte>
     * @param separator: Array<Byte> - 分割符号
     */
    public func split(separator: Array<Byte>): Array<Array<Byte>>{
        let result = ArrayList<Array<Byte>>()
        var currentIndex = 0
        for(i in 0..this.size - 1){
            if(i >= separator.size){
                if(this[i - separator.size..i] == separator){
                    result.append(this[currentIndex..i-separator.size])
                    currentIndex = i
                }
            }
        }
        result.append(this[currentIndex..])
        return result.toArray()
    }
}