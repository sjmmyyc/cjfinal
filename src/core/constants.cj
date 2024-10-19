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
            println("Set \u{1b}[32mdevMode\u{1b}[0m = \u{1b}[32m${Config.DEV_MODE}\u{1b}[0m")
        }
        get(){
            return Config.DEV_MODE
        }
    }
}