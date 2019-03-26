//
//  ZYMacro.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#ifndef ZYMacro_h
#define ZYMacro_h

// debug日志输出
#ifdef DEBUG
#define ZYLog(...) NSLog(__VA_ARGS__)
#else
#define ZYLog(...) 
#define NSLog(...)
#endif


//主色调 
#define MAIN_COLOR_GREEN                HexRGB(0x1CBD4C)        //主色调绿色
#define NAVIGATIONBAR_COLOR             [UIColor whiteColor]    //导航栏颜色
#define NAVIGATIONBAR_SHADOW_COLOR      HexRGB(0xf2f2f2)        //导航栏颜色
#define VIEW_COLOR                      HexRGB(0xF5F5F5)        //视图默认底色
 
//字颜色
#define WORD_COLOR_BLACK                HexRGB(0x18191A)        //字颜色黑色
#define WORD_COLOR_GRAY                 HexRGB(0x7A7C80)        //字颜调灰色
#define WORD_COLOR_GRAY_9F              HexRGB(0x9F9F9F)        //字颜调灰色9F
#define WORD_COLOR_GRAY_AB              HexRGB(0xABADB3)        //字颜调灰色AB
#define WORD_COLOR_GRAY_9B              HexRGB(0x9b9b9b)        //字颜调灰色9B
#define WORD_COLOR_RED                  HexRGB(0xED0A2B)        //字颜红色
#define WORD_COLOR_ORANGE               HexRGB(0xFF6007)        //字颜色橘色

//按钮颜色
#define BTN_COLOR_NORMAL_GREEN          HexRGB(0x1CBD4C)        //按钮绿色正常
#define BTN_COLOR_HEIGHTLIGHT_GREEN     HexRGB(0x15B345)        //按钮绿色高亮
#define BTN_COLOR_DISABLE_GREEN         HexRGB(0x82E0AA)        //按钮绿色失效  
#define BTN_COLOR_DISABLE               HexRGB(0xD2D3D6)        //按钮失效

//主配置
#define NAVIGATIONBAR_FONT          MEDIUM_FONT(17)           //导航栏字体大小
#define NAVIGATIONBAR_TITLECOLOR    [UIColor blackColor]    //导航栏字体颜色

//屏幕对象
#define SCREEN  [UIApplication sharedApplication].delegate.window

//屏幕宽高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

//iphone各机型判断
#define IS_IPHONE_3_5 CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen].currentMode.size) //iphone4
#define IS_IPHONE_4_0 CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size) //iphone5
#define IS_IPHONE_4_7 CGSizeEqualToSize(CGSizeMake(750, 1334), [UIScreen mainScreen].currentMode.size) //iphone6
#define IS_IPHONE_5_5 CGSizeEqualToSize(CGSizeMake(1242, 2208), [UIScreen mainScreen].currentMode.size) //iphone6p
#define IS_IPHONE_5_8 CGSizeEqualToSize(CGSizeMake(1125, 2436), [UIScreen mainScreen].currentMode.size) //iphonex
#define IS_IPHONE_6_1 CGSizeEqualToSize(CGSizeMake(828, 1792), [UIScreen mainScreen].currentMode.size) //iphonexr
#define IS_IPHONE_6_5 CGSizeEqualToSize(CGSizeMake(1242, 2688), [UIScreen mainScreen].currentMode.size) //iphonexsmax

//UI机型尺寸比例（以iphone6为基准）
#define UI_H_SCALE      (SCREEN_WIDTH/375.0) 
#define UI_V_SCALE      (SCREEN_HEIGHT/667.0)

//分割线
#define LINE_HEIGHT     0.5
#define LINE_COLOR      HexRGB(0xE8EAED)

//屏幕物理像素与现实像素比值
#define SCREEN_SCALE    [UIScreen mainScreen].scale

//判断是否是iphone设备
#define IS_PHONE        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone

//字体大小,宏名以iphone6P下的字号为准
#define IOS9_VALUABLE    (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0)
#define FONT(x)          IOS9_VALUABLE ? [UIFont fontWithName:@"PingFangSC-Regular" size:FONT_SIZE(x)] : [UIFont systemFontOfSize:FONT_SIZE(x)]
#define SEMIBOLD_FONT(x) IOS9_VALUABLE ? [UIFont fontWithName:@"PingFangSC-Semibold" size:FONT_SIZE(x)] : [UIFont boldSystemFontOfSize:FONT_SIZE(x)]
#define MEDIUM_FONT(x)   IOS9_VALUABLE ? [UIFont fontWithName:@"PingFangSC-Medium" size:FONT_SIZE(x)] : [UIFont systemFontOfSize:FONT_SIZE(x)]
#define LIGHT_FONT(x)    IOS9_VALUABLE ? [UIFont fontWithName:@"PingFangSC-Light" size:FONT_SIZE(x)] : [UIFont systemFontOfSize:FONT_SIZE(x)]
#define BOLD_FONT(x)     [UIFont boldSystemFontOfSize:FONT_SIZE(x)]
#define FONT_SIZE(x)     ((IS_IPHONE_5_5?x+1:(IS_IPHONE_4_7||IS_IPHONE_5_8||IS_IPHONE_6_1||IS_IPHONE_6_5?x:x-1)))

//默认控件尺寸
#define TABBAR_HEIGHT           ((IS_IPHONE_5_8 || IS_IPHONE_6_1 || IS_IPHONE_6_5)?83.0:49.0)  //tabbar的默认高度
#define DOWN_DANGER_HEIGHT      ((IS_IPHONE_5_8 || IS_IPHONE_6_1 || IS_IPHONE_6_5)?34:0)    //底部非安全区高度
#define STATUSBAR_HEIGHT        ((IS_IPHONE_5_8 || IS_IPHONE_6_1 || IS_IPHONE_6_5)?44.0:20.0)  //状态栏高度
#define FRINGE_TOP_EXTRA_HEIGHT ((IS_IPHONE_5_8 || IS_IPHONE_6_1 || IS_IPHONE_6_5)?24.0:0)  //iphoneX顶部多余的高度
#define NAVIGATION_BAR_HEIGHT   (STATUSBAR_HEIGHT+44.0)  //navigation+statue默认高度

//生成颜色对象
#define HexRGB(hex)                 [UIColor colorWithRed:(((hex & 0xFF0000) >> 16)/255.0) green:((hex & 0xFF00) >> 8)/255.0 blue:(hex & 0xFF)/255.0 alpha:1.0]
#define HexRGBAlpha(hex,a)          [UIColor colorWithRed:(((hex & 0xFF0000) >> 16)/255.0) green:((hex & 0xFF00) >> 8)/255.0 blue:(hex & 0xFF)/255.0 alpha:a]
#define RGB(r, g, b)                [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)        [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

//获取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
//获取当前APP名字
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//获取当前APP版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//获取当前APPbuild号
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//获取bundle id
#define APP_BUNDLEID [[NSBundle mainBundle] bundleIdentifier]

#endif /* ZYMacro_h */
