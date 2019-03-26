//
//  ZYPhoneTextField.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/6.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPhoneTextField.h"

@interface ZYPhoneTextField()

@end

@implementation ZYPhoneTextField

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addTarget:self
                 action:@selector(editChanged:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)editChanged:(ZYTextField *)textField{
    self.text = textField.text;
}

- (void)setText:(NSString *)text{
    NSString *phone = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(phone.length > 11){
        phone = [phone substringToIndex:11];
    }
    if(phone.length >3 && phone.length < 7){
        NSString *fs = [[phone substringToIndex:3] stringByAppendingString:@" "];
        if(phone.length > 3){
            fs = [fs stringByAppendingString:[phone substringFromIndex:3]];
        }
        [super setText:fs];
    }else if(phone.length == 3){
        [super setText:phone];
    }else if(phone.length >7){
        NSString *fs = [[[[phone substringToIndex:3] stringByAppendingString:@" "] stringByAppendingString:[phone substringWithRange:NSMakeRange(3, 4)]] stringByAppendingString:@" "];
        fs = [fs stringByAppendingString:[phone substringFromIndex:7]];
        [super setText:fs];
    }else if(phone.length == 7){
        NSString *fs = [[[phone substringToIndex:3] stringByAppendingString:@" "] stringByAppendingString:[phone substringWithRange:NSMakeRange(3, 4)]];
        [super setText:fs];
    }
    !_changedBlock ? : _changedBlock(phone);
}

- (NSString *)phone{
    return [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
