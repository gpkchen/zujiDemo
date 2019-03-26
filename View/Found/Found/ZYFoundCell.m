//
//  ZYFoundCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundCell.h"
#import "AppFoundPage.h"
#import "ZYLikeButton.h"
#import "AppUserReleaseListInfo.h"
#import "AppMyReleaseListInfo.h"

@interface ZYFoundCell()

@property (nonatomic , strong) UIImageView *avatarIV;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) ZYLikeButton *likeBtn;
@property (nonatomic , strong) UILabel *likeNumLab;

@property (nonatomic , strong) UIImageView *iv_1;   //只有一张图或者没有图

@property (nonatomic , strong) UIImageView *iv_2_1; //有两张图的第一张
@property (nonatomic , strong) UIImageView *iv_2_2; //有两张图的第二张

@property (nonatomic , strong) UIImageView *iv_3_1; //大于三张图的第一张
@property (nonatomic , strong) UIImageView *iv_3_2; //大于三张图的第二张
@property (nonatomic , strong) UIImageView *iv_3_3; //大于三张图的第三张
@property (nonatomic , strong) UILabel *moreLab; //更多

//点赞头像列表
@property (nonatomic , strong) NSMutableArray *likedAvatarIVArr;

@end

@implementation ZYFoundCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZYFoundCellType)type{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarIV];
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(40 * UI_H_SCALE, 40 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.centerY.equalTo(self.avatarIV);
            make.size.mas_equalTo(CGSizeMake(self.moreBtn.width + 30 * UI_H_SCALE, self.moreBtn.width + 30 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.nameLab];
        
        if(type == ZYFoundCellTypeUserCenter){
            self.moreBtn.hidden = NO;
            [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarIV.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(self.contentView.mas_top).mas_offset(27 * UI_H_SCALE);
                make.right.lessThanOrEqualTo(self.moreBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
            }];
            [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLab);
                make.centerY.equalTo(self.contentView.mas_top).mas_offset(44.5 * UI_H_SCALE);
            }];
        }else{
            self.moreBtn.hidden = YES;
            [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
                make.centerY.equalTo(self.avatarIV);
            }];
            [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarIV.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(self.avatarIV);
                make.right.lessThanOrEqualTo(self.timeLab.mas_left);
            }];
        }
        
        [self.contentView addSubview:self.iv_1];
        [self.iv_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(345 * UI_H_SCALE, 172 * UI_H_SCALE));
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iv_2_1];
        [self.iv_2_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(172 * UI_H_SCALE, 172 * UI_H_SCALE));
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iv_2_2];
        [self.iv_2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iv_2_1.mas_right).mas_offset(1);
            make.size.mas_equalTo(CGSizeMake(172 * UI_H_SCALE, 172 * UI_H_SCALE));
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iv_3_1];
        [self.iv_3_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(172 * UI_H_SCALE, 172 * UI_H_SCALE));
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iv_3_2];
        [self.iv_3_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iv_3_1.mas_right).mas_offset(1);
            make.size.mas_equalTo(CGSizeMake(172 * UI_H_SCALE, 86 * UI_H_SCALE));
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.iv_3_3];
        [self.iv_3_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iv_3_2);
            make.size.mas_equalTo(CGSizeMake(172 * UI_H_SCALE, 85 * UI_H_SCALE));
            make.top.equalTo(self.iv_3_2.mas_bottom).mas_offset(1);
        }];
        
        [self.iv_3_3 addSubview:self.moreLab];
        [self.moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.iv_3_3);
        }];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(255 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.likeBtn];
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).mas_offset(-10 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(self.likeBtn.originSize.width + 30 * UI_H_SCALE,
                                             self.likeBtn.originSize.height + 30 * UI_H_SCALE));
        }];
        
        for(int i=0;i<5;++i){
            UIImageView *iv = [UIImageView new];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            iv.cornerRadius = 10 * UI_H_SCALE;
            iv.borderColor = UIColor.whiteColor;
            iv.borderWidth = 1;
            iv.backgroundColor = HexRGB(0xd8d8d8);
            
            [self.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20 * UI_H_SCALE, 20 * UI_H_SCALE));
                make.left.equalTo(self.contentView).mas_offset(59 * UI_H_SCALE - i * 11 * UI_H_SCALE);
                make.centerY.equalTo(self.likeBtn);
            }];
            
            [self.likedAvatarIVArr addObject:iv];
        }
        
        self.likedAvatarIVArr = [NSMutableArray arrayWithArray:[[self.likedAvatarIVArr reverseObjectEnumerator] allObjects]];
        
        [self.contentView addSubview:self.likeNumLab];
        [self.likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.likeBtn);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - 显示推荐列表
