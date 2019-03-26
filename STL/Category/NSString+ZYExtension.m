//
//  NSString+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "NSString+ZYExtension.h"
#import "GTMBase64.h"

@implementation NSString (ZYExtension)

+ (BOOL)isBlank:(NSString *)str{
    if(!str){
        return YES;
    }
    if([str isKindOfClass:[NSNull class]]){
        return YES;
    }
    if(![str isKindOfClass:[NSString class]]){
        return YES;
    }
    if([[str stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        return YES;
    }
    if([str isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

- (NSDictionary *)toDictionary{
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
//        Log(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSArray *)urlLocations{
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        [arr addObject:[NSValue valueWithRange:match.range]];
    }
    return arr;
}

- (BOOL)isUrl{
    if(!self){
        return NO;
    }
    NSString *regex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (!isMatch)
        return NO;
    return YES;
}

- (NSString *)distanceNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    
    long long time = [self longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSString * dateStr = [dateFormatter stringFromDate:date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = [[dateStr substringWithRange:NSMakeRange(0,4)] integerValue];
    components.month = [[dateStr substringWithRange:NSMakeRange(4,2)] integerValue];
    components.day = [[dateStr substringWithRange:NSMakeRange(6,2)] integerValue];
    //目标 0点时间
    NSDate *zeroDate = [calendar dateFromComponents:components];
    
    NSString * dateNowStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = [[dateNowStr substringWithRange:NSMakeRange(0,4)] integerValue];
    nowComponents.month = [[dateNowStr substringWithRange:NSMakeRange(4,2)] integerValue];
    nowComponents.day = [[dateNowStr substringWithRange:NSMakeRange(6,2)] integerValue];
    //今天 0点时间
    NSDate *todayZeroDate = [calendar dateFromComponents:nowComponents];
    
    NSDateComponents *cps = [calendar components:unitFlags
                                        fromDate:zeroDate
                                          toDate:todayZeroDate
                                         options:0];
    NSInteger distanceZeroDay = [cps day];
    NSInteger distanceZeroMonth = [cps month];
    NSInteger distanceZeroYear = [cps year];
    
    if (distanceZeroYear > 0){
        return [NSString stringWithFormat:@"%ld年前",(long)distanceZeroYear];
    }else if (distanceZeroMonth > 0){
        return [NSString stringWithFormat:@"%ld个月前",(long)distanceZeroMonth];
    }else if (distanceZeroDay > 1){
        return [NSString stringWithFormat:@"%ld天前",(long)distanceZeroDay];
    }else if (distanceZeroDay == 1){
        return @"昨天";
    }else{
        cps = [calendar components:unitFlags
                          fromDate:date
                            toDate:[NSDate date]
                           options:0];
        NSInteger distanceMinute = [cps minute];
        NSInteger distanceHour = [cps hour];
        if(distanceMinute <= 10 && distanceHour < 1)
            return @"刚刚";
        
        dateFormatter.dateFormat = @"HH:mm";
        return [dateFormatter stringFromDate:date];
    }
}

- (NSUInteger)unicodeLength{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (BOOL)isAdult{
    if(!self || ![self isIdentityCardNumber]){
        return NO;
    }
    NSDate *now = [NSDate date];
    int nowYear = (int)[now getYearValue];
    int nowMonth = (int)[now getMonthValue];
    int nowDay = (int)[now getDayValue];
    int year = [[self substringWithRange:NSMakeRange(6, 4)] intValue];
    int month = [[self substringWithRange:NSMakeRange(10, 2)] intValue];
    int day = [[self substringWithRange:NSMakeRange(12, 2)] intValue];
    int age = nowYear - year;
    if (age > 18) {
        return YES;
    }
    if (age < 18) {
        return NO;
    }
    if (age == 18) {
        if (nowMonth - month > 0) {
            return YES;
        } else if (nowMonth == month) {
            if (nowDay - day >= 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isLettersNumber{
    if(!self){
        return NO;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (!isMatch)
        return NO;
    return YES;
}

- (BOOL)isTelNumber{
    if(!self){
        return NO;
    }
    NSString *regex = @"^0?(13[0-9]|15[0123456789]|18[0123456789]|17[0123456789]|14[0123456789]|16[0123456789]|19[0123456789])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (!isMatch)
        return NO;
    return YES;
}

- (NSString *)telConfusion{
    if(![self isTelNumber]){
        return nil;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

- (BOOL) isInt{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL) isDouble{
    NSScanner *scan = [NSScanner scannerWithString:self];
    double val;
    return[scan scanDouble:&val] && [scan isAtEnd];
}

- (BOOL)isIdentityCardNumber{
    if (self.length != 18) {
        return  NO;
    }
    
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

- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:self];
}

- (BOOL)isQQNumber{
    NSString *qqRegex = @"[1-9]([0-9]{5,11})";
    NSPredicate *qqPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    
    return [qqPredicate evaluateWithObject:self];
}

- (BOOL)isBankCard{
    NSString *noRegex = @"[0-9]{10,20}";
    NSPredicate *noPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", noRegex];
    
    return [noPredicate evaluateWithObject:self];
}

+ (NSString *)intToBinary:(int)intValue{
    int byteBlock = 8,
    totalBits = (sizeof(int)) * byteBlock,
    binaryDigit = totalBits;
    char ndigit[totalBits + 1];
    
    while (binaryDigit-- > 0) {
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        
        intValue >>= 1;
    }
    
    ndigit[totalBits] = 0;
    
    return [NSString stringWithUTF8String:ndigit];
}

- (BOOL)isEmpty{
    if (self) {
        if ([self isKindOfClass:[NSNull class]]) {
            return YES;
        }
        
        if ([self isEqual:[NSNull null]]) {
            return YES;
        }
        
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return ([trimedString length]==0);
    }
    
    return YES;
}

- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString *)tripleDES:(CCOperation)operation key:(NSString *)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (operation == kCCDecrypt){
        NSData *EncryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[key UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(operation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    //    else if (ccStatus == kCCParamError) return @"PARAM ERROR";
    //    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    //    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    //    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    //    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    //    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString *result;
    
    if (operation == kCCDecrypt){
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }else{
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    return result;
}

- (NSString *)URLEncode{
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString; 
}

-(NSString *)URLDecode{
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;  
}

- (NSDictionary *)dict{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        ZYLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSArray *)array{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        ZYLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

- (NSString *)imageStyleUrl:(CGSize)size{
    if([self rangeOfString:@"?"].location != NSNotFound){
        return self;
    }
    return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,w_%d,h_%d,limit_1/auto-orient,1/quality,Q_100",self,(int)size.width,(int)size.height];
}

- (NSString *)imageStyleUrlNoCut:(CGSize)size{
    if([self rangeOfString:@"?"].location != NSNotFound){
        return self;
    }
    return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_mfit,w_%d,h_%d,limit_1/auto-orient,1/quality,Q_100",self,(int)size.width,(int)size.height];
}

@end
