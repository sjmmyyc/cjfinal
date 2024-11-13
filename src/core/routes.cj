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

import cjfinal.exception.AlreadyExistException
import cjfinal.config.CmdColor
import std.collection.HashMap
import std.reflect.TypeInfo
import encoding.url.URL
import std.collection.ArrayList
import log.getGlobalLogger

/**
 * 路由
 */
public class Routes{

    private let logger = getGlobalLogger([("name", "main")])
    private static let routesMap = HashMap<String, Controller>()

    public init(){}

    /**
     * 添加路由控制器
     * @param path 控制器目录
     * @param controller 控制器
     */
    public func add(path: String, controller: Controller){
        // 判断path是否已存在
        match(routesMap.get(path)){
            case None =>
                // path不存在，添加到routesMap中
                logger.info("${CmdColor.purple}Add route: ${path} -> ${TypeInfo.of(controller).name}${CmdColor.white}")
                routesMap.put(path, controller)
            case _ => 
                // path已存在，抛出AlreadyExistException
                throw AlreadyExistException('path "${path}" already exist.')
        } 
    }

    /**
     * 根据请求获取匹配到的(path和controller)
     * @param url URL
     * @return 匹配到的path和controller对象
     */
    public static func get(url: URL): (?String, ?Controller){
        let pathList = calPossiblePath(url)

        for(path in pathList){
            if(let Some(con) <- routesMap.get(path)){
                return (path, con)
            }
        } 
        return (None, None)
    }

    /**
     * 根据url计算出所有path的可能性，返回的是个列表，排列顺序根据path包含的节点数从高到低排列
     */
    private static func calPossiblePath(url: URL): ArrayList<String>{
        let nodeList = getRouteNodeList(url)
        let pathList = ArrayList<String>()
        var tempPath = ""
        for(node in nodeList){
            tempPath += "/" + node
            pathList.append(tempPath)
        }
        pathList.sortBy(stable: true, comparator: {p1: String, p2: String =>
            if(p1.size > p2.size){
                return Ordering.LT
            }else{
                return Ordering.GT
            }
        })
        pathList.append("/")
        return pathList
    }

    /**
     * 根据URL获取节点列表(以“/”分割的字符串被看做是一个节点)，节点index和其后的部分将被丢弃
     */
    private static func getRouteNodeList(url: URL): ArrayList<String>{
        let tempList = url.path.split("/")
        let pathList = ArrayList<String>();
        for(name in tempList){
            if(name != ""){
                if(name == "index"){
                    break
                }
                pathList.append(name)
            }
        }
        return pathList
    }
}