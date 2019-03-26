//
//  ZYOrderDetailView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailView.h"
#import "GetOrderDetail.h"

@interface ZYOrderDetailView ()

@property (nonatomic , strong) UIView *btnBackView;
@property (nonatomic , strong) ZYElasticButton *btnOne;
@property (nonatomic , strong) ZYElasticButton *btnTwo;
@property (nonatomic , strong) ZYElasticButton *btnThree;
@property (nonatomic , strong) ZYElasticButton *btnFour;

@end

@implementation ZYOrderDetailView

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = VIEW_COLOR;
    
    [self addSubview:self.btnBackView];
    [self.btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.mas_equalTo(70 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 70 * UI_H_SCALE + DOWN_DANGER_HEIGHT, 0));
    }];
    
    [self.btnBackView addSubview:self.btnOne];
    [self.btnBackView addSubview:self.btnTwo];
    [self.btnBackView addSubview:self.btnThree];
    [self.btnBackView addSubview:self.btnFour];
    
    [self.btnFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnBackView).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.btnBackView).mas_offset(15 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [self.btnThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnFour.mas_left).mas_offset(-10 * UI_H_SCALE);
        make.top.equalTo(self.btnBackView).mas_offset(15 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [self.btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnThree.mas_left).mas_offset(-10 * UI_H_SCALE);
        make.top.equalTo(self.btnBackView).mas_offset(15 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeZero);
    }];

    [self.btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnTwo.mas_left).mas_offset(-10 * UI_H_SCALE);
        make.top.equalTo(self.btnBackView).mas_offset(15 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [self addSubview:self.buyOffInfoBtn];
    [self.buyOffInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-26 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(108 * UI_H_SCALE, 40 * UI_H_SCALE));
    }];
}

