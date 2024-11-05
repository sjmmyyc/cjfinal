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
package cjfinal.plugin.mysql

import cjfinal.plugin.IPlugin
import std.database.sql.PooledDatasource
import mysqlclient4cj.jdbc.impl.{DatasourceImpl, ConnectionImpl}
import mysqlclient4cj.jdbc.{DriverManager, Datasource, Connection, SqlException}

/**
 * MysqlPlugin.
 */
public class MysqlPlugin <: IPlugin{

    private var _datasource: ?Datasource = None
    private var _connection: ?Connection = None

    private let _ip: String
    private let _port: Int
    private let _username: String
    private let _password: String
    private let _database: String


    public init(ip: String, username: String, password: String, database: String){
        this(ip, 3306, username, password, database)
    }

    public init(ip: String, port: Int, username: String, password: String, database: String){
        this._ip = ip
        this._port = port
        this._username = username
        this._password = password
        this._database = database
    }

    public func start(): Bool{
        try{
            let usernameProp = ("username", _username)
            let passwordProp = ("password", _password)
            let databaseProp = ("database", _database)
            let driver = DriverManager.getDriver("mysql").getOrThrow()
            this._datasource = driver.open("mysql://${this._ip}:${this._port}", [usernameProp, passwordProp, databaseProp])
            this._connection = this._datasource?.connect()
            return true
        }catch(e: SqlException){
            e.printStackTrace()
            return false
        }
    }

    public func stop(): Bool{
        this._connection?.close()
        true
    }

    public prop connection: Connection{
        get(){
            if(let Some(con) <- this._connection){
                if(con.isClosed()){
                    this._connection = this._datasource?.connect()
                }
            }else{
                this._connection = this._datasource?.connect()
            }
            this._connection.getOrThrow()
        }
    }
}