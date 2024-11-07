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
 * DbKit用于管理多数据源和其配置信息
 */
public class DbKit{

    public static let MAIN_CONFIG_NAME = "main"
    private static let configs: Map<String, Config> = HashMap<String, Config>()
    
    /**
     * 添加数据源配置
     */
    public static func addConfig(name: String, config: Config): Unit{
        configs.put(name, config)
        // 如果此时只有一个数据源配置项，便将其设置为Db的主DbPro
        if(configs.size == 1){
            Db.setMain(config)
        }
    }

    /**
     * 获取数据源配置
     */
    public static func getConfig(name: String): Config{
        return configs.get(name).getOrThrow()
    }
}