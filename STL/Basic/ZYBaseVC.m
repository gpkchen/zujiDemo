//
//  ZYBaseVC.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"
#import "ZYBaseNC.h"
#import "ZYMacro.h"
#import "UIView+ZYExtension.h"
#import "UIButton+ZYExtension.h"

@interface ZYBaseVC ()

//处理侧滑返回临时变量
@property (nonatomic , strong) ZYBaseVC *backLastVC;
@property (nonatomic , strong) ZYBaseNC *backNC;
@property (nonatomic , assign) CGFloat backLastVCAlpha;
@property (nonatomic , assign) CGFloat backSelfVCAlpha;

@property (nonatomic , assign) BOOL isShowed; //是否显示过了

@property (nonatomic , strong) ZYErrorView *errorView;
@property (nonatomic , strong) ZYLoadingView *loadingView;

@property (nonatomic , strong) ZYHud *commonHud; //加载动画

@end

@implementation ZYBaseVC

@synthesize customNavigationBar = _customNavigationBar;

- (void)dealloc{
    
}

- (instancetype)init{
    if(self = [super init]){
        _navigationBarAlpha = 1;
        _shouldSwipeToBack = YES;
        _shouldShowBackBtn = YES;
        _isShowed = NO;
    }
    return self;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if(!_navigationBarAlpha){
        _shouldShowBackBtn = NO;
    }
    [self overrideBackBtn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if(!(self.navigationController &&
         self.navigationController.presentingViewController &&
         (self.navigationController.viewControllers.count == 1 && !_isShowed))){
        if(_navigationBarAlpha <= 0 && !self.navigationController.navigationBar.isHidden){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = YES;
            });
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.navigationController && [self.navigationController isKindOfClass:[ZYBaseNC class]]){
            [self setNavigationBarAlpha:self.navigationBarAlpha];
        }
    });
    
    _isShowed = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_showCustomNavigationBar){
        [self.view addSubview:self.customNavigationBar];
    }

    //第一个VC要提前隐藏导航栏
    if((self.navigationController.viewControllers.count == 1 && !_isShowed)){
        [self setNavigationBarAlpha:_navigationBarAlpha];
        if(_navigationBarAlpha <= 0 && !self.navigationController.navigationBar.isHidden){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = YES;
            });
        }
    }

    //如果vc有navigationController,那么subvc也有
    if(_navigationBarAlpha > 0 && [self.parentViewController isKindOfClass:[UINavigationController class]]){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.navigationBar.hidden = NO;
        });
    }

    //如果当前控制器present了一个vc，那么返回的时候要提前处理导航栏以维持效果
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.navigationController && self.navigationController.presentedViewController){
            if(self.navigationBarAlpha <= 0 && !self.navigationController.navigationBar.isHidden){
                [self setNavigationBarAlpha:self.navigationBarAlpha];
                self.navigationController.navigationBar.hidden = YES;
            }
        }
    });

    //友盟统计
    [ZYStatisticsService beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ZYStatisticsService endLogPageView:NSStringFromClass([self class])];
}

- (void)setTitle:(NSString *)title{
    if(_showCustomNavigationBar){
        self.customNavigationBar.title = title;
    }else{
        [super setTitle:title];
    }
}

#pragma mark - setter
- (void)setLeftBarItems:(NSArray *)leftBarItems{
    _leftBarItems = leftBarItems;
    
    for (NSObject *obj in leftBarItems) {
        if (![obj isKindOfClass:[NSString class]]
            && ![obj isKindOfClass:[UIImage class]]
            && ![obj isKindOfClass:[UIButton class]]) {
            _leftBarItems = nil;
            return;
        }
    }
    
    self.navigationItem.leftBarButtonItems = [self addBarItems:leftBarItems
                                                isLeftBarItems:YES];
}

