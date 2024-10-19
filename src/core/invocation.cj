/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import std.reflect.InstanceFunctionInfo

import std.reflect.TypeInfo

/**
 * Invocation用来调用目标方法上的拦截器和目标方法
 */
public class Invocation{

    private let _action: Action
    private let _interceptors: Array<Interceptor>

    private var _index: Int64

    public init(action: Action){
        this._action = action
        _interceptors = action.interceptors
        this._index = -1
    }

    public func invoke(): Unit{
        this._index++
        if(this._index < _interceptors.size){
            let inv = _interceptors[this._index]
            TypeInfo.of(inv).getInstanceFunction("intercept", TypeInfo.of<Invocation>()).apply(inv, this)
        }else{
            this._action.call()
        }
    }
}