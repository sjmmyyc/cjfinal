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

import std.collection.ArrayList
import serialization.serialization.{Serializable, DataModelStruct, DataModel, field}

/**
 * Page is the result of Db.paginate(...)
 */
public class Page <: Serializable<Page>{

    private let _list: ArrayList<Record>
    private let _pageNumber: Int
    private let _pageSize: Int
    private let _totalPage: Int
    private let _totalRow: Int

    public prop list: ArrayList<Record>{
        get(){
            return _list
        }
    }

    public prop pageNumber: Int{
        get(){
            return _pageNumber
        }
    }

    public prop pageSize: Int{
        get(){
            return _pageSize
        }
    }

    public prop totalPage: Int{
        get(){
            return _totalPage
        }
    }

    public prop totalRow: Int{
        get(){
            return _totalRow
        }
    }

    public prop isFirstPage: Bool{
        get(){
            return _pageNumber == 1
        }
    }

    public prop isLastPage: Bool{
        get(){
            return _pageNumber >= _totalPage
        }
    }

    /**
     * 测试用，无实际意义
     */
    public init(){
        _list = ArrayList<Record>()
        _pageNumber = 0
        _pageSize = 0
        _totalPage = 0
        _totalRow = 0
    }

    public init(list: ArrayList<Record>, pageNumber: Int, pageSize: Int, totalPage: Int, totalRow: Int){
        _list = list
        _pageNumber = pageNumber
        _pageSize = pageSize
        _totalPage = totalPage
        _totalRow = totalRow
    }

    public func serialize(): DataModel {
        var dms = DataModelStruct()
        dms.add(field<Int>("pageNumber", _pageNumber))
        dms.add(field<Int>("pageSize", _pageSize))
        dms.add(field<Int>("totalPage", _totalPage))
        dms.add(field<Int>("totalRow", _totalRow))
        dms.add(field<ArrayList<Record>>("list", _list))
        return dms
    }
       
    public static func deserialize(_: DataModel): Page {
        // let dms = match(dm) {
        //     case data: DataModelStruct => data
        //     case _ => throw Exception("this data is not DataModelStruct")
        // }
        var obj = Page()
        
        // obj.name = String.deserialize(dms.get("name"))
        // obj.age = Int64.deserialize(dms.get("age"))
        // obj.total = Float64.deserialize(dms.get("total"))
        // obj.isStudent = Bool.deserialize(dms.get("isStudent"))
        // obj.auths = Array < String >.deserialize(dms.get("auths"))
        return obj
    }
}