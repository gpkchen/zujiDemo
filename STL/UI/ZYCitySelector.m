//
//  ZYCitySelector.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCitySelector.h"

@interface ZYCitySelector ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *cancelBtn;
@property (nonatomic , strong) ZYElasticButton *confirmBtn;

@property (nonatomic , strong) ZYTableView *provinceTable;
@property (nonatomic , strong) ZYTableView *cityTable;
@property (nonatomic , strong) ZYTableView *distinctTable;

@property (nonatomic , assign) int provinceSelectedIndex;
@property (nonatomic , assign) int citySelectedIndex;
@property (nonatomic , assign) int distinctSelectedIndex;

@property (nonatomic , strong) NSMutableArray *provinceArr;
@property (nonatomic , strong) NSMutableArray *cityArr;
@property (nonatomic , strong) NSMutableArray *distinctArr;

@property (nonatomic , strong) NSURLSessionDataTask *cityTask;
@property (nonatomic , strong) NSURLSessionDataTask *distinctTask;

@end

@implementation ZYCitySelector

- (instancetype)init{
    self = [super init];
    if(self){
        _provinceSelectedIndex = -1;
        _citySelectedIndex = -1;
        _distinctSelectedIndex = -1;
        
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
//    __weak __typeof__(self) weakSelf = self;
    [self.backView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.backView).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.backView).mas_offset(60 * UI_H_SCALE);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    [self.backView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.centerY.equalTo(self.backView.mas_top).mas_offset(30 * UI_H_SCALE);
    }];
    
    [self.backView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView);
        make.bottom.equalTo(self.line.mas_top);
        make.width.mas_equalTo(self.cancelBtn.width + 30 * UI_H_SCALE);
    }];
    
    [self.backView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.backView);
        make.bottom.equalTo(self.line.mas_top);
        make.width.mas_equalTo(self.cancelBtn.width + 30 * UI_H_SCALE);
    }];
    
    [self.backView addSubview:self.provinceTable];
    [self.provinceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backView);
        make.top.equalTo(self.line.mas_bottom);
    }];
    
    [self.backView addSubview:self.cityTable];
    [self.cityTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.backView);
        make.top.equalTo(self.line.mas_bottom);
        make.left.equalTo(self.backView).mas_offset(SCREEN_WIDTH / 3.0);
    }];
    
    [self.backView addSubview:self.distinctTable];
    [self.distinctTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.backView);
        make.top.equalTo(self.line.mas_bottom);
        make.left.equalTo(self.backView).mas_offset(SCREEN_WIDTH / 3.0 * 2);
    }];
}

#pragma mark - 加载地区数据（1省2市3区）
- (NSURLSessionDataTask *)loadArea:(NSString *)addressId type:(int)type{
    _p_AreaDropDown *param = [_p_AreaDropDown new];
    param.addressId = addressId;
    return [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(2 == type && ![task isEqual:self.cityTask]){
                                return;
                            }
                            if(3 == type && ![task isEqual:self.distinctTask]){
                                return;
                            }
                            if(responseObj.isSuccess){
                                NSMutableArray *tmpArr = nil;
                                ZYTableView *tmpTab = nil;
                                if(1 == type){
                                    tmpArr = self.provinceArr;
                                    tmpTab = self.provinceTable;
                                    self.provinceSelectedIndex = -1;
                                }else if(2 == type){
                                    tmpArr = self.cityArr;
                                    tmpTab = self.cityTable;
                                    self.citySelectedIndex = -1;
                                }else if(3 == type){
                                    tmpArr = self.distinctArr;
                                    tmpTab = self.distinctTable;
                                    self.distinctSelectedIndex = -1;
                                }
                                [tmpArr removeAllObjects];
                                NSArray *arr = responseObj.data[@"cows"];
                                for(NSDictionary *dic in arr){
                                    _m_AreaDropDown *model = [[_m_AreaDropDown alloc] initWithDictionary:dic];
                                    model.parentId = addressId;
                                    [tmpArr addObject:model];
                                }
                                [tmpTab reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        } authFail:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYCitySelectorCell *preCell = nil;
    ZYCitySelectorCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if([tableView isEqual:self.provinceTable]){
        self.cityTable.hidden = NO;
        self.distinctTable.hidden = YES;
        preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_provinceSelectedIndex inSection:0]];
        _provinceSelectedIndex = (int)indexPath.row;
        _citySelectedIndex = -1;
        _distinctSelectedIndex = -1;
        
        [self.cityArr removeAllObjects];
        [self.cityTable reloadData];
        
        _m_AreaDropDown *model = self.provinceArr[indexPath.row];
        _cityTask = [self loadArea:model.addressId type:2];
    }else if([tableView isEqual:self.cityTable]){
        self.distinctTable.hidden = NO;
        preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_citySelectedIndex inSection:0]];
        _citySelectedIndex = (int)indexPath.row;
        _distinctSelectedIndex = -1;
        
        [self.distinctArr removeAllObjects];
        [self.distinctTable reloadData];
        
        _m_AreaDropDown *model = self.cityArr[indexPath.row];
        _distinctTask = [self loadArea:model.addressId type:3];
    }else{
        preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_distinctSelectedIndex inSection:0]];
        _distinctSelectedIndex = (int)indexPath.row;
    }
    preCell.titleLab.textColor = WORD_COLOR_GRAY;
    newCell.titleLab.textColor = MAIN_COLOR_GREEN;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.provinceTable]){
        return self.provinceArr.count;
    }else if([tableView isEqual:self.cityTable]){
        return self.cityArr.count;
    }else{
        return self.distinctArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = nil;
    if([tableView isEqual:self.provinceTable]){
        identifier = @"ZYCitySelectorCellProvince";
    }else if([tableView isEqual:self.cityTable]){
        identifier = @"ZYCitySelectorCellCity";
    }else{
        identifier = @"ZYCitySelectorCellDistinct";
    }
    ZYCitySelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCitySelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([tableView isEqual:self.provinceTable]){
        if(indexPath.row == _provinceSelectedIndex){
            cell.titleLab.textColor = MAIN_COLOR_GREEN;
        }else{
            cell.titleLab.textColor = WORD_COLOR_GRAY;
        }
        _m_AreaDropDown *model = self.provinceArr[indexPath.row];
        cell.titleLab.text = model.addressName;
    }else if([tableView isEqual:self.cityTable]){
        if(indexPath.row == _citySelectedIndex){
            cell.titleLab.textColor = MAIN_COLOR_GREEN;
        }else{
            cell.titleLab.textColor = WORD_COLOR_GRAY;
        }
        _m_AreaDropDown *model = self.cityArr[indexPath.row];
        cell.titleLab.text = model.addressName;
    }else{
        if(indexPath.row == _distinctSelectedIndex){
            cell.titleLab.textColor = MAIN_COLOR_GREEN;
        }else{
            cell.titleLab.textColor = WORD_COLOR_GRAY;
        }
        _m_AreaDropDown *model = self.distinctArr[indexPath.row];
        cell.titleLab.text = model.addressName;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - public
- (void)show{
    self.panelView = self.backView;
    if(!self.provinceArr.count){
        [self loadArea:nil type:1];
    }
    [super show];
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.size = CGSizeMake(SCREEN_WIDTH, 464 * UI_V_SCALE);
    }
    return _backView;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(17);
        _titleLab.text = @"所选地区";
    }
    return _titleLab;
}

