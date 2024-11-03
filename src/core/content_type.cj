package cjfinal.core

public enum ContentType <: ToString{
    | Text
    | Json
    | Html
    | File

    public func toString(): String{
        match(this){
            case Text => "text/plain; charset=utf8"
            case Json => "text/json; charset=utf8"
            case Html => "text/html; charset=utf8"
            case File => "application/octet-stream"
        }
    }
}