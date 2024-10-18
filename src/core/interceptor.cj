/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

/**
 * 拦截器接口
 */
public interface Interceptor{
    /**
     * 在Action之前调用
     * @return Bool true表示继续执行其后的拦截器或Action，fase表示终止执行其后的拦截器或Action
     */
    func before(_: Controller): Bool{
        return true
    }

    /**
     * 在Action之后调用
     * @return Bool true表示继续执行其后的拦截器或Action，fase表示终止执行其后的拦截器或Action
     */
    func after(_: Controller): Bool{return true}
}