//
//  ZYStudentAuthMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"
#import "ZYBaseTableCell.h"

typedef void (^ZYStudentAuthMenuSelectAction)(int index);


@interface ZYStudentAuthMenuCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIImageView *selectionIV;

@end



@interface ZYStudentAuthMenu : ZYBaseSheet

@property (nonatomic , strong) NSArray *titles;
@property (nonatomic , assign) int selectedIndex;

@property (nonatomic , copy) ZYStudentAuthMenuSelectAction selectAction;

@end
