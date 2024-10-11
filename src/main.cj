/*
 * Copyright (c) 杨云超(yyc1030@qq.com) 2024-2024. All rights reserved.
 */
package cjfinal

import cjfinal.core.CJFinal
import cjfinal.test.TestConfig

main(): Int64 {
    CJFinal.start(TestConfig(), 80)
    return 0
}