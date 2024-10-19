/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import std.collection.ArrayList
import cjfinal.kit.ObjectKit

/**
 * 用于为Controller和其public方法配置拦截器
 */
@Annotation[target: [Type, MemberFunction]]
public class Before{
    
    let interceptorStr: String
    
    public const init(interceptorStr: String){
        this.interceptorStr = interceptorStr
    }

    public func getInterceptors(): Array<Interceptor>{
        let array = ArrayList<Interceptor>()
        var _interceptors = this.interceptorStr.replace(" ", "")
        _interceptors = _interceptors.replace("\n", "")
        let strArray = _interceptors.split(",")
        for(str in strArray){
            let interceptor = ObjectKit.new(str) as Interceptor
            if(let Some(intcept) <- interceptor){
                array.append(intcept)
            }
        }
        return array.toArray()
    }
}