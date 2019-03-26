//
//  ZYItemDetailVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYWebVC.h"

#define ZYItemDetailVCDragHeight (70 * UI_H_SCALE) //上拉下拉临界点偏移量

@interface ZYItemDetailVC : ZYBaseVC

/**商品id*/
@property (nonatomic , copy) NSString *itemId;

@end
