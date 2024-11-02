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
import std.fs.{File, OpenOption, FSException, Directory, exists}
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
        // println("boundary:\n${this._boundary}")
        this.resolving()
    }

    /**
     * 解析请求，从请求中获取FormDataItem数组
     */
    private func resolving(): Unit{
        // 计算buffer的大小
        let buffLength = this.calcBufferedLength(capacity: Config.UPLOAD_BUFFER_CAPACITY)
        // println(buffLength)
        let buffer = BufferedInputStream(this._request.body, buffLength)
        var fragment = Array<Byte>(buffLength, repeat: 0)
        // 记录是否是第一次查询
        var isStart = true
        // 记录上当前操作的索引起始位置
        var currentIndex = 0
        var tempItem: ?FormDataItem = None
        // 表示是否在寻找header，另一种情况是寻找value
        var isFindHead = true
        // 是否需要在当前fragment中继续查找
        var needFind = true
        // 上一fragment未解析剩余部分
        var lastRemining = Array<Byte>()
        // 当前文件
        var currentFile: ?File = None

        while(buffer.read(fragment) > 0){
            let currentFragment = lastRemining.concat(fragment)
            currentIndex = 0
            lastRemining = Array<Byte>()

            // 如果是第一次，直接更新currentIndex
            if(isStart){
                currentIndex = this._boundary.size
                isStart = false
            }
            do{
                // println("------------ inner loop start ------------")
                if(isFindHead){
                    // println(">> Find header")
                    // println("currentIndex: ${currentIndex}")
                    // 查找header
                    // 那么从currentIndex－2到分隔符“\r\n\r\n“之间的数据，即为头部数据
                    if(let Some(splitIndex) <- currentFragment.indexOf("\r\n\r\n".toArray(), currentIndex)){
                        // 找到了头部数据
                        tempItem = FormDataItem(currentFragment[currentIndex+2..splitIndex], this._uploadPath)
                        if(let Some(item) <- tempItem){
                            if(item.isFile){
                                item.value = item.filename
                                // println("是文件，新建文件${tempItem?.filename}")
                                // 将curentIndex到末尾的值写入文件
                                var path = "${this._uploadPath}"
                                if(!path.endsWith("/")){
                                    path = path + "/"
                                }
                                if(!exists(path)){
                                    Directory.create(path, recursive: true)
                                }
                                currentFile?.close()
                                let filename = "${Random().nextUInt64()}${item.extName}"
                                currentFile = File(path + filename, OpenOption.Create(false))
                                item.uploadFile = UploadFile(item.name, this._uploadPath, filename, item.value, item.getContentType())
                            }
                        }
                        // 更新currentIndex
                        currentIndex = splitIndex + 4
                        // 置为查找value
                        isFindHead = false
                        needFind = true
                    }else{
                        // println("no header, collect remining data...")
                        // 没找到，说明当前fragment中，已无分隔符了
                        needFind = false
                        // 需要将剩下的fragment缓存起来
                        lastRemining = currentFragment.clone(currentIndex..currentFragment.size)
                    }
                }else{
                    // 查找value
                    if(let Some(item) <- tempItem){
                        // println(">> Find '${item.name}' value, isFile: ${item.isFile}")
                        // println("currentIndex: ${currentIndex}")
                        // 那么从currentIndex到boundaryIndex-2之间的数据，即为value
                        if(let Some(boundaryIndex) <- currentFragment.indexOf(this._boundary, currentIndex)){
                            // println("find boundary, resolving...")
                            // 判断是否是文件
                            if(item.isFile){
                                // 是文件
                                // println("writefile: ${currentIndex}..${boundaryIndex-2}")
                                currentFile?.write(currentFragment[currentIndex..boundaryIndex-2])
                                // item.value = item.filename
                                this._items.append(item)
                                // 说明文件结尾了
                                currentFile?.close()
                                currentFile = None
                            }else{
                                // 是普通属性
                                item.value = String.fromUtf8(currentFragment[currentIndex..boundaryIndex-2])
                                // println("value: ${item.value}")
                                this._items.append(item)
                            }
                            tempItem = None
                            currentIndex = boundaryIndex + this._boundary.size
                            // println('currentIndex / fragmentSize: ${currentIndex} / ${currentFragment.size}')
                            // 判断boundary后面跟的是不是"--"
                            if(currentIndex <= currentFragment.size - 2 && currentFragment[currentIndex..currentIndex+2] == "--".toArray()){
                                currentFile?.close()
                                needFind = false
                                // println("over...")
                            }else{
                                needFind = true
                            }
                            isFindHead = true
                        }else{
                            // println("current fragment has no boundary...collect remining data...")
                            // 说明当前fragment中已无boundary了
                            // 接着要看是文件还是常规属性
                            if(item.isFile){
                                // 如果是文件，还不能马上写入文件中，否则boudary若被拆分到下一页，将无法正确的找到下一个boundary
                                if(currentIndex < currentFragment.size - this._boundary.size){
                                    // println("write to file: ${currentIndex}..${currentFragment.size - this._boundary.size}")
                                    currentFile?.write(currentFragment[currentIndex..currentFragment.size - this._boundary.size])
                                    lastRemining = currentFragment.clone(currentFragment.size - this._boundary.size..currentFragment.size)
                                }else{
                                    lastRemining = currentFragment.clone(currentIndex..currentFragment.size)
                                }
                            }else{
                                // 表示是常规属性，说明在这个fragment中没有拼够完整的值数据
                                // 需要将剩下的fragment缓存起来
                                lastRemining = currentFragment.clone(currentIndex..currentFragment.size)
                            }
                            // 既然没找到boundary，那就直接去下一个循环
                            needFind = false
                        }
                    }
                }
                // println("------------ inner loop end ------------")
            }while(needFind)
            // println("remining: ${lastRemining.size}， Start enter next fragment...")
            // println("----------------------------------------------------------------------")
        }

        // cjc 0.56.4版本无法访问此方法，待cjc升级后再看情况吧
        // buffer.close()
    }

    /**
     * 计算Buffer的长度，可传入一个默认值
     * @param capacity! - 默认大小，如果不指定，默认为Config.UPLOAD_BUFFER_CAPACITY
     * @return - 当contentLength < capacity，返回contentLength，否则返回capacity
     */
    private func calcBufferedLength(capacity!: Int = Config.UPLOAD_BUFFER_CAPACITY): Int{
        let contentLength = getContentLength(this._request)
        var len = 0;
        if(contentLength < capacity){
            len = contentLength
        }else{
            if(capacity > 128){
                len = capacity
            }else{
                len = 128
            }
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
            if(getContentLength(req) > maxPostSize){
                throw ExceedingLimitException("upload file size must be less than ${maxPostSize}.")
            }
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

    public prop uploadFiles: Array<UploadFile>{
        get(){
            let arr = ArrayList<UploadFile>()
            for(item in this._items){
                if(item.isFile){
                    arr.append(item.uploadFile)
                }
            }
            return arr.toArray()
        }
    }
}

public func getContentLength(request: HttpRequest): Int{
    return Int.parse(request.headers.getFirst("content-length") ?? "0")
}