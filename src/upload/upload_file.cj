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
public class UploadFile{

    private var _parameterName: String

    private var _uploadPath: String
    private var _fileName: String
    private var _originalFileName: String
    private var _contentType: String

    public init(parameterName: String, uploadPath: String, fileName: String, originalFileName: String, contentType: String){
        this._parameterName = parameterName
        this._uploadPath = uploadPath
        this._fileName = fileName
        this._originalFileName = originalFileName
        this._contentType = contentType
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

    public prop fileName: String{
        get(){
            this._fileName
        }
    }

    public prop originalFileName: String{
        get(){
            this._originalFileName
        }
    }
}