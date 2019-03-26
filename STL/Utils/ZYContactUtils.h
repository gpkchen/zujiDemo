//
//  ZYContactUtils.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#if !TARGET_IPHONE_SIMULATOR

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZYContactUtilsPickBlock)(NSString *givenName,NSString *familyName,NSString *phone);


/**联系人模型*/
@interface ZYContact : NSObject

@property (nonatomic , copy) NSString *firstName;
@property (nonatomic , copy) NSString *middleName;
@property (nonatomic , copy) NSString *lastName;
@property (nonatomic , strong) NSArray *phones;

@end

@interface ZYContactUtils : NSObject

/**单例*/
+ (instancetype) utils;

/**检测通讯录权限*/
+ (BOOL)isAuthAddressBookWithRequire:(BOOL)should success:(void(^)(void))success;

/**显示选择界面*/
- (void) showWithViewController:(UIViewController *)viewController pickBlock:(ZYContactUtilsPickBlock)block;
/**遍历所有联系人信息*/
- (void) enumerateAllContactInfo:(void(^)(ZYContact *contact))block;

@end


#endif
