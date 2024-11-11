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
import std.database.sql.{SqlDbType, UpdateResult, Connection, TransactionIsoLevel, SqlNullableBigInt}
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
        autoShowSql(sql.toString())
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
        autoShowSql(sql.toString())
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
        autoShowSql(sql.toString())
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
        autoShowSql(sql)
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        let results = DbKit.getSqlDbTypeList(result.columnInfos)
        result.next(results)
        for((i, columnInfo) in result.columnInfos.iterator().enumerate()){
            record.set(columnInfo.name, results.get(i).getOrThrow())
        }
        autoClose(conn)
        return record
    }

    public func find(sql: String, params: ArrayList<Any>): ArrayList<Record>{
        let list = ArrayList<Record>()
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        autoShowSql(sql)
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        var results = DbKit.getSqlDbTypeList(result.columnInfos)
        while(result.next(results)){
            var record = Record()
            for((index, columnInfo) in result.columnInfos.iterator().enumerate()){
                record.set(columnInfo.name, results.get(index).getOrThrow())
            }
            list.append(record)
            results = DbKit.getSqlDbTypeList(result.columnInfos)
        }
        autoClose(conn)
        return list
    }

    public func queryList<T>(sql: String, params: ArrayList<Any>): ArrayList<?T>{
        let list = ArrayList<?T>()
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        autoShowSql(sql)
        let stmt = conn.prepareStatement(sql)
        let result = stmt.query(paramList.toArray())
        if(result.columnInfos.size != 1){
            conn.close()
            throw IllegalArgumentException("Db.query(..) only supports single column queries.")
        }
        var results = DbKit.getSqlDbTypeList(result.columnInfos)
        while(result.next(results)){
            list.append(DbKit.getValue<T>(results.get(0).getOrThrow()))
            results = DbKit.getSqlDbTypeList(result.columnInfos)
        }
        autoClose(conn)
        return list
    }

    public func query<T>(sql: String, params: ArrayList<Any>): ?T{
        var value: ?T = None
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        let stmt = conn.prepareStatement(sql)
        autoShowSql(sql)
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

    public func paginate(pageNumber: Int, pageSize: Int, select: String, sqlExceptSelect: String, params: ArrayList<Any>): Page{
        let paramList = DbKit.getSqlDbTypeList(params)
        let conn = _config.connect()
        // get totalRow
        var sql = "select count(*) ${sqlExceptSelect}"
        autoShowSql(sql)
        var stmt = conn.prepareStatement(sql)
        var result = stmt.query()
        let totalRowSqlDbType = SqlNullableBigInt(None)
        result.next([totalRowSqlDbType])
        let totalRow = totalRowSqlDbType.value.getOrThrow()
        // calculate totalPage
        var totalPage = totalRow / pageSize
        if(totalRow % pageSize > 0){
            totalPage++
        }
        // get record list
        sql = "${select} ${sqlExceptSelect} limit ${(pageNumber - 1) * pageSize}, ${pageSize}"
        autoShowSql(sql)
        stmt = conn.prepareStatement(sql)
        result = stmt.query(paramList.toArray())
        let list = ArrayList<Record>()
        var results = DbKit.getSqlDbTypeList(result.columnInfos)
        while(result.next(results)){
            var record = Record()
            for((index, columnInfo) in result.columnInfos.iterator().enumerate()){
                record.set(columnInfo.name, results.get(index).getOrThrow())
            }
            list.append(record)
            results = DbKit.getSqlDbTypeList(result.columnInfos)
        }
        let page = Page(list, pageNumber, pageSize, totalPage, totalRow)
        autoClose(conn)
        return page
    }

    public func tx(level: TransactionIsoLevel, trans: () -> Bool): Bool{
        let conn = _config.connect()
        let transaction = conn.createTransaction()
        transaction.isoLevel = level
        transaction.begin()
        _config.setThreadLocalConnection(conn)
        var result = false
        if(trans()){
            transaction.commit()
            result = true
        }else{
            transaction.rollback()
            result = false
        }
        _config.clearThreadLocalConnection()
        conn.close()
        return result
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
     * 自动判断是否真正关闭连接，用于对事务的支持
     */
    private func autoClose(conn: Connection): Unit{
        if(!_config.isTransaction){
            conn.close()
        }
    }

    private func autoShowSql(sql: String): Unit{
        if(_config.showSql){
            println(sql)
        }
    }
}