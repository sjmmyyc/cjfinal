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
package cjfinal.upload

import std.fs.File

/**
 * UploadFile.
 */
public class UploadFile <: ToString{

    private var _parameterName: String

    private var _uploadPath: String
    private var _filename: String
    private var _originalFilename: String
    private var _contentType: String

    public init(parameterName: String, uploadPath: String, filename: String, originalFilename: String, contentType: String){
        this._parameterName = parameterName
        this._uploadPath = uploadPath
        this._filename = filename
        this._originalFilename = originalFilename
        this._contentType = contentType
    }

    public func toString(): String{
        return "UploadFile: parameterName: ${this._parameterName}, uploadPath: ${this._uploadPath}, fileName: ${this._filename}, originalFilename: ${this._originalFilename}, contentType: ${this._contentType}"
    }

    public prop parameterName: String{
        get(){
            this._parameterName
        }
    }

    public prop uploadPath: String{
        get(){
            this._uploadPath
        }
    }

    public prop filename: String{
        get(){
            this._filename
        }
    }

    public prop originalFilename: String{
        get(){
            this._originalFilename
        }
    }
}