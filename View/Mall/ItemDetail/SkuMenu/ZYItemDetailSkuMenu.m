//
//  ZYItemDetailSkuMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailSkuMenu.h"
#import "ZYItemDetailSkuMenuCell.h"
#import "ZYItemDetailSkuMenuServiceCell.h"

#define kSkuMenuToolBarHeight (55 * UI_H_SCALE)

@interface ZYItemDetailSkuMenu ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYElasticButton *closeBtn; //关闭按钮

@property (nonatomic , strong) UIImageView *screenshotIV; //截屏图片
@property (nonatomic , strong) UIView *patchView; //灰色底部
@property (nonatomic , strong) UIView *panelBack; //整个菜单底部
@property (nonatomic , strong) UIView *panelView; //菜单白色底部
@property (nonatomic , strong) UIImageView *iconIV; //产品图标

@property (nonatomic , strong) ZYElasticButton *payBtn; //支付按钮
@property (nonatomic , strong) UILabel *priceLab; //价格
@property (nonatomic , strong) UIView *toolBar;
@property (nonatomic , strong) UIView *toolBarBack;

@property (nonatomic , strong) ZYTableView *tableView;

@property (nonatomic , strong) NSArray *selectedSkus; //选择的属性
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute_Sub *selectedPeriod; //选择的租期
@property (nonatomic , strong) NSArray *selectedServices; //选择的增值服务
@property (nonatomic , strong) _m_ItemDetail_SkuPrice *selectedSkuPrice; //对应的价格

@end

@implementation ZYItemDetailSkuMenu

- (instancetype) init{
    if(self = [super init]){
        [self initSelf];
    }
    return self;
}

- (void)initSelf{
    self.backgroundColor = [UIColor blackColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self addSubview:self.screenshotIV];
    self.screenshotIV.frame = self.bounds;
    
    [self addSubview:self.patchView];
    self.patchView.frame = self.bounds;
    
    [self addSubview:self.panelBack];
    self.panelBack.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 538 * UI_V_SCALE + DOWN_DANGER_HEIGHT);
    
    [self.panelBack addSubview:self.panelView];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.panelBack);
        make.top.equalTo(self.panelBack).mas_offset(38 * UI_V_SCALE);
    }];
    
    [self.panelBack addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.panelView);
        make.size.mas_equalTo(CGSizeMake(13 + 30 * UI_H_SCALE, 13 + 30 * UI_H_SCALE));
    }];
    
    [self.panelBack addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panelBack).mas_offset(15 * UI_H_SCALE);
        make.top.equalTo(self.panelBack);
        make.size.mas_equalTo(CGSizeMake(100 * UI_H_SCALE, 100 * UI_H_SCALE));
    }];
    
    [self.panelBack addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panelBack);
        make.top.equalTo(self.iconIV.mas_bottom);
        make.bottom.equalTo(self.panelBack).mas_offset(-(kSkuMenuToolBarHeight + DOWN_DANGER_HEIGHT));
    }];
    
    [self.panelBack addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.panelBack);
        make.height.mas_equalTo(DOWN_DANGER_HEIGHT + kSkuMenuToolBarHeight);
    }];
    
    [self.toolBar addSubview:self.toolBarBack];
    [self.toolBarBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.toolBar);
        make.height.mas_equalTo(kSkuMenuToolBarHeight);
    }];
    
    [self.toolBar addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.toolBar);
        make.width.mas_equalTo(150 * UI_H_SCALE);
        make.bottom.equalTo(self.toolBar).mas_offset(-DOWN_DANGER_HEIGHT);
    }];
    
    [self.toolBar addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolBar).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.toolBarBack);
    }];
}

