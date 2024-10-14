/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.exception

/**
 * AlreadyExistException
 */
public class AlreadyExistException <: Exception{

    public init(msg: String){
        super(msg)
    }

    public override func getClassName(): String{
        return "AlreadyExistException"
    }
}