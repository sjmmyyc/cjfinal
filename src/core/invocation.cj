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

    public func getController(): Controller{
        return this._action.controller
    }
}