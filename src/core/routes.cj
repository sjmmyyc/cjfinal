/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal.core

import std.collection.HashMap
import std.reflect.TypeInfo

/**
 * 路由
 */
public class Routes{

    private static let routesMap = HashMap<String, Controller>()

    public init(){}

    /**
     * 添加路由控制器
     * @param path 控制器目录
     * @param controller 控制器
     */
    public func add(path: String, controller: Controller){
        if(CJFinal.me.constants.devMode){
            println("Add route: ${path} -> ${TypeInfo.of(controller).name}")
        }
        routesMap.put(path, controller)
    }
}