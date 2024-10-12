/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.core

/**
 * 已存在异常
 */
public class AlreadyExistException <: Exception{

    public init(msg: String){
        super(msg)
    }

    public override func getClassName(): String{
        return "AlreadyExistException"
    }
}