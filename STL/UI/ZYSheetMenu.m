//
//  ZYSheetMenu.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSheetMenu.h"
#import "UIView+ZYExtension.h"
#import "ZYMacro.h"
#import "ZYElasticButton.h"
#import "UIButton+ZYExtension.h"
#import "Masonry.h"
#import "UIImage+ZYExtension.h"

#define ZHSheetMenuCellHeight (50 * UI_H_SCALE) //cell高度

@interface ZYSheetMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ZYElasticButton *cancelBtn;

@property (nonatomic , copy) ZYSheetMenuSelectionAction selectionAction; //选择回调
@property (nonatomic , copy) ZYSheetMenuCancelAction cancelAction; //取消回调

@end

@implementation ZYSheetMenu

- (instancetype)init{
    self = [super init];
    if(self){
        _cancelBtnStyle = ZYSheetMenuCancelBtnStyleRound;
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.backView addSubview:self.tableView];
    [self.backView addSubview:self.cancelBtn];
}

#pragma mark - setter
- (void)setDateArr:(NSArray *)dateArr{
    _dateArr = dateArr;
    [_tableView reloadData];
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = HexRGB(0xf3f6f6);
    }
    return _backView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
#endif
        _tableView.backgroundColor = HexRGB(0xf3f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, self.height, self.width, 0);
        _tableView.bounces = NO;
        _tableView.delaysContentTouches = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ZYElasticButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [ZYElasticButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setAdjustsImageWhenHighlighted:NO];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn.titleLabel setFont:FONT(14)];
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismissWithCompletion:nil];
        }];
    }
    return _cancelBtn;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZESheetMenuCell";
    ZYSheetMenuCell *cell = (ZYSheetMenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYSheetMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.separator.hidden = 0 == indexPath.row;
    cell.text = [_dateArr objectAtIndex:indexPath.row];
    if(_cancelBtnStyle == ZYSheetMenuCancelBtnStyleRound){
        cell.textColor =  HexRGB(0x3b4a5a);
    }else if(_cancelBtnStyle == ZYSheetMenuCancelBtnStyleFull){
        cell.textColor =  HexRGB(0xFF3939);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZHSheetMenuCellHeight;
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
    __weak __typeof__(self) weakSelf = self;
    [self dismissWithCompletion:^{
        if(weakSelf.selectionAction){
            weakSelf.selectionAction(indexPath.row);
        }
    }];
}

#pragma mark - public
- (void)show{
    NSInteger lineNum = _dateArr.count > 5 ? 5 : _dateArr.count;
    if(_cancelBtnStyle == ZYSheetMenuCancelBtnStyleRound){
        [self.cancelBtn setBackgroundColor:HexRGB(0xE8EAED) forState:(UIControlStateNormal)];
        [self.cancelBtn setTitleColor:WORD_COLOR_GRAY forState:(UIControlStateNormal)];
        self.cancelBtn.shouldRound = YES;
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.backView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.tableView.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.height.mas_equalTo(44 * UI_H_SCALE);
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView).mas_offset(UIEdgeInsetsMake(0, 0, 93 * UI_H_SCALE + DOWN_DANGER_HEIGHT, 0));
        }];
        self.backView.size = CGSizeMake(SCREEN_WIDTH,lineNum * ZHSheetMenuCellHeight + 93 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }else if(_cancelBtnStyle == ZYSheetMenuCancelBtnStyleFull){
        [self.cancelBtn setBackgroundColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [self.cancelBtn setTitleColor:WORD_COLOR_BLACK forState:(UIControlStateNormal)];
        self.cancelBtn.shouldRound = NO;
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView);
            make.top.equalTo(self.tableView.mas_bottom).mas_offset(10 * UI_H_SCALE);
            make.height.mas_equalTo(ZHSheetMenuCellHeight);
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView).mas_offset(UIEdgeInsetsMake(0, 0, ZHSheetMenuCellHeight + 10 * UI_H_SCALE + DOWN_DANGER_HEIGHT, 0));
        }];
        self.backView.size = CGSizeMake(SCREEN_WIDTH,(lineNum + 1) * ZHSheetMenuCellHeight + 10 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }
    self.panelView = self.backView;
    [super show];
}

- (void)dismissWithCompletion:(ZYBaseSheetDismissAction)completion{
    [super dismiss:completion];
}

- (void)selectionAction:(void(^_Nonnull)(NSUInteger index))action{
    _selectionAction = action;
}

- (void)cancelAction:(void(^_Nonnull)(void))action{
    _cancelAction = action;
}

@end





@interface ZYSheetMenuCell ()

@property (nonatomic , strong) UILabel *textLab;

@end

@implementation ZYSheetMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView *view = [UIView new];
        view.backgroundColor = HexRGB(0xf0f0f0);
        self.selectedBackgroundView = view;
        
        _separator = [[UIImageView alloc]init];
        _separator.image = [UIImage imageWithColor:HexRGB(0xeeeeee)];
        _separator.hidden = YES;
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        _textLab = [UILabel new];
        _textLab.font = FONT(16);
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.textColor = HexRGB(0x3b4a5a);
        [self.contentView addSubview:_textLab];
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLab.text = text;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _textLab.textColor = textColor;
}

@end
