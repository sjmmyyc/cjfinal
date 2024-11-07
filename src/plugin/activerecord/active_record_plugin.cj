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

import cjfinal.plugin.{IPlugin, IDatasourceProvider}
import cjfinal.plugin.activerecord.dialect.{Dialect, MysqlDialect}
import std.database.sql.Datasource

/**
 * ActiveRecordPlugin.
 */
public class ActiveRecordPlugin <: IPlugin{

    private let _configName: String
    private let _dp: IDatasourceProvider
    private let _dialect: Dialect
    private var _showSql = false

    private var _isStarted = false

    /**
     * 是否显示生成的SQL语句
     */
    public mut prop showSql: Bool{
        set(value){
            _showSql = value
        }
        get(){
            return _showSql
        }
    }

    /**
     * 构造器，configName使用默认名称main，方言默认为MysqlDialect
     * @Param dsProvider - 数据源提供者
     */
    public init(dsProvider: IDatasourceProvider){
        this(DbKit.MAIN_CONFIG_NAME, dsProvider)
    }

    /**
     * 构造器，由用户指定配置名称，方言默认为MysqlDialect
     * @Param configName - 配置名称
     * @Param dsProvider - 数据源提供者
     */
    public init(configName: String, dsProvider: IDatasourceProvider){
        this(configName, dsProvider, MysqlDialect())
    }

    /**
     * 构造器，由用户指定配置名称和方言
     * @Param configName - 配置名称
     * @Param dsProvider - 数据源提供者
     * @Param dialect - 方言
     */
    public init(configName: String, dsProvider: IDatasourceProvider, dialect: Dialect){
        if(configName == ""){
            throw IllegalArgumentException("Config name can not be blank")
        }
        _configName = configName
        _dp = dsProvider
        _dialect = dialect
    }

    /**
     * 启动插件
     */
    public override func start(): Bool{
        if(_isStarted){
            return true
        }

        let config = Config(_configName, _dp.getDatasource(), _dialect, _showSql)
        DbKit.addConfig(_configName, config)
        return true
    }

    /**
     * 停止插件
     */
    public override func stop(): Bool{
        true
    }
}