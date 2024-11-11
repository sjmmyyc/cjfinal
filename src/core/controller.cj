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
package cjfinal.core

import net.http.{HttpContext, HttpStatusCode, HttpResponseBuilder}
import encoding.json.{ToJson, JsonArray}
import encoding.url.{URL, Form}
import serialization.serialization.Serializable
import std.convert.Parsable
import std.collection.ArrayList
import std.reflect.TypeInfo
import std.fs.{File, OpenOption}
import std.io.{InputStream, BufferedInputStream}
import cjfinal.upload.{MultipartForm, UploadFile, ExceedingLimitException}
import cjfinal.config.Config

/**
 * 控制器基类
 */
public abstract class Controller{
    private var _ctx: ?HttpContext = None
    private var _form: ?Form = None
    private var _params: Array<String> = []

    protected func renderText(text: String): Unit{
        this.setContentType(ContentType.Text)
            .setStatus(HttpStatusCode.STATUS_OK)
            .body(text)
    }

    protected func renderHtml(str: String): Unit{
        this.setContentType(ContentType.Html)
            .setStatus(HttpStatusCode.STATUS_OK)
            .body(str)
    }

    protected func renderJson<T>(obj: Serializable<T>): Unit{
        this.setContentType(ContentType.Json)
            .setStatus(HttpStatusCode.STATUS_OK)
            .body(obj.serialize().toJson().asObject().toJsonString())
    }

    protected func renderJson<T>(list: ArrayList<T>): Unit where T <: Serializable<T>{
        let obj = JsonArray()
        for(item in list){
            obj.add(item.serialize().toJson().asObject())
        }
        this.setContentType(ContentType.Json)
            .setStatus(HttpStatusCode.STATUS_OK)
            .body(obj.toString())
    }

    protected func renderFile(filepath: String): Unit{
        var arr = filepath.split("/")
        var filename = arr.last.getOrDefault({ => "download"})
        this.renderFile(File(filepath, OpenOption.Open(true, false)), filename)
    }

    protected func renderFile(inputStream: InputStream, filename: String): Unit{
        this.setContentType(ContentType.File)
            .setStatus(HttpStatusCode.STATUS_OK)
            .setHeader("Content-Disposition", "attachment; filename=${filename}")
            .body(inputStream)
    }

    protected func renderErr413(): Unit{
        this.setContentType(ContentType.Html)
            .setStatus(HttpStatusCode.STATUS_REQUEST_CONTENT_TOO_LARGE)
            .body(HttpStatusCode.STATUS_REQUEST_CONTENT_TOO_LARGE.toString() + " - STATUS_REQUEST_CONTENT_TOO_LARGE")
    }

    /**
     * 获取URL中的请求参数，没找到返回空字符串
     */
    protected func get(key: String): String{
        return this.form.get(key) ?? ""
    }

    protected func getTo<T>(key: String): T where T <: Parsable<T>{
        let str = this.get(key)
        try{
            return T.parse(str)
        }catch(e: IllegalArgumentException){
            // 无法转换
            let typeInfo = TypeInfo.of<T>()
            println('\u{1b}[33m"${str}" can not parse to ${typeInfo}\u{1b}[0m')
            throw IllegalArgumentException('"${str}" can not parse to ${typeInfo}')
        }
    }

    protected func getArray(key: String): Array<String>{
        let result = ArrayList<String>()
        let arr = this.form.getAll(key)
        for(str in arr){
            result.append(str)
        }
        return result.toArray()
    }

    protected func getArrayTo<T>(key: String): Array<T> where T <: Parsable<T>{
        let result = ArrayList<T>()
        for(str in this.getArray(key)){
            try{
                result.append(T.parse(str))
            }catch(e: IllegalArgumentException){
                // 无法转换
                let typeInfo = TypeInfo.of<T>()
                println('\u{1b}[33m"${str}" can not parse to ${typeInfo}\u{1b}[0m')
                throw IllegalArgumentException('"${str}" can not parse to ${typeInfo}')
            }
        }
        return result.toArray()
    }

    protected func getParam(index: Int64): String{
        return this._params.get(index) ?? ""
    }

