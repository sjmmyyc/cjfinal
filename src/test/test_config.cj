/*
 * Copyright (c) 杨云超 2024-2024. All rights reserved.
 */
package cjfinal.test

import cjfinal.config.{
    CJFinalConfig,
    Constants
}


public class TestConfig <: CJFinalConfig{
    public func configConstants(me: Constants): Unit{
        me.devMode = true
    }
}