//
//  ZYMallVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallVC.h"
#import "ZYMallView.h"
#import "ZYMallTemplate0.h"
#import "ZYMallTemplate1.h"
#import "ZYMallTemplate2.h"
#import "ZYMallTemplate3.h"
#import "ZYMallTemplate4.h"
#import "ZYMallTemplate5.h"
#import "ZYMallTemplate6.h"
#import "AppModuleList.h"
#import "UnRead.h"
#import "QYSDK.h"
#import "ZYMallTitleView.h"
#import "ZYMallTemplateDB.h"

@interface ZYMallVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYMallView *baseView;
@property (nonatomic , strong) ZYMallTitleView *titleView;
@property (nonatomic , strong) NSMutableArray *modules;

@end

@implementation ZYMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBarItems = @[[UIImage imageNamed:@"zy_service_normal"]];
    self.view = self.baseView;
    self.navigationItem.titleView = self.titleView;
    
    self.modules = [ZYMallTemplateDB getTemplates];
    if(!self.modules.count){
        [self showLoadingView];
    }else{
        [self.baseView.tableView reloadData];
    }
    [self loadData:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //客服消息有无未读
    if([[QYSDK sharedSDK] conversationManager].allUnreadCount > 0){
        self.rightBarItems = @[[UIImage imageNamed:@"zy_service_unread"]];
    }else{
        self.rightBarItems = @[[UIImage imageNamed:@"zy_service_normal"]];
    }
}

- (void)rightBarItemsAction:(int)index{
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&swipeToBack=0&alwaysBounceVertical=0&alwaysBounceHorizontal=0",
                                      [[ZYH5Utils formatUrl:ZYH5TypeHelp param:nil] URLEncode]]];
}

#pragma mark - 加载是否有未读消息
- (void)loadIsUnreadMessage{
    _p_UnRead *param = [_p_UnRead new];
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.success){
                                _m_UnRead *model = [[_m_UnRead alloc] initWithDictionary:responseObj.data];
                                if(model.unRead){
                                    self.rightBarItems = @[[UIImage imageNamed:@"zy_service_unread"]];
                                }else{
                                    self.rightBarItems = @[[UIImage imageNamed:@"zy_service_normal"]];
                                }
                            }
                        }
                        failure:nil
                       authFail:nil];
}

#pragma mark - 获取模板列表
- (void)loadData:(BOOL)showHud{
    _p_AppModuleList *param = [_p_AppModuleList new];
    param.pagePosition = @"1";
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            if(responseObj.isSuccess){
                                //存入本地数据库
                                [ZYMallTemplateDB saveTemplates:responseObj.data];
                                
                                [self.modules removeAllObjects];
                                NSArray *arr = responseObj.data;
                                for(NSDictionary *dic in arr){
                                    _m_AppModuleList *model = [[_m_AppModuleList alloc] initWithDictionary:dic];
                                    [self.modules addObject:model];
                                }
                                [self.baseView.tableView reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            __weak __typeof__(self) weakSelf = self;
                            if(self.modules.count){
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
                                        [weakSelf loadData:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_AppModuleList *model = self.modules[indexPath.section];
    if(model.templateStyle == ZYMallTemplateStyleBanner){
        static NSString *identifier = @"ZYMallVCTemplate0";
        ZYMallTemplate0 *cell = (ZYMallTemplate0 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    if(model.templateStyle == ZYMallTemplateStyleClassify){
        static NSString *identifier = @"ZYMallVCTemplate1";
        ZYMallTemplate1 *cell = (ZYMallTemplate1 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    if(model.templateStyle == ZYMallTemplateStyleHot){
        static NSString *identifier = @"ZYMallVCTemplate2";
        ZYMallTemplate2 *cell = (ZYMallTemplate2 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    if(model.templateStyle == ZYMallTemplateStyleContent){
        static NSString *identifier = @"ZYMallVCTemplate3";
        ZYMallTemplate3 *cell = (ZYMallTemplate3 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    if(model.templateStyle == ZYMallTemplateStyleSpecial){
        static NSString *identifier = @"ZYMallVCTemplate4";
        ZYMallTemplate4 *cell = (ZYMallTemplate4 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    if(model.templateStyle == ZYMallTemplateStyleTiny){
        static NSString *identifier = @"ZYMallVCTemplate5";
        ZYMallTemplate5 *cell = (ZYMallTemplate5 *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYMallTemplate5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:model];
        cell.action = ^(NSString *url) {
            [[ZYRouter router] go:url];
        };
        return cell;
    }
    //ZYMallTemplateStyleEvent
    static NSString *identifier = @"ZYMallVCTemplate6";
    ZYMallTemplate6 *cell = (ZYMallTemplate6 *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYMallTemplate6 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell showCellWithModel:model];
    cell.action = ^(NSString *url) {
        [[ZYRouter router] go:url];
    };
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modules.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([cell isKindOfClass:[ZYMallTemplate6 class]]){
        ZYMallTemplate6 *c = (ZYMallTemplate6 *)cell;
        [c beginScroll];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if([cell isKindOfClass:[ZYMallTemplate6 class]]){
        ZYMallTemplate6 *c = (ZYMallTemplate6 *)cell;
        [c pauseScroll];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_AppModuleList *model = self.modules[indexPath.section];
    if(model.templateStyle == ZYMallTemplateStyleBanner){
        return ZYMallTemplate0Height;
    }
    if(model.templateStyle == ZYMallTemplateStyleClassify){
        return ZYMallTemplate1Height;
    }
    if(model.templateStyle == ZYMallTemplateStyleHot){
        return ZYMallTemplate2Height;
    }
    if(model.templateStyle == ZYMallTemplateStyleContent){
        return ZYMallTemplate3Height;
    }
    if(model.templateStyle == ZYMallTemplateStyleSpecial){
        return ZYMallTemplate4Height;
    }
    if(model.templateStyle == ZYMallTemplateStyleTiny){
        return ZYMallTemplate5Height;
    }
    //ZYMallTemplateStyleEvent
    return ZYMallTemplate6Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.modules.count - 1){
        return 0.01;
    }
    _m_AppModuleList *model = self.modules[section];
    if(model.templateStyle == ZYMallTemplateStyleHot ||
       model.templateStyle == ZYMallTemplateStyleSpecial ||
       model.templateStyle == ZYMallTemplateStyleContent){
        return 10 * UI_H_SCALE;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [UIView new];
    footer.backgroundColor = VIEW_COLOR;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - getter
- (ZYMallView *)baseView{
    if(!_baseView){
        _baseView = [ZYMallView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            [weakSelf loadData:NO];
        }];
    }
    return _baseView;
}

- (ZYMallTitleView *)titleView{
    if(!_titleView){
        _titleView = [ZYMallTitleView new];
        [_titleView.searchBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:@"ZYMallSearchVC"];
        }];
    }
    return _titleView;
}

- (NSMutableArray *)modules{
    if(!_modules){
        _modules = [NSMutableArray array];
    }
    return _modules;
}

@end
