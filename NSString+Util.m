//
//  NSString+Util.m
//  DFHelperDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

@implementation NSString (Util)

- (NSString *)filenameAppend:(NSString *)append
{
    // 1.获取没有拓展名的文件名
    NSString *filename = [self stringByDeletingPathExtension];
    
    // 2.拼接append
    filename = [filename stringByAppendingString:append];
    
    // 3.拼接拓展名
    NSString *extension = [self pathExtension];
    
    // 4.生成新的文件名
    return [filename stringByAppendingPathExtension:extension];
}

- (BOOL)validRegex:(NSString *)regex {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//用户名验证
- (BOOL)isUserNameValid
{
    NSString* regex = @"^[a-zA-Z0-9_@.-]{6,32}$";
    return [self validRegex:regex];
}

//用户密码验证
- (BOOL)isUserPasswordValid
{
    NSString* regex = @"^(?=.*?[0-9])(?=.*?[A-z])[0-9A-z!-)]{6,16}$";
    return [self validRegex:regex];
}

//电子邮箱验证
- (BOOL)isEmailValid{
    //    NSString* regex = @"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSString* regex = @"^[a-z0-9]*([-+.'][a-z0-9]*)*@[a-z0-9]*([-.][a-z0-9]*)*\\.[a-z0-9]*([-.][a-z0-9]*)*$";
    return [self validRegex:regex];
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((1[3,5,8][0-9])|(14[5,7])|(17[0,6,7,8]))\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})(|-)\\d{7,8}|\\d{7,8}$";
    
    return [self validRegex:MOBILE] || [self validRegex:CM] || [self validRegex:CU] || [self validRegex:CT] || [self validRegex:PHS];
}

- (BOOL)isQQValid {
    
    NSString *regex = @"^[1-9]\\d{4,10}$";
    return [self validRegex:regex];
}

- (BOOL)isFaxValid {
    
    NSString *regex = @"^(\\d{3,4}-)?\\d{7,8}$";
    return [self validRegex:regex];
}

- (BOOL)isURLValid {
    
    NSLog(@"%@", self);
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self]];
}

- (BOOL)isBankNumValid
{
    NSString *regex = @"^[\\d]{16,19}";
    return [self validRegex:regex];
}

- (BOOL)isZipCodeValid
{
    BOOL success = [self isNumber];
    if (self.length != 6) {
        
        success = NO;
    }
    
    return success;
}

