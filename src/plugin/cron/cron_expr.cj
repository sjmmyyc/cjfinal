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

import std.regex.Regex
import std.time.DateTime
import std.convert.Parsable
import std.collection.ArrayList

/**
 * Cron表达式
 * CJFinal的Cron表达式支持5个部分，从左到右分别表示分、时、日、月、周
 */
public class CronExpr{

    // Cron表达式字段：分钟、小时、日期、月份、星期
    private static let MINUTE = 0
    private static let HOUR = 1
    private static let DAY = 2
    private static let MONTH = 3
    private static let WEEKDAY = 4

    private let _cronFields: Array<String>

    public init(expr: String){
        // let re = Regex(##"^(\d{1,2}|[*/\-,\d]+)\s+(\d{1,2}|[*/\-,\d]+)\s+(\d{1,2}|[*/\-,\d]+)\s+(\d{1,2}|[*/\-,\d]+)\s+(\d{1,2}|[*/\-,\d]+)$"##)
        let re = Regex(##"^(\d{1,2}|[*]{1}|[\d{1,2}*]/\d{1,2}|\d{1,2}-\d{1,2}/\d{1,2}|\d{1,2}-\d{1,2}|(\d{1,2},*)*)\s+(\d{1,2}|[*]{1}|[\d{1,2}*]/\d{1,2}|\d{1,2}-\d{1,2}/\d{1,2}|\d{1,2}-\d{1,2}|(\d{1,2},*)*)\s+(\d{1,2}|[*L]{1}|[\d{1,2}*]/\d{1,2}|\d{1,2}-[\d{1,2}L{1}]/\d{1,2}|\d{1,2}-[\d{1,2}L{1}]|([\d{1,2}|L{1}],*)*)\s+(\d{1,2}|[*]{1}|[\d{1,2}*]/\d{1,2}|\d{1,2}-\d{1,2}/\d{1,2}|\d{1,2}-\d{1,2}|(\d{1,2},*)*)\s+(\d{1,2}|[*]{1}|[\d{1,2}*]/\d{1,2}|\d{1,2}-\d{1,2}/\d{1,2}|\d{1,2}-\d{1,2}|(\d{1,2},*)*)$"##)
        if(re.matches(expr).isNone()){
            throw ParseException("Invalid Cron Expression")
        }
        _cronFields = expr.split(" ")
    }

    /**
     * 测试未来5次的执行时间
     */
    public func test(current: DateTime): ArrayList<DateTime>{
        let result = ArrayList<DateTime>()
        var temp = current
        for(_ in 0..5){
            temp = next(temp)
            result.append(temp)
        }
        return result
    }

    /**
     * 根据传入的时间，计算下一次执行时间
     */
    public func next(current: DateTime): DateTime{
        var test = DateTime.of(year: current.year, month: current.month, dayOfMonth: current.dayOfMonth, hour: current.hour, minute: current.minute)
        do{
            test = test.addMinutes(1)
        }while(!matches(test))
        return test
    }

    /**
     * 检查给定的时间是否匹配Cron表达式
     */
    private func matches(date: DateTime): Bool{
        var checkDay = false
        if(_cronFields[DAY].contains("L")){
            var temp = _cronFields[DAY]
            temp = temp.replace("L", "${getMaxOfMonth(date)}")
            checkDay = matchesField(date.dayOfMonth, temp)
        }else{
            checkDay = matchesField(date.dayOfMonth, _cronFields[DAY])
        }

        return matchesField(date.minute, _cronFields[MINUTE]) &&
               matchesField(date.hour, _cronFields[HOUR]) &&
               checkDay &&
               matchesField(date.month.value(), _cronFields[MONTH]) &&
               matchesField(date.dayOfWeek.value(), _cronFields[WEEKDAY]);
    }

    /**
     * 检查单个字段是否匹配
     */
    private func matchesField(value: Int, field: String): Bool{
        if(field == "*"){
            return true
        }
        let values = field.split(",")
        for(v in values){
            if(v.contains("/")){
                // 步进值
                let steps = v.split("/")
                var start = 0
                var end = 0
                var step = Int.parse(steps[1])
                if(steps[0] == "*"){
                    // 如 */5
                    if((value - start) % step == 0){
                        return true
                    }
                }else if(steps[0].contains("-")){
                    // 如 3-20/5
                    let vals = steps[0].split("-")
                    start = Int.parse(vals[0])
                    end = Int.parse(vals[1])
                    if((value - start) % step == 0 && value >= start && value <= end){
                        return true
                    }
                }else{
                    // 如 5
                    start = Int.parse(steps[0])
                    if((value - start) % step == 0){
                        return true
                    }
                }
            }else if(v.contains("-")){
                // 范围值，如1-5
                let range = v.split("-")
                let start = Int.parse(range[0])
                let end = Int.parse(range[1])
                if(value >= start && value <= end){
                    return true
                }
            }else{
                // 具体值
                if(Int.parse(v) == value){
                    return true
                }
            }
        }
        return false
    }

    /**
     * 获取传入的日期所表示的月份总共有多少天
     */
    private func getMaxOfMonth(date: DateTime): Int{
        var tempDate = date
        var result = 0
        do{
            result = tempDate.dayOfMonth
            tempDate = tempDate.addDays(1)
        }while(tempDate.monthValue == date.monthValue)
        return result
    }
}