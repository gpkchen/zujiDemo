//
//  ZYSetVC.m
//  Apollo
//
//  Created by shaxia on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSetVC.h"
#import "ZYSetView.h"
#import "ZYSetCell.h"

@interface ZYSetVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) ZYSetView *baseView;
@property (nonatomic , strong) NSArray *dataArr;

@end

@implementation ZYSetVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view = self.baseView;
    
    if(![ZYUser user].isUserLogined){
        self.baseView.logoutButton.hidden = YES;
    }else{
        self.baseView.logoutButton.hidden = NO;
    }
}

#pragma mark - override
- (void)systemBackButtonClicked{
    void (^backCallBack)(void) = self.callBack;
    !backCallBack ? : backCallBack();
    [super systemBackButtonClicked];
}

#pragma mark - tabelView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYSetVCCell";
    ZYSetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.pullY = self.baseView.tableView.contentOffset.y + self.baseView.tableView.scrollIndicatorInsets.top;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0 == indexPath.row){
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                          [[ZYH5Utils formatUrl:ZYH5TypeAbout param:nil] URLEncode]]];
    }else if(1 == indexPath.row){
        NSString *url = [[ZYEnvirUtils utils].webPrefix stringByAppendingString:@"privacy-policy"];
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",[url URLEncode]]];
    }else if(2 == indexPath.row){
        [ZYAppUtils openURL:ApolloAppUrl];
    }
}

#pragma mark - getter
- (ZYSetView *)baseView{
    if (!_baseView) {
        _baseView = [ZYSetView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.logoutButton clickAction:^(UIButton * _Nonnull button) {
            [ZYAlert showWithTitle:nil
                           content:@"确定要退出吗？"
                      buttonTitles:@[@"取消", @"确定"]
                      buttonAction:^(ZYAlert *alert, int index) {
                          if(1 == index){
                              [alert dismiss];
                              [[ZYLoginService service] logout:^{
                                  [weakSelf systemBackButtonClicked];
                              }];
                          } else {
                              [alert dismiss];
                          }
                      }];
        }];
    }
    return _baseView;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"关于我们",@"subTitle":@""},
                     @{@"title":@"隐私政策",@"subTitle":@""},
                     @{@"title":@"当前版本",@"subTitle":[NSString stringWithFormat:@"V%@",APP_VERSION]},];
    }
    return _dataArr;
}

@end
