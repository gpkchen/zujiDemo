//
//  ZYItemDetailSkuMenuCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailSkuMenuCell.h"
#import "ZYItemDetailSkuMenuButton.h"

@interface ZYItemDetailSkuMenuCell ()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) NSMutableArray *btns;
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute *sku;

@end

@implementation ZYItemDetailSkuMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separator.hidden = NO;
    }
    return self;
}

+ (CGFloat)heightForCellWithModel:(_m_ItemDetail_SkuAttribute *)model{
    CGFloat x = 15 * UI_H_SCALE;
    CGFloat y = 46 * UI_H_SCALE;
    for(int i=0;i<model.valueList.count;++i){
        _m_ItemDetail_SkuAttribute_Sub *value = model.valueList[i];
        CGSize size = [value.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:FONT(14)}
                                               context:nil].size;
        size = CGSizeMake(size.width + 32 * UI_H_SCALE, 36 * UI_H_SCALE);
        if(x + 20 * UI_H_SCALE + size.width > SCREEN_WIDTH - 15 * UI_H_SCALE){
            x = 15 * UI_H_SCALE;
            y += size.height + 10 * UI_H_SCALE;
        }
        
        x += 20 * UI_H_SCALE + size.width;
        if(i == model.valueList.count - 1){
            y += size.height + 15 * UI_H_SCALE;
        }
        
    }
    return y;
}

- (void)showCellWithModel:(_m_ItemDetail_SkuAttribute *)model isPeriod:(BOOL)is{
    _sku = model;
    [self.contentView removeAllSubviews];
    [self.btns removeAllObjects];
    __weak __typeof__(self) weakSelf = self;
    
    [self.contentView addSubview:self.separator];
    [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        make.bottom.equalTo(self.contentView).mas_offset(-1);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
    
    self.titleLab.text = model.name;
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        make.centerY.equalTo(self.contentView.mas_top).mas_offset(25 * UI_H_SCALE);
    }];
    
    CGFloat x = 15 * UI_H_SCALE;
    CGFloat y = 46 * UI_H_SCALE;
    for(int i=0;i<model.valueList.count;++i){
        _m_ItemDetail_SkuAttribute_Sub *value = model.valueList[i];
        ZYItemDetailSkuMenuButton *btn = [ZYItemDetailSkuMenuButton new];
        btn.value = value;
        if(!is){
            if(value.hasStorage){
                if(value.isSelected){
                    btn.buttonState = ZYItemDetailSkuMenuButtonStateSelected;
                }else{
                    btn.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
                }
            }else{
                btn.buttonState = ZYItemDetailSkuMenuButtonStateDisable;
            }
        }else{
            if(value.isSelected){
                btn.buttonState = ZYItemDetailSkuMenuButtonStateSelected;
            }else{
                btn.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
            }
        }
        if(x + 20 * UI_H_SCALE + btn.width > SCREEN_WIDTH - 15 * UI_H_SCALE){
            x = 15 * UI_H_SCALE;
            y += btn.height + 10 * UI_H_SCALE;
        }
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(x);
            make.top.equalTo(self.contentView).mas_offset(y);
            make.size.mas_equalTo(btn.size);
        }];
        [btn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:(ZYItemDetailSkuMenuButton *)button];
        }];
        [self.btns addObject:btn];
        
        x += 20 * UI_H_SCALE + btn.width;
        
    }
}

- (void)refreshCell{
    for(ZYItemDetailSkuMenuButton *btn in self.btns){
        if(btn.value.hasStorage){
            if(btn.value.isSelected){
                btn.buttonState = ZYItemDetailSkuMenuButtonStateSelected;
            }else{
                btn.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
            }
        }else{
            btn.buttonState = ZYItemDetailSkuMenuButtonStateDisable;
        }
    }
}

- (void)btnAction:(ZYItemDetailSkuMenuButton *)button{
    if(button.buttonState == ZYItemDetailSkuMenuButtonStateNormal){
        for(ZYItemDetailSkuMenuButton *btn in self.btns){
            if(![btn isEqual:button] && btn.buttonState != ZYItemDetailSkuMenuButtonStateDisable){
                btn.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
                btn.value.isSelected = NO;
            }
        }
        button.buttonState = ZYItemDetailSkuMenuButtonStateSelected;
        button.value.isSelected = YES;
        !_selectionBlock ? : _selectionBlock(_sku,button.value);
    }else{
        button.buttonState = ZYItemDetailSkuMenuButtonStateNormal;
        button.value.isSelected = NO;
        !_selectionBlock ? : _selectionBlock(_sku,nil);
    }
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(14);
    }
    return _titleLab;
}

- (NSMutableArray *)btns{
    if(!_btns){
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end
