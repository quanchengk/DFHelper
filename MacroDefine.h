//
//  MacroDefine.h
//
//  Created by 全程恺 on 9/27/16.
//  Copyright © 2016 全程恺. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#ifdef __OBJC__

//app名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//app版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 传入应用版本号，判断应用版本是否大于传入的version，用于版本迭代过程中的版本区分
#define kAppVersionGreaterThan(version) [version compare:kAppVersion options:NSNumericSearch] == NSOrderedAscending

// 传入系统版本号，其他的比较关系可以自己举一反三
#define kSystemVersionGreaterThan(version)  [version compare:[[UIDevice currentDevice] systemVersion] options:NSNumericSearch] == NSOrderedAscending

// 线上版本屏蔽所有内容输出
#ifdef AppStore
#define df_log(format, ...) do { } while(0)
#else
#define df_log(format, ...) do { printf("\n<%s : %d : %s>\n-: %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__,__FUNCTION__,[[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while(0)
#endif

#define df_logFunc  df_log(@"%s", __func__)

//非空的字符串 避免输出null
#define kUnNilStr(str)  ((str && ![str isEqual:[NSNull null]]) ? str : @"")

//RGB颜色设置
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]

//RGBA颜色设置
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]

// 十六进制颜色设置
#define HEXCOLOR(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//当前window
#define kCurrentWindow  [[UIApplication sharedApplication].windows firstObject]

#define kKeyWindow  [UIApplication sharedApplication].keyWindow

//屏幕高度
#define kScreenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)

//屏幕宽度
#define kScreenWidth    (kSystemVersionGreaterThan(7.0) ? CGRectGetHeight([UIScreen mainScreen].bounds) : CGRectGetHeight([[UIScreen mainScreen] applicationFrame]))

#endif

#endif /* MacroDefine_h */
