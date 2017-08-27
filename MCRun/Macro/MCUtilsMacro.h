//
//  MCUtilsMacro.h
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef MCUtilsMacro_h
#define MCUtilsMacro_h

// 打印方法
#ifdef DEBUG
#define MCLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])    //会输出Log所在函数的函数名
#else
#define MCLog(...) do { } while (0)
#endif


#endif /* MCUtilsMacro_h */
