//
//  ListUserCoupon.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ListUserCoupon.h"

@implementation _p_ListUserCoupon

- (instancetype)init{
    if(self = [super init]){
        _size = ZYRequestDefaultPageSize;
        self.url = @"/app/oper/userCoupon/listUserCouponNew";
    }
    return self;
}

@end






@implementation _m_ListUserCoupon

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if(self = [super initWithDictionary:dic]){
        _cellNormalHeight = 136 * UI_H_SCALE;
        _useRange = [@"适用商品：" stringByAppendingString:_useRange];
        
        CGFloat limitWidth = [_useRange boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:FONT(12)}
                                                 context:nil].size.width;
        if(limitWidth > SCREEN_WIDTH - 70 * UI_H_SCALE){
            _openable = YES;
            CGFloat height = [_useRange boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 * UI_H_SCALE, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:FONT(12)}
                                                     context:nil].size.height;
            _cellOpenHeight = 105 * UI_H_SCALE + height + 16 * UI_H_SCALE;
        }
    }
    return self;
}

@end
