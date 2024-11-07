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

    public static func save(table: String, record: Record): Bool{
        return MAIN.getOrThrow().save(table, record)
    }

    public static func save(table: String, primaryKey: String, record: Record): Bool{
        return MAIN.getOrThrow().save(table, primaryKey, record)
    }
}