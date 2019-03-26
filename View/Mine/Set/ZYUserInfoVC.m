//
//  ZYUserInfoVC.m
//  Apollo
//
//  Created by shaxia on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserInfoVC.h"
#import "ZYUserInfoCell.h"

#import "PortraitUpdate.h"
#import "ZYUploadImage.h"

static NSString * const ZYUSERINFOCELLID = @"ZYUSERINFOCELLID";

@interface ZYUserInfoVC () <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic , strong) ZYTableView  *tableView;

@end

@implementation ZYUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self.view setBackgroundColor:VIEW_COLOR];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - getter

-(ZYTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) style:(UITableViewStyleGrouped)];
        [_tableView setBackgroundColor:VIEW_COLOR];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[ZYUserInfoCell class] forCellReuseIdentifier:ZYUSERINFOCELLID];
    }
    return _tableView;
}

#pragma mark - tabelView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYUSERINFOCELLID forIndexPath:indexPath];
    NSString *avtor = ![ZYUser user].portraitPath? @"" : [ZYUser user].portraitPath;
    NSString *nickName = ![ZYUser user].nickname? @"" : [ZYUser user].nickname;
    NSString *moblie = ![ZYUser user].mobile? @"" : [ZYUser user].mobile;
    
    if (0 == indexPath.section) {
        cell.avtor = avtor;
    } else if(1 == indexPath.section){
        cell.nickname = nickName;
    } else {
        cell.mobile = moblie;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak __typeof__(self) weakSelf = self;
    if (0 == indexPath.section) {
        ZYSheetMenu *menu = [ZYSheetMenu new];
        menu.dateArr = @[@"从手机中选择",@"拍摄照片"];
        [menu selectionAction:^(NSUInteger index) {
            if(0 == index){
                [weakSelf callAlbum];
            }else{
                [weakSelf callCamera];
            }
        }];
        [menu show];
        
    } else if(1 == indexPath. section){
        [[ZYRouter router] goVC:@"ZYEditNickNameVC" withCallBack:^{
            [self.tableView reloadData];
        }];
    } else {
        
    }
}

#pragma mark - callCamera
- (void)callCamera{
    __weak __typeof__(self) weakSelf = self;
    [[ZYPhotoUtils utils] callCamera:self editable:YES callback:^(UIImage *image) {
        [weakSelf uploadImg:image];
    } dismissCallback:nil];
}

#pragma mark - callAlbum
- (void)callAlbum{
    __weak __typeof__(self) weakSelf = self;
    [[ZYPhotoUtils utils] callAlbum:self editable:YES callback:^(UIImage *image) {
        [weakSelf uploadImg:image];
    } dismissCallback:nil];
}

#pragma mark - 上传图像
- (void)uploadImg:(UIImage *)image{
    if(image){
        
        //把图片转成NSData类型的数据来保存文件
        
        NSData *data=UIImageJPEGRepresentation(image, 0.3);
        
        _p_ZYUploadImage *parm = [[_p_ZYUploadImage alloc] init];
        
        parm.scene = @"user/headerimg";
        
        [[ZYHttpClient client] upload:parm showHUD:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"uploadFile"
                                    fileName:[NSString stringWithFormat:@"%lld.jpeg",[[NSDate date] millisecondSince1970]]
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
            
            if(responseObj.success){
                
                _m_ZYUploadImage *model = [_m_ZYUploadImage mj_objectWithKeyValues:responseObj.data];
                [self portraitUpdateWith:model.url];
                
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
}

#pragma mark - PortraitUpdate

- (void)portraitUpdateWith:(NSString *)portraitPath
{
    _p_PortraitUpdate *params = [[_p_PortraitUpdate alloc] init];
    params.portraitPath = portraitPath;
    [[ZYHttpClient client] post:params showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            [ZYToast showWithTitle:@"更换头像成功！"];
            
            ZYUser *user = [ZYUser user];
            user.portraitPath = portraitPath;
            [user save];
            
            [self.tableView reloadData];
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

@end