- (void)showRecommend:(_m_AppFoundPage *)model{
    //显示内容
    NSString *avatar = [model.avatar imageStyleUrl:CGSizeMake(80 * UI_H_SCALE, 80 * UI_H_SCALE)];
    [self.avatarIV loadImage:avatar];
    [self.avatarIV tapped:^(UITapGestureRecognizer *gesture) {
        if(model.userId){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYUserCenterVC?userId=%@",[model.userId URLEncode]]];
        }
    } delegate:nil];
    
    self.nameLab.text = model.publisher;
    self.timeLab.text = model.createDate;
    self.contentLab.text = model.title;
    
    self.likeBtn.isLiked = model.isZan == 1;
    self.likeBtn.contentSource = model.source;
    self.likeBtn.contentId = model.sourceId;
    __weak __typeof__(self) weakSelf = self;
    self.likeBtn.actionResult = ^(BOOL isLiked) {
        if(isLiked){
            model.zanAmount++;
            model.isZan = 1;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            [model.zanAvatars insertObject:@{@"avatar":[ZYUser user].portraitPath} atIndex:0];
            [weakSelf showLikeAvatars:model.zanAvatars];
        }else{
            model.zanAmount--;
            model.isZan = 2;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            for(int i=0;i<model.zanAvatars.count;++i){
                NSDictionary *dic = model.zanAvatars[i];
                if([dic[@"avatar"] isEqualToString:[ZYUser user].portraitPath]){
                    [model.zanAvatars removeObjectAtIndex:i];
                    break;
                }
            }
            [weakSelf showLikeAvatars:model.zanAvatars];
        }
    };
    
    self.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
    
    //显示图片
    [self showImage:model.images];
    
    //处理文字位置
    if(model.images.count){
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(255 * UI_H_SCALE);
        }];
    }else{
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
    }
    
    //显示点赞人头像
    [self showLikeAvatars:model.zanAvatars];
}

#pragma mark - 显示此刻列表
- (void)showMoment:(_m_AppUserReleaseListInfo *)model{
    //显示内容
    NSString *avatar = [model.avatar imageStyleUrl:CGSizeMake(80 * UI_H_SCALE, 80 * UI_H_SCALE)];
    [self.avatarIV loadImage:avatar];
    [self.avatarIV tapped:^(UITapGestureRecognizer *gesture) {
        if(model.userId){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYUserCenterVC?userId=%@",[model.userId URLEncode]]];
        }
    } delegate:nil];
    
    self.nameLab.text = model.nickname;
    self.timeLab.text = model.releaseTime;
    self.contentLab.text = model.title;
    
    self.likeBtn.isLiked = model.isZan == 1;
    self.likeBtn.contentSource = ZYArticleSourceUser;
    self.likeBtn.contentId = model.userReleaseId;
    __weak __typeof__(self) weakSelf = self;
    self.likeBtn.actionResult = ^(BOOL isLiked) {
        [ZYStatisticsService event:@"found_userpublish_like"];
        if(isLiked){
            model.zanAmount++;
            model.isZan = 1;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            [model.zanAvatars insertObject:@{@"avatar":[ZYUser user].portraitPath} atIndex:0];
            [weakSelf showLikeAvatars:model.zanAvatars];
        }else{
            model.zanAmount--;
            model.isZan = 2;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            for(int i=0;i<model.zanAvatars.count;++i){
                NSDictionary *dic = model.zanAvatars[i];
                if([dic[@"avatar"] isEqualToString:[ZYUser user].portraitPath]){
                    [model.zanAvatars removeObjectAtIndex:i];
                    break;
                }
            }
            [weakSelf showLikeAvatars:model.zanAvatars];
        }
    };
    
    self.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
    
    //显示图片
    [self showImage:model.images];
    
    //处理文字位置
    if(model.images.count){
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(255 * UI_H_SCALE);
        }];
    }else{
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
    }
    
    //显示点赞人头像
    [self showLikeAvatars:model.zanAvatars];
}

