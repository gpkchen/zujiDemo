//
//  ZYReceiveCouponMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/27.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReceiveCouponMenu.h"
#import "ListUserCoupon.h"
#import "ZYCouponCell.h"
#import "ZYReceiveCouponHeader.h"
#import "ReceiveCoupon.h"

@interface ZYReceiveCouponMenu()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYReceiveCouponHeader *header1;
@property (nonatomic , strong) ZYReceiveCouponHeader *header2;

@end

@implementation ZYReceiveCouponMenu

- (instancetype)init{
    if(self = [super init]){
        
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(56 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.titleLab);
            make.width.mas_equalTo(30 + 30 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.panel);
            make.top.equalTo(self.titleLab.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - public
- (void)show{
    self.panelView = self.panel;
    [super show];
}

#pragma mark - 领取优惠券
- (void)receive:(NSString *)couponGrantId{
    _p_ReceiveCoupon *param = [_p_ReceiveCoupon new];
    param.couponGrantId = couponGrantId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [ZYComplexToast showSuccessWithTitle:@"领取成功"
                                                              detail:@"午餐又可以加鸡腿了"
                                                             centerY:SCREEN_HEIGHT - 493 * UI_V_SCALE / 2.0];
                            }else if(responseObj.code == 6001){
                                [ZYComplexToast showFailureWithTitle:@"优惠券已领完"
                                                              detail:@"敬请期待下次活动～"
                                                             centerY:SCREEN_HEIGHT - 493 * UI_V_SCALE / 2.0];
                            }else if(responseObj.code == 6002){
                                [ZYComplexToast showMessageWithTitle:@"此券已领取"
                                                              detail:@"抓紧时间去下单吧～"
                                                             centerY:SCREEN_HEIGHT - 493 * UI_V_SCALE / 2.0];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                            !self.refreshCouponAction ? : self.refreshCouponAction();
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                        } authFail:^{
                            [self dismiss:nil];
                        }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_ListUserCoupon *model = nil;
    if(indexPath.section < self.toReceiveCoupons.count){
        model = self.toReceiveCoupons[indexPath.section];
    }else{
        model = self.receivedCoupons[indexPath.section - self.toReceiveCoupons.count];
    }
    if(model.isOpen){
        return model.cellOpenHeight;
    }
    return model.cellNormalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section && self.toReceiveCoupons.count){
        return 35 * UI_H_SCALE;
    }
    if(self.toReceiveCoupons.count == section && self.receivedCoupons.count){
        return 55 * UI_H_SCALE;
    }
    return 15 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section && self.toReceiveCoupons.count){
        return self.header1;
    }
    if(self.toReceiveCoupons.count == section && self.receivedCoupons.count){
        return self.header2;
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
        cell.backgroundColor = HexRGB(0xF7FAF8);
    }
    _m_ListUserCoupon *model = nil;
    if(indexPath.section < self.toReceiveCoupons.count){
        model = self.toReceiveCoupons[indexPath.section];
    }else{
        model = self.receivedCoupons[indexPath.section - self.toReceiveCoupons.count];
    }
    [cell showReceiveCellWithModel:model];
    
    [cell.openBtn clickAction:^(UIButton * _Nonnull button) {
        model.isOpen = !model.isOpen;
        [tableView reloadData];
    }];
    
    __weak __typeof__(self) weakSelf = self;
    [cell.useBtn clickAction:^(UIButton * _Nonnull button) {
        if(model.couponGrantId){
            //领取优惠券
            [weakSelf receive:model.couponGrantId];
        }else{
            //去使用
            [weakSelf dismiss:nil];
        }
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.toReceiveCoupons.count + self.receivedCoupons.count;
}

#pragma mark - setter
- (void)setToReceiveCoupons:(NSMutableArray *)toReceiveCoupons receivedCoupons:(NSMutableArray *)receivedCoupons{
    _toReceiveCoupons = toReceiveCoupons;
    _receivedCoupons = receivedCoupons;
    self.header2.numLab.text = [NSString stringWithFormat:@"共%ld张",receivedCoupons.count];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = HexRGB(0xF7FAF8);
        _panel.size = CGSizeMake(SCREEN_WIDTH, 493 * UI_V_SCALE);
    }
    return _panel;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(20);
        _titleLab.text = @"领优惠券";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = UIColor.whiteColor;
    }
    return _titleLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _closeBtn;
}

- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HexRGB(0xF7FAF8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ZYReceiveCouponHeader *)header1{
    if(!_header1){
        _header1 = [ZYReceiveCouponHeader new];
        _header1.titleLab.text = @"可领优惠券";
        _header1.numLab.text = @"";
    }
    return _header1;
}

- (ZYReceiveCouponHeader *)header2{
    if(!_header2){
        _header2 = [ZYReceiveCouponHeader new];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"已领优惠券(以下是你账户里的可用优惠券)"];
        [title addAttribute:NSFontAttributeName value:LIGHT_FONT(14) range:NSMakeRange(5, title.length - 5)];
        _header2.titleLab.attributedText = title;
    }
    return _header2;
}

@end
