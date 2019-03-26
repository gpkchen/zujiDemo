//
//  ZYUser.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUser.h"

static NSString * const kUserStorageKey = @"kUserStorageKey"; //存储Key

@implementation ZYUser

+ (instancetype) user{
    static ZYUser *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [NSUserDefaults readObjectWithKey:kUserStorageKey];
        if(!_instance){
            _instance = [[ZYUser alloc] init];
        }
    });
    
    return _instance;
}

- (void) save{
    [NSUserDefaults writeWithObject:self forKey:kUserStorageKey];
}

- (void) removeLoginInfo{
    _apiToken = nil;
    _refreshToken = nil;
    _userId = nil;
    _portraitPath = nil;
    _nickname = nil;
    [self save];
}

#pragma mark - getter
- (BOOL)isUserLogined{
    if(_userId && _apiToken && _refreshToken){
        return YES;
    }
    return NO;
}

- (BOOL)silenceLoginAbility{
    return ![NSString isBlank:_refreshToken];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)coder{
    _userId = [coder decodeObjectForKey:@"userId"];
    _mobile = [coder decodeObjectForKey:@"mobile"];
    _nickname = [coder decodeObjectForKey:@"nickname"];
    _portraitPath = [coder decodeObjectForKey:@"portraitPath"];
    _apiToken = [coder decodeObjectForKey:@"apiToken"];
    _refreshToken = [coder decodeObjectForKey:@"refreshToken"];
    
    _bottomImageUrl = [coder decodeObjectForKey:@"bottomImageUrl"];
    _foundImg = [coder decodeObjectForKey:@"foundImg"];
    _foundImgSelected = [coder decodeObjectForKey:@"foundImgSelected"];
    _mallImg = [coder decodeObjectForKey:@"mallImg"];
    _mallImgSelected = [coder decodeObjectForKey:@"mallImgSelected"];
    _shareImg = [coder decodeObjectForKey:@"shareImg"];
    _shareImgSelected = [coder decodeObjectForKey:@"shareImgSelected"];
    _mineImg = [coder decodeObjectForKey:@"mineImg"];
    _mineImgSelected = [coder decodeObjectForKey:@"mineImgSelected"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_mobile forKey:@"mobile"];
    [coder encodeObject:_nickname forKey:@"nickname"];
    [coder encodeObject:_portraitPath forKey:@"portraitPath"];
    [coder encodeObject:_refreshToken forKey:@"refreshToken"];
    [coder encodeObject:_apiToken forKey:@"apiToken"];
    
    [coder encodeObject:_bottomImageUrl forKey:@"bottomImageUrl"];
    [coder encodeObject:_foundImg forKey:@"foundImg"];
    [coder encodeObject:_foundImgSelected forKey:@"foundImgSelected"];
    [coder encodeObject:_mallImg forKey:@"mallImg"];
    [coder encodeObject:_mallImgSelected forKey:@"mallImgSelected"];
    [coder encodeObject:_shareImg forKey:@"shareImg"];
    [coder encodeObject:_shareImgSelected forKey:@"shareImgSelected"];
    [coder encodeObject:_mineImg forKey:@"mineImg"];
    [coder encodeObject:_mineImgSelected forKey:@"mineImgSelected"];
}

@end
