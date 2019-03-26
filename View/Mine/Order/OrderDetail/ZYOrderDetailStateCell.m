
//
//  ZYOrderDetailStateCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailStateCell.h"
#import "GetOrderDetail.h"

@interface ZYOrderDetailStateCell ()

@property (nonatomic , strong) UIImageView *backIV;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *stateLab;

@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UILabel *amountLab;
@property (nonatomic , strong) UILabel *overdueLab;
@property (nonatomic , strong) UILabel *noticeLab;

@property (nonatomic , strong) _m_GetOrderDetail *model;

@end

@implementation ZYOrderDetailStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.backIV];
        [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.stateLab];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(29.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(52 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.overdueLab];
        [self.overdueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(60 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderDetail *)model{
    _model = model;
    switch (model.status) {
        case ZYOrderStateWaitPay:{
            //待付款
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.iconIV.hidden = NO;
            self.iconIV.image = [UIImage imageNamed:@"zy_order_state_icon_unpayed"];
            self.stateLab.text = @"待付款";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconIV.mas_right).mas_offset(6 * UI_H_SCALE);
                make.centerY.equalTo(self.iconIV);
            }];
            [self showCountDown];
            self.amountLab.hidden = NO;
            self.amountLab.text = [NSString stringWithFormat:@"需付款：￥%.2f",model.localTotalPrice];
            self.noticeLab.hidden = YES;
        }
            break;
        case ZYOrderStateCanceled:{
            //已关闭
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_gray"];
            self.iconIV.hidden = YES;
            self.stateLab.text = @"已关闭";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            self.noticeLab.hidden = YES;
        }
            break;
        case ZYOrderStateAbnormal:{
            //异常
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.iconIV.hidden = YES;
            self.stateLab.text = @"异常";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            self.noticeLab.hidden = NO;
            self.noticeLab.text = @"你归还的商品经检测发现异常状况，请你保持电话畅通， 等待客服人员与你联系。";
        }
            break;
        case ZYOrderStateWaitDeliver:{
            //待发货
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.amountLab.hidden = YES;
            self.timeLab.hidden = YES;
            if(model.isCanceling == 1){
                self.iconIV.hidden = YES;
                self.stateLab.text = @"取消中";
                [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
                }];
                self.noticeLab.hidden = NO;
                self.noticeLab.text = @"工作人员将在核对信息后，为你取消";
            }else{
                self.iconIV.hidden = NO;
                self.iconIV.image = [UIImage imageNamed:@"zy_order_state_icon_undelivered"];
                self.stateLab.text = @"待发货";
                [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.iconIV.mas_right).mas_offset(6 * UI_H_SCALE);
                    make.centerY.equalTo(self.iconIV);
                }];
                self.noticeLab.hidden = YES;
            }
        }
            break;
        case ZYOrderStateWaitReceipt:{
            //待收货
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.iconIV.hidden = NO;
            self.iconIV.image = [UIImage imageNamed:@"zy_order_state_icon_unreceived"];
            self.stateLab.text = @"待收货";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconIV.mas_right).mas_offset(6 * UI_H_SCALE);
                make.centerY.equalTo(self.iconIV);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            if(model.expressType == ZYExpressTypeSelfLifting){
                self.noticeLab.hidden = NO;
                self.noticeLab.text = @"请赶往门店提取您的商品";
            }else{
                self.noticeLab.hidden = YES;
            }
        }
            break;
        case ZYOrderStateUsing:{
            //使用中
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.iconIV.hidden = YES;
            self.stateLab.text = @"体验中";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            if(model.rentType == ZYRentTypeLong){
                //长期
                if(model.isPayAllBills){
                    if(model.isReturnBack){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = @"已经提交归还，等待物流揽收";
                    }else if(model.realReturnBackDays > 3){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = @"账单已还清";
                    }else if(model.realReturnBackDays <= 3 && model.realReturnBackDays >0){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = [NSString stringWithFormat:@"距离租期到期还有%d天",model.realReturnBackDays];
                    }else if(model.realReturnBackDays == 0){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = @"租期今日到期";
                    }else if(model.returnBackDays > 0){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = [NSString stringWithFormat:@"请在%d天内归还/续租/购买",model.returnBackDays + 1];
                    }else if(model.returnBackDays == 0){
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = @"请在今日归还/续租/购买";
                    }else{
                        self.noticeLab.hidden = NO;
                        self.noticeLab.text = [NSString stringWithFormat:@"你已超时归还%d天",-model.returnBackDays];
                    }
                }else if(model.overdueDays > 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = [NSString stringWithFormat:@"账单已逾期%d天",model.overdueDays];
                }else if(model.repayBillDays > 0 && model.repayBillDays <= 7){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = [NSString stringWithFormat:@"距离账单日%d天",model.repayBillDays];
                }else if(model.repayBillDays == 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = @"账单日已到，请及时还款。";
                }else{
                    self.noticeLab.hidden = YES;
                }
            }else{
                //短期
                if(model.isReturnBack){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = @"已经提交归还，等待物流揽收";
                }else if(model.realReturnBackDays > 3){
                    self.noticeLab.hidden = YES;
                }else if(model.realReturnBackDays <= 3 && model.realReturnBackDays >0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = [NSString stringWithFormat:@"距离租期到期还有%d天",model.realReturnBackDays];
                }else if(model.realReturnBackDays == 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = @"租期今日到期";
                }else if(model.returnBackDays > 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = [NSString stringWithFormat:@"请在%d天内归还/续租/购买",model.returnBackDays + 1];
                }else if(model.returnBackDays == 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = @"请在今日归还/续租/购买";
                }else if(model.returnBackDays < 0){
                    self.noticeLab.hidden = NO;
                    self.noticeLab.text = [NSString stringWithFormat:@"你已超时归还%d天",-model.returnBackDays];
                }else{
                    self.noticeLab.hidden = YES;
                }
            }
        }
            break;
        case ZYOrderStateMailedBack:{
            //已寄回
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_red"];
            self.iconIV.hidden = YES;
            self.stateLab.text = @"已寄回";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            if(model.returnOverDays > 0){
                self.noticeLab.hidden = NO;
                self.noticeLab.text = [NSString stringWithFormat:@"你已超时归还%d天,需要支付相应的违约金。",model.returnOverDays];
            }else{
                self.noticeLab.hidden = NO;
                self.noticeLab.text = @"商品寄回中。";
            }
        }
            break;
        case ZYOrderStateDone:{
            //已完成
            self.backIV.image = [UIImage imageNamed:@"zy_order_state_back_green"];
            self.iconIV.hidden = YES;
            self.stateLab.text = @"已完成";
            [self.stateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            }];
            self.timeLab.hidden = YES;
            self.amountLab.hidden = YES;
            self.noticeLab.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 显示支付倒计时
