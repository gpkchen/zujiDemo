//
//  ZYMineQuotaDetailView.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/15.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMineQuotaDetailView : UIView

/**临时额度*/
@property (nonatomic , assign) double amount;
/**有效期*/
@property (nonatomic , copy) NSString *limit;
/**说明*/
@property (nonatomic , copy) NSString *explain;

- (void)showAtPoint:(CGPoint)point;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
