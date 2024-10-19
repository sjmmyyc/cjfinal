/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import std.collection.ArrayList

/**
 * Interceptor tools
 */
public class Interceptors{
    
    private let _interceptorList = ArrayList<Interceptor>()

    public func add(interceptor: Interceptor): Unit{
        this._interceptorList.append(interceptor)
    }

    public prop interceptors: Array<Interceptor>{
        get(){
            return this._interceptorList.toArray()
        }
    }
}