/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.core

/**
 * 控制器基类
 */
public abstract class Controller{

    public func renderText(text: String): Unit{
        println("renderText(${text})...")
    }
}