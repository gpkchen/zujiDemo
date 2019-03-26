//
//  ZYOrderListCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderListCell.h"
#import "GetOrderList.h"

@interface ZYOrderListCell ()

@property (nonatomic , strong) UILabel *stateLab;
@property (nonatomic , strong) UIImageView *itemIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *skuLab;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) UILabel *stateRightLab;
@property (nonatomic , strong) ZYElasticButton *btnLeft;
@property (nonatomic , strong) ZYElasticButton *btnMid;
@property (nonatomic , strong) ZYElasticButton *btnRight;

@property (nonatomic , strong) _m_GetOrderList *model;

@end

@implementation ZYOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.separator.hidden = NO;
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(40 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.stateLab];
        [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(20 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.itemIV];
        [self.itemIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(60 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 80 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(66 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.skuLab];
        [self.skuLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(92 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemIV.mas_right).mas_offset(10 * UI_H_SCALE);;
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(119 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.btnRight];
        [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.itemIV.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.btnMid];
        [self.btnMid mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnRight.mas_left).mas_offset(-10 * UI_H_SCALE);
            make.top.equalTo(self.itemIV.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.btnLeft];
        [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnMid.mas_left).mas_offset(-10 * UI_H_SCALE);
            make.top.equalTo(self.itemIV.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.stateRightLab];
        [self.stateRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(20 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_GetOrderList *)model{
    _model = model;
    __weak __typeof__(self) weakSelf = self;
    switch (model.status) {
        case ZYOrderStateWaitPay:{
            //待付款
            self.stateLab.text = @"待付款";
            self.btnLeft.hidden = YES;
            self.btnMid.hidden = NO;
            self.btnRight.hidden = NO;
            self.stateRightLab.hidden = NO;
            self.stateRightLab.textColor = WORD_COLOR_ORANGE;
            
            [self.btnMid setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"立即付款" forState:UIControlStateNormal];
            [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
            }];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
            }];
            [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeCancel);
            }];
            [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayOrder);
            }];
            
            if(model.payExpireTime >= 0){
                [self showCountDown];
            }
        }
            break;
        case ZYOrderStateCanceled:{
            //已取消
            self.stateLab.text = @"已取消";
            self.btnLeft.hidden = YES;
            self.btnMid.hidden = YES;
            self.btnRight.hidden = YES;
            self.stateRightLab.hidden = YES;
        }
            break;
        case ZYOrderStateAbnormal:{
            //异常
            self.stateLab.text = @"异常";
            self.stateRightLab.hidden = NO;
            self.stateRightLab.text = @"你归还的商品经检测发现异常状况";
            self.stateRightLab.textColor = WORD_COLOR_GRAY;
            self.btnLeft.hidden = YES;
            self.btnMid.hidden = YES;
            
            if(model.isPenalty){
                self.btnRight.hidden = NO;
                [self.btnRight setTitle:@"支付违约金" forState:UIControlStateNormal];
                [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayPenalty);
                }];
            }else{
                self.btnRight.hidden = YES;
            }
        }
            break;
        case ZYOrderStateWaitDeliver:{
            //待发货
            self.stateLab.text = @"待发货";
            self.btnLeft.hidden = YES;
            self.btnMid.hidden = YES;
            if(model.isCanceling == 1){
                self.stateRightLab.hidden = NO;
                self.stateRightLab.text = @"取消中";
                self.stateRightLab.textColor = WORD_COLOR_ORANGE;
            }else{
                self.stateRightLab.hidden = YES;
            }
            
            self.btnRight.hidden = NO;
            [self.btnRight setTitle:@"联系客服" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
            }];
            [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeService);
            }];
        }
            break;
        case ZYOrderStateWaitReceipt:{
            //待收货
            self.stateLab.text = @"待收货";
            self.stateRightLab.hidden = YES;
            
            if(model.expressType == ZYExpressTypeMail){
                self.btnLeft.hidden = YES;
                self.btnMid.hidden = NO;
                self.btnRight.hidden = NO;
                
                [self.btnMid setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnRight setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeLogistics);
                }];
                [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeReceipt);
                }];
            }else{
                self.btnLeft.hidden = YES;
                self.btnMid.hidden = YES;
                self.btnRight.hidden = YES;
            }
        }
            break;
        case ZYOrderStateUsing:{
            //使用中
            self.stateLab.text = @"体验中";
            if(model.rentType == ZYRentTypeLong){
                //长租
                if(model.isPayAllBills){
                    if(model.isReturnBack){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = @"已经提交归还，等待物流揽收";
                    }else if(model.realReturnBackDays > 3){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = @"账单已还清";
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }else if(model.realReturnBackDays <= 3 && model.realReturnBackDays >0){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = [NSString stringWithFormat:@"距离租期到期还有%d天",model.realReturnBackDays];
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }else if(model.realReturnBackDays == 0){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = @"租期今日到期";
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }else if(model.returnBackDays > 0){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = [NSString stringWithFormat:@"请在%d天内归还/续租/购买",model.returnBackDays + 1];
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }else if(model.returnBackDays == 0){
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = @"请在今日归还/续租/购买";
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }else{
                        self.stateRightLab.hidden = NO;
                        self.stateRightLab.text = [NSString stringWithFormat:@"你已超时归还%d天",-model.returnBackDays];
                        self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    }
                    if(model.isRelet){
                        self.btnLeft.hidden = NO;
                        self.btnMid.hidden = NO;
                        [self.btnLeft setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnMid setTitle:@"续租" forState:UIControlStateNormal];
                        [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                        }];
                        [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                        }];
                        [self.btnLeft clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeBuy);
                        }];
                        [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRenewal);
                        }];
                    }else{
                        self.btnLeft.hidden = YES;
                        self.btnMid.hidden = NO;
                        [self.btnMid setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                        }];
                        [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeBuy);
                        }];
                    }
                    self.btnRight.hidden = NO;
                    if(model.isReturnBack){
                        [self.btnRight setTitle:@"修改物流" forState:UIControlStateNormal];
                    }else{
                        [self.btnRight setTitle:@"归还" forState:UIControlStateNormal];
                    }
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeReturn);
                    }];
                }else if(model.overdueDays > 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = [NSString stringWithFormat:@"账单已逾期%d天",model.overdueDays];
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    self.btnLeft.hidden = YES;
                    
                    self.btnMid.hidden = NO;
                    self.btnRight.hidden = NO;
                    [self.btnMid setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnRight setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayBill);
                    }];
                }else if(model.repayBillDays > 7){
                    self.stateRightLab.hidden = YES;
                    self.btnLeft.hidden = YES;
                    self.btnMid.hidden = NO;
                    self.btnRight.hidden = NO;
                    [self.btnMid setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnRight setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayBill);
                    }];
                }else if(model.repayBillDays > 0 && model.repayBillDays <= 7){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = [NSString stringWithFormat:@"距离账单日还有%d天",model.repayBillDays];
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    self.btnLeft.hidden = YES;
                    self.btnMid.hidden = NO;
                    self.btnRight.hidden = NO;
                    [self.btnMid setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnRight setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayBill);
                    }];
                }else if(model.repayBillDays == 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = @"账单日已到";
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                    self.btnLeft.hidden = YES;
                    self.btnMid.hidden = NO;
                    self.btnRight.hidden = NO;
                    [self.btnMid setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnRight setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayBill);
                    }];
                }else{
                    self.stateRightLab.hidden = YES;
                    self.btnLeft.hidden = YES;
                    self.btnMid.hidden = YES;
                    self.btnRight.hidden = NO;
                    [self.btnRight setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRepair);
                    }];
                }
            }else{
                //短租
                if(model.isReturnBack){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = @"已经提交归还，等待物流揽收";
                }else if(model.realReturnBackDays > 3){
                    self.stateRightLab.hidden = YES;
                }else if(model.realReturnBackDays <= 3 && model.realReturnBackDays >0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = [NSString stringWithFormat:@"距离租期到期还有%d天",model.realReturnBackDays];
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                }else if(model.realReturnBackDays == 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = @"租期今日到期";
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                }else if(model.returnBackDays > 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = [NSString stringWithFormat:@"请在%d天内归还/续租/购买",model.returnBackDays + 1];
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                }else if(model.returnBackDays == 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = @"请在今日归还/续租/购买";
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                }else if(model.returnBackDays < 0){
                    self.stateRightLab.hidden = NO;
                    self.stateRightLab.text = [NSString stringWithFormat:@"你已超时归还%d天",-model.returnBackDays];
                    self.stateRightLab.textColor = WORD_COLOR_ORANGE;
                }else{
                    self.stateRightLab.hidden = YES;
                }
                if(model.isRelet){
                    self.btnLeft.hidden = NO;
                    self.btnMid.hidden = NO;
                    [self.btnLeft setTitle:@"购买" forState:UIControlStateNormal];
                    [self.btnMid setTitle:@"续租" forState:UIControlStateNormal];
                    [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnLeft clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeBuy);
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeRenewal);
                    }];
                }else{
                    self.btnLeft.hidden = YES;
                    self.btnMid.hidden = NO;
                    [self.btnMid setTitle:@"购买" forState:UIControlStateNormal];
                    [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                    }];
                    [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeBuy);
                    }];
                }
                self.btnRight.hidden = NO;
                if(model.isReturnBack){
                    [self.btnRight setTitle:@"修改物流" forState:UIControlStateNormal];
                }else{
                    [self.btnRight setTitle:@"归还" forState:UIControlStateNormal];
                }
                [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(72 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeReturn);
                }];
            }
        }
            break;
        case ZYOrderStateMailedBack:{
            //已寄回
            self.stateLab.text = @"已寄回";
            if(model.returnOverDays > 0){
                self.stateRightLab.hidden = NO;
                self.stateRightLab.text = [NSString stringWithFormat:@"你已超时归还%d天",model.returnOverDays];
                self.stateRightLab.textColor = WORD_COLOR_GRAY_AB;
            }else{
                self.stateRightLab.hidden = YES;
            }
            self.btnLeft.hidden = YES;
            if(model.isPenalty){
                self.btnMid.hidden = NO;
                self.btnRight.hidden = NO;
                [self.btnMid setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnRight setTitle:@"支付违约金" forState:UIControlStateNormal];
                [self.btnMid mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnMid clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeLogistics);
                }];
                [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypePayPenalty);
                }];
            }else{
                self.btnMid.hidden = YES;
                self.btnRight.hidden = NO;
                [self.btnRight setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(96 * UI_H_SCALE, 32 * UI_H_SCALE));
                }];
                [self.btnRight clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(model,ZYOrderStateAcionTypeLogistics);
                }];
            }
        }
            break;
        case ZYOrderStateDone:{
            //已完成
            self.stateLab.text = @"已完成";
            self.btnLeft.hidden = YES;
            self.btnMid.hidden = YES;
            self.btnRight.hidden = YES;
            self.stateRightLab.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    NSString *url = [model.imageUrl imageStyleUrl:CGSizeMake(160 * UI_H_SCALE, 160 * UI_H_SCALE)];
    [self.itemIV loadImage:url];
    self.titleLab.text = model.title;
    self.skuLab.text = [NSString stringWithFormat:@"规格:%@",model.goodsSkuNames];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.rentPrice];
}

