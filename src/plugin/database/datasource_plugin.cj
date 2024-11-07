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
import cjfinal.plugin.IDatasourceProvider
import cjfinal.exception.NotFoundException
import std.database.sql.{DriverManager, PooledDatasource, Datasource}
import mysqlclient4cj.cdbc.{DatasourceImpl}

/**
 * DatasourcePlugin.
 */
public class DatasourcePlugin <: IPlugin & IDatasourceProvider{

    private var _ds: ?Datasource = None

    // 基本属性
    private let _url: String
    private let _database: String
    private let _username: String
    private let _password: String
    
    private var _isStarted = false

    public init(url: String, database: String, username: String, password: String){
        _url = url
        _database = database
        _username = username
        _password = password
    }

    public func start(): Bool{
        if(_isStarted){
            return true
        }
        let usernameProp = ("username", _username)
        let passwordProp = ("password", _password)
        let databaseProp = ("database", _database)
        let driverName = _url.split("://")[0]

        if(driverName != "mysql"){
            throw UnsupportedException('"${driverName}" database is not yet supported')
        }

        let driver = DriverManager.getDriver(driverName).getOrThrow()
        _ds = PooledDatasource(driver.open(_url, [usernameProp, passwordProp, databaseProp]))

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
    public override func getDatasource(): Datasource{
        return _ds.getOrThrow()
    }
}