//
//  ZYStudentSchoolListView.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBaseTableCell.h"

@class _m_PulldownSchool;

typedef void (^ZYStudentSchoolListViewSelectAction)(_m_PulldownSchool *school);



@interface ZYStudentSchoolListViewCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *titleLab;

@end



@interface ZYStudentSchoolListView : UIView

@property (nonatomic , strong) NSArray *schools;

@property (nonatomic , copy) ZYStudentSchoolListViewSelectAction selectAction;

@end
