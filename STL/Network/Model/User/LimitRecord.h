//
//  LimitRecord.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _p_LimitRecord : ZYBaseParam

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;

@end



@interface _m_LimitRecord : ZYBaseModel

/**变更标题*/
@property (nonatomic , copy) NSString *title;
/**变更类型（1增加，2减少）*/
@property (nonatomic , assign) int recordType;
/**变更内容*/
@property (nonatomic , copy) NSString *content;
/**变更金额*/
@property (nonatomic , assign) double amount;
/**变更时间*/
@property (nonatomic , copy) NSString *time;

/**本地：记录cell高度*/
@property (nonatomic , assign) CGFloat cellHeight;

@end


NS_ASSUME_NONNULL_END
