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
package cjfinal.test.handler

import cjfinal.core.Handler
import net.http.HttpContext
import cjfinal.kit.PropKit

public class CORSHandler <: Handler{
    
    public func handle(ctx: HttpContext): Unit{
        let response = ctx.responseBuilder
        response.header("Access-Control-Allow-Origin", "*");
		response.header("Access-Control-Allow-Methods", "OPTIONS,GET,PUT,POST,DELETE");
        var time = 2592000;	 // 默认缓存时间设置为30天
        if(PropKit.getBoolByDefault("devMode", false)) {
			// 如果是开发模式，设置为10秒
			time = 10;
		}
		// 设置缓存时间
		response.header("Access-Control-Max-Age", time.toString());
		response.header("Access-Control-Allow-Headers", "Accept,Origin,DNT,X-Custom-Header,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Last-Modified");
        this.next.handle(ctx)
    }
}