package cjfinal.core

import net.http.Server
import net.http.ServerBuilder
import net.http.HttpContext

/**
 * CJFinal服务器类
 */
public class CJFinal{
    // 注意，修改版本号时，应将cjpm.toml文件中的版本号一并修改
    public static let version = "0.0.1"

    private var server: ?Server = None
    private let port: Int64

    /**
     * 构造器
     * @param port 端口号
     */
    public init(port: Int64){
        this.port = port
    }

    /**
     * 启动服务器
     */
    public func start(){
        this.server = ServerBuilder()
            .addr("127.0.0.1")
            .port(UInt16(this.port))
            .build()
        println("Welcom to use CJFinal Framework, current version is: ${version}")
        this.server?.distributor.register("/", {ctx =>
            ctx.responseBuilder.body("Hello Cangjie!")
        })
        this.server?.serve()
    }
}