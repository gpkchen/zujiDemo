//
//  ZYProtocol.h
//  PodLib
//
//  Created by 李明伟 on 2018/4/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

/*
 协议对象生成途径有三条：
 1.通过平台协议url生成，这种url可出现在h5发起的跳转、推送等，是经过加密的
 2.通过内部模拟出的协议url，在一些情况下我们希望内部模拟出一个协议url去执行，那么一些逻辑就不用重复写，直接复用路由的逻辑，比如，现在已存在一个协议叫“login”,做的操作是去执行登录操作，涉及到判断是否静默登录等状态，这种情况下我们已经在路由里写了这个逻辑了，不想再重复写，所以我们就内部生成这么一个协议url让路由执行，只是为了方便这种url不需要加密
 3.内部模块或者界面间通过控制器名来做跳转
 */

#import <Foundation/Foundation.h>

/**跳转协议*/
@interface ZYProtocol : NSObject

/**跳转方式：是否PUSH*/
@property (nonatomic , assign) BOOL isPush;
/**协议*/
@property (nonatomic , copy) NSString *url;
/**协议头*/
@property (nonatomic , copy) NSString *head;
/**目标*/
@property (nonatomic , copy) NSString *target;
/**参数集合*/
@property (nonatomic , strong) NSDictionary *params;
/**回调*/
@property (nonatomic , strong) id callBack;

/**便利构造(通过外部协议URL解析)*/
- (instancetype)initWithOutUrl:(NSString *)url;

/**便利构造（通过内部协议URL解析）*/
- (instancetype)initWithInnerUrl:(NSString *)url;

@end
