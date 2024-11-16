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
package cjfinal.config

/**
 * CmdColor.
 * 当Config.DEV_MODE为false时，不需要颜色指令，因此返回空字符串
 */
public class CmdColor{

    public static prop gray: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[30m"
            }else{
                return ""
            }
        }
    }

    public static prop red: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[31m"
            }else{
                return ""
            }
        }
    }

    public static prop green: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[32m"
            }else{
                return ""
            }
        }
    }

    public static prop yellow: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[33m"
            }else{
                return ""
            }
        }
    }

    public static prop blue: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[34m"
            }else{
                return ""
            }
        }
    }

    public static prop purple: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[35m"
            }else{
                return ""
            }
        }
    }

    public static prop cyan: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[36m"
            }else{
                return ""
            }
        }
    }

    public static prop lightGray: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[37m"
            }else{
                return ""
            }
        }
    }

    public static prop white: String{
        get(){
            if(Config.DEV_MODE){
                return "\u{1b}[0m"
            }else{
                return ""
            }
        }
    }
}