#pragma mark - 显示用户中心列表
- (void)showUserCenterMoment:(_m_AppMyReleaseListInfo *)model{
    //显示内容
    NSString *avatar = [model.avatar imageStyleUrl:CGSizeMake(80 * UI_H_SCALE, 80 * UI_H_SCALE)];
    [self.avatarIV loadImage:avatar];
    
    self.nameLab.text = model.nickname;
    self.timeLab.text = model.releaseTime;
    self.contentLab.text = model.title;
    
    self.likeBtn.isLiked = model.isZan == 1;
    self.likeBtn.contentSource = ZYArticleSourceUser;
    self.likeBtn.contentId = model.userReleaseId;
    __weak __typeof__(self) weakSelf = self;
    self.likeBtn.actionResult = ^(BOOL isLiked) {
        if(isLiked){
            model.zanAmount++;
            model.isZan = 1;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            [model.zanAvatars insertObject:@{@"avatar":[ZYUser user].portraitPath} atIndex:0];
            [weakSelf showLikeAvatars:model.zanAvatars];
        }else{
            model.zanAmount--;
            model.isZan = 2;
            weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
            
            for(int i=0;i<model.zanAvatars.count;++i){
                NSDictionary *dic = model.zanAvatars[i];
                if([dic[@"avatar"] isEqualToString:[ZYUser user].portraitPath]){
                    [model.zanAvatars removeObjectAtIndex:i];
                    break;
                }
            }
            [weakSelf showLikeAvatars:model.zanAvatars];
        }
    };
    
    self.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",model.zanAmount];
    
    //显示图片
    [self showImage:model.images];
    
    //处理文字位置
    if(model.images.count){
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(255 * UI_H_SCALE);
        }];
    }else{
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(70 * UI_H_SCALE);
        }];
    }
    
    //显示点赞人头像
    [self showLikeAvatars:model.zanAvatars];
}

#pragma mark - 显示图片
- (void)showImage:(NSArray *)images{
    if(images.count == 0){
        self.iv_1.hidden = YES;
        self.iv_2_1.hidden = YES;
        self.iv_2_2.hidden = YES;
        self.iv_3_1.hidden = YES;
        self.iv_3_2.hidden = YES;
        self.iv_3_3.hidden = YES;
    }else if(images.count == 1){
        self.iv_1.hidden = NO;
        self.iv_2_1.hidden = YES;
        self.iv_2_2.hidden = YES;
        self.iv_3_1.hidden = YES;
        self.iv_3_2.hidden = YES;
        self.iv_3_3.hidden = YES;
        
        NSString *url = [images[0][@"imageUrl"] imageStyleUrl:CGSizeMake(690 * UI_H_SCALE, 344 * UI_H_SCALE)];
        [self.iv_1 loadImage:url];
    }else if(images.count == 2){
        self.iv_1.hidden = YES;
        self.iv_2_1.hidden = NO;
        self.iv_2_2.hidden = NO;
        self.iv_3_1.hidden = YES;
        self.iv_3_2.hidden = YES;
        self.iv_3_3.hidden = YES;
        
        NSString *url1 = [images[0][@"imageUrl"] imageStyleUrl:CGSizeMake(344 * UI_H_SCALE, 344 * UI_H_SCALE)];
        [self.iv_2_1 loadImage:url1];
        NSString *url2 = [images[1][@"imageUrl"] imageStyleUrl:CGSizeMake(344 * UI_H_SCALE, 344 * UI_H_SCALE)];
        [self.iv_2_2 loadImage:url2];
        
    }else if(images.count >= 3){
        self.iv_1.hidden = YES;
        self.iv_2_1.hidden = YES;
        self.iv_2_2.hidden = YES;
        self.iv_3_1.hidden = NO;
        self.iv_3_2.hidden = NO;
        self.iv_3_3.hidden = NO;
        
        NSString *url1 = [images[0][@"imageUrl"] imageStyleUrl:CGSizeMake(344 * UI_H_SCALE, 344 * UI_H_SCALE)];
        [self.iv_3_1 loadImage:url1];
        NSString *url2 = [images[1][@"imageUrl"] imageStyleUrl:CGSizeMake(344 * UI_H_SCALE, 172 * UI_H_SCALE)];
        [self.iv_3_2 loadImage:url2];
        NSString *url3 = [images[2][@"imageUrl"] imageStyleUrl:CGSizeMake(344 * UI_H_SCALE, 170 * UI_H_SCALE)];
        [self.iv_3_3 loadImage:url3];
        
        int rest = (int)images.count - 3;
        if(rest > 0){
            self.moreLab.hidden = NO;
            NSShadow *shadow = [[NSShadow alloc]init];
            shadow.shadowBlurRadius = 3.0;
            shadow.shadowOffset = CGSizeMake(1, 1);
            shadow.shadowColor = [UIColor blackColor];
            NSMutableAttributedString *moreAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%d",rest]];
            [moreAtt addAttribute:NSShadowAttributeName
                            value:shadow
                            range:NSMakeRange(0, moreAtt.length)];
            self.moreLab.attributedText = moreAtt;
        }else{
            self.moreLab.hidden = YES;
        }
    }
}