- (ZYElasticButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [ZYElasticButton new];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateHighlighted];
        _cancelBtn.font = FONT(16);
        [_cancelBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _cancelBtn;
}

- (ZYElasticButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [ZYElasticButton new];
        _confirmBtn.backgroundColor = [UIColor whiteColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _confirmBtn.font = FONT(16);
        [_confirmBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_confirmBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.provinceSelectedIndex == -1 ||
               weakSelf.citySelectedIndex == -1 ||
               weakSelf.distinctSelectedIndex == -1){
                return;
            }
            _m_AreaDropDown *province = weakSelf.provinceArr[weakSelf.provinceSelectedIndex];
            _m_AreaDropDown *city = weakSelf.cityArr[weakSelf.citySelectedIndex];
            _m_AreaDropDown *distinct = weakSelf.distinctArr[weakSelf.distinctSelectedIndex];
            
            if(!([distinct.parentId isEqualToString:city.addressId] &&
                 [city.parentId isEqualToString:province.addressId])){
                return;
            }
            
            [weakSelf dismiss:nil];
            !weakSelf.confirmAction ? : weakSelf.confirmAction(province,city,distinct);
        }];
    }
    return _confirmBtn;
}

- (ZYTableView *)provinceTable{
    if(!_provinceTable){
        _provinceTable = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provinceTable.backgroundColor = [UIColor whiteColor];
        _provinceTable.showsVerticalScrollIndicator = NO;
        _provinceTable.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _provinceTable.delegate = self;
        _provinceTable.dataSource = self;
    }
    return _provinceTable;
}

- (ZYTableView *)cityTable{
    if(!_cityTable){
        _cityTable = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTable.backgroundColor = [UIColor whiteColor];
        _cityTable.showsVerticalScrollIndicator = NO;
        _cityTable.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _cityTable.hidden = YES;
        _cityTable.delegate = self;
        _cityTable.dataSource = self;
    }
    return _cityTable;
}

- (ZYTableView *)distinctTable{
    if(!_distinctTable){
        _distinctTable = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _distinctTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _distinctTable.backgroundColor = [UIColor whiteColor];
        _distinctTable.showsVerticalScrollIndicator = NO;
        _distinctTable.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _distinctTable.hidden = YES;
        _distinctTable.delegate = self;
        _distinctTable.dataSource = self;
    }
    return _distinctTable;
}

- (NSMutableArray *)provinceArr{
    if(!_provinceArr){
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}

- (NSMutableArray *)cityArr{
    if(!_cityArr){
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

- (NSMutableArray *)distinctArr{
    if(!_distinctArr){
        _distinctArr = [NSMutableArray array];
    }
    return _distinctArr;
}

@end





@implementation ZYCitySelectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = FONT(16);
    }
    return _titleLab;
}

@end
