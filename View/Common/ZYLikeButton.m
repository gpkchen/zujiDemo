//
//  ZYLikeButton.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLikeButton.h"
#import "OptUserReleaseZan.h"
#import "OptNewsZan.h"

@interface ZYLikeButton()

@property (nonatomic , strong) UIImage *normalImg;
@property (nonatomic , strong) UIImage *likedImg;

@end

@implementation ZYLikeButton

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        _normalImg = [UIImage imageNamed:@"zy_like_btn_normal"];
        _likedImg = [UIImage imageNamed:@"zy_like_btn_liked"];
        
        [self setImage:_normalImg forState:UIControlStateNormal];
        [self setImage:_normalImg forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [self clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] requireLogin:^{
                if(weakSelf.contentSource == ZYArticleSourceUser){
                    [weakSelf likeUserContent];
                }else if(weakSelf.contentSource == ZYArticleSourceOfficial){
                    [weakSelf likeOfficialContent];
                }
                weakSelf.isLiked = !weakSelf.isLiked;
                !weakSelf.actionResult ? : weakSelf.actionResult(weakSelf.isLiked);
            }];
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setIsLiked:(BOOL)isLiked{
    _isLiked = isLiked;
    
    if(isLiked){
        [self setImage:_likedImg forState:UIControlStateNormal];
        [self setImage:_likedImg forState:UIControlStateHighlighted];
    }else{
        [self setImage:_normalImg forState:UIControlStateNormal];
        [self setImage:_normalImg forState:UIControlStateHighlighted];
    }
}

- (CGSize)originSize{
    return _normalImg.size;
}

#pragma mark - 用户发布内容点赞
- (void)likeUserContent{
    _p_OptUserReleaseZan *param = [_p_OptUserReleaseZan new];
    param.userReleaseId = _contentId;
    param.status = _isLiked ? @"2" : @"1";
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        } authFail:nil];
}

#pragma mark - 官方咨询内容点赞
- (void)likeOfficialContent{
    _p_OptNewsZan *param = [_p_OptNewsZan new];
    param.newsId = _contentId;
    param.status = _isLiked ? @"2" : @"1";
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        } authFail:nil];
}

@end
