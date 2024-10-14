/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal.core

import cjfinal.exception.AlreadyExistException

import std.collection.HashMap
import std.reflect.TypeInfo
import encoding.url.URL
import std.collection.ArrayList

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
        // 判断path是否已存在
        match(routesMap.get(path)){
            case None =>
                // path不存在，添加到routesMap中
                if(CJFinal.me.constants.devMode){
                    println("Add route: ${path} -> ${TypeInfo.of(controller).name}")
                }
                routesMap.put(path, controller)
            case _ => 
                // path已存在，抛出AlreadyExistException
                throw AlreadyExistException('path "${path}" already exist.')
        } 
    }

    /**
     * 根据请求获取匹配到的(path和controller)
     * @param url URL
     * @return (String, Option<Controller>) 匹配到的path和controller对象
     */
    public func get(url: URL): (String, ?Controller){
        let pathList = this.calPossiblePath(url)
        var controller: ?Controller = None

        for(path in pathList){
            controller = routesMap.get(path)
            match(controller){
                case None => continue
                case Some(con) => return (path, con)
            }
        } 
        return ("", None)
    }

    /**
     * 根据url计算出所有path的可能性，返回的是个列表，排列顺序根据path包含的节点数从高到低排列
     */
    private func calPossiblePath(url: URL): ArrayList<String>{
        let nodeList = this.getRouteNodeList(url)
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
    private func getRouteNodeList(url: URL): ArrayList<String>{
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