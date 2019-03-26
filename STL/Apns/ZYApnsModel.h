//
//  ZYApnsModel.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**推送展示方式*/
typedef NS_ENUM(int , ZHApnsShowType) {
    ZHApnsShowTypeNone = 1,         //不展示
    ZHApnsShowTypeAlert = 2,        //弹出alert
    ZHApnsShowTypeGainAmount = 3,   //获取免押额度，不可提额
    ZHApnsShowTypePassAuth = 4,     //通过授信，不可提额
    ZHApnsShowTypeGainAmountImprove = 5,     //获取免押额度，可提额
    ZHApnsShowTypePassAuthImprove = 6,     //通过授信，可提额
};

/**推送解析后对象*/
@interface ZYApnsModel : NSObject

/**协议*/
@property (nonatomic , copy) NSString *url;
/**标题*/
@property (nonatomic , copy) NSString *title;
/**内容*/
@property (nonatomic , copy) NSString *content;
/**是否需要弹出弹框*/
@property (nonatomic , assign) ZHApnsShowType showType;
/**按钮标题1（shouldAlert为1时用）*/
@property (nonatomic , copy) NSString *btnTitle1;
/**按钮标题2（shouldAlert为1时用）*/
@property (nonatomic , copy) NSString *btnTitle2;
/**扩展字段*/
@property (nonatomic , copy) NSString *remarks;

/**便利构造*/
- (instancetype) initWithDictionary:(NSDictionary *)dic;

@end