- (void)setRightBarItems:(NSArray *)rightBarItems{
    _rightBarItems = rightBarItems;
    
    for (NSObject *obj in rightBarItems) {
        if (![obj isKindOfClass:[NSString class]]
            && ![obj isKindOfClass:[UIImage class]]
            && ![obj isKindOfClass:[UIButton class]]) {
            _rightBarItems = nil;
            return;
        }
    }
    
    self.navigationItem.rightBarButtonItems = [self addBarItems:rightBarItems
                                                 isLeftBarItems:NO];
}

- (void)setShowCustomNavigationBar:(BOOL)showCustomNavigationBar{
    _showCustomNavigationBar = showCustomNavigationBar;
    if(showCustomNavigationBar){
        self.navigationBarAlpha = 0;
    }
}

#pragma mark - 重写系统返回按钮
- (void)overrideBackBtn{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    if (self.navigationController.viewControllers.count > 1 && _shouldShowBackBtn) {
        UIImage *leftBtnImg = [UIImage imageNamed:@"zy_navigation_back_btn"];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        leftBtn.frame = CGRectMake(0, 0, 40 * UI_H_SCALE, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        [leftBtn setImage:leftBtnImg
                 forState:UIControlStateNormal];
        [leftBtn setImage:leftBtnImg
                 forState:UIControlStateHighlighted];
        [leftBtn addTarget:self
                    action:@selector(systemBackButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil
                                                                                   action:nil];
        spaceItem.width = 0;
        self.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];
    }else{
        self.navigationItem.leftBarButtonItems = nil;
    }
}

- (void)systemBackButtonClicked{
    if(self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 设置导航栏透明度
- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha{
    _navigationBarAlpha = navigationBarAlpha;
    if([self.navigationController isKindOfClass:[ZYBaseNC class]]){
        ZYBaseNC *nc = (ZYBaseNC *)self.navigationController;
        nc.alpha = navigationBarAlpha;
    }
}

#pragma mark - hud相关
- (void)showHud{
    if(!_commonHud){
        _commonHud = [ZYHud new];
    }
    [_commonHud show];
}

- (void)hideHud{
    if(_commonHud){
        [_commonHud dismiss];
    }
}

#pragma mark - 全屏加载动画相关
- (void)showLoadingView{
    if(self.loadingView.superview){
        [self.loadingView removeFromSuperview];
    }
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.loadingView startAnimation];
    
    if(_showCustomNavigationBar && [self.view isEqual:self.customNavigationBar.superview]){
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}

- (void)hideLoadingView{
    if(self.loadingView.superview){
        [self.loadingView stopAnimation];
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - 错误视图相关
- (void)hideErrorView{
    if(self.errorView.superview){
        [self.errorView removeFromSuperview];
    }
}

- (void)showErrorViewWithImage:(UIImage *)image
                      contentY:(CGFloat)contentY
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(ZYErrorViewButtonAction)buttonAvction{
    if(self.errorView.superview){
        [self.errorView removeFromSuperview];
    }
    self.errorView.image = image;
    self.errorView.buttonTitle = buttonTitle;
    self.errorView.contentY = contentY;
    self.errorView.buttonAction = buttonAvction;
    
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if(_showCustomNavigationBar && [self.view isEqual:self.customNavigationBar.superview]){
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}

- (void)showNetTimeOutView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nettimeout"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"重新加载"
                    buttonAction:buttonAction];
}

- (void)showNoNetView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nonet"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"重新加载"
                    buttonAction:buttonAction];
}

- (void)showSystemErrorView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_serverbroken"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"稍后加载"
                    buttonAction:buttonAction];
}

- (void)showNoCollectionView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nocollection"]
                        contentY:NAVIGATION_BAR_HEIGHT + 58 * UI_H_SCALE
                     buttonTitle:@"去逛逛"
                    buttonAction:buttonAction];
}

- (void)showNoMessageView{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nomessage"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:nil
                    buttonAction:nil];
}

- (void)showNoBillView{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nobill"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:nil
                    buttonAction:nil];
}

- (void)showNoCouponView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nocoupon"]
                        contentY:NAVIGATION_BAR_HEIGHT + 58 * UI_H_SCALE
                     buttonTitle:@"去逛逛"
                    buttonAction:buttonAction];
}