- (void)show{
    self.patchView.alpha = 0;
    self.panelBack.top = SCREEN_HEIGHT;
    self.screenshotIV.image = [SCREEN screenShot];
    if(_detail.imageList.count){
        NSString *url = [_detail.imageList[0][@"url"] imageStyleUrl:CGSizeMake(200 * UI_H_SCALE, 200 * UI_H_SCALE)];
        [self.iconIV loadImage:url];
    }
    [self refreshMenu];
    [self checkService];
    [self.tableView reloadData];
    //总库存
    NSUInteger totalStorage = 0;
    for(_m_ItemDetail_SkuPrice *skuPrice in self.detail.skuPriceList){
        totalStorage += skuPrice.storage;
    }
    if(totalStorage <= 0){
        //已售罄
        self.payBtn.enabled = NO;
        [self.payBtn setTitle:@"已售罄" forState:UIControlStateDisabled];
    }else if(self.detail.status){
        if(ZYItemStateUnSelling == self.detail.status){
            //已下架
            self.payBtn.enabled = NO;
            [self.payBtn setTitle:@"已下架" forState:UIControlStateDisabled];
        }else if(ZYItemStateToSell == self.detail.status){
            //即将上架
            self.payBtn.enabled = NO;
            [self.payBtn setTitle:@"即将上架" forState:UIControlStateDisabled];
        }
    }else{
        //已上架
        self.payBtn.enabled = YES;
    }
    [SCREEN addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.patchView.alpha = 1;
                         self.panelBack.top = SCREEN_HEIGHT - self.panelBack.height;
                         CGAffineTransform transform;
                         if(IS_IPHONE_5_8 || IS_IPHONE_6_1 || IS_IPHONE_6_5){
                             transform = CGAffineTransformMakeScale(0.9, 0.9);
                         }else{
                             transform = CGAffineTransformMakeScale(0.95, 0.95);
                         }
                         self.screenshotIV.transform = transform;
                     } completion:^(BOOL finished){
                         
                     }];
}

- (void)dismiss:(ZYItemDetailSkuMenuDismissAction)finish{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.patchView.alpha = 0;
                         self.panelBack.top = SCREEN_HEIGHT;
                         self.screenshotIV.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:^(BOOL finished){
                         [self removeFromSuperview];
                         !finish ? : finish();
                     }];
}

- (void)reset{
    self.selectedSkuPrice = nil;
    self.selectedServices = nil;
    self.selectedPeriod = nil;
    self.selectedSkus = nil;
}

#pragma mark - 根据数据源刷新菜单
- (void)refreshMenu{
    for(_m_ItemDetail_SkuAttribute *sku in _detail.skuAttributeList){
        for(_m_ItemDetail_SkuAttribute_Sub *skuValue in sku.valueList){
            if(sku.isSelected){
                //如果当前一级sku已有选中的二级sku，那么该一级sku只刷新未选中的二级sku
                if([sku.selectedSkuValue isEqual:skuValue]){
                    continue;
                }
            }
            NSString *paths = nil;
            for(_m_ItemDetail_SkuAttribute *tmpSku in _detail.skuAttributeList){
                if(![sku isEqual:tmpSku]){
                    if(tmpSku.isSelected){
                        if(!paths){
                            paths = [NSString stringWithFormat:@"%@:%@",tmpSku.attributeId,tmpSku.selectedSkuValue.valueId];
                        }else{
                            paths = [paths stringByAppendingString:[NSString stringWithFormat:@";%@:%@",tmpSku.attributeId,tmpSku.selectedSkuValue.valueId]];
                        }
                    }
                }else{
                    if(!paths){
                        paths = [NSString stringWithFormat:@"%@:%@",tmpSku.attributeId,skuValue.valueId];
                    }else{
                        paths = [paths stringByAppendingString:[NSString stringWithFormat:@";%@:%@",tmpSku.attributeId,skuValue.valueId]];
                    }
                }
            }
            if(paths && [_skuStorages objectForKey:paths]){
                skuValue.hasStorage = YES;
            }else{
                skuValue.hasStorage = NO;
            }
        }
    }
}

