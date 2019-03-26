//
//  AppMyReleaseListInfo.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "AppMyReleaseListInfo.h"

@implementation _p_AppMyReleaseListInfo

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/userRelease/appMyReleaseListInfo";
        self.size = ZYRequestDefaultPageSize;
        self.needApiToekn = NO;
    }
    return self;
}

@end



@implementation _m_AppMyReleaseListInfo

- (void)countCellHeight{
    if(self.title.length){
        CGFloat contentHeight = [self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * UI_H_SCALE, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:MEDIUM_FONT(18)}
                                                         context:nil].size.height;
        if(self.images.count){
            _cellHeight = contentHeight + 255 * UI_H_SCALE + 70 * UI_H_SCALE;
        }else{
            _cellHeight = contentHeight + 70 * UI_H_SCALE + 70 * UI_H_SCALE;
        }
    }else{
        if(self.images.count){
            _cellHeight = 315 * UI_H_SCALE;
        }else{
            _cellHeight = 140 * UI_H_SCALE;
        }
    }
}

@end
