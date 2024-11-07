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

/**
 * Db.
 */
public class Db{

    private static var _MAIN: ?DbPro = None

    /**
     * for DbKit.addConfig(configName)
     */
    static func initi(configName: String): Unit{
        
    }

    // public static func use(configName: String): DbPro{
    //     // return DbKit.getDatasource(configName)
    // }

    public static func save(table: String, record: Record): Bool{
        save(table, "id", record)
    }

    public static func save(table: String, primaryKey: String, record: Record): Bool{
        true
    }
}