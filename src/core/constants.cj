/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

/**
 * CJFinal运行时常量
 */
public class Constants{

    // 是否开发模式
    public mut prop devMode: Bool{
        set(value){
            Config.DEV_MODE = value
            println("Set devMode = ${Config.DEV_MODE}")
        }
        get(){
            return Config.DEV_MODE
        }
    }
}