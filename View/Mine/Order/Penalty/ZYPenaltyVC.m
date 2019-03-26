//
//  ZYPenaltyVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPenaltyVC.h"
#import "ZYPenaltyView.h"
#import "ZYDetailCell.h"
#import "ZYItemCell.h"
#import "GetPenaltyOrderInfo.h"
#import "ZYPenaltyFooter.h"
#import "GetBillPenalty.h"

@interface ZYPenaltyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYPenaltyView *baseView;
@property (nonatomic , strong) _m_GetPenaltyOrderInfo *info;

@end

@implementation ZYPenaltyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"违约金详情";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
        _billIds = self.dicParam[@"billIds"];
        _payBillType = self.dicParam[@"payBillType"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
}

#pragma mark - 加载续租详情信息
- (void)loadDetail:(BOOL)showHud{
    if(_billIds && _payBillType){
        _p_GetBillPenalty *param = [_p_GetBillPenalty new];
        param.orderId = _orderId;
        param.billIds = _billIds;
        param.payBillType = _payBillType;
        [[ZYHttpClient client] post:param
                            showHud:showHud
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                [self hideLoadingView];
                                [self hideErrorView];
                                if(responseObj.isSuccess){
                                    self.info = [[_m_GetPenaltyOrderInfo alloc] initWithDictionary:responseObj.data];
                                    [self.baseView.tableView reloadData];
                                }else{
                                    [ZYToast showWithTitle:responseObj.message];
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self hideLoadingView];
                                [self hideErrorView];
                                
                                __weak __typeof__(self) weakSelf = self;
                                if(self.info){
                                    if(error.code == ZYHttpErrorCodeTimeOut){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                                    }else if(error.code == ZYHttpErrorCodeNoNet){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                                    }else if(error.code == ZYHttpErrorCodeSystemError){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                                    }
                                }else{
                                    if(error.code == ZYHttpErrorCodeTimeOut){
                                        [self showNetTimeOutView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }else if(error.code == ZYHttpErrorCodeNoNet){
                                        [self showNoNetView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }else if(error.code == ZYHttpErrorCodeSystemError){
                                        [self showSystemErrorView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }
                                }
                            } authFail:^{
                                [self hideLoadingView];
                                [self hideErrorView];
                            }];
    }else{
        _p_GetPenaltyOrderInfo *param = [_p_GetPenaltyOrderInfo new];
        param.orderId = _orderId;
        [[ZYHttpClient client] post:param
                            showHud:showHud
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                [self hideLoadingView];
                                [self hideErrorView];
                                if(responseObj.isSuccess){
                                    self.info = [[_m_GetPenaltyOrderInfo alloc] initWithDictionary:responseObj.data];
                                    [self.baseView.tableView reloadData];
                                }else{
                                    [ZYToast showWithTitle:responseObj.message];
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                [self hideLoadingView];
                                [self hideErrorView];
                                
                                __weak __typeof__(self) weakSelf = self;
                                if(self.info){
                                    if(error.code == ZYHttpErrorCodeTimeOut){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                                    }else if(error.code == ZYHttpErrorCodeNoNet){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                                    }else if(error.code == ZYHttpErrorCodeSystemError){
                                        [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                                    }
                                }else{
                                    if(error.code == ZYHttpErrorCodeTimeOut){
                                        [self showNetTimeOutView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }else if(error.code == ZYHttpErrorCodeNoNet){
                                        [self showNoNetView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }else if(error.code == ZYHttpErrorCodeSystemError){
                                        [self showSystemErrorView:^{
                                            [weakSelf loadDetail:YES];
                                        }];
                                    }
                                }
                            } authFail:^{
                                [self hideLoadingView];
                                [self hideErrorView];
                            }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return ZYItemCellHeight;
    }
    return ZYDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(1 == section){
        return ZYPenaltyFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(1 == section){
        return [ZYPenaltyFooter new];
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    if(self.info.reductionAmount){
        return 5;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYPenaltyVCItemCell";
        ZYItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *url = [_info.imageUrl imageStyleUrl:CGSizeMake((ZYItemCellHeight - 30 * UI_H_SCALE) * 2, (ZYItemCellHeight - 30 * UI_H_SCALE) * 2)];
        [cell.itemIV loadImage:url];
        cell.titleLab.text = _info.title;
        cell.skuLab.text = [NSString stringWithFormat:@"规格:%@",_info.goodsSkuNames];
        cell.priceLab.text = [NSString stringWithFormat:@"￥%@",_info.rentPrice];
        return cell;
    }
    static NSString *identifier = @"ZYPenaltyVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(0 == indexPath.row){
        cell.titleLab.text = @"商品价值";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.marketPrice];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
    }else if(1 == indexPath.row){
        cell.titleLab.text = @"违约金/天";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = _info.penaltyAmountWay;
        cell.contentLab.textColor = WORD_COLOR_BLACK;
    }else if(2 == indexPath.row){
        cell.titleLab.text = @"逾期天数";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = [NSString stringWithFormat:@"%d天",_info.overdueDays];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
    }else if(3 == indexPath.row){
        if(self.info.reductionAmount){
            cell.titleLab.text = @"减免";
            cell.titleLab.textColor = WORD_COLOR_BLACK;
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.reductionAmount];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else{
            cell.titleLab.text = @"应付违约金";
            cell.titleLab.textColor = WORD_COLOR_ORANGE;
            cell.contentLab.text = _info.payPenaltyAmountWay;
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
        }
    }else if(4 == indexPath.row){
        cell.titleLab.text = @"应付违约金";
        cell.titleLab.textColor = WORD_COLOR_ORANGE;
        cell.contentLab.text = _info.payPenaltyAmountWay;
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - getter
- (ZYPenaltyView *)baseView{
    if(!_baseView){
        _baseView = [ZYPenaltyView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

@end
