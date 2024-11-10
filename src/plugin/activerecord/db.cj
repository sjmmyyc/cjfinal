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

import std.collection.{Map, HashMap}
import std.database.sql.{UpdateResult, TransactionIsoLevel}
import std.collection.ArrayList

/**
 * Db.
 */
public class Db{

    private static var MAIN: ?DbPro = None
    private static let cache: Map<String, DbPro> = HashMap<String, DbPro>()

    /**
     * for DbKit.addConfig(configName)
     */
    public static func setMain(config: Config): Unit{
        MAIN = DbPro(config)
    }

    /**
     * 删除缓存的DbPro，如果不存在相应的DbPro，返回None
     */
    public static func removeDbPro(config: Config): ?DbPro{
        return cache.remove(config.name)
    }

    /**
     * 选择使用哪个数据源
     */
    public static func use(configName: String): DbPro{
        if(let Some(dbPro) <- cache.get(configName)){
            return dbPro
        }else{
            let dbPro = DbPro(DbKit.getConfig(configName))
            cache.put(configName, dbPro)
            return dbPro
        }
    }

    public static func save(table: String, record: Record): UpdateResult{
        return MAIN.getOrThrow().save(table, record)
    }

    /**
     * 将record中的所有参数以and连接做为判断条件，来删除table表中的条目
     */
    public static func delete(table: String, record: Record): UpdateResult{
        return MAIN.getOrThrow().delete(table, record)
    }

    public static func update(table: String, record: Record): UpdateResult{
        return MAIN.getOrThrow().update(table, record)
    }

    public static func update(table: String, primaryKeys: String, recrod: Record): UpdateResult{
        return MAIN.getOrThrow().update(table, primaryKeys, recrod)
    }

    public static func update(sql: String): UpdateResult{
        return update(sql, [])
    }

    public static func update(sql: String, params: Array<Any>): UpdateResult{
        let paramList = ArrayList<Any>(params)
        return MAIN.getOrThrow().update(sql, paramList)
    }

    public static func findFirst(sql: String): Record{
        return findFirst(sql, [])
    }

    public static func findFirst(sql: String, params: Array<Any>): Record{
        let paramList = ArrayList<Any>(params)
        return MAIN.getOrThrow().findFirst(sql, paramList)
    }

    public static func find(sql: String): ArrayList<Record>{
        return find(sql, [])
    }

    public static func find(sql: String, params: Array<Any>): ArrayList<Record>{
        let paramList = ArrayList<Any>(params)
        return MAIN.getOrThrow().find(sql, paramList)
    }

    public static func queryList<T>(sql: String): ArrayList<?T>{
        return queryList<T>(sql, [])
    }

    public static func queryList<T>(sql: String, params: Array<Any>): ArrayList<?T>{
        let paramList = ArrayList<Any>(params)
        return MAIN.getOrThrow().queryList(sql, paramList)
    }

    public static func query<T>(sql: String): T{
        return query<T>(sql, [])
    }

    public static func query<T>(sql: String, params: Array<Any>): T{
        return queryNullable<T>(sql, params).getOrThrow()
    }

    public static func queryNullable<T>(sql: String): ?T{
        return queryNullable<T>(sql, [])
    }

    public static func queryNullable<T>(sql: String, params: Array<Any>): ?T{
        let paramList = ArrayList<Any>(params)
        return MAIN.getOrThrow().query(sql, paramList)
    }

    public static func tx(trans: () -> Bool): Bool{
        return MAIN.getOrThrow().tx(TransactionIsoLevel.RepeatableRead, trans)
    }

    public static func tx(level: TransactionIsoLevel, trans: () -> Bool): Bool{
        return MAIN.getOrThrow().tx(level, trans)
    }
}