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

import cjfinal.plugin.activerecord.dialect.{Dialect, MysqlDialect}
import std.database.sql.Datasource

/**
 * ActiveRecordPlugin Config.
 */
public class Config{

    private let _ds: Datasource
    
    private let _dialect: Dialect

    private var _showSql: Bool

    public mut prop showSql: Bool{
        set(value){
            _showSql = value
        }
        get(){
            return _showSql
        }
    }

    /**
     * 构造器，默认方言为MysqlDialect
     * @Param datasource - 数据源
     */
    public init(datasource: Datasource){
        this(datasource, MysqlDialect())
    }

    /**
     * 构造器
     * @Param datasource - 数据源
     * @Param dialect - 方言
     */
    public init(datasource: Datasource, dialect: Dialect){
        _ds = datasource
        _dialect = dialect
        _showSql = false
    }
}