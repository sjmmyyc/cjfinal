/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import net.http.HttpContext

/**
 * 控制器基类
 */
public abstract class Controller{
    private var _ctx: ?HttpContext = None

    public func renderText(text: String): Unit{
        this.ctx.responseBuilder.body(text)
    }

    public mut prop ctx: HttpContext{
        set(value){
            this._ctx = value
        }
        get(){
            return this._ctx.getOrThrow()
        }
    }
}