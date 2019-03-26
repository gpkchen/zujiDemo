//
//  ZYExchangeCouponResultVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYExchangeCouponResultVC.h"
#import "ZYExchangeCouponResultView.h"
#import "ZYCouponCell.h"

@interface ZYExchangeCouponResultVC ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ZYExchangeCouponResultView *baseView;

@end

@implementation ZYExchangeCouponResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"兑换成功";
    self.rightBarItems = @[@"确定"];
}

#pragma mark - override
- (void)rightBarItemsAction:(int)index{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_coupon.isOpen){
        return _coupon.cellOpenHeight;
    }
    return _coupon.cellNormalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return self.baseView.header.height;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return self.baseView.header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYCouponSubVCCell";
    ZYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell showCellWithModel:_coupon];
    cell.useBtn.hidden = YES;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - getter
- (ZYExchangeCouponResultView *)baseView{
    if(!_baseView){
        _baseView = [ZYExchangeCouponResultView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        [_baseView.orderBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 1;
        }];
    }
    return _baseView;
}

@end