#pragma mark - 显示支付倒计时
- (void)showCountDown{
    long long m = _model.payExpireTime / 1000 / 60;
    long long s = (_model.payExpireTime - m * 60 * 1000) / 1000;
    
    if(m >= 0 && s >= 0){
        self.stateRightLab.hidden = NO;
        self.stateRightLab.text = [NSString stringWithFormat:@"倒计时:%lld':%lld''",m,s];
    }else{
        self.stateRightLab.hidden = YES;
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
            self.stateRightLab.hidden = YES;
            !_orderCloseBlock ? : _orderCloseBlock(_model);
        }
    }
}

#pragma mark - getter
- (UILabel *)stateLab{
    if(!_stateLab){
        _stateLab = [UILabel new];
        _stateLab.textColor = WORD_COLOR_BLACK;
        _stateLab.font = FONT(14);
    }
    return _stateLab;
}

- (UIImageView *)itemIV{
    if(!_itemIV){
        _itemIV = [UIImageView new];
        _itemIV.contentMode = UIViewContentModeScaleAspectFill;
        _itemIV.clipsToBounds = YES;
    }
    return _itemIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
    }
    return _titleLab;
}

- (UILabel *)skuLab{
    if(!_skuLab){
        _skuLab = [UILabel new];
        _skuLab.textColor = WORD_COLOR_GRAY;
        _skuLab.font = FONT(14);
    }
    return _skuLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = FONT(14);
    }
    return _priceLab;
}

