/**
 * Copyright (c) 2024-2024, Kevin Yang 杨云超 (yyc1030@qq.com).
 */
package cjfinal

import cjfinal.core.CJFinal
import cjfinal.test.TestConfig

main(): Int64 {
    CJFinal.start(TestConfig(), 80)
    return 0
}