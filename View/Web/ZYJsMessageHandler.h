//
//  ZYJsMessageHandler.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/30.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYJsMessageHandler : NSObject <WKScriptMessageHandler>

+ (NSArray *)messageNames;

@end

NS_ASSUME_NONNULL_END
