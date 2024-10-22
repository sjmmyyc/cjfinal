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

import net.http.{HttpContext}
import encoding.json.ToJson
import encoding.url.{URL, Form}
import serialization.serialization.Serializable

/**
 * 控制器基类
 */
public abstract class Controller{
    private var _ctx: ?HttpContext = None
    private var _form: ?Form = None

    protected func renderText(text: String): Unit{
        this.ctx.responseBuilder.body(text)
    }

    protected func renderHtml(str: String): Unit{
        this.ctx.responseBuilder
            .header("content-type", "text/html; charset=utf8")
            .body(str)
    }

    protected func renderJson<T>(obj: Serializable<T>): Unit{
        this.ctx.responseBuilder
            .header("content-type", "text/json; charset=utf8")
            .body(obj.serialize().toJson().asObject().toJsonString())
    }

    /**
     * 获取URL中的请求参数，没找到返回空字符串
     */
    protected func get(key: String): String{
        return this.form.get(key) ?? ""
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
}