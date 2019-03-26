//
//  ZYPhoneTextField.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/6.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYTextField.h"

typedef void (^ZYPhoneTextFieldEditChangedBlock)(NSString *phone);

/**手机号专用输入框，格式3-4-4*/
@interface ZYPhoneTextField : ZYTextField

@property (nonatomic , copy , readonly) NSString *phone;

@property (nonatomic , copy) ZYPhoneTextFieldEditChangedBlock changedBlock;

@end