    protected func getParamTo<T>(index: Int64): T where T <: Parsable<T>{
        var str: String = this.getParam(index)
        try{
            return T.parse(str)
        }catch(e: IllegalArgumentException){
            // 无法转换
            let typeInfo = TypeInfo.of<T>()
            println('\u{1b}[33m"${str}" can not parse to ${typeInfo}\u{1b}[0m')
            throw IllegalArgumentException('"${str}" can not parse to ${typeInfo}')
        }
    }

    /**
     * 上传文件
     */
    protected func getFiles(): Array<UploadFile>{
        return this.getFiles(Config.UPLOAD_PATH, Config.MAX_UPLOAD_SIZE)
    }

    /**
     * 上传文件
     * ＠param maxPostSize - 允许的最大上传尺寸
     */
    protected func getFiles(maxPostSize: Int): Array<UploadFile>{
        return this.getFiles(Config.UPLOAD_PATH, maxPostSize)
    }

    protected func getFiles(uploadPath: String): Array<UploadFile>{
        return this.getFiles(uploadPath, Config.MAX_UPLOAD_SIZE)
    }

    /**
     * 上传文件
     * @param uploadPath - 字符串表示的路径，可使用绝对路径和相对路径
     * @param maxPostSize - 允许的最大上传尺寸
     * @throw FSException - 在根据路径创建目录时，如果没有权限，则会抛出该异常
     * @throw ExceedingLimitException - 上传文件超过限制尺寸时抛出该异常
     */
    protected func getFiles(uploadPath: String, maxPostSize: Int): Array<UploadFile>{
        var result = Array<UploadFile>()
        if(let Some(multiForm) <- MultipartForm.get(this.ctx.request, uploadPath, maxPostSize)){
            this._form = multiForm.form
            result = multiForm.uploadFiles
        }
        return result
    }

    protected func getFile(parameterName: String): ?UploadFile {
        let uploadFiles = this.getFiles()
        var result: ?UploadFile = None
        for(uploadFile in uploadFiles){
            if(uploadFile.parameterName == parameterName){
                result = uploadFile
                break
            }
        }
        return result
    }

    protected func getFile(parameterName: String, uploadPath: String): ?UploadFile {
        let uploadFiles = this.getFiles(uploadPath)
        var result: ?UploadFile = None
        for(uploadFile in uploadFiles){
            if(uploadFile.parameterName == parameterName){
                result = uploadFile
                break
            }
        }
        return result
    }

    protected func getFile(parameterName: String, maxPostSize: Int): ?UploadFile{
        let uploadFiles = this.getFiles(maxPostSize)
        var result: ?UploadFile = None
        for(uploadFile in uploadFiles){
            if(uploadFile.parameterName == parameterName){
                result = uploadFile
                break
            }
        }
        return result
    }

    protected func getFile(parameterName: String, uploadPath: String, maxPostSize: Int): ?UploadFile{
        let uploadFiles = this.getFiles(uploadPath, maxPostSize)
        var result: ?UploadFile = None
        for(uploadFile in uploadFiles){
            if(uploadFile.parameterName == parameterName){
                result = uploadFile
                break
            }
        }
        return result
    }

    /**
     * 向response中添加header
     */
    protected func setHeader(key: String, value: String): Controller{
        this.ctx.responseBuilder.header(key, value)
        this
    }

    protected func setContentType(contentType: ContentType): Controller{
        this.setHeader("Content-Type", contentType.toString())
        this
    }

    protected func setStatus(status: UInt16): Controller {
        this.ctx.responseBuilder.status(status)
        this
    }

    protected func body(str: String): Controller {
        this.ctx.responseBuilder.body(str)
        this
    }

    protected func body(inputStream: InputStream): Controller{
        this.ctx.responseBuilder.body(inputStream)
        this
    }

    public mut prop ctx: HttpContext{
        set(value){
            this._ctx = value
        }
        get(){
            return this._ctx.getOrThrow()
        }
    }

    public mut prop form: Form{
        set(value){
            this._form = value
        }
        get(){
           return this._form.getOrThrow()
        }
    }

    public mut prop param: Array<String>{
        set(value){
            this._params = value
        }
        get(){
            return this._params
        }
    }
}