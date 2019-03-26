//
//  ZYMineHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMineHeader.h"
#import "UILabel+FlickerNumber.h"

@interface ZYMineHeader()

@property (nonatomic , strong) UIImageView *userCenterArrow; //个人中心箭头
@property (nonatomic , strong) UIImageView *quotaBack; //额度背景
@property (nonatomic , strong) UILabel *amountTitleLab; //额度标题
@property (nonatomic , strong) UILabel *amountLab; //额度
@property (nonatomic , strong) UILabel *noticeLab; //提示
@property (nonatomic , strong) UILabel *tmpQuotaLab;
@property (nonatomic , strong) UILabel *orderTitleLab; //订单标题
@property (nonatomic , strong) UIImageView *allOrderArrow; //全部订单箭头
@property (nonatomic , strong) UIView *line; //分割线
@property (nonatomic , strong) UIView *bottomView;

@property (nonatomic , strong) NSArray *orderBtnIcons;
@property (nonatomic , strong) NSArray *orderBtnTitles;
@property (nonatomic , strong) NSArray *orderBtnStates;

@end

@implementation ZYMineHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.nicknameLab];
        [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(73.5 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
        }];
        
        [self addSubview:self.userCenterLab];
        [self.userCenterLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLab);
            make.centerY.equalTo(self.mas_top).mas_offset(102 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
        }];
        
        [self addSubview:self.userCenterArrow];
        [self.userCenterArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userCenterLab);
            make.left.equalTo(self.userCenterLab.mas_right).mas_offset(4);
        }];
        
        [self addSubview:self.portrait];
        [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60 * UI_H_SCALE, 60 * UI_H_SCALE));
            make.top.equalTo(self.mas_top).mas_offset(54 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self addSubview:self.quotaBack];
        [self.quotaBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).mas_offset(125 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
            make.height.mas_equalTo(212 * UI_H_SCALE);
        }];
        
        [self addSubview:self.authBtn];
        [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-35 * UI_H_SCALE);
            make.top.equalTo(self.quotaBack.mas_top).mas_offset(114 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self addSubview:self.recordBtn];
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-35 * UI_H_SCALE);
            make.top.equalTo(self.quotaBack.mas_top).mas_offset(26 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 28 * UI_H_SCALE));
        }];
        
        [self addSubview:self.instructionBtn];
        [self.instructionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBtn);
            make.centerY.equalTo(self.quotaBack.mas_top).mas_offset(80 * UI_H_SCALE);
            make.size.mas_equalTo(self.instructionBtn.size);
        }];
        
        [self addSubview:self.amountTitleLab];
        [self.amountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(35 * UI_H_SCALE);
            make.centerY.equalTo(self.quotaBack.mas_top).mas_offset(40 * UI_H_SCALE);
        }];
        
        [self addSubview:self.amountLab];
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(35 * UI_H_SCALE);
            make.centerY.equalTo(self.quotaBack.mas_top).mas_offset(72 * UI_H_SCALE);
        }];
        
        [self addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_equalTo(35 * UI_H_SCALE);
            make.centerY.equalTo(self.quotaBack.mas_top).mas_offset(131.5 * UI_H_SCALE);
        }];
        
        [self addSubview:self.tmpQuotaLab];
        [self.tmpQuotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noticeLab);
            make.top.equalTo(self.noticeLab.mas_bottom);
        }];
        
        [self addSubview:self.quotaHelpBtn];
        [self.quotaHelpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noticeLab.mas_right);
            make.centerY.equalTo(self.noticeLab);
            make.size.mas_equalTo(self.quotaHelpBtn.size);
        }];
        
        [self addSubview:self.orderTitleLab];
        [self.orderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.quotaBack.mas_bottom).mas_offset(14.5 * UI_H_SCALE);
        }];
        
        [self addSubview:self.allOrderArrow];
        [self.allOrderArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.orderTitleLab);
        }];
        
        [self addSubview:self.allOrderLab];
        [self.allOrderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.allOrderArrow.mas_left).mas_offset(-8 * UI_H_SCALE);
            make.centerY.equalTo(self.allOrderArrow);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.quotaBack.mas_bottom).mas_offset(43 * UI_H_SCALE);
            make.height.mas_equalTo(1);
        }];
        
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(10 * UI_H_SCALE);
        }];
        
        CGFloat btnWidth = SCREEN_WIDTH / 5.0;
        for(int i=0;i<self.orderBtnTitles.count;++i){
            ZYMineOrderBtn *btn = [ZYMineOrderBtn new];
            btn.icon = self.orderBtnIcons[i];
            btn.title = self.orderBtnTitles[i];
            NSNumber *state = self.orderBtnStates[i];
            btn.orderState = state.intValue;
            [self addSubview:btn];
            [self.orderBtns addObject:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).mas_offset(i * btnWidth);
                make.top.equalTo(self.line.mas_bottom);
                make.bottom.equalTo(self.bottomView.mas_top);
                make.width.mas_equalTo(btnWidth);
            }];
        }
    }
    return self;
}

#pragma mark - setter
- (void)setMineInfo:(_m_GetMyHomeInfo *)mineInfo{
    _mineInfo = mineInfo;
    
    if(!mineInfo){
        self.nicknameLab.text = @"登录／注册";
        self.portrait.image = [UIImage imageNamed:@"zy_mine_userIcon_notLogin"];
        
        for(ZYMineOrderBtn *btn in self.orderBtns){
            btn.num = 0;
        }
        return;
    }
    
    self.nicknameLab.text = mineInfo.nickName;
    NSString *url = [mineInfo.portraitPath imageStyleUrl:CGSizeMake(120*UI_H_SCALE, 120*UI_H_SCALE)];
    [self.portrait loadImage:url placeholder:[UIImage imageNamed:@"zy_mine_userIcon_default"]];
    for(_m_GetMyHomeInfo_maps *map in mineInfo.maps){
        switch (map.status) {
            case ZYOrderStateWaitPay:{
                ZYMineOrderBtn *btn = self.orderBtns[0];
                btn.num = map.num;
            }
                break;
            case ZYOrderStateWaitDeliver:{
                ZYMineOrderBtn *btn = self.orderBtns[1];
                btn.num = map.num;
            }
                break;
            case ZYOrderStateWaitReceipt:{
                ZYMineOrderBtn *btn = self.orderBtns[2];
                btn.num = map.num;
            }
                break;
            case ZYOrderStateUsing:{
                ZYMineOrderBtn *btn = self.orderBtns[3];
                btn.num = map.num;
            }
                break;
            case ZYOrderStateAbnormal:{
                ZYMineOrderBtn *btn = self.orderBtns[4];
                btn.num = map.num;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)setAuthInfo:(_m_AuditStatus *)authInfo{
    _authInfo = authInfo;
    
    if(!authInfo){
        self.amountLab.text = @"0.00";
        self.noticeLab.text = @"登录认证，立享免押资格";
        [self.authBtn setTitle:@"去登录" forState:UIControlStateNormal];
        self.recordBtn.hidden = YES;
        self.tmpQuotaLab.hidden = YES;
        self.quotaHelpBtn.hidden = YES;
        return;
    }
    
    self.recordBtn.hidden = NO;
    [self.amountLab fn_setNumber:@(authInfo.limit) format:@"%.2f"];
    switch (authInfo.status) {
        case ZYAuthStateUnAuth:{
            [self.authBtn setTitle:@"去认证" forState:UIControlStateNormal];
        }
            break;
        case ZYAuthStateCanceled:{
            [self.authBtn setTitle:@"去认证" forState:UIControlStateNormal];
        }
            break;
        case ZYAuthStateAuthing:{
            [self.authBtn setTitle:@"审核中" forState:UIControlStateNormal];
        }
            break;
        case ZYAuthStateImprove:{
            [self.authBtn setTitle:@"提额中" forState:UIControlStateNormal];
        }
            break;
        case ZYAuthStateAuthed:{
            if(!authInfo.writeOperator || !authInfo.studentIdCard || (!authInfo.taoBaoSwitch && !authInfo.writeTaobao)){
                [self.authBtn setTitle:@"提升额度" forState:UIControlStateNormal];
            }else{
                [self.authBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
    
    if(authInfo.tempLimitFlag){
        NSMutableAttributedString *amount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总额度(元):%.2f",authInfo.totalLimit]];
        [amount addAttribute:NSFontAttributeName value:MEDIUM_FONT(12) range:NSMakeRange(0, 7)];
        [amount addAttribute:NSFontAttributeName value:BOLD_FONT(18) range:NSMakeRange(7, amount.length - 7)];
        self.noticeLab.attributedText = amount;
        self.tmpQuotaLab.hidden = NO;
        self.quotaHelpBtn.hidden = NO;
    }else{
        self.tmpQuotaLab.hidden = YES;
        self.quotaHelpBtn.hidden = YES;
        switch (authInfo.status) {
            case ZYAuthStateUnAuth:{
                self.noticeLab.text = @"登录成功，认证立享免押资格";
            }
                break;
            case ZYAuthStateCanceled:{
                self.noticeLab.text = @"登录成功，认证立享免押资格";
            }
                break;
            case ZYAuthStateAuthing:{
                self.noticeLab.text = @"请耐心等待审核结果";
            }
                break;
            case ZYAuthStateImprove:
            case ZYAuthStateAuthed:{
                NSMutableAttributedString *amount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总额度(元):%.2f",authInfo.totalLimit]];
                [amount addAttribute:NSFontAttributeName value:MEDIUM_FONT(12) range:NSMakeRange(0, 7)];
                [amount addAttribute:NSFontAttributeName value:BOLD_FONT(18) range:NSMakeRange(7, amount.length - 7)];
                self.noticeLab.attributedText = amount;
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - getter
- (UILabel *)nicknameLab{
    if(!_nicknameLab){
        _nicknameLab = [UILabel new];
        _nicknameLab.textColor = WORD_COLOR_BLACK;
        _nicknameLab.font = SEMIBOLD_FONT(24);
        _nicknameLab.userInteractionEnabled = YES;
        _nicknameLab.text = @"登录／注册";
    }
    return _nicknameLab;
}

- (UILabel *)userCenterLab{
    if(!_userCenterLab){
        _userCenterLab = [UILabel new];
        _userCenterLab.textColor = WORD_COLOR_BLACK;
        _userCenterLab.font = LIGHT_FONT(14);
        _userCenterLab.userInteractionEnabled = YES;
        _userCenterLab.text = @"查看个人主页";
    }
    return _userCenterLab;
}

- (UIImageView *)userCenterArrow{
    if(!_userCenterArrow){
        _userCenterArrow = [UIImageView new];
        _userCenterArrow.image = [UIImage imageNamed:@"zy_mine_user_center_arrow"];
    }
    return _userCenterArrow;
}

- (UIImageView *)portrait{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.image = [UIImage imageNamed:@"zy_mine_userIcon_notLogin"];
        _portrait.clipsToBounds = YES;
        _portrait.contentMode = UIViewContentModeScaleAspectFill;
        _portrait.userInteractionEnabled = YES;
        _portrait.cornerRadius = 30 * UI_H_SCALE;
    }
    return _portrait;
}

- (UIImageView *)quotaBack{
    if(!_quotaBack){
        _quotaBack = [UIImageView new];
        _quotaBack.image = [UIImage imageNamed:@"zy_mine_quota_back"];
    }
    return _quotaBack;
}

- (UILabel *)orderTitleLab{
    if(!_orderTitleLab){
        _orderTitleLab = [UILabel new];
        _orderTitleLab.textColor = WORD_COLOR_BLACK;
        _orderTitleLab.font = MEDIUM_FONT(18);
        _orderTitleLab.text = @"我的订单";
    }
    return _orderTitleLab;
}

- (UILabel *)allOrderLab{
    if(!_allOrderLab){
        _allOrderLab = [UILabel new];
        _allOrderLab.textColor = HexRGB(0x999999);
        _allOrderLab.font = FONT(12);
        _allOrderLab.text = @"查看全部订单";
        _allOrderLab.userInteractionEnabled = YES;
    }
    return _allOrderLab;
}

- (UIImageView *)allOrderArrow{
    if(!_allOrderArrow){
        _allOrderArrow = [UIImageView new];
        _allOrderArrow.image = [UIImage imageNamed:@"zy_mine_all_order_arrow"];
    }
    return _allOrderArrow;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = HexRGB(0xf0f0f0);
    }
    return _line;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [UIView new];
        _bottomView.backgroundColor = VIEW_COLOR;
    }
    return _bottomView;
}

- (NSMutableArray *)orderBtns{
    if(!_orderBtns){
        _orderBtns = [NSMutableArray array];
    }
    return _orderBtns;
}

- (NSArray *)orderBtnIcons{
    if(!_orderBtnIcons){
        _orderBtnIcons = @[[UIImage imageNamed:@"zy_mine_order_unpay_icon"],
                           [UIImage imageNamed:@"zy_mine_order_undelivery_icon"],
                           [UIImage imageNamed:@"zy_mine_order_unreceive_icon"],
                           [UIImage imageNamed:@"zy_mine_order_using_icon"],
                           [UIImage imageNamed:@"zy_mine_order_abnormal_icon"]];
    }
    return _orderBtnIcons;
}

- (NSArray *)orderBtnTitles{
    if(!_orderBtnTitles){
        _orderBtnTitles = @[@"待付款",@"待发货",@"待收货",@"体验中",@"异常"];
    }
    return _orderBtnTitles;
}

- (NSArray *)orderBtnStates{
    if(!_orderBtnStates){
        _orderBtnStates = @[[NSNumber numberWithInt:ZYOrderStateWaitPay],
                            [NSNumber numberWithInt:ZYOrderStateWaitDeliver],
                            [NSNumber numberWithInt:ZYOrderStateWaitReceipt],
                            [NSNumber numberWithInt:ZYOrderStateUsing],
                            [NSNumber numberWithInt:ZYOrderStateAbnormal]];
    }
    return _orderBtnStates;
}

- (ZYElasticButton *)authBtn{
    if(!_authBtn){
        _authBtn = [ZYElasticButton new];
        _authBtn.backgroundColor = UIColor.whiteColor;
        _authBtn.shouldRound = YES;
        _authBtn.font = MEDIUM_FONT(12);
        [_authBtn setTitleColor:HexRGB(0x25A1F0) forState:UIControlStateNormal];
        [_authBtn setTitleColor:HexRGB(0x25A1F0) forState:UIControlStateHighlighted];
        [_authBtn setTitle:@"去认证" forState:UIControlStateNormal];
    }
    return _authBtn;
}

- (ZYElasticButton *)recordBtn{
    if(!_recordBtn){
        _recordBtn = [ZYElasticButton new];
        _recordBtn.shouldRound = YES;
        _recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _recordBtn.font = MEDIUM_FONT(14);
        [_recordBtn setTitle:@"变更记录" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_recordBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    }
    return _recordBtn;
}

- (ZYElasticButton *)instructionBtn{
    if(!_instructionBtn){
        _instructionBtn = [ZYElasticButton new];
        _instructionBtn.backgroundColor = UIColor.clearColor;
        
        __weak __typeof__(_instructionBtn) weakBtn = _instructionBtn;
        UILabel *lab = [UILabel new];
        lab.textColor = UIColor.whiteColor;
        lab.text = @"额度说明";
        lab.font = MEDIUM_FONT(12);
        [lab sizeToFit];
        [_instructionBtn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakBtn);
            make.centerY.equalTo(weakBtn);
        }];
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"zy_mine_quota_instruction_arrow"];
        [_instructionBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakBtn);
            make.left.equalTo(lab.mas_right).mas_offset(4 * UI_H_SCALE);
        }];
        
        _instructionBtn.size = CGSizeMake(lab.width + 4 * UI_H_SCALE + iv.image.size.width, 28 * UI_H_SCALE);
    }
    return _instructionBtn;
}

- (UILabel *)amountTitleLab{
    if(!_amountTitleLab){
        _amountTitleLab = [UILabel new];
        _amountTitleLab.textColor = UIColor.whiteColor;
        _amountTitleLab.font = MEDIUM_FONT(14);
        _amountTitleLab.text = @"可用额度(元)";
    }
    return _amountTitleLab;
}

- (UILabel *)amountLab{
    if(!_amountLab){
        _amountLab = [UILabel new];
        _amountLab.textColor = UIColor.whiteColor;
        _amountLab.font = BOLD_FONT(42);
        _amountLab.text = @"0.00";
    }
    return _amountLab;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = UIColor.whiteColor;
        _noticeLab.font = MEDIUM_FONT(12);
        _noticeLab.text = @"登录认证，立享免押资格";
    }
    return _noticeLab;
}

- (UILabel *)tmpQuotaLab{
    if(!_tmpQuotaLab){
        _tmpQuotaLab = [UILabel new];
        _tmpQuotaLab.textColor = UIColor.whiteColor;
        _tmpQuotaLab.font = MEDIUM_FONT(12);
        _tmpQuotaLab.text = @"(含临时额度)";
    }
    return _tmpQuotaLab;
}

- (ZYElasticButton *)quotaHelpBtn{
    if(!_quotaHelpBtn){
        _quotaHelpBtn = [ZYElasticButton new];
        _quotaHelpBtn.backgroundColor = UIColor.clearColor;
        UIImage *img= [UIImage imageNamed:@"zy_mine_quota_help"];
        [_quotaHelpBtn setImage:img forState:UIControlStateNormal];
        [_quotaHelpBtn setImage:img forState:UIControlStateHighlighted];
        _quotaHelpBtn.size = CGSizeMake(img.size.width + 16, img.size.height + 16);
    }
    return _quotaHelpBtn;
}

@end
