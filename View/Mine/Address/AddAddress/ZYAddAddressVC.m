//
//  ZYAddAddressVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddAddressVC.h"
#import "ZYAddAddressView.h"
#import "ZYAddAddressCell.h"
#import "ZYCitySelector.h"
#import "AddressInsert.h"
#import "AddressDetail.h"

@interface ZYAddAddressVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYAddAddressView *baseView;
@property (nonatomic , strong) NSArray *titles;
@property (nonatomic , strong) ZYCitySelector *citySelector;

@property (nonatomic , strong) _m_AreaDropDown *selectedProvince;
@property (nonatomic , strong) _m_AreaDropDown *selectedCity;
@property (nonatomic , strong) _m_AreaDropDown *selectedDistinct;

@property (nonatomic , assign) BOOL isDefault;

@property (nonatomic , copy) NSString *addressId; //地址id，用于修改地址
@property (nonatomic , strong) _m_AddressDetail *detail; //地址id，用于修改地址

@end

@implementation ZYAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.successBlock = self.callBack;
    
    _addressId = self.dicParam[@"addressId"];
    if(_addressId){
        [self showLoadingView];
        [self loadDetail:NO];
        self.title = @"编辑收货地址";
    }else{
        self.title = @"添加收货地址";
    }
}

#pragma mark - 获取地址详情
- (void)loadDetail:(BOOL)showHud{
    self.baseView.tableView.userInteractionEnabled = NO;
    _p_AddressDetail *param = [_p_AddressDetail new];
    param.addressId = _addressId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.detail = [[_m_AddressDetail alloc] initWithDictionary:responseObj.data];
                                self.baseView.receiverText.text = self.detail.contact;
                                self.baseView.mobileText.text = self.detail.mobile;
                                
                                if(![NSString isBlank:self.detail.provinceCode]){
                                    _m_AreaDropDown *province = [_m_AreaDropDown new];
                                    province.addressId = self.detail.provinceCode;
                                    province.addressName = self.detail.provinceName;
                                    self.selectedProvince = province;
                                }
                                
                                if(![NSString isBlank:self.detail.cityCode]){
                                    _m_AreaDropDown *city = [_m_AreaDropDown new];
                                    city.addressId = self.detail.cityCode;
                                    city.addressName = self.detail.cityName;
                                    self.selectedCity = city;
                                }
                                
                                if(![NSString isBlank:self.detail.districtCode]){
                                    _m_AreaDropDown *district = [_m_AreaDropDown new];
                                    district.addressId = self.detail.districtCode;
                                    district.addressName = self.detail.districtName;
                                    self.selectedDistinct = district;
                                }
                                
                                self.baseView.addressText.text = self.detail.address;
                                self.isDefault = self.detail.isDefault;
                                
                                [self.baseView.tableView reloadData];
                                self.baseView.tableView.userInteractionEnabled = YES;
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            __weak __typeof__(self) weakSelf = self;
                            if(self.detail){
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

#pragma mark - 保存地址
- (void)saveAddress{
    NSString *reveiver = self.baseView.receiverText.text;
    NSString *mobile = self.baseView.mobileText.text;
    NSString *address = self.baseView.addressText.text;
    NSString *isDefault = _isDefault ? @"1" : @"0";
    
    if([NSString isBlank:reveiver]){
        [ZYToast showWithTitle:@"请填写收货人姓名！"];
        return;
    }
    if([NSString isBlank:mobile] || ![mobile isTelNumber]){
        [ZYToast showWithTitle:@"请填写正确的手机号码！"];
        return;
    }
    if([NSString isBlank:address]){
        [ZYToast showWithTitle:@"请填写详细地址！"];
        return;
    }
    if(!_selectedProvince || !_selectedCity || !_selectedDistinct){
        [ZYToast showWithTitle:@"请选择省市区！"];
        return;
    }
    
    _p_AddressInsert *param = [_p_AddressInsert new];
    param.addressId = _detail.addressId;
    param.contact = reveiver;
    param.mobile = mobile;
    param.provinceCode = _selectedProvince.addressId;
    param.cityCode = _selectedCity.addressId;
    param.districtCode = _selectedDistinct.addressId;
    param.address = address;
    param.isDefault = isDefault;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [ZYToast showWithTitle:@"收货地址保存成功！"];
                                [self.navigationController popViewControllerAnimated:YES];
                                !self.successBlock ? : self.successBlock();
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }
                        } authFail:nil];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.baseView resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 3){
        return 98 * UI_H_SCALE;
    }
    return ZYAddAddressCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(1 == section){
        return 89 * UI_H_SCALE;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(1 == section){
        return self.baseView.footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.baseView resignFirstResponder];
    
    if(indexPath.section == 0 && indexPath.row == 2){
        [self.citySelector show];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYAddressManageVCCell";
    ZYAddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYAddAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(indexPath.section == 0 && indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.showArrow = YES;
        cell.contentLab.hidden = NO;
        cell.contentLab.text = @"请选择";
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showArrow = NO;
        cell.contentLab.hidden = YES;
    }
    if(indexPath.section == 1){
        cell.defaultWitch.hidden = NO;
    }else{
        cell.defaultWitch.hidden = YES;
    }
    cell.titleLab.text = self.titles[indexPath.section][indexPath.row];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        [cell.contentView addSubview:self.baseView.receiverText];
        [self.baseView.receiverText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.equalTo(cell.contentView).mas_offset(115 * UI_H_SCALE);
        }];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        [cell.contentView addSubview:self.baseView.mobileText];
        [self.baseView.mobileText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).mas_offset(-15 * UI_H_SCALE);
            make.left.equalTo(cell.contentView).mas_offset(115 * UI_H_SCALE);
        }];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        if(_selectedProvince && _selectedCity && _selectedDistinct){
            cell.contentLab.text = [NSString stringWithFormat:@"%@ %@ %@",_selectedProvince.addressName,_selectedCity.addressName,_selectedDistinct.addressName];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else{
            cell.contentLab.text = @"请选择";
            cell.contentLab.textColor = WORD_COLOR_GRAY;
        }
    }else if(indexPath.section == 0 && indexPath.row == 3){
        [cell.contentView addSubview:self.baseView.addressText];
        [self.baseView.addressText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView);
            make.top.equalTo(cell.separator.mas_bottom);
            make.right.equalTo(cell.contentView).mas_offset(-15 * UI_H_SCALE + 10);
            make.left.equalTo(cell.contentView).mas_offset(15 * UI_H_SCALE - 10);
        }];
    }else if(indexPath.section == 1){
        cell.defaultWitch.on = _isDefault;
        [cell.defaultWitch removeTarget:self
                                 action:@selector(defaultSwitchAction)
                       forControlEvents:UIControlEventValueChanged];
        [cell.defaultWitch addTarget:self
                              action:@selector(defaultSwitchAction)
                    forControlEvents:UIControlEventValueChanged];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - switch事件
- (void)defaultSwitchAction{
    _isDefault = !_isDefault;
//    [self.baseView.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
//                                   withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - getter
- (ZYAddAddressView *)baseView{
    if(!_baseView){
        _baseView = [ZYAddAddressView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.saveBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf saveAddress];
        }];
    }
    return _baseView;
}

- (NSArray *)titles{
    if(!_titles){
        _titles = @[@[@"收货人",@"手机号码",@"省市区",@""],@[@"设为默认地址"]];
    }
    return _titles;
}

- (ZYCitySelector *)citySelector{
    if(!_citySelector){
        _citySelector = [ZYCitySelector new];
        
        __weak __typeof__(self) weakSelf = self;
        _citySelector.confirmAction = ^(_m_AreaDropDown *province, _m_AreaDropDown *city, _m_AreaDropDown *distinct) {
            weakSelf.selectedProvince = province;
            weakSelf.selectedCity = city;
            weakSelf.selectedDistinct = distinct;
            [weakSelf.baseView.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    return _citySelector;
}

@end
