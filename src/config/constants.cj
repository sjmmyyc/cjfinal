/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.config

/**
 * CJFinal运行时常量
 */
public class Constants{

    // 开发模式默认为false
    private var _devMode = false
    // 是否开发模式
    public mut prop devMode: Bool{
        set(value){
            this._devMode = value
            println("Set devMode = ${this._devMode}")
        }
        get(){
            return _devMode
        }
    }
}