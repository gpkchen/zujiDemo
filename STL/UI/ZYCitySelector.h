//
//  ZYCitySelector.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"
#import "ZYBaseTableCell.h"
#import "AreaDropDown.h"

//确认回调
typedef void (^ZYCitySelectorConfirmAction)(_m_AreaDropDown *province,_m_AreaDropDown *city,_m_AreaDropDown *distinct);
//取消回调
typedef void (^ZYCitySelectorCancelAction)(void);

/**省市区选择器*/
@interface ZYCitySelector : ZYBaseSheet

@property (nonatomic , copy) ZYCitySelectorConfirmAction confirmAction;

/**显示方法*/
- (void)show;

@end




/*************上拉菜单Cell*************/
@interface ZYCitySelectorCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *titleLab;

@end
