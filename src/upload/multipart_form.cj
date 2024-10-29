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
import std.collection.ArrayList
import std.io.BufferedInputStream

/**
 * MultipartForm.
 * 将“multipart/form-data” 请求封装成对象。
 * 不可直接创建对象，需通过MultipartForm.get()方法获取该类对象
 */
public class MultipartForm{

    private let _request: HttpRequest
    private let _uploadPath: String
    // 允许的单文件最大尺寸
    private let _maxPostSize: Int

    private let _items = ArrayList<FormDataItem>()
    
    private init(req: HttpRequest, uploadPath: String, maxPostSize: Int){
        this._request = req
        this._uploadPath = uploadPath
        this._maxPostSize = maxPostSize
        this.resolving()
    }

    /**
     * 解析请求，从请求中获取FormDataItem数组
     */
    public func resolving(): Unit{
        let contentLength = this.getContentLength()
        let body = Array<Byte>(contentLength, repeat: 0)
        let buffer = BufferedInputStream(this._request.body)
        buffer.read(body)
        let separator = getSeparator()
        let itemArr = body.split(separator)
        for(item in itemArr){
            this._items.append(FormDataItem(item))
        }
    }

    private func getContentLength(): Int{
        return Int.parse(this._request.headers.getFirst("content-length") ?? "0")
    }

    private func getBoundary(): String{
        let contentType = this._request.headers.getFirst("content-type").getOrThrow()
        return contentType["multipart/form-data; boundary=".size..]
    }

    private func getSeparator(): Array<Byte>{
        return "--${this.getBoundary()}".toArray()
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
                form = MultipartForm(req, uploadPath, maxPostSize)
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
        let thisSize = this.size
        let separatorSize = separator.size
        // 记录上一次匹配到的索引下标
        var prevIndex = 0
        for(i in 0..=thisSize - separatorSize){
            if(this[i..i+separatorSize] == separator){
                // 匹配上了
                // i=0表示开头的位置，不需要，抛弃
                if(i != 0){
                    if(i - prevIndex != separatorSize){
                        if(prevIndex == 0){
                            result.append(this[separatorSize..i])
                        }else{
                            result.append(this[prevIndex + separatorSize..i])
                        }
                    }
                }
                // 记录上一个匹配的位置
                prevIndex = i
            }
        }
        // 如果上一次匹配到的索引下标 ＋ 分隔符长度不等于自身数组长度，说明后面还有内容
        if(prevIndex + separatorSize != thisSize){
            let last = this[prevIndex + separatorSize..]
            if(last != "--\r\n".toArray()){
                result.append(last)
            }
        }
        return result.toArray()
    }
}