- (void)showNoAddressView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_noaddress"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"去添加"
                    buttonAction:buttonAction];
}

- (void)showNoOrderView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_noorder"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"去逛逛"
                    buttonAction:buttonAction];
}

- (void)showPassAuthView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_passauth"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:@"返回首页"
                    buttonAction:buttonAction];
}

- (void)showNoStoreView{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_no_store"]
                        contentY:NAVIGATION_BAR_HEIGHT + 20 * UI_H_SCALE
                     buttonTitle:nil
                    buttonAction:nil];
}

- (void)showNoSearchResultView{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nosearchresult"]
                        contentY:NAVIGATION_BAR_HEIGHT + 110 * UI_H_SCALE
                     buttonTitle:nil
                    buttonAction:nil];
}

- (void)showNoLimitRecordView:(ZYErrorViewButtonAction)buttonAction{
    [self showErrorViewWithImage:[UIImage imageNamed:@"zy_error_nolimitrecord"]
                        contentY:NAVIGATION_BAR_HEIGHT + 110 * UI_H_SCALE
                     buttonTitle:@"去认证生成记录"
                    buttonAction:buttonAction];
}

#pragma mark - getter
- (BOOL)isVisiable{
    return (self.isViewLoaded && self.view.window);
}

- (ZYErrorView *)errorView{
    if(!_errorView){
        _errorView = [ZYErrorView new];
    }
    return _errorView;
}

- (ZYLoadingView *)loadingView{
    if(!_loadingView){
        _loadingView = [ZYLoadingView new];
    }
    return _loadingView;
}

- (ZYCustomNavigationBar *)customNavigationBar{
    if(!_customNavigationBar){
        _customNavigationBar = [ZYCustomNavigationBar new];
    }
    return _customNavigationBar;
}

#pragma mark - private methods
- (NSMutableArray *)addBarItems:(NSArray *)array
                 isLeftBarItems:(BOOL)isLeftBarItems{
    NSMutableArray *items = [NSMutableArray array];
    for (NSObject *obj in array) {
        UIButton *button = nil;
        NSUInteger index = [array indexOfObject:obj];
        
        if ([obj isKindOfClass:[NSString class]]) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.font = FONT(14);
            [button setTitle:(NSString *)obj
                    forState:UIControlStateNormal];
            [button setTitleColor:WORD_COLOR_BLACK
                         forState:UIControlStateNormal];
            [button setTitleColor:WORD_COLOR_BLACK
                         forState:UIControlStateHighlighted];
            [button sizeToFit];
            if(isLeftBarItems){
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else{
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
            CGFloat width = button.width;
            if(width < 30){
                width = 30;
            }
            button.size = CGSizeMake(width, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        }else if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)obj;
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            if(isLeftBarItems){
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else{
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
            CGFloat width = image.size.width;
            if(width < 30){
                width = 30;
            }
            button.size = CGSizeMake(width, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
            [button setImage:image
                    forState:UIControlStateNormal];
            [button setImage:image
                    forState:UIControlStateHighlighted];
        }else if ([obj isKindOfClass:[UIButton class]]) {
            button = (UIButton *)obj;
        }
        button.tag = index + 100;
        if (isLeftBarItems) {
            [button addTarget:self
                       action:@selector(leftBarItemsClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        }else {
            [button addTarget:self
                       action:@selector(rightBarItemsClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                   target:nil
//                                                                                   action:nil];
//        if(0 == index){
//            spaceItem.width = -5;
//        }else{
//            spaceItem.width = 20;
//        }
        
//        [items addObject:spaceItem];
        [items addObject:item];
    }
    
    return items;
}

- (void)leftBarItemsClicked:(UIButton *)button{
    [self leftBarItemsAction:(int)button.tag - 100];
}
- (void)rightBarItemsClicked:(UIButton *)button{
    [self rightBarItemsAction:(int)button.tag - 100];
}

#pragma mark - 自定义按钮事件(用于继承重载)
- (void)leftBarItemsAction:(int)index{}
- (void)rightBarItemsAction:(int)index{}



@end
