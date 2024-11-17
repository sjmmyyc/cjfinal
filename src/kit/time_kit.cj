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
package cjfinal.kit

import std.format.Formatter

/**
 * TimeKit.
 */
public class TimeKit{

    /**
     * 将传入的纳秒转换成直观记数，以纳秒、微秒、毫秒、秒来显示
     */
    public static func intuitive(nanoseconds: Int): String{
        if(nanoseconds < 1000){
            return nanoseconds.format(".2") + "ns"
        }else if(nanoseconds < 1000000){
            return (Float64(nanoseconds) / 1e3).format(".2") + "μs"
        }else if(nanoseconds < 1000000000){
            return (Float64(nanoseconds) / 1e6).format(".2") + "ms"
        }else{
            return (Float64(nanoseconds) / 1e9).format(".2") + "s"
        }
        return ""
    }

    /**
     * 将传入的duration转换成直观记数，以纳秒、微秒、毫秒、秒来显示
     */
    public static func intuitive(duration: Duration): String{
        return intuitive(duration.toNanoseconds())
    }
}