- (void)showCountDown{
    long long m = _model.payExpireTime / 1000 / 60;
    long long s = (_model.payExpireTime - m * 60 * 1000) / 1000;
    
    if(m >= 0 && s >= 0){
        self.timeLab.hidden = NO;
        self.timeLab.text = [NSString stringWithFormat:@"剩余：%lld分钟%lld秒",m,s];
    }else{
        self.timeLab.hidden = YES;
        !_orderCloseBlock ? : _orderCloseBlock(_model);
    }
}


#pragma mark - setter
- (void)setTimeCount:(int)timeCount{
    _timeCount = timeCount;
    
    if(_model.status == ZYOrderStateWaitPay){
        if(_model.payExpireTime >= 0){
            _model.payExpireTime -= 1000;
            [self showCountDown];
        }else{
            self.timeLab.hidden = YES;
            !_orderCloseBlock ? : _orderCloseBlock(_model);
        }
    }
}

#pragma mark - getter
- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
    }
    return _backIV;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}

- (UILabel *)stateLab{
    if(!_stateLab){
        _stateLab = [UILabel new];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font = FONT(20);
    }
    return _stateLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.font = FONT(15);
        _timeLab.textColor = [UIColor whiteColor];
    }
    return _timeLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.font = FONT(13);
        _amountLab.textColor = [UIColor whiteColor];
    }
    return _amountLab;
}

- (UILabel *)overdueLab{
    if(!_overdueLab){
        _overdueLab = [UILabel new];
        _overdueLab.font = FONT(12);
        _overdueLab.textColor = [UIColor whiteColor];
    }
    return _overdueLab;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.font = FONT(12);
        _noticeLab.textColor = [UIColor whiteColor];
        _noticeLab.numberOfLines = 2;
        _noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
        _noticeLab.text = @"您归还的商品经检测发现异常状况，请您保持电话畅通， 等待客服人员与您联系。";
    }
    return _noticeLab;
}

@end
