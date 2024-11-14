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
package cjfinal.plugin.cron

import std.collection.LinkedList
import log.getGlobalLogger
import std.time.DateTime
import std.sync.Timer

/**
 * 定时任务调度器
 */
public class Scheduler{
    // 单例
    private static var _me: ?Scheduler = None
    private static let _taskList = LinkedList<Task>()
    private static let dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    private static var _timer: ?Timer = None

    private let logger = getGlobalLogger([("name", "main")])

    private init(){}

    /**
     * 获取调度器
     */
    public static func get(): Scheduler{
        if(_me.isNone()){
            _me = Scheduler()
        }
        return _me.getOrThrow()
    }

    /**
     * 添加新任务到调度器，按时间先后顺序添加到链表中
     */
    public func addTask(task: Task): Unit{
        // logger.debug("add: ${task.nextTime.toString(dateFormat)}")
        var currentNode = _taskList.firstNode()
        var isAdded = false
        while(let Some(node) <- currentNode){
            // 判断新加入的任务最近一次执行时间是否在currentNode之前
            if(task.nextTime <= node.value.nextTime){
                _taskList.insertBefore(node, task)
                isAdded = true
                break
            }
            currentNode = node.next
        }
        if(!isAdded){
            _taskList.append(task)
        }
    }

    /**
     * 开始调度定时任务
     */
    public func start(): Unit{
        debugInfo()
        // 获取第一个task的执行时间
        let firstNode = _taskList.firstNode()
        if(let Some(node) <- firstNode){
            let nearestTime = node.value.nextTime
            // logger.debug("Nearest task time: ${nearestTime.toString(dateFormat)}")
            let now = DateTime.now()
            let duration = nearestTime - now
            _timer = Timer.once(duration, execute)
        }
    }

    /**
     * 定时器时间到了时，会调用这个方法
     */
    private func execute(): Unit{
        let now = DateTime.now()
        var currentNode = _taskList.firstNode()
        while(let Some(node) <- currentNode){
            currentNode = node.next
            if(node.value.nextTime <= now){
                let task = _taskList.remove(node)
                spawn{
                    task.run()
                }
                task.updateNextTime(now)
                addTask(task)
            }else{
                break
            }
        }
        start()
    }

    /**
     * 停止调度定时任务
     */
    public func stop(): Unit{
        _timer?.cancel()
    }

    /**
     * 打印调试信息
     */
    private func debugInfo(): Unit{
        logger.debug("task num: ${_taskList.size}")
        for(node in _taskList.firstNode().getOrThrow().backward()){
            logger.debug("Task time: ${node.nextTime.toString(dateFormat)}")
        }
    }
}