//身份证号码
- (BOOL)isIdentityCardNoValid
{
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[self substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

//过滤数字
-(BOOL)isNumber
{
    NSString *regex=@"(^[0-9]+$)";
    return [self validRegex:regex];
}

- (BOOL)containChinese {
    
    for (NSInteger i = self.length - 2; i >= 0; i--) {
        
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [self substringWithRange:range];
        if ([str isChinese]) {
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containEnglish {
    
    for (NSInteger i = self.length - 2; i >= 0; i--) {
        
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [self substringWithRange:range];
        if ([str containEnglish]) {
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containNumber {
    
    for (NSInteger i = self.length - 2; i >= 0; i--) {
        
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [self substringWithRange:range];
        if ([str isNumber]) {
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isDomainContainChinese:(BOOL *)isChinese {
    
    //如果输入的内容是以www.开头，过滤掉
    NSMutableString *string = [NSMutableString stringWithString:self];
    if ([string hasPrefix:@"www."] && string.length >= 4) {
        
        [string deleteCharactersInRange:NSMakeRange(0, 4)];
    }
    
    BOOL res = NO;
    //开头必须为中文、英文、数字其一
    NSCharacterSet *cs1 = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
    NSString *filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
    res = [string isEqualToString:filtered1];
    if (string.length == 1 && !res && ![string isChinese]) {
        
        return NO;
    }
    
    //仅支持输入50位字符
    if (self.length > 50) {
        
        return NO;
    }
    //去掉结尾的后缀，如果有带的话
    NSArray *matches = [string componentsSeparatedByString:@"."];
    if (matches.count > 1) {
        
        NSString *lastMatch = [matches lastObject];
        if (lastMatch.length) {
            
            NSRange range = [string rangeOfString:lastMatch];
            if (range.length) {
                
                [string deleteCharactersInRange:NSMakeRange(range.location - 1, range.length + 1)];
            }
        }
    }
    
    if (string.length == 0) {
        
        return NO;
    }
    
    if ([string containChinese]) {
        
        //如果中间的一串是纯汉字的话，返回成功
        if (isChinese) {
            *isChinese = YES;
        }
        return YES;
    }
    
//如果只是包含中文，直接返回错误域名（不允许汉字和其他的混合）
//    for (NSInteger i = string.length - 2; i >= 0; i--) {
//
//        NSRange range = NSMakeRange(i, 1);
//        NSString *str = [string substringWithRange:range];
//        if ([str isChinese]) {
//
//            return NO;
//        }
//    }
    
    //内容(中文、英文、数字和中横杠)
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.-"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    res = [string isEqualToString:filtered];
    
    return res;
}

- (BOOL)isDomainWhileEditingInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *str = [NSMutableString stringWithString:self];
    [str replaceCharactersInRange:range withString:string];
    
    BOOL res = NO;
    //开头必须为中文、英文、数字其一
    NSCharacterSet *cs1 = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
    NSString *filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
    res = [string isEqualToString:filtered1];
    if (range.location == 0 && !res && ![string isChinese]) {
        
        return NO;
    }
    
    //仅支持输入50位字符
    if (str.length > 50) {
        
        return NO;
    }
    
    //内容(中文、英文、数字和中横杠)
    if ([string isChinese]) {
        
        return YES;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.-"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    res = [string isEqualToString:filtered];
    
    return res;
}

-(BOOL)isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEnglish
{
    NSString *match=@"(^[a-zA-Z.]*$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

+(BOOL)isBankNumValid:(NSString*)num
{
    NSString *mobileregex = @"^[\\d]{16,19}";
    NSPredicate *regexmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileregex];
    if([regexmobile evaluateWithObject:num]){
        
        return YES;
    }else{
        return NO;
    }
}

//密码强度验证
- (NSString *)checkPasswordStrength
{
    //正则表达式（包含 数字、字母、特殊字符）
    NSString *regex = @"^[0-9a-zA-Z_]\\w{5,32}$";
    //只包含数字的密码验证(6-32)
    NSString *digitregex = @"\\d+";
    //只包含小写字母的密码验证(6-32)
    NSString *letterregex = @"[a-z]+";
    //只包含大写字母的密码验证(6-32)
    NSString *bigletterregex = @"[A-Z]+";
    //只包含特殊字符_的密码验证(6-32)
    NSString *specialregex = @"[_]+";
    
    int matchCount=0;
    BOOL isValid = [self validRegex:regex];
    BOOL hasDigit = [self validRegex:digitregex];//是否存在数字
    BOOL hasLetter = [self validRegex:letterregex];//是否存在小写字符
    BOOL hasBigLetter = [self validRegex:bigletterregex];//是否存在大写字符
    BOOL hasSpecial = [self validRegex:specialregex];//是否存在特殊字符
    
    if (hasDigit) {
        matchCount+=1;
    }if (hasLetter) {
        matchCount+=1;
    }if (hasBigLetter) {
        matchCount+=1;
    }if (hasSpecial) {
        matchCount+=1;
    }
    NSLog(@"matchcount:%d",matchCount);
    
    if (!isValid) {
        return @"unvalid";
    }else if (matchCount==1) {
        return @"low";
    }else if (matchCount==2||matchCount==3) {
        return @"medium";
    }else if (matchCount==4) {
        return @"high";
    }
    
    return nil;
}

//URL转码
- (NSString *)URLEncodeString
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                 (CFStringRef)self, nil,
                                                                                 (CFStringRef)@"!*'();@&=+$, %#[]", kCFStringEncodingUTF8));
    return result;
}

//URL解码
- (NSString *)URLDecodeString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

//将NSString 转换成 NSarray NSdictionay
- (id)JsonValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+ (NSString *)JsonStringWithJsonValue:(id)obj
{
    if (!obj) {
        
        return @"";
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        
        return obj;
    }
    NSError *error = nil;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        return obj;
    }
    NSString *str = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    return str ? str : obj;
}

+ (NSString *)XmlStringWithDict:(NSDictionary *)dict
{
    NSMutableString *xmlStr = [[NSMutableString alloc]init];
    [xmlStr appendString:@"<?xml version='1.0' encoding='utf-8' standalone='yes'?>\n"];
    [xmlStr appendString:@"<tree>"];
    NSArray *keys  = dict.allKeys;
    NSArray *values = dict.allValues;
    for (int i = 0 ; i<keys.count; i++) {
        NSString *keyStr = keys[i];
        NSString *valueStr = values[i];
        [xmlStr appendFormat:@"<%@>",keyStr];
        [xmlStr appendString:valueStr];
        [xmlStr appendFormat:@"</%@>",keyStr];
    }
    [xmlStr appendString:@"</tree>"];
    
    return xmlStr;
}

+ (NSString *)XmlStringWithDict:(NSDictionary *)dict attributes:(NSArray *)attArr
{
    NSMutableString *xmlStr = [[NSMutableString alloc]init];
    [xmlStr appendString:@"<?xml version='1.0' encoding='utf-8' standalone='yes'?>\n"];
    [xmlStr appendString:@"<tree>"];
    NSArray *keys  = dict.allKeys;
    NSArray *values = dict.allValues;
    for (int i = 0 ; i<keys.count; i++) {
        NSString *keyStr = keys[i];
        NSString *valueStr = values[i];
        [xmlStr appendFormat:@"<%@>",keyStr];
        [xmlStr appendString:valueStr];
        [xmlStr appendFormat:@"</%@>",keyStr];
    }
    for (NSDictionary *attDict in attArr) {
        NSString *node = [attDict objectForKey:@"node"];
        NSString *text = [attDict objectForKey:@"text"];
        NSString *attKey = [attDict objectForKey:@"attkey"];
        NSString *attValue = [attDict objectForKey:@"attvalue"];
        [xmlStr appendFormat:@"<%@ %@=\"%@\">",node,attKey,attValue];
        [xmlStr appendString:text];
        [xmlStr appendFormat:@"</%@>",node];
    }
    
    [xmlStr appendString:@"</tree>"];
    
    
    return xmlStr;
}

- (NSString *)addStar {
    
    if ([self isMobileNumber]) {
        
        NSRange range = NSMakeRange(3, 4);
        return [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
    else if ([self isEmailValid]) {
        
        NSString *emailName = [self componentsSeparatedByString:@"@"][0];
        NSRange range = NSMakeRange(ceil(emailName.length * .3), emailName.length * .6);
        NSMutableString *starStr = [NSMutableString string];
        for (int i = 0; i < range.length; i++) {
            
            [starStr appendString:@"*"];
        }
        return [self stringByReplacingCharactersInRange:range withString:starStr];
    }
    else if ([self isIdentityCardNoValid]) {
        
        return [self stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    }
    else
        
        return self;
}

- (NSString *)bankNumFormat {
    
    NSMutableString *mStr = [NSMutableString stringWithString:self];
    [mStr replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mStr.length)];
    
    if (![mStr isNumber]) {
        
        NSLog(@"不是纯数字，请检查格式");
        return @"";
    }
    
    NSInteger spaceIndex = 4;
    while (spaceIndex < mStr.length) {
        
        [mStr insertString:@" " atIndex:spaceIndex];
        spaceIndex += 5;
    }
    
    return mStr;
}

+ (NSString *)getCurrentDate
{
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return curDate;
}

+ (NSString *)transYMDHMSFromTimeInvatal:(NSString *)timsp {
    
    NSString *currentDateStr = timsp;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    
    //如果本身就是时间格式的字符串，不需要格式化
    if (timsp.length && !currentDate) {
        NSTimeInterval time = [timsp doubleValue]; // 如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
        currentDate = [NSDate dateWithTimeIntervalSince1970:time];
        
        currentDateStr = [dateFormatter stringFromDate:currentDate];
    }
    
    return currentDateStr;
}

- (NSString *)MD5 {
    
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

+ (NSString *)devicePlatForm {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    //http://www.cnblogs.com/xiaofeixiang/
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
