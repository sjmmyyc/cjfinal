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
import encoding.json.ToJson
import encoding.url.{URL, Form}
import serialization.serialization.Serializable
import std.convert.Parsable
import std.collection.ArrayList
import std.reflect.TypeInfo

/**
 * 控制器基类
 */
public abstract class Controller{
    private var _ctx: ?HttpContext = None
    private var _form: ?Form = None
    private var _param: Array<String> = []

    protected func renderText(text: String): Unit{
        this.ctx.responseBuilder
            .status(HttpStatusCode.STATUS_OK)
            .body(text)
    }

    protected func renderHtml(str: String): Unit{
        this.ctx.responseBuilder
            .header("content-type", "text/html; charset=utf8")
            .status(HttpStatusCode.STATUS_OK)
            .body(str)
    }

    protected func renderJson<T>(obj: Serializable<T>): Unit{
        this.ctx.responseBuilder
            .header("content-type", "text/json; charset=utf8")
            .status(HttpStatusCode.STATUS_OK)
            .body(obj.serialize().toJson().asObject().toJsonString())
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
        return this._param.get(index) ?? ""
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
     * 向response中添加header
     */
    protected func setHeader(key: String, value: String): Controller{
        this.ctx.responseBuilder.header(key, value)
        return this
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
            this._param = value
        }
        get(){
            return this._param
        }
    }
}