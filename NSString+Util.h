//
//  NSString+Util.h
//  DFHelperDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

#pragma mark - 内容合法性验证
// 用户名合法性验证
- (BOOL)isUserNameValid;

// 用户密码合法性验证
- (BOOL)isUserPasswordValid;

// 电子邮箱验证
- (BOOL)isEmailValid;

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber;

// 身份证号码合法性验证
- (BOOL)isIdentityCardNoValid;

// 邮编
- (BOOL)isZipCodeValid;

// qq
- (BOOL)isQQValid;

// 传真
- (BOOL)isFaxValid;

- (BOOL)isURLValid;

// 校验银行卡号
- (BOOL)isBankNumValid;

// 合法域名，isChinese可用于判断是否是纯中文域名
- (BOOL)isDomainContainChinese:(BOOL *)isChinese;

// 输入时的合法域名判断
- (BOOL)isDomainWhileEditingInRange:(NSRange)range replacementString:(NSString *)string;

// 是否是纯中文
- (BOOL)isChinese;

// 字符是纯英文
- (BOOL)isEnglish;

// 字符是纯数字数字
- (BOOL)isNumber;

// 字符包含中文
- (BOOL)containChinese;

// 字符包含英文
- (BOOL)containEnglish;

// 字符包含数字
- (BOOL)containNumber;

// 密码强度验证
- (NSString *)checkPasswordStrength;

#pragma mark - 内容转换
// 字符串转json
- (id)JsonValue;

// Json格式转字符串
+ (NSString *)JsonStringWithJsonValue:(id)obj;

// xml格式转字符串
+ (NSString *)XmlStringWithDict:(NSDictionary *)dict;

// xml格式转字符串
+ (NSString *)XmlStringWithDict:(NSDictionary *)dict attributes:(NSArray *)attArr;

// 加星，仅针对手机号或邮箱
- (NSString *)addStar;

// 银行卡号格式化，例如：1111222233334444 转换为 1111 2222 3333 4444
- (NSString *)bankNumFormat;

// URL转码
- (NSString *)URLEncodeString;

// URL解码
- (NSString *)URLDecodeString;

#pragma mark - 时间获取
// 获取当前时间 YYYY年MM月dd日 HH:mm:ss
+ (NSString *)getCurrentDate;

// 时间戳转成时间 YYYY年MM月dd日 HH时mm分ss秒
+ (NSString *)transYMDHMSFromTimeInvatal:(NSString *)timsp;

#pragma mark - 其他
- (NSString *)MD5;

// 字符串拼接
- (NSString *)filenameAppend:(NSString *)append;

// 获取设备版本号
+ (NSString *)devicePlatForm;

@end
