/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.core
/**
 * 服务器配置
 * 配置顺序：configContants(), configRoutes()
 */
public abstract class CJFinalConfig{
    /**
     * 配置运行时常量
     */
    public func configConstants(me: Constants): Unit

    /**
     * 配置路由
     */
    public func configRoutes(me: Routes): Unit
}