#pragma mark - 显示点赞人数头像
- (void)showLikeAvatars:(NSArray *)avatars{
    //显示点赞人头像
    for(int i=0;i<self.likedAvatarIVArr.count;++i){
        UIImageView *iv = self.likedAvatarIVArr[i];
        if(i >= avatars.count){
            iv.hidden = YES;
        }else{
            iv.hidden = NO;
            NSString *url = [avatars[i][@"avatar"] imageStyleUrl:CGSizeMake(40 * UI_H_SCALE, 40 * UI_H_SCALE)];
            [iv loadImage:url];
        }
    }
    
    //显示点赞数
    if(avatars.count){
        int count = (int)avatars.count;
        if(count > 5){
            count = 5;
        }
        [self.likeNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(42 * UI_H_SCALE + (count - 1) * 11 * UI_H_SCALE);
        }];
    }else{
        [self.likeNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
        }];
    }
}

#pragma mark - getter
- (UIImageView *)avatarIV{
    if(!_avatarIV){
        _avatarIV = [UIImageView new];
        _avatarIV.userInteractionEnabled = YES;
        _avatarIV.clipsToBounds = YES;
        _avatarIV.cornerRadius = 20 * UI_H_SCALE;
        _avatarIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarIV;
}

- (ZYElasticButton *)moreBtn{
    if(!_moreBtn){
        _moreBtn = [ZYElasticButton new];
        _moreBtn.backgroundColor = UIColor.whiteColor;
        UIImage *img = [UIImage imageNamed:@"zy_arrow_down"];
        [_moreBtn setImage:img forState:UIControlStateNormal];
        [_moreBtn setImage:img forState:UIControlStateHighlighted];
        _moreBtn.size = img.size;
    }
    return _moreBtn;
}

- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = UIColor.blackColor;
        _nameLab.font = FONT(15);
    }
    return _nameLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textColor = WORD_COLOR_GRAY_9B;
        _timeLab.font = FONT(12);
    }
    return _timeLab;
}

- (UIImageView *)iv_1{
    if(!_iv_1){
        _iv_1 = [UIImageView new];
        _iv_1.contentMode = UIViewContentModeScaleAspectFill;
        _iv_1.clipsToBounds = YES;
    }
    return _iv_1;
}

- (UIImageView *)iv_2_1{
    if(!_iv_2_1){
        _iv_2_1 = [UIImageView new];
        _iv_2_1.contentMode = UIViewContentModeScaleAspectFill;
        _iv_2_1.clipsToBounds = YES;
    }
    return _iv_2_1;
}

- (UIImageView *)iv_2_2{
    if(!_iv_2_2){
        _iv_2_2 = [UIImageView new];
        _iv_2_2.contentMode = UIViewContentModeScaleAspectFill;
        _iv_2_2.clipsToBounds = YES;
    }
    return _iv_2_2;
}

- (UIImageView *)iv_3_1{
    if(!_iv_3_1){
        _iv_3_1 = [UIImageView new];
        _iv_3_1.contentMode = UIViewContentModeScaleAspectFill;
        _iv_3_1.clipsToBounds = YES;
    }
    return _iv_3_1;
}

- (UIImageView *)iv_3_2{
    if(!_iv_3_2){
        _iv_3_2 = [UIImageView new];
        _iv_3_2.contentMode = UIViewContentModeScaleAspectFill;
        _iv_3_2.clipsToBounds = YES;
    }
    return _iv_3_2;
}

- (UIImageView *)iv_3_3{
    if(!_iv_3_3){
        _iv_3_3 = [UIImageView new];
        _iv_3_3.contentMode = UIViewContentModeScaleAspectFill;
        _iv_3_3.clipsToBounds = YES;
    }
    return _iv_3_3;
}

- (UILabel *)moreLab{
    if(!_moreLab){
        _moreLab = [UILabel new];
        _moreLab.textColor = UIColor.whiteColor;
        _moreLab.font = FONT(18);
    }
    return _moreLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.font = MEDIUM_FONT(18);
        _contentLab.textColor = HexRGB(0x4a4a4a);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLab;
}

- (ZYLikeButton *)likeBtn{
    if(!_likeBtn){
        _likeBtn = [ZYLikeButton new];
    }
    return _likeBtn;
}

- (NSMutableArray *)likedAvatarIVArr{
    if(!_likedAvatarIVArr){
        _likedAvatarIVArr = [NSMutableArray array];
    }
    return _likedAvatarIVArr;
}

- (UILabel *)likeNumLab{
    if(!_likeNumLab){
        _likeNumLab = [UILabel new];
        _likeNumLab.font = FONT(14);
        _likeNumLab.textColor = WORD_COLOR_GRAY_9B;
    }
    return _likeNumLab;
}

@end
