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
package cjfinal.plugin.database


import cjfinal.plugin.IPlugin
import std.database.sql.PooledDatasource
import mysqlclient4cj.jdbc.impl.{DatasourceImpl, ConnectionImpl}
import mysqlclient4cj.jdbc.{DriverManager, Datasource, Connection, SqlException}

/**
 * DatasourcePlugin.
 */
public class DatasourcePlugin <: IPlugin{

    private var _ds: ?Datasource = None

    // 基本属性
    private let _host: String
    private let _port: Int
    private let _username: String
    private let _password: String
    private let _database: String
    
    private var _isStarted = false

    public init(host: String, username: String, password: String, database: String){
        this(host, 3306, username, password, database)
    }

    public init(host: String, port: Int, username: String, password: String, database: String){
        _host = host
        _port = port
        _username = username
        _password = password
        _database = database
    }

    public func start(): Bool{
        if(_isStarted){
            return true
        }
        let usernameProp = ("username", _username)
        let passwordProp = ("password", _password)
        let databaseProp = ("database", _database)
        let driver = DriverManager.getDriver("mysql").getOrThrow()
        this._ds = driver.open("mysql://${_host}:${_port}", [usernameProp, passwordProp, databaseProp])

        _isStarted = true
        return true
    }

    public func stop(): Bool{
        _ds?.close()
        _ds = None
        _isStarted = false
        return true
    }

    /**
     * 获取datasource
     */
    public prop datasource: Datasource{
        get(){
            return _ds.getOrThrow()
        }
    }
}