//
//  ZYH5Utils.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYH5Utils.h"

@implementation ZYH5Utils

+ (NSString *)formatJson{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[ZYDeviceUtils utils].uuidForDevice forKey:@"deviceID"];
    [dic setValue:APP_BUILD forKey:@"appVersion"];
    [dic setValue:RequestClient forKey:@"client"];
    if([ZYUser user].userId){
        [dic setValue:[ZYUser user].userId forKey:@"uid"];
    }
    if([ZYUser user].apiToken){
        [dic setValue:[ZYUser user].apiToken forKey:@"apiToken"];
    }
    
    return [[dic json] URLEncode]; 
}

+ (NSString *)formatUrl:(ZYH5Type)type param:(NSString *)param{
    NSString *url = [ZYEnvirUtils utils].h5Prefix;
    url = [url stringByAppendingString:[self formatJson]];
    url = [url stringByAppendingString:@"/"];
    switch (type) {
        case ZYH5TypeItemDetail:{
            url = [url stringByAppendingString:@"item-detail/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeHelp:{
            url = [url stringByAppendingString:@"help"];
        }
            break;
        case ZYH5TypeExpress:{
            url = [url stringByAppendingString:@"logistics/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeMessage:{
            url = [url stringByAppendingString:@"message"];
        }
            break;
        case ZYH5TypeReturn:{
            url = [url stringByAppendingString:@"return/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeRepair:{
            url = [url stringByAppendingString:@"repair"];
        }
            break;
        case ZYH5TypeAbout:{
            url = [url stringByAppendingString:@"about"];
        }
            break;
        case ZYH5TypeCoupon:{
            url = [url stringByAppendingString:@"coupon-instructions"];
        }
            break;
        case ZYH5TypeUserAgreement:{
            url = [url stringByAppendingString:@"protocol/user-services-agreement"];
        }
            break;
        case ZYH5TypeServiceAgreement:{
            url = [url stringByAppendingString:@"protocol/user-leasing-andService-agreement/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeFound:{
            url = [url stringByAppendingString:@"find"];
        }
            break;
        case ZYH5TypeFoundDetail:{
            url = [url stringByAppendingString:@"find-detail/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeItemServiceAgreement:{
            url = [url stringByAppendingString:@"vas-detail/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypeUserPublishDetail:{
            url = [url stringByAppendingString:@"user-release-detail/"];
            url = [url stringByAppendingString:param];
        }
            break;
        case ZYH5TypePreemptiveExplanation:{
            url = [url stringByAppendingString:@"preemptive-explanation"];
        }
            break;
        case ZYH5TypeExchangeCouponRule:{
            url = [url stringByAppendingString:@"exchange-rules"];
        }
            break;
        case ZYH5TypeLimitRecord:{
            url = [url stringByAppendingString:@"credit-description"];
        }
            break;
            
        default:
            break;
    }
    return url;
}

@end
