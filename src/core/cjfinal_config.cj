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
/**
 * 服务器配置
 * 配置顺序：configConstant(), configInterceptor(), configRoute(), configPlugin(), configHandler()
 */
public abstract class CJFinalConfig{
    /**
     * 配置运行时常量
     */
    public open func configConstants(_: Constants): Unit{}

    /**
     * 配置拦截器
     */
    public open func configInterceptor(_: Interceptors): Unit{}

    /**
     * 配置路由
     */
    public open func configRoute(_: Routes): Unit{}

    // configPlugin()

    /**
     * 配置Handler
     */
    public open func configHandler(_: Handlers): Unit{}

    /**
     * 服务器启动完成后的回调
     */
    public open func onStart(): Unit{}

    /**
     * 服务器关闭前的回调
     */
    public open func onStop(): Unit{}
}