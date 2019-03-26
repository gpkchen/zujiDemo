//
//  ZYAddContactVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddContactVC.h"
#import "ZYAddContactView.h"
#import "ZYAddContactCell.h"
#import "ZYAddContactFooter.h"
#import "UrgentAdd.h"

@interface ZYAddContactVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic , strong) ZYAddContactView *baseView;
@property (nonatomic , strong) ZYAddContactFooter *footer;

@end

@implementation ZYAddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"添加紧急联系人";
    
    if(!_contactName){
        _contactName = self.dicParam[@"contactName"];
    }
    if(!_contactMobile){
        _contactMobile = self.dicParam[@"contactMobile"];
    }
}

#pragma mark - 保存紧急联系人
- (void)save{
    if ([NSString isBlank:self.contactName]) {
        [ZYToast showWithTitle:@"请输入紧急联系人姓名!"];
        return;
    }
    if ([NSString isBlank:self.contactMobile]) {
        [ZYToast showWithTitle:@"请输入紧急联系人手机号!"];
        return;
    }
    NSString *type = nil;
    if(self.footer.leftBtn.isSelected){
        type = @"1";
    }else if(self.footer.midBtn.isSelected){
        type = @"2";
    }else if(self.footer.rightBtn.isSelected){
        type = @"3";
    }
    if (!type) {
        [ZYToast showWithTitle:@"请选择与紧急联系人关系!"];
        return;
    }
    _p_UrgentAdd *param = [[_p_UrgentAdd alloc] init];
    param.urgentName = self.contactName;
    param.urgentMobile = self.contactMobile;
    param.urgentRelation = type;
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            [self systemBackButtonClicked];
            [ZYToast showWithTitle:@"紧急联系人添加成功！"];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYAddContactVCCell";
    ZYAddContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYAddContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.separator.hidden = indexPath.row == 0;
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.row + 100;
    if (0 == indexPath.row) {
        [cell.leftLabel setText:@"紧急联系人姓名"];
        [cell.textView setText:self.contactName];
        cell.textView.enabled = YES;
        cell.textView.keyboardType =  UIKeyboardTypeDefault;
    } else if (1 == indexPath.row){
        [cell.leftLabel setText:@"紧急联系人号码"];
        [cell.textView setText:self.contactMobile];
        cell.textView.enabled = YES;
        cell.textView.keyboardType =  UIKeyboardTypePhonePad;
    } else {
        [cell.leftLabel setText:@"与紧急联系人关系"];
        cell.textView.enabled = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.baseView endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYAddContactCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ZYContactFooterHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.baseView endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (100 == textField.tag) {//姓名
        self.contactName = textField.text;
    } else {//手机号
        self.contactMobile = textField.text;
    }
}

#pragma mark - getter
- (ZYAddContactView *)baseView{
    if(!_baseView){
        _baseView = [ZYAddContactView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYAddContactFooter *)footer{
    if(!_footer){
        _footer = [ZYAddContactFooter new];
        
        __weak __typeof__(self) weakSelf = self;
        [_footer.confirmBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf save];
        }];
    }
    return _footer;
}

@end
