/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

/**
 * 拦截器接口
 */
public interface Interceptor{
    
    func intercept(inv: Invocation): Unit

    func say(): Unit
}