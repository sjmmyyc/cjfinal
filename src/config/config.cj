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
 * CJFinal运行时配置信息
 */
public class Config{

    // 是否是开发模式
    protected static var DEV_MODE = false

    // 上传文件存放目录，默认相对于当前目录，如果指定为其它目录，请确保有对应目录的访问权限
    protected static var UPLOAD_PATH = "upload"

    // 上传文件允许的最大尺寸，默认为2MB
    protected static var MAX_UPLOAD_SIZE = 2 * 1024 * 1024

    // 上传文件时的BufferedInputStream缓冲区大小，默认为64K，下限为128字节
    protected static var UPLOAD_BUFFER_CAPACITY = 64 * 1024
}