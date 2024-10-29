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
package cjfinal.util

import std.collection.ArrayList

/**
 * extend Array<Byte>.
 */
extend Array<Byte> {

    /**
     * 分割Array<Byte>
     * @param separator: Array<Byte> - 分割符号
     * @param dropLast!: Bool - 是否丢弃最后一项，默认为false
     */
    public func split(separator: Array<Byte>, dropLast!: Bool = false): ArrayList<Array<Byte>>{
        let result = ArrayList<Array<Byte>>()
        let thisSize = this.size
        let separatorSize = separator.size
        // 记录上一次匹配到的索引下标
        var prevIndex = 0
        for(i in 0..=thisSize - separatorSize){
            if(this[i..i+separatorSize] == separator){
                // 匹配上了

                // 表示开头的位
                if(i != 0){
                    if(i - prevIndex != separatorSize){

                    }
                }
            }
        }
        return result
    }
}

/**
 * ByteArrayUtils.
 */
public class ByteArrayUtils{

}