#pragma mark - 查找价格
- (void)checkPrice{
    
    _selectedSkus = nil;
    _selectedPeriod = nil;
    _selectedSkuPrice = nil;
    
    NSString *paths = nil;
    //sku
    NSMutableArray *skus = [NSMutableArray array];
    for(_m_ItemDetail_SkuAttribute *sku in _detail.skuAttributeList){
        if(!sku.isSelected){
            self.priceLab.hidden = YES;
            return;
        }
        if(!paths){
            paths = [NSString stringWithFormat:@"%@:%@",sku.attributeId,sku.selectedSkuValue.valueId];
        }else{
            paths = [paths stringByAppendingString:[NSString stringWithFormat:@";%@:%@",sku.attributeId,sku.selectedSkuValue.valueId]];
        }
        [skus addObject:sku.selectedSkuValue];
    }
    _selectedSkus = skus;
    
    //租期
    if(!_detail.rentPeriod.isSelected){
        self.priceLab.hidden = YES;
        return;
    }
    if(!paths){
        paths = [NSString stringWithFormat:@"%@:%@",_detail.rentPeriod.attributeId,_detail.rentPeriod.selectedSkuValue.valueId];
    }else{
        paths = [paths stringByAppendingString:[NSString stringWithFormat:@";%@:%@",_detail.rentPeriod.attributeId,_detail.rentPeriod.selectedSkuValue.valueId]];
    }
    _selectedPeriod = _detail.rentPeriod.selectedSkuValue;
    
    //价格
    for(_m_ItemDetail_SkuPrice *price in _detail.skuPriceList){
        if([price.path hasPrefix:paths]){
            _selectedSkuPrice = price;
            break;
        }
    }
    if(_selectedSkuPrice){
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2f/%@",_selectedSkuPrice.price,_selectedSkuPrice.unit];
        self.priceLab.hidden = NO;
    }else{
        self.priceLab.hidden = YES;
    }
}

#pragma mark - 查找增值服务
- (void)checkService{
    //增值服务
    _selectedServices = nil;
    NSMutableArray *services = [NSMutableArray array];
    for(_m_ItemDetail_Service *service in _detail.serviceList){
        if(service.isSelected || service.isRequired){
            [services addObject:service];
        }
    }
    _selectedServices = services;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        _m_ItemDetail_SkuAttribute *model = _detail.skuAttributeList[indexPath.row];
        return [ZYItemDetailSkuMenuCell heightForCellWithModel:model];
    }
    if(1 == indexPath.section){
        return [ZYItemDetailSkuMenuCell heightForCellWithModel:_detail.rentPeriod];
    }
    _m_ItemDetail_Service *model = _detail.serviceList[indexPath.row];
    return [ZYItemDetailSkuMenuServiceCell heightForCellWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(2 == section){
        return 50 * UI_H_SCALE;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(2 == section){
        UIView *header = [UIView new];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *titleLab = [UILabel new];
        titleLab.textColor = WORD_COLOR_BLACK;
        titleLab.font = FONT(14);
        titleLab.text = @"增值服务";
        [header addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(header);
        }];
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(2 == indexPath.section){
        _m_ItemDetail_Service *model = _detail.serviceList[indexPath.row];
        if(!model.isRequired){
            ZYItemDetailSkuMenuServiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.isSelected = !cell.isSelected;
        }
        [self checkService];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return _detail.skuAttributeList.count;
    }
    if(1 == section){
        return 1;
    }
    return _detail.serviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    if(0 == indexPath.section){
        static NSString * identifier = @"ZYItemDetailSkuMenuCell";
        ZYItemDetailSkuMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemDetailSkuMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        _m_ItemDetail_SkuAttribute *model = _detail.skuAttributeList[indexPath.row];
        [cell showCellWithModel:model isPeriod:NO];
        cell.selectionBlock = ^(_m_ItemDetail_SkuAttribute *sku, _m_ItemDetail_SkuAttribute_Sub *skuValue) {
            if(skuValue){
                //选中某项
                sku.isSelected = YES;
                sku.selectedSkuValue = skuValue;
            }else{
                //取消选中某项
                sku.isSelected = NO;
                sku.selectedSkuValue = nil;
            }
            //刷新菜单
            [weakSelf refreshMenu];
            NSArray *cells = [weakSelf.tableView visibleCells];
            for(UITableViewCell *cell in cells){
                if([weakSelf.tableView indexPathForCell:cell].section == 0){
                    ZYItemDetailSkuMenuCell *tmpCell = (ZYItemDetailSkuMenuCell *)cell;
                    [tmpCell refreshCell];
                }
            }
            
            [weakSelf checkPrice];
        };
        
        return cell;
    }
    if(1 == indexPath.section){
        static NSString * identifier = @"ZYItemDetailSkuMenuPeriodCell";
        ZYItemDetailSkuMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemDetailSkuMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell showCellWithModel:_detail.rentPeriod isPeriod:YES];
        cell.selectionBlock = ^(_m_ItemDetail_SkuAttribute *period, _m_ItemDetail_SkuAttribute_Sub *skuValue) {
            if(skuValue){
                //选中某项
                period.isSelected = YES;
                period.selectedSkuValue = skuValue;
            }else{
                //取消选中某项
                period.isSelected = NO;
                period.selectedSkuValue = nil;
            }
            [weakSelf checkPrice];
        };
        
        return cell;
    }
    static NSString * identifier = @"ZYItemDetailSkuMenuServiceCell";
    ZYItemDetailSkuMenuServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYItemDetailSkuMenuServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    _m_ItemDetail_Service *model = _detail.serviceList[indexPath.row];
    [cell showCellWithModel:model];
    [cell.agreementBtn clickAction:^(UIButton * _Nonnull button) {
        [weakSelf dismiss:^{
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeItemServiceAgreement param:model.valueServiceId] URLEncode]]];
        }];
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!_detail.serviceList.count){
        return 2;
    }
    return 3;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view.tag == 100){
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = [UIColor whiteColor];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_item_detail_menu_close_btn"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_item_detail_menu_close_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
            !weakSelf.selectionAction ? : weakSelf.selectionAction(weakSelf.selectedSkus,
                                                                   weakSelf.selectedPeriod,
                                                                   weakSelf.selectedServices,
                                                                   weakSelf.selectedSkuPrice);
        }];
    }
    return _closeBtn;
}

