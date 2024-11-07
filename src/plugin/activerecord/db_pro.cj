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
package cjfinal.plugin.activerecord

/**
 * DbPro.数据库访问操作的主要实现类
 */
public class DbPro{

    private let _config: Config

    public prop config: Config{
        get(){
            this._config
        }
    }

    public init(config: Config){
        _config = config
    }

    public func save(table: String, record: Record): Bool{
        return save(table, "id", record)
    }

    public func save(table: String, primaryKey: String, record: Record): Bool{
        println(_config.name)
        true
    }
}