#pragma mark - setter
- (void)setDetail:(_m_GetOrderDetail *)detail{
    _detail = detail;
    
    __weak __typeof__(self) weakSelf = self;
    switch (detail.status) {
        case ZYOrderStateWaitPay:{
            //待付款
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            self.btnThree.hidden = NO;
            self.btnFour.hidden = NO;
            [self.btnThree setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.btnFour setTitle:@"立即付款" forState:UIControlStateNormal];
            [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
            }];
            [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
            }];
            [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeCancel);
            }];
            [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypePayOrder);
            }];
        }
            break;
        case ZYOrderStateCanceled:{
            //已关闭
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            self.btnThree.hidden = YES;
            self.btnFour.hidden = YES;
        }
            break;
        case ZYOrderStateAbnormal:{
            //异常
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            self.btnThree.hidden = YES;
            if(detail.isPenalty){
                self.btnFour.hidden = NO;
                [self.btnFour setTitle:@"支付违约金" forState:UIControlStateNormal];
                [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypePayPenalty);
                }];
            }else{
                self.btnFour.hidden = YES;
            }
        }
            break;
        case ZYOrderStateWaitDeliver:{
            //待发货
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            self.btnThree.hidden = YES;
            self.btnFour.hidden = NO;
            [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
            }];
            
            if(detail.isCanceling == 1 || detail.isCanceling == 2){
                [self.btnFour setTitle:@"联系客服" forState:UIControlStateNormal];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeService);
                }];
            }else {
                [self.btnFour setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeCancelExamine);
                }];
            }
        }
            break;
        case ZYOrderStateWaitReceipt:{
            //待收货
            if(detail.expressType == ZYExpressTypeMail){
                self.btnOne.hidden = YES;
                self.btnTwo.hidden = YES;
                self.btnThree.hidden = NO;
                self.btnFour.hidden = NO;
                [self.btnThree setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnFour setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeLogistics);
                }];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeReceipt);
                }];
            }else{
                self.btnOne.hidden = YES;
                self.btnTwo.hidden = YES;
                self.btnThree.hidden = YES;
                self.btnFour.hidden = YES;
            }
        }
            break;
        case ZYOrderStateUsing:{
            //使用中
            if(detail.rentType == ZYRentTypeLong){
                //长租
                if(detail.isPayAllBills && detail.returnBackDays >= 0 && detail.returnBackDays <= 3){
                    if(detail.isRelet){
                        self.btnOne.hidden = NO;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnOne setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnTwo setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"续租" forState:UIControlStateNormal];
                        [self.btnOne mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnOne clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRenewal);
                        }];
                    }else{
                        self.btnOne.hidden = YES;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnTwo setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                    }
                    
                    self.btnFour.hidden = NO;
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    if(detail.isReturnBack){
                        [self.btnFour setTitle:@"修改物流" forState:UIControlStateNormal];
                    }else{
                        [self.btnFour setTitle:@"归还" forState:UIControlStateNormal];
                    }
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeReturn);
                    }];
                }else if(detail.isPayAllBills && detail.returnBackDays > 3){
                    if(detail.isRelet){
                        self.btnOne.hidden = NO;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnOne setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnTwo setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"续租" forState:UIControlStateNormal];
                        [self.btnOne mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnOne clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRenewal);
                        }];
                    }else{
                        self.btnOne.hidden = YES;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnTwo setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                    }
                    
                    self.btnFour.hidden = NO;
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    if(detail.isReturnBack){
                        [self.btnFour setTitle:@"修改物流" forState:UIControlStateNormal];
                    }else{
                        [self.btnFour setTitle:@"归还" forState:UIControlStateNormal];
                    }
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeReturn);
                    }];
                }else if(detail.isPayAllBills && detail.returnBackDays < 0){
                    if(detail.isRelet){
                        self.btnOne.hidden = NO;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnOne setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnTwo setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"续租" forState:UIControlStateNormal];
                        [self.btnOne mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnOne clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRenewal);
                        }];
                    }else{
                        self.btnOne.hidden = YES;
                        self.btnTwo.hidden = NO;
                        self.btnThree.hidden = NO;
                        [self.btnTwo setTitle:@"报修" forState:UIControlStateNormal];
                        [self.btnThree setTitle:@"购买" forState:UIControlStateNormal];
                        [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                        }];
                        [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                        }];
                        [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                            !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                        }];
                    }
                    
                    self.btnFour.hidden = NO;
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    if(detail.isReturnBack){
                        [self.btnFour setTitle:@"修改物流" forState:UIControlStateNormal];
                    }else{
                        [self.btnFour setTitle:@"归还" forState:UIControlStateNormal];
                    }
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeReturn);
                    }];
                }else if(detail.overdueDays > 0){
                    self.btnOne.hidden = YES;
                    self.btnTwo.hidden = YES;
                    self.btnThree.hidden = NO;
                    self.btnFour.hidden = NO;
                    [self.btnThree setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnFour setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                    }];
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                    }];
                    [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypePayBill);
                    }];
                }else if(detail.repayBillDays >= 0){
                    self.btnOne.hidden = YES;
                    self.btnTwo.hidden = YES;
                    self.btnThree.hidden = NO;
                    self.btnFour.hidden = NO;
                    [self.btnThree setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnFour setTitle:@"支付账单" forState:UIControlStateNormal];
                    [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                    }];
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                    }];
                    [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypePayBill);
                    }];
                }else{
                    self.btnOne.hidden = YES;
                    self.btnTwo.hidden = YES;
                    self.btnThree.hidden = YES;
                    self.btnFour.hidden = NO;
                    [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                    }];
                    [self.btnFour setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                    }];
                }
            }else{
                //短租
                if(detail.isRelet){
                    self.btnOne.hidden = NO;
                    self.btnTwo.hidden = NO;
                    self.btnThree.hidden = NO;
                    [self.btnOne setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnTwo setTitle:@"购买" forState:UIControlStateNormal];
                    [self.btnThree setTitle:@"续租" forState:UIControlStateNormal];
                    [self.btnOne mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    [self.btnOne clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                    }];
                    [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRenewal);
                    }];
                }else{
                    self.btnOne.hidden = YES;
                    self.btnTwo.hidden = NO;
                    self.btnThree.hidden = NO;
                    [self.btnTwo setTitle:@"报修" forState:UIControlStateNormal];
                    [self.btnThree setTitle:@"购买" forState:UIControlStateNormal];
                    [self.btnTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                    }];
                    [self.btnTwo clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeRepair);
                    }];
                    [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                        !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeBuy);
                    }];
                }
                
                self.btnFour.hidden = NO;
                [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60 * UI_H_SCALE) / 4.0, 32 * UI_H_SCALE));
                }];
                if(detail.isReturnBack){
                    [self.btnFour setTitle:@"修改物流" forState:UIControlStateNormal];
                }else{
                    [self.btnFour setTitle:@"归还" forState:UIControlStateNormal];
                }
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeReturn);
                }];
            }
        }
            break;
        case ZYOrderStateMailedBack:{
            //已寄回
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            
            if(detail.isPenalty){
                self.btnThree.hidden = NO;
                self.btnFour.hidden = NO;
                [self.btnThree setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnFour setTitle:@"支付违约金" forState:UIControlStateNormal];
                [self.btnThree mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnThree clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeLogistics);
                }];
                
                [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypePayPenalty);
                }];
            }else{
                self.btnThree.hidden = YES;
                self.btnFour.hidden = NO;
                [self.btnFour mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(110 * UI_H_SCALE, 40 * UI_H_SCALE));
                }];
                [self.btnFour setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.btnFour clickAction:^(UIButton * _Nonnull button) {
                    !weakSelf.buttonAction ? : weakSelf.buttonAction(ZYOrderStateAcionTypeLogistics);
                }];
            }
        }
            break;
        case ZYOrderStateDone:{
            //已完成
            self.btnOne.hidden = YES;
            self.btnTwo.hidden = YES;
            self.btnThree.hidden = YES;
            self.btnFour.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    if(detail.status == ZYOrderStateDone ||
       detail.status == ZYOrderStateCanceled ||
       (detail.status == ZYOrderStateAbnormal && !detail.isPenalty) ||
       (detail.status == ZYOrderStateWaitReceipt && detail.expressType == ZYExpressTypeSelfLifting)){
        self.btnBackView.hidden = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
    }else{
        self.btnBackView.hidden = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, DOWN_DANGER_HEIGHT + 70 * UI_H_SCALE, 0));
        }];
    }
}

