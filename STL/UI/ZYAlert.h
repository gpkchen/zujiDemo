//
//  ZYAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

@class ZYAlert;
typedef void (^ZYAlertButtonAction)(ZYAlert *alert,int index); //按钮事件

/**定制提示框/警告框*/
@interface ZYAlert : ZYBaseAlert


/**
 显示定制弹框

 @param title 标题
 @param content 内容
 @param type 类型
 @param titles 按钮标题
 @param action 按钮事件
 @return 弹窗对象
 */
+ (ZYAlert *)showWithTitle:(NSString *)title
                   content:(NSString *)content
              buttonTitles:(NSArray *)titles
              buttonAction:(ZYAlertButtonAction)action;

@end
