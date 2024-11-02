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
package cjfinal.test.controller

import cjfinal.core.Controller
import cjfinal.aop.{Before, Clear}
import cjfinal.test.model.User
import cjfinal.upload.ExceedingLimitException
import std.fs.FSException

@Before["cjfinal.test.interceptor.ControllerInterceptor"]
@Clear[""]
public class RootController <: Controller{

    @Before["cjfinal.test.interceptor.MethodInterceptor"]
    public func index(){
        let obj = User()
        this.renderJson(obj)
    }

    public func login(){
        println(this.get("phone"))
        let user = User()
        this.renderJson(user)
    }

    @Clear[""]
    public func formdata(){
        try{
            // let uploadFiles = this.getFiles()
            // for(uploadFile in uploadFiles){
            //     println(uploadFile)
            // }
            // println("name: ${this.get('name')}")
            println(this.getFile("avatar"))
            this.renderText("/formdata is invoke.")
        }catch(e: ExceedingLimitException){
            this.renderErr413()
        }catch(e: FSException){
            this.renderText("Already exist...")
        }catch(e: Exception){
            e.printStackTrace()
        }
    }
}