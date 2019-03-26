//
//  NSString+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@interface NSString (ZYExtension)

/**判断是否为空（空格也算空）*/
+ (BOOL)isBlank:(NSString *)str;
/**NSString转字典*/
- (NSDictionary *)toDictionary;
/**寻找字符串中网址的位置(NSValue)*/
- (NSArray *)urlLocations;
/**是否是网址*/
- (BOOL)isUrl;
/**14位字符串转换为今天明天显示*/
- (NSString *)distanceNow;
/**unicode字符数*/
- (NSUInteger)unicodeLength;
/**根据身份证号判断是否成年*/
- (BOOL)isAdult;
/**是否字母数字组合*/
- (BOOL)isLettersNumber;
/**手机号有效性检查*/
- (BOOL)isTelNumber;
/**手机号脱敏*/
- (NSString *)telConfusion;
/**判断字符串是不是整数*/
- (BOOL) isInt;
/**判断字符串是不是双精度浮点型*/
- (BOOL) isDouble;
/**判断字符串是不是身份证号码*/
- (BOOL)isIdentityCardNumber;
/**判断字符串是不是邮箱*/
- (BOOL)isEmailAddress;
/**判断字符串是不是qq*/
- (BOOL)isQQNumber;
/**银行卡格式不正确*/
- (BOOL)isBankCard;
/**md5加密*/
- (NSString *)md5;
/**3DES加解密*/
- (NSString *)tripleDES:(CCOperation)operation key:(NSString *)key;
/**URLEncode编码*/
- (NSString *)URLEncode;
/**URLEncode解码*/
- (NSString *)URLDecode;
/**json转dic*/
- (NSDictionary *)dict;
/**json转nsarray*/
- (NSArray *)array;

/**拼接图片样式方案（裁剪多余部分）*/
- (NSString *)imageStyleUrl:(CGSize)size;
/**拼接图片样式方案*/
- (NSString *)imageStyleUrlNoCut:(CGSize)size;

@end
