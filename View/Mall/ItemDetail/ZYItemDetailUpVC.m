//
//  ZYItemDetailUpVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpVC.h"
#import "ZYItemDetailUpView.h"
#import "ZYItemDetailUpBannerCell.h"
#import "ZYItemDetailUpTitleCell.h"
#import "ZYItemDetailUpSkuCell.h"
#import "ZYItemDetailUpDragCell.h"
#import "ZYItemDetailUpServiceCell.h"
#import "ZYItemDetailVC.h"
#import "ZYItemDetailUpOperationCell.h"
#import "ZYItemDetailUpActivityCell.h"
#import "ZYItemDetailUpCouponCell.h"
#import "ZYReceiveCouponMenu.h"
#import "ReceiveList.h"
#import "ListUserCoupon.h"
#import "ZYItemDetailUpSpikeCell.h"

@interface ZYItemDetailUpVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYItemDetailUpView *baseView;
@property (nonatomic , strong) ZYReceiveCouponMenu *couponMenu;

@property (nonatomic , assign) CGFloat titleCellHeight; //记录标题cell高度

@end

@implementation ZYItemDetailUpVC

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
}

- (void)pause{
    ZYItemDetailUpBannerCell *cell = [self.baseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(cell){
        [cell pause];
    }
}

#pragma mark - 获取可领取优惠券
- (void)loadReceiveCoupon:(BOOL)shouldShowMenu{
    _p_ReceiveList *param = [_p_ReceiveList new];
    param.categoryId = self.detail.categoryId;
    param.itemId = self.detail.itemId;
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.success){
                                [self.toReceiveCoupons removeAllObjects];
                                [self.receivedCoupons removeAllObjects];
                                NSArray *arr = responseObj.data[@"canReceiveList"];
                                for(NSDictionary *dic in arr){
                                    _m_ListUserCoupon *model = [[_m_ListUserCoupon alloc] initWithDictionary:dic];
                                    [self.toReceiveCoupons addObject:model];
                                }
                                arr = responseObj.data[@"alreadyReceiveList"];
                                for(NSDictionary *dic in arr){
                                    _m_ListUserCoupon *model = [[_m_ListUserCoupon alloc] initWithDictionary:dic];
                                    [self.receivedCoupons addObject:model];
                                }
                                
                                [self.couponMenu setToReceiveCoupons:self.toReceiveCoupons receivedCoupons:self.receivedCoupons];
                                [self.baseView.tableView reloadData];
                                
                                if(shouldShowMenu){
                                    [self.couponMenu show];
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                        } authFail:nil];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentHeight = scrollView.contentSize.height;
    if(contentHeight < scrollView.height){
        contentHeight = scrollView.height;
    }
    if(scrollView.contentOffset.y + scrollView.height >= contentHeight + ZYItemDetailVCDragHeight){
        !_scrollBlock ? : _scrollBlock();
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        if(0 == indexPath.row){
            return SCREEN_WIDTH;
        }
        if(1 == indexPath.row && _detail.activityType == 2){
            //秒杀
            return ZYItemDetailUpSpikeCellHeight;
        }
        if(1 == indexPath.row && _detail.activityType == 1){
            //一般活动
            return ZYItemDetailUpActivityCellHeight;
        }
        if(1 == indexPath.row && ZYItemOpetationTypePreemption == _detail.operateType){
            //抢先
            return ZYItemDetailUpOperationCellHeight;
        }
        return _titleCellHeight;
    }
    if(1 == indexPath.section){
        if(0 == indexPath.row){
            return ZYItemDetailUpSkuCellHeight;
        }
        return ZYItemDetailUpCouponCellHeight;
    }
    if(2 == indexPath.section){
        return ZYItemDetailUpServiceCellHeight;
    }
    return ZYItemDetailUpDragCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [UIView new];
    header.backgroundColor = VIEW_COLOR;
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(0 == indexPath.section && 1 == indexPath.row && ZYItemOpetationTypePreemption == _detail.operateType && !_detail.activityType){
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                          [[ZYH5Utils formatUrl:ZYH5TypePreemptiveExplanation param:nil] URLEncode]]];
    }else if(1 == indexPath.section && 0 == indexPath.row){
        !_skuAction ? : _skuAction();
    }else if(1 == indexPath.section && 1 == indexPath.row){
        if([ZYUser user].isUserLogined){
            [self.couponMenu show];
        }else{
            [[ZYLoginService service] requireLogin:^{
                [self loadReceiveCoupon:YES];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        if(_detail.activityType || ZYItemOpetationTypePreemption == _detail.operateType){
            return 3;
        }
        return 2;
    }
    if(1 == section){
        if(self.toReceiveCoupons.count + self.receivedCoupons.count > 0){
            return 2;
        }
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    if(0 == indexPath.section){
        if(0 == indexPath.row){
            static NSString * identifier = @"ZYItemDetailUpVCBannerCell";
            ZYItemDetailUpBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[ZYItemDetailUpBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell showCellWithModel:_detail];
            
            __weak __typeof__(self) weakSelf = self;
            cell.collectionAction = ^{
                !weakSelf.collectionAction ? : weakSelf.collectionAction();
            };
            cell.rentAction = ^{
                !weakSelf.rentAction ? : weakSelf.rentAction();
            };
            return cell;
        }
        if(1 == indexPath.row && _detail.activityType == 2){
            static NSString * identifier = @"ZYItemDetailUpVCSpikeCell";
            ZYItemDetailUpSpikeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[ZYItemDetailUpSpikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell showCellWithModel:_detail];
            return cell;
        }
        if(1 == indexPath.row && _detail.activityType == 1){
            static NSString * identifier = @"ZYItemDetailUpVCActivityCell";
            ZYItemDetailUpActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[ZYItemDetailUpActivityCell alloc] initWithReuseIdentifier:identifier];
            }
            cell.activityName = _detail.activityName;
            cell.effectiveTime = _detail.effectiveTime;
            return cell;
        }
        if(1 == indexPath.row && ZYItemOpetationTypePreemption == _detail.operateType){
            static NSString * identifier = @"ZYItemDetailUpVCOperationCell";
            ZYItemDetailUpOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[ZYItemDetailUpOperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.notice = _detail.preemptionExplain;
            return cell;
        }
        static NSString * identifier = @"ZYItemDetailUpVCTitleCell";
        ZYItemDetailUpTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemDetailUpTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_detail];
        [cell.depositBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goVC:@"limit" withCallBack:^(NSString *authStatus){
                    weakSelf.detail.authStatus = authStatus;
                    [weakSelf.baseView.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
            }];
        }];
        [cell.shareBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"item_share"];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"share?title=%@&icon=%@&content=%@&url=%@",
                                              [weakSelf.detail.shareTitle URLEncode],
                                              [weakSelf.detail.shareImageUrl URLEncode],
                                              [weakSelf.detail.shareContent URLEncode],
                                              [weakSelf.detail.shareUrl URLEncode]]];
        }];
        return cell;
    }
    if(1 == indexPath.section){
        if(0 == indexPath.row){
            static NSString * identifier = @"ZYItemDetailUpVCSkuCell";
            ZYItemDetailUpSkuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[ZYItemDetailUpSkuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if(_selectedSkuTitle){
                cell.skuLab.text = _selectedSkuTitle;
            }else{
                cell.skuLab.text = @"请选择产品参数";
            }
            return cell;
        }
        static NSString * identifier = @"ZYItemDetailUpVCCouponCell";
        ZYItemDetailUpCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemDetailUpCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.couponLab.textColor = WORD_COLOR_ORANGE;
        if(self.receivedCoupons.count){
            cell.couponLab.text = [NSString stringWithFormat:@"已领取%ld张优惠券",self.receivedCoupons.count];
        }else{
            cell.couponLab.text = @"有券可领";
        }
        return cell;
    }
    if(2 == indexPath.section){
        static NSString * identifier = @"ZYItemDetailUpVCServiceCell";
        ZYItemDetailUpServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemDetailUpServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_detail.guaranteeList];
        return cell;
    }
    static NSString * identifier = @"ZYItemDetailUpVCDragCell";
    ZYItemDetailUpDragCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYItemDetailUpDragCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_detail){
        return 4;
    }
    return 0;
}

