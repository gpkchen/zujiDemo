//
//  ZYShareMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/7.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

typedef NS_ENUM(int , ZYShareType) {
    ZYShareTypeWeb = 0, //分享网址
    ZYShareTypeImage = 1, //分享单张图片
};

@interface ZYShareMenu : ZYBaseSheet

/**分享类型*/
@property (nonatomic , assign) ZYShareType shareType;

#pragma mark - 分享网址专用
/**分享icon*/
@property (nonatomic , copy) NSString *icon;
/**分享标题*/
@property (nonatomic , copy) NSString *title;
/**分享内容*/
@property (nonatomic , copy) NSString *content;
/**分享链接*/
@property (nonatomic , copy) NSString *url;


#pragma mark - 分享单张图片专用
/** 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）*/
@property (nonatomic, retain) id shareImage;


#pragma mark - 通用配置
/**是否参与统计*/
@property (nonatomic , assign) BOOL shouldStatistics;

/**分享界面标题*/
@property (nonatomic , copy) NSString *mainTitle;

@end
