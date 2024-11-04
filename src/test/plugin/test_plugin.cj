package cjfinal.test.plugin

import cjfinal.plugin.IPlugin

public class TestPlugin <: IPlugin{

    public func start(): Bool{
        println("TestPlugin start...")
        true
    }

    public func stop(): Bool{
        println("TestPlugin stop...")
        true
    }
}