#pragma mark - setter
- (void)setDetail:(_m_ItemDetail *)detail{
    _detail = detail;
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = MEDIUM_FONT(18);
    titleLab.numberOfLines = 2;
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    titleLab.text = detail.title;
    CGSize titleSize = [titleLab sizeThatFits:CGSizeMake(SCREEN_WIDTH - 95 * UI_H_SCALE, CGFLOAT_MIN)];
    
    if(_detail.activityDiscountList.count){
        CGFloat activityHeight = 0;
        CGFloat x = 15 * UI_H_SCALE;
        for(int i=0;i<_detail.activityDiscountList.count;++i){
            NSDictionary *dic = _detail.activityDiscountList[i];
            NSString *activityName = dic[@"name"];
            CGSize activitySize = [activityName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:FONT(12)}
                                                             context:nil].size;
            activitySize = CGSizeMake(activitySize.width + 20 * UI_H_SCALE, activitySize.height + 8 * UI_H_SCALE);
            if(x + activitySize.width > SCREEN_WIDTH - 15 * UI_H_SCALE){
                activityHeight += activitySize.height + 10 * UI_H_SCALE;
                x = 15 * UI_H_SCALE;
            }
            x += activitySize.width + 10 * UI_H_SCALE;
            
            if(i == _detail.activityDiscountList.count - 1){
                activityHeight += activitySize.height;
            }
        }
        
        _titleCellHeight = titleSize.height + activityHeight + 109 * UI_H_SCALE;
    }else{
        _titleCellHeight = titleSize.height + 100 * UI_H_SCALE;
    }
    
    [self.baseView.tableView reloadData];
    
    [self loadReceiveCoupon:NO];
}

- (void)setSelectedSkuTitle:(NSString *)selectedSkuTitle{
    _selectedSkuTitle = selectedSkuTitle;
    [self.baseView.tableView reloadData];
}

- (void)setTimeCount:(int)timeCount{
    _timeCount = timeCount;
    UITableViewCell *cell = [self.baseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if(cell && [cell isKindOfClass:[ZYItemDetailUpSpikeCell class]]){
        ZYItemDetailUpSpikeCell *tmpCell = (ZYItemDetailUpSpikeCell *)cell;
        tmpCell.timeCount = timeCount;
    }
}

#pragma mark - getter
- (ZYTableView *)tableView{
    return self.baseView.tableView;
}

- (ZYItemDetailUpView *)baseView{
    if(!_baseView){
        _baseView = [ZYItemDetailUpView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYReceiveCouponMenu *)couponMenu{
    if(!_couponMenu){
        _couponMenu = [ZYReceiveCouponMenu new];
        
        __weak __typeof__(self) weakSelf = self;
        _couponMenu.refreshCouponAction = ^{
            [weakSelf loadReceiveCoupon:NO];
        };
    }
    return _couponMenu;
}

- (NSMutableArray *)toReceiveCoupons{
    if(!_toReceiveCoupons){
        _toReceiveCoupons = [NSMutableArray array];
    }
    return _toReceiveCoupons;
}

- (NSMutableArray *)receivedCoupons{
    if(!_receivedCoupons){
        _receivedCoupons = [NSMutableArray array];
    }
    return _receivedCoupons;
}

@end
