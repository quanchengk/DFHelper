//
//  DFHelper.h
//  Created by 全程恺 on 16/10/9.
//  Copyright (c) 2016年 Danfort. All rights reserved.
//  工具类

#import <UIKit/UIKit.h>

@interface DFHelper : UIControl

#pragma mark - UI对象获取
/**
 *  获取视图结构底层的目标对象
 *
 *  @param className 要获取的类名
 *  @param obj       从obj往父视图遍历
 *
 *  @return 检测到要获取的实例，如有，就把这个实例返回，否则回传nil
 */
+ (id)getTargetClass:(Class)className
          fromObject:(id)obj;

// 获取最上层的控制器，类似于获取本控制器的实例
+ (id)getTopViewController;

// 获取视图的第一响应者
+ (id)getFirstResponderInView:(UIView *)view;

#pragma mark - 线程操作
// 延时执行
+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds;
// 子线程执行
+ (void)doSomethingOnSubThread:(void (^)(void))functions;
// 主线程执行
+ (void)doSomethingOnMainThread:(void (^)(void))functions;

#pragma mark - user default 操作
// 添加
+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey;
// 读取
+ (id)objectForDestKey:(NSString *)destkey;
// 删除
+ (void)removeObjectForDestKey:(NSString *)destkey;

#pragma mark - keychain 操作
//写入keychain
+ (void)saveKey:(NSString *)service data:(id)data;
//读取
+ (id)loadKey:(NSString *)service;
//删除
+ (void)deleteKey:(NSString *)service;

@end
