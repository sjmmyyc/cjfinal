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
import std.collection.ArrayList
import std.database.sql.{SqlDbType, UpdateResult, Connection}
import std.reflect.TypeInfo

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

    public func save(table: String, record: Record): UpdateResult{
        let conn = _config.connect()
        let sql = StringBuilder()
        let params = ArrayList<SqlDbType>()
        _config.dialect.forDbSave(sql, table, record, params)
        if(_config.showSql){
            println(sql)
        }
        let stmt = conn.prepareStatement(sql.toString())
        let result = stmt.update(params.toArray())
        autoClose(conn)
        return result
    }

    public func delete(table: String, record: Record): UpdateResult{
        let conn = _config.connect()
        let sql = StringBuilder()
        let params = ArrayList<SqlDbType>()
        _config.dialect.forDbDelete(sql, table, record, params)
        if(_config.showSql){
            println(sql)
        }
        let stmt = conn.prepareStatement(sql.toString())
        let result = stmt.update(params.toArray())
        autoClose(conn)
        return result
    }

    public func update(table: String, record: Record): UpdateResult{
        return update(table, "id", record)
    }

    public func update(table: String, primaryKeys: String, record: Record): UpdateResult{
        let conn = _config.connect()
        let sql = StringBuilder()
        let params = ArrayList<SqlDbType>()
        let pKeys = toArray(primaryKeys)
        _config.dialect.forDbUpdate(sql, table, pKeys, record, params)
        if(_config.showSql){
            println(sql)
        }
        let stmt = conn.prepareStatement(sql.toString())
        let result = stmt.update(params.toArray())
        autoClose(conn)
        return result
    }

    public func update(sql: String, params: ArrayList<Any>): UpdateResult{
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        let result = stmt.update(paramList.toArray())
        autoClose(conn)
        return result
    }

    public func findFirst(sql: String, params: ArrayList<Any>): Record{
        let paramList = DbKit.getSqlDbTypeList(params)
        let record = Record()
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        let results = DbKit.getSqlDbTypeList(result.columnInfos)
        result.next(results)
        var i = 0
        for(columnInfo in result.columnInfos){
            record.set(columnInfo.name, results.get(i).getOrThrow())
            i++
        }
        autoClose(conn)
        return record
    }

    public func find(sql: String, params: ArrayList<Any>): ArrayList<Record>{
        let list = ArrayList<Record>()
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        let results = DbKit.getSqlDbTypeList(result.columnInfos)
        while(result.next(results)){
            var i = 0
            var record = Record()
            for(columnInfo in result.columnInfos){
                record.set(columnInfo.name, results.get(i).getOrThrow())
                i++
            }
            list.append(record)
        }
        autoClose(conn)
        return list
    }

    public func queryList<T>(sql: String, params: ArrayList<Any>): ArrayList<?T>{
        let list = ArrayList<?T>()
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        if(result.columnInfos.size != 1){
            conn.close()
            throw IllegalArgumentException("Db.query(..) only supports single column queries.")
        }
        let results = DbKit.getSqlDbTypeList(result.columnInfos)
        while(result.next(results)){
            list.append(DbKit.getValue<T>(results.get(0).getOrThrow()))
        }
        autoClose(conn)
        return list
    }

    public func query<T>(sql: String, params: ArrayList<Any>): ?T{
        var value: ?T = None
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        if(result.columnInfos.size != 1){
            conn.close()
            throw IllegalArgumentException("Db.query(..) only supports single column queries.")
        }
        let results = DbKit.getSqlDbTypeList(result.columnInfos)
        result.next(results)
        value = DbKit.getValue<T>(results.get(0).getOrThrow())
        autoClose(conn)
        return value
    }

    public func tx(trans: () -> Bool): Unit{
        let conn = _config.connect()
        let transaction = conn.createTransaction()
        transaction.begin()
        _config.setThreadLocalConnection(conn)
        if(trans()){
            transaction.commit()
        }else{
            transaction.rollback()
        }
        _config.clearThreadLocalConnection()
        conn.close()
    }

    /**
     * 根据主键组成的字符串，获取到主键列表
     */
    private func toArray(primaryKey: String): Array<String>{
        let list = ArrayList<String>()
        let arr = primaryKey.split(",")
        for(key in arr){
            list.append(key.trimAscii())
        }
        return list.toArray()
    }

    /**
     * 自动关闭连接，用于对事务的支持
     */
    private func autoClose(conn: Connection): Unit{
        if(!_config.isTransaction){
            conn.close()
        }
    }
}