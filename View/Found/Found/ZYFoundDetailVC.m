//
//  ZYFoundDetailVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundDetailVC.h"
#import "ShareArticle.h"
#import "ZYLikeButton.h"
#import "NewsOrUserReleaseZanDetail.h"

@interface ZYFoundDetailVC ()

//埋点
@property (nonatomic , assign) long long beginTime; //浏览开始时间（用于统计）

@property (nonatomic , strong) UIView *tooBar;
@property (nonatomic , strong) ZYLikeButton *likeBtn;
@property (nonatomic , strong) NSMutableArray *likedAvatarIVArr;//点赞头像列表
@property (nonatomic , strong) UILabel *likeNumLab;

@property (nonatomic , strong) _m_NewsOrUserReleaseZanDetail *likeInfo;

@end

@implementation ZYFoundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBarItems = @[[UIImage imageNamed:@"zy_found_share_btn"]];
    
    if(!_sourceId){
        _sourceId = self.dicParam[@"sourceId"];
    }
    if(!_source){
        _source = self.dicParam[@"source"];
    }
    
    [self.view addSubview:self.tooBar];
    [self.tooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(48 * UI_H_SCALE + DOWN_DANGER_HEIGHT);
    }];
    
    self.likeBtn.contentSource = [_source intValue];
    self.likeBtn.contentId = _sourceId;
    [self.tooBar addSubview:self.likeBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.tooBar);
        make.size.mas_equalTo(CGSizeMake(self.likeBtn.originSize.width + 40 * UI_H_SCALE,
                                         48 * UI_H_SCALE));
    }];
    
    [self.tooBar addSubview:self.likeNumLab];
    [self.likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeBtn);
        make.left.equalTo(self.tooBar).mas_offset(15 * UI_H_SCALE);
    }];
    
    for(int i=0;i<5;++i){
        UIImageView *iv = [UIImageView new];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.cornerRadius = 10 * UI_H_SCALE;
        iv.borderColor = UIColor.whiteColor;
        iv.borderWidth = 1;
        iv.hidden = YES;
        iv.backgroundColor = HexRGB(0xd8d8d8);
        
        [self.tooBar addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20 * UI_H_SCALE, 20 * UI_H_SCALE));
            make.left.equalTo(self.tooBar).mas_offset(59 * UI_H_SCALE - i * 11 * UI_H_SCALE);
            make.centerY.equalTo(self.likeBtn.mas_top).mas_offset(24 * UI_H_SCALE);
        }];
        
        [self.likedAvatarIVArr addObject:iv];
    }
    
    self.likedAvatarIVArr = [NSMutableArray arrayWithArray:[[self.likedAvatarIVArr reverseObjectEnumerator] allObjects]];
    
    self.webViewInsets = UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 48 * UI_H_SCALE + DOWN_DANGER_HEIGHT, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _beginTime = [[NSDate date] millisecondSince1970];
    [self loadLikeInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    long long now = [[NSDate date] millisecondSince1970];
    if([_source intValue] == ZYArticleSourceOfficial){
        [ZYStatisticsService event:@"found_recommenddetail" durations:(int)(now - _beginTime)];
    }else if([_source intValue] == ZYArticleSourceUser){
        [ZYStatisticsService event:@"found_momentdetail" durations:(int)(now - _beginTime)];
    }
}

- (void)rightBarItemsAction:(int)index{
    _p_ShareArticle *param = [_p_ShareArticle new];
    param.sourceId = _sourceId;
    param.source = _source;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_ShareArticle *model = [_m_ShareArticle mj_objectWithKeyValues:responseObj.data];
                                [[ZYRouter router] go:model.url];
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

#pragma mark - 查询点赞信息
- (void)loadLikeInfo{
    _p_NewsOrUserReleaseZanDetail *param = [_p_NewsOrUserReleaseZanDetail new];
    param.sourceId = _sourceId;
    param.source = _source;
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.likeInfo = [_m_NewsOrUserReleaseZanDetail mj_objectWithKeyValues:responseObj.data];
                                self.likeBtn.hidden = NO;
                                self.likeBtn.isLiked = self.likeInfo.isZan == 1;
                                
                                self.likeNumLab.hidden = NO;
                                self.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",self.likeInfo.zanAmount];
                                [self showLikeAvatars:self.likeInfo.zanAvatars];
                                
                                void (^callback)(BOOL isLike,int likeNum, NSMutableArray *avatars) = self.callBack;
                                !callback ? : callback(self.likeInfo.isZan == 1,self.likeInfo.zanAmount,self.likeInfo.zanAvatars);
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
            make.left.equalTo(self.tooBar).mas_offset(42 * UI_H_SCALE + (count - 1) * 11 * UI_H_SCALE);
        }];
    }else{
        [self.likeNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tooBar).mas_offset(15 * UI_H_SCALE);
        }];
    }
}

#pragma mark - getter
- (UIView *)tooBar{
    if(!_tooBar){
        _tooBar = [UIView new];
        _tooBar.backgroundColor = [UIColor whiteColor];
        _tooBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _tooBar.layer.shadowOpacity = 0.05;
        _tooBar.layer.shadowOffset = CGSizeMake(0, -1);
    }
    return _tooBar;
}

- (ZYLikeButton *)likeBtn{
    if(!_likeBtn){
        _likeBtn = [ZYLikeButton new];
        _likeBtn.hidden = YES;
        
        __weak __typeof__(self) weakSelf = self;
        _likeBtn.actionResult = ^(BOOL isLiked) {
            if(isLiked){
                weakSelf.likeInfo.zanAmount++;
                weakSelf.likeInfo.isZan = 1;
                weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",weakSelf.likeInfo.zanAmount];
                
                [weakSelf.likeInfo.zanAvatars insertObject:@{@"avatar":[ZYUser user].portraitPath} atIndex:0];
                [weakSelf showLikeAvatars:weakSelf.likeInfo.zanAvatars];
            }else{
                weakSelf.likeInfo.zanAmount--;
                weakSelf.likeInfo.isZan = 2;
                weakSelf.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",weakSelf.likeInfo.zanAmount];
                
                for(int i=0;i<weakSelf.likeInfo.zanAvatars.count;++i){
                    NSDictionary *dic = weakSelf.likeInfo.zanAvatars[i];
                    if([dic[@"avatar"] isEqualToString:[ZYUser user].portraitPath]){
                        [weakSelf.likeInfo.zanAvatars removeObjectAtIndex:i];
                        break;
                    }
                }
                [weakSelf showLikeAvatars:weakSelf.likeInfo.zanAvatars];
            }
            void (^callback)(BOOL isLike,int likeNum, NSMutableArray *avatars) = weakSelf.callBack;
            !callback ? : callback(isLiked,weakSelf.likeInfo.zanAmount,weakSelf.likeInfo.zanAvatars);
        };
        
        self.likeNumLab.text = [NSString stringWithFormat:@"%d人赞",weakSelf.likeInfo.zanAmount];
    }
    return _likeBtn;
}

- (UILabel *)likeNumLab{
    if(!_likeNumLab){
        _likeNumLab = [UILabel new];
        _likeNumLab.hidden = YES;
        _likeNumLab.font = FONT(14);
        _likeNumLab.textColor = WORD_COLOR_GRAY_9B;
    }
    return _likeNumLab;
}

- (NSMutableArray *)likedAvatarIVArr{
    if(!_likedAvatarIVArr){
        _likedAvatarIVArr = [NSMutableArray array];
    }
    return _likedAvatarIVArr;
}

@end
