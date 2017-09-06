//
//  DFHelper.m
//  Created by 全程恺 on 16/10/9.
//  Copyright (c) 2015年 Danfort. All rights reserved.
//

#import "DFHelper.h"
#import "AppDelegate.h"
#import <Security/Security.h>

@implementation DFHelper

+ (id)getTargetClass:(Class)className fromObject:(id)obj
{
    UIResponder *next = [obj nextResponder];
    do {
        if ([next isKindOfClass:[className class]]) {
            
            return next;
        }
        next =[next nextResponder];
    }
    while (next != nil);
    
    return nil;
}

+ (id)getFirstResponderInView:(UIView *)view
{
    UIResponder *responder;
    for (UIView *child in view.subviews) {
        
        if ([child isFirstResponder]) {
            
            responder = child;
        }
        else if(!responder) {
            
            //搜索里面的文本框
            responder = [DFHelper getFirstResponderInView:child];
        }
    }
    
    return responder;
}

+ (id)getTopViewController
{
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    UIViewController *appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        
        topViewController = ((UITabBarController *)topViewController).selectedViewController;
    }
    
    while ([topViewController isKindOfClass:[UINavigationController class]]) {
        
        topViewController = ((UINavigationController *)topViewController).topViewController;
    }
    
    return topViewController;
}

#pragma mark - 延时执行
+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       functions();
                   });
}

#pragma mark - 子线程执行
+ (void)doSomethingOnSubThread:(void (^)(void))functions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        functions();
    });
}

#pragma mark - 主线程执行
+ (void)doSomethingOnMainThread:(void (^)(void))functions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        functions();
    });
}

#pragma mark - NSUserDefaults
+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey
{
    [[NSUserDefaults standardUserDefaults] setObject:destObj forKey:destKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForDestKey:(NSString *)destkey
{
    id object = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    object = [[NSUserDefaults standardUserDefaults] objectForKey:destkey];
    return object;
}

+ (void)removeObjectForDestKey:(NSString *)destkey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:destkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - key chain
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

//写入
+ (void)saveKey:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

//读取
+ (id)loadKey:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

//删除
+ (void)deleteKey:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
