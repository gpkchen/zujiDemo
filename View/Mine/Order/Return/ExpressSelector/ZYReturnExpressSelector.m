
//
//  ZYReturnExpressSelector.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnExpressSelector.h"
#import "ZYReturnExpressSelectorCell.h"
#import "ExpressCompanyList.h"

@interface ZYReturnExpressSelector()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYElasticButton *nextBtn;

@property (nonatomic , strong) NSMutableArray *expresses;
@property (nonatomic , assign) int selectedIndex;

@end

@implementation ZYReturnExpressSelector

- (instancetype)init{
    if(self = [super init]){
        self.shouldTapToDismiss = NO;
        _selectedIndex = -1;
        
        [self.panel addSubview:self.nextBtn];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.panel).mas_offset(-27 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(56 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.titleLab);
            make.width.mas_equalTo(30 + 30 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.panel);
            make.top.equalTo(self.titleLab.mas_bottom);
            make.bottom.equalTo(self.nextBtn.mas_top).mas_offset(-20 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)show{
    self.panelView = self.panel;
    if(self.expresses.count){
        [super show];
    }else{
        [self loadData];
    }
}

#pragma mark - 获取快递公司
- (void)loadData{
    _p_ExpressCompanyList *param = [_p_ExpressCompanyList new];
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.expresses = [_m_ExpressCompanyList mj_objectArrayWithKeyValuesArray:responseObj.data];
                                [self.tableView reloadData];
                                [super show];
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
                        } authFail:^{
                            
                        }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYReturnExpressSelectorCellHeight;
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
    
    _selectedIndex = (int)indexPath.row;
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYReturnExpressSelectorCell";
    ZYReturnExpressSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYReturnExpressSelectorCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    _m_ExpressCompanyList *model = self.expresses[indexPath.row];
    cell.titleLab.text = model.name;
    
    if(indexPath.row == _selectedIndex){
        cell.cb.selected = YES;
    }else{
        cell.cb.selected = NO;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [cell.cb clickAction:^(UIButton * _Nonnull button) {
        weakSelf.selectedIndex = (int)indexPath.row;
        [weakSelf.tableView reloadData];
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.size = CGSizeMake(SCREEN_WIDTH, 480 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
        _panel.backgroundColor = VIEW_COLOR;
    }
    return _panel;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(20);
        _titleLab.text = @"选择快递公司";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = UIColor.whiteColor;
    }
    return _titleLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _closeBtn;
}

- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ZYElasticButton *)nextBtn{
    if(!_nextBtn){
        _nextBtn = [ZYElasticButton new];
        [_nextBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _nextBtn.font = FONT(18);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_nextBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.selectedIndex == -1){
                [ZYToast showWithTitle:@"请先选择快递公司！"];
                return;
            }
            _m_ExpressCompanyList *model = weakSelf.expresses[weakSelf.selectedIndex];
            !weakSelf.selectionAction ? : weakSelf.selectionAction(model.companyCode);
            [weakSelf dismiss:nil];
        }];
    }
    return _nextBtn;
}

- (NSMutableArray *)expresses{
    if(!_expresses){
        _expresses = [NSMutableArray array];
    }
    return _expresses;
}

@end
