//
//  ZYWebVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"
#import <WebKit/WebKit.h>

@interface ZYWebVC : ZYBaseVC

//网页控件加载完成回调(第一次初始化网页控件可能是异步的)
@property (nonatomic , copy) void (^webInitComplete)(void);

/**网址链接*/
@property (nonatomic , copy) NSString *url; 
/**是否允许返回上一页,默认NO*/
@property (nonatomic , assign) BOOL voidBack;

/**webview偏移量*/
@property (nonatomic , assign) UIEdgeInsets webViewInsets;
/**webview位置*/
@property (nonatomic , assign) CGRect webViewFrame;
/**进度条纵坐标偏移量*/
@property (nonatomic , assign) CGFloat progressViewY;
/**浏览器对象*/
@property (nonatomic , strong , readonly) WKWebView *webView;
/**进度条对象*/
@property (nonatomic , strong) UIProgressView *progressView;
/**是否可以下拉刷新*/
@property (nonatomic , assign) BOOL refreshEnable;
/**是否允许弹簧效果*/
@property (nonatomic , assign) BOOL alwaysBounceVertical;
/**是否允许弹簧效果*/
@property (nonatomic , assign) BOOL alwaysBounceHorizontal;


//具体业务使用
/**淘宝认证后是否发起授信*/
@property (nonatomic , assign) BOOL shouldAuthAlfterTaobao;


/**
 拦截器，用于继承

 @param protocol 拦截到的内部协议对象
 @return YES：子类已处理了协议；NO：子类并未处理协议
 */
- (BOOL)catchProtocol:(ZYProtocol *)protocol;
/**刷新*/
- (void)reload;

@end
