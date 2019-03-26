//
//  ZYItemDetailUpBannerCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpBannerCell.h"
#import <SDCycleScrollView.h>
#import "ZYItemDetailMediaPlayer.h"
#import "ItemDetail.h"

@interface ZYItemDetailUpBannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) SDCycleScrollView *banner;
@property (nonatomic , strong) ZYItemDetailMediaPlayer *player;

@property (nonatomic , strong) NSArray *images;
@property (nonatomic , copy) NSString *videoUrl;

@property (nonatomic , strong) ZYElasticButton *videoBtn; //视频按钮
@property (nonatomic , strong) ZYElasticButton *imageBtn; //图片按钮
@property (nonatomic , strong) UILabel *numLab;

@end

@implementation ZYItemDetailUpBannerCell

- (void)dealloc{
    if(_videoUrl){
        [self.player free];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.banner];
        self.banner.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        
        [self.contentView addSubview:self.videoBtn];
        [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(50, 22));
            make.right.equalTo(self.contentView.mas_centerX).mas_offset(-5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.imageBtn];
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(50, 22));
            make.left.equalTo(self.contentView.mas_centerX).mas_offset(5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(45 * UI_H_SCALE, 20 * UI_H_SCALE));
        }];
    }
    return self;
}

- (void)pause{
    if(_videoUrl){
        [self.player pause];
    }
}

- (void)showCellWithModel:(_m_ItemDetail *)model{
    if(_images.count || _videoUrl){
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    for(NSDictionary *dic in model.imageList){
        NSString *url = [dic[@"url"] imageStyleUrl:CGSizeMake(SCREEN_WIDTH * 2, SCREEN_WIDTH * 2)];
        if(!images.count){
            self.player.coverUrl = url;
        }
        [images addObject:url];
    }
    self.banner.imageURLStringsGroup = images;
    self.numLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)images.count];
    if(model.videoUrl){
        self.player.url = [NSURL URLWithString:model.videoUrl];
        self.player.images = images;
        self.player.title = model.title;
        NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f/%@",model.price,model.unit]];
        [price addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, 1)];
        [price addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(price.length - model.unit.length - 1, model.unit.length + 1)];
        self.player.price = price;
        
        if(!self.player.superview){
            [self.contentView insertSubview:self.player atIndex:0];
            self.player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        }
        self.banner.hidden = YES;
        self.videoBtn.hidden = NO;
        self.imageBtn.hidden = NO;
        self.numLab.hidden = YES;
    }else{
        self.banner.hidden = NO;
        self.videoBtn.hidden = YES;
        self.imageBtn.hidden = YES;
        self.numLab.hidden = NO;
    }
    _videoUrl = model.videoUrl;
    _images = images;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.numLab.text = [NSString stringWithFormat:@"%d/%d",(int)index + 1,(int)_images.count];
}

#pragma mark - getter
- (SDCycleScrollView *)banner{
    if(!_banner){
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
        _banner.autoScrollTimeInterval = 3;
        _banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _banner.showPageControl = NO;
        _banner.delegate = self;
        _banner.backgroundColor = [UIColor whiteColor];
    }
    return _banner;
}

- (ZYItemDetailMediaPlayer *)player{
    if(!_player){
        _player = [ZYItemDetailMediaPlayer new];
        
        __weak __typeof__(self) weakSelf = self;
        _player.collectionAction = ^{
            !weakSelf.collectionAction ? : weakSelf.collectionAction();
        };
        _player.rentAction = ^{
            !weakSelf.rentAction ? : weakSelf.rentAction();
        };
    }
    return _player;
}

- (ZYElasticButton *)videoBtn{
    if(!_videoBtn){
        _videoBtn = [ZYElasticButton new];
        _videoBtn.backgroundColor = UIColor.clearColor;
        [_videoBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_video_normal"] forState:UIControlStateNormal];
        [_videoBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_video_normal"] forState:UIControlStateHighlighted];
        [_videoBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_video_selected"] forState:UIControlStateDisabled];
        _videoBtn.enabled = NO;
        
        __weak __typeof__(self) weakSelf = self;
        [_videoBtn clickAction:^(UIButton * _Nonnull button) {
            button.enabled = NO;
            weakSelf.imageBtn.enabled = YES;
            weakSelf.player.hidden = NO;
            weakSelf.banner.hidden = YES;
            weakSelf.numLab.hidden = YES;
            
            if(weakSelf.player.isPaused){
                [weakSelf.player play];
            }
        }];
    }
    return _videoBtn;
}

- (ZYElasticButton *)imageBtn{
    if(!_imageBtn){
        _imageBtn = [ZYElasticButton new];
        _imageBtn.backgroundColor = UIColor.clearColor;
        [_imageBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_image_normal"] forState:UIControlStateNormal];
        [_imageBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_image_normal"] forState:UIControlStateHighlighted];
        [_imageBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_image_selected"] forState:UIControlStateDisabled];
        
        __weak __typeof__(self) weakSelf = self;
        [_imageBtn clickAction:^(UIButton * _Nonnull button) {
            button.enabled = NO;
            weakSelf.videoBtn.enabled = YES;
            weakSelf.player.hidden = YES;
            weakSelf.banner.hidden = NO;
            weakSelf.numLab.hidden = NO;
            
            if(weakSelf.player.isPlaying){
                [weakSelf.player pause];
            }
        }];
    }
    return _imageBtn;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.font = FONT(13);
        _numLab.backgroundColor = HexRGB(0x7a7a7a);
        _numLab.cornerRadius = 10 * UI_H_SCALE;
        _numLab.textColor = UIColor.whiteColor;
        _numLab.clipsToBounds = YES;
        _numLab.hidden = YES;
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}

@end