#pragma mark - getter
- (UIView *)btnBackView{
    if(!_btnBackView){
        _btnBackView = [UIView new];
        _btnBackView.backgroundColor = [UIColor whiteColor];
    }
    return _btnBackView;
}

- (ZYElasticButton *)billBtn{
    if(!_billBtn){
        _billBtn = [ZYElasticButton new];
        _billBtn.shouldAnimate = NO;
        _billBtn.font = FONT(15);
        [_billBtn setTitle:@"查看账单" forState:UIControlStateNormal];
        [_billBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_billBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_billBtn sizeToFit];
        _billBtn.size = CGSizeMake(_billBtn.width, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
    }
    return _billBtn;
}

- (ZYElasticButton *)btnOne{
    if(!_btnOne){
        _btnOne = [ZYElasticButton new];
        _btnOne.shouldRound = YES;
        _btnOne.font = FONT(16);
        _btnOne.borderColor = WORD_COLOR_GRAY;
        _btnOne.borderWidth = 1;
        _btnOne.backgroundColor = [UIColor whiteColor];
        [_btnOne setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_btnOne setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
    }
    return _btnOne;
}

- (ZYElasticButton *)btnTwo{
    if(!_btnTwo){
        _btnTwo = [ZYElasticButton new];
        _btnTwo.shouldRound = YES;
        _btnTwo.font = FONT(16);
        _btnTwo.borderColor = WORD_COLOR_GRAY;
        _btnTwo.borderWidth = 1;
        _btnTwo.backgroundColor = [UIColor whiteColor];
        [_btnTwo setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_btnTwo setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
    }
    return _btnTwo;
}

- (ZYElasticButton *)btnThree{
    if(!_btnThree){
        _btnThree = [ZYElasticButton new];
        _btnThree.shouldRound = YES;
        _btnThree.font = FONT(16);
        _btnThree.borderColor = WORD_COLOR_GRAY;
        _btnThree.borderWidth = 1;
        _btnThree.backgroundColor = [UIColor whiteColor];
        [_btnThree setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_btnThree setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
    }
    return _btnThree;
}

- (ZYElasticButton *)btnFour{
    if(!_btnFour){
        _btnFour = [ZYElasticButton new];
        _btnFour.shouldRound = YES;
        _btnFour.font = FONT(16);
        _btnFour.borderColor = BTN_COLOR_NORMAL_GREEN;
        _btnFour.borderWidth = 1;
        _btnFour.backgroundColor = [UIColor whiteColor];
        [_btnFour setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_btnFour setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _btnFour;
}


- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (ZYElasticButton *)buyOffInfoBtn{
    if(!_buyOffInfoBtn){
        _buyOffInfoBtn = [ZYElasticButton new];
        _buyOffInfoBtn.hidden = YES;
        _buyOffInfoBtn.backgroundColor = HexRGBAlpha(0x000000, 0.3);
        _buyOffInfoBtn.shouldRound = YES;
        ZYElasticButton *button = _buyOffInfoBtn;
        UILabel *lab = [UILabel new];
        lab.textColor = UIColor.whiteColor;
        lab.font = FONT(14);
        lab.text = @"买断详情";
        [_buyOffInfoBtn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(button);
        }];
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"zy_order_detail_buy_off_arrow"];
        [_buyOffInfoBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.right.equalTo(button).mas_offset(-15 * UI_H_SCALE);
        }];
    }
    return _buyOffInfoBtn;
}

- (ZYElasticButton *)helpBtn{
    if(!_helpBtn){
        _helpBtn = [ZYElasticButton new];
        _helpBtn.backgroundColor = UIColor.clearColor;
        [_helpBtn setImage:[UIImage imageNamed:@"zy_order_buy_off_help"] forState:UIControlStateNormal];
        [_helpBtn setImage:[UIImage imageNamed:@"zy_order_buy_off_help"] forState:UIControlStateHighlighted];
    }
    return _helpBtn;
}

@end
