/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.aop

/**
 * 用于为Controller和其public方法清除拦截器
 */
@Annotation[target: [Type, MemberFunction]]
public class Clear{

    let interceptorStr: String

    public const init(interceptorStr: String){
        this.interceptorStr = interceptorStr
    }

    public func get(): Array<String>{
        var _interceptors = this.interceptorStr.replace(" ", "")
        _interceptors = _interceptors.replace("\n", "")
        return _interceptors.split(",")
    }
}