- (UIImageView *)screenshotIV{
    if(!_screenshotIV){
        _screenshotIV = [UIImageView new];
        _screenshotIV.backgroundColor = [UIColor clearColor];
    }
    return _screenshotIV;
}

- (UIView *)patchView{
    if(!_patchView){
        _patchView = [[UIView alloc] init];
        _patchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _patchView.tag = 100;
        
        __weak __typeof__(self) weakSelf = self;
        [_patchView tapped:^(UITapGestureRecognizer * _Nonnull gesture) {
            !weakSelf.selectionAction ? : weakSelf.selectionAction(weakSelf.selectedSkus,
                                                                   weakSelf.selectedPeriod,
                                                                   weakSelf.selectedServices,
                                                                   weakSelf.selectedSkuPrice);
            [weakSelf dismiss:nil];
        } delegate:self];
    }
    return _patchView;
}

- (UIView *)panelBack{
    if(!_panelBack){
        _panelBack = [UIView new];
        _panelBack.backgroundColor = [UIColor clearColor];
    }
    return _panelBack;
}

- (UIView *)panelView{
    if(!_panelView){
        _panelView = [UIView new];
        _panelView.backgroundColor = [UIColor whiteColor];
    }
    return _panelView;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.borderColor = HexRGB(0xE8EAED);
        _iconIV.borderWidth = LINE_HEIGHT;
        _iconIV.backgroundColor = [UIColor whiteColor];
        _iconIV.clipsToBounds = YES;
    }
    return _iconIV;
}

- (UIView *)toolBar{
    if(!_toolBar){
        _toolBar = [UIView new];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UIView *)toolBarBack{
    if(!_toolBarBack){
        _toolBarBack = [UIView new];
        _toolBarBack.backgroundColor = [UIColor whiteColor];
        _toolBarBack.layer.shadowColor = [UIColor blackColor].CGColor;
        _toolBarBack.layer.shadowOpacity = 0.05;
        _toolBarBack.layer.shadowOffset = CGSizeMake(0, -1);
    }
    return _toolBarBack;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = MEDIUM_FONT(18);
        _priceLab.hidden = YES;
    }
    return _priceLab;
}

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        _payBtn.font = FONT(18);
        [_payBtn setTitle:@"立即租" forState:UIControlStateNormal];
        [_payBtn setTitle:@"立即租" forState:UIControlStateHighlighted];
        _payBtn.shouldAnimate = NO;
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_payBtn setTitleColor:WORD_COLOR_GRAY_AB forState:UIControlStateDisabled];
        [_payBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_payBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        
        __weak __typeof__(self) weakSelf = self;
        [_payBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"item_rent"];
            !weakSelf.selectionAction ? : weakSelf.selectionAction(weakSelf.selectedSkus,
                                                                   weakSelf.selectedPeriod,
                                                                   weakSelf.selectedServices,
                                                                   weakSelf.selectedSkuPrice);
            !weakSelf.rentAction ? : weakSelf.rentAction();
        }];
    }
    return _payBtn;
}

- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
