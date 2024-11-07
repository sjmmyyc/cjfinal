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

    private let _name: String
    private let _ds: Datasource
    private let _dialect: Dialect
    private var _showSql: Bool

    public prop name: String{
        get(){
            this._name
        }
    }

    public mut prop showSql: Bool{
        set(value){
            _showSql = value
        }
        get(){
            return _showSql
        }
    }

    /**
     * 构造器
     * @Param name - 配置名称
     * @Param datasource - 数据源
     * @Param dialect - 方言
     * @Param showSql - 是否显示生成的SQL语句
     */
    public init(name: String, datasource: Datasource, dialect: Dialect, showSql: Bool){
        _name = name
        _ds = datasource
        _dialect = dialect
        _showSql = showSql
    }
}