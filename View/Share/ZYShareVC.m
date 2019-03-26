//
//  ZYShareVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareVC.h"
#import "ZYShareView.h"
#import "ZYShareAlert.h"
#import "ZYShareMenu.h"
#import "GetMoneyDetails.h"
#import "ZYShareCell.h"

@interface ZYShareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYShareView *baseView;

@property (nonatomic , strong) _m_GetMoneyDetails *shareinfo;



@end

@implementation ZYShareVC

- (instancetype)init{
    if(self = [super init]){
        self.navigationBarAlpha = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.navigationItem.title = @"赚佣金";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self getModel];
    [self.baseView.header.jumpLabel beginScroll];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.baseView.header.jumpLabel pauseScroll];
}

#pragma mark - getData

- (void)getModel{
    _p_GetMoneyDetails *param = [[_p_GetMoneyDetails alloc] init];
    [[ZYHttpClient client] post:param showHud:NO success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        
        if (responseObj.success) {
            
            _m_GetMoneyDetails *model = [_m_GetMoneyDetails mj_objectWithKeyValues:responseObj.data];
            
            if(model.makeJobGetMoneyUrl){
                self.baseView.footer.taskBtn.hidden = NO;
                [self.baseView.footer.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo((SCREEN_WIDTH - 40 * UI_H_SCALE) / 2.0);
                }];
            }else{
                self.baseView.footer.taskBtn.hidden = YES;
                [self.baseView.footer.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(SCREEN_WIDTH - 30 * UI_H_SCALE);
                }];
            }
            
            self.baseView.header.inviteNumLab.text = model.inviteAmount;
            self.baseView.header.inviteAmountLab.text = model.cash;
            
            NSMutableArray *titlesArr = [NSMutableArray array];
            for (int i = 0; i < model.couponHistoryList.count; i++) {
                _m_couponHistoryList_list *couponHistoryListModel = model.couponHistoryList[i];
                NSString *couponHistory = [NSString stringWithFormat:@"%@%@轻松赚取%@元现金券",couponHistoryListModel.mobile,couponHistoryListModel.time,couponHistoryListModel.amount];
                [titlesArr addObject:couponHistory];
            }
            self.baseView.header.jumpLabel.titles = [NSArray arrayWithArray:titlesArr];
            
            self.shareinfo = model;
            [self.baseView.tableView reloadData];
        } else {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shareinfo.benefitList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYShareVCCell";
    ZYShareCell *cell = (ZYShareCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    _m_GetMoneyDetails_benefit *model = self.shareinfo.benefitList[indexPath.row];
    [cell.iv loadImage:[model.imgUrl imageStyleUrl:CGSizeMake(SCREEN_WIDTH * 2, 240 * UI_H_SCALE)]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYShareCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ZYShareHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ZYShareFooterHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.baseView.header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.baseView.footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _m_GetMoneyDetails_benefit *model = self.shareinfo.benefitList[indexPath.row];
    if(model.benefitDetails.count){
        [[ZYShareAlert new] showWithModelWith:model];
    }
}

#pragma mark - 分享按钮事件
- (void)shareBtnAction{
    ZYShareMenu *menu = [ZYShareMenu new];
    menu.shareType = ZYShareTypeWeb;
    menu.icon = self.shareinfo.shareImageUrl;
    menu.title = self.shareinfo.shareTitle;
    menu.content = self.shareinfo.shareContent;
    menu.url = self.shareinfo.shareUrl;
    menu.mainTitle = @"邀请好友";
    menu.shouldStatistics = YES;
    [menu show];
}

#pragma mark - getter
- (ZYShareView *)baseView{
    if(!_baseView){
        _baseView = [ZYShareView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.footer.shareBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf shareBtnAction];
            [ZYStatisticsService event:@"share_share"];
        }];
        [_baseView.footer.taskBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",weakSelf.shareinfo.makeJobGetMoneyUrl]];
        }];
    }
    return _baseView;
}

@end