- (ZYElasticButton *)btnLeft{
    if(!_btnLeft){
        _btnLeft = [ZYElasticButton new];
        _btnLeft.font = FONT(14);
        _btnLeft.shouldRound = YES;
        _btnLeft.borderColor = WORD_COLOR_GRAY;
        _btnLeft.borderWidth = 1;
        _btnLeft.backgroundColor = [UIColor whiteColor];
        [_btnLeft setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_btnLeft setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
    }
    return _btnLeft;
}

- (ZYElasticButton *)btnMid{
    if(!_btnMid){
        _btnMid = [ZYElasticButton new];
        _btnMid.font = FONT(14);
        _btnMid.shouldRound = YES;
        _btnMid.borderColor = WORD_COLOR_GRAY;
        _btnMid.borderWidth = 1;
        _btnMid.backgroundColor = [UIColor whiteColor];
        [_btnMid setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_btnMid setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
    }
    return _btnMid;
}

- (ZYElasticButton *)btnRight{
    if(!_btnRight){
        _btnRight = [ZYElasticButton new];
        _btnRight.font = FONT(14);
        _btnRight.shouldRound = YES;
        _btnRight.borderColor = BTN_COLOR_NORMAL_GREEN;
        _btnRight.borderWidth = 1;
        _btnRight.backgroundColor = [UIColor whiteColor];
        [_btnRight setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_btnRight setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _btnRight;
}

- (UILabel *)stateRightLab{
    if(!_stateRightLab){
        _stateRightLab = [UILabel new];
        _stateRightLab.textColor = WORD_COLOR_ORANGE;
        _stateRightLab.font = FONT(14);
    }
    return _stateRightLab;
}

@end
