//
//  ZYPublishMomentVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPublishMomentVC.h"
#import "ZYPublishMomentView.h"
#import "ZYPublishMomentCell.h"
#import "ZYPublishMomentHeader.h"
#import "YBImageBrowser.h"
#import "ZYUploadImage.h"
#import "AddUserRelease.h"
#import "ZYMomentsDB.h"

static NSString * const kPublishMomentCellIdentifier = @"kPublishMomentCellIdentifier";
static NSString * const kPublishMomentHeaderIdentifier = @"kPublishMomentHeaderIdentifier";

@interface ZYPublishMomentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) ZYPublishMomentView *baseView;

@property (nonatomic , copy) NSString *content;
@property (nonatomic , strong) NSMutableArray *imageArr;

@end

@implementation ZYPublishMomentVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZYMoment *dbMoment = [ZYMomentsDB readMoment];
    _content = dbMoment.content;
    _imageArr = [NSMutableArray arrayWithArray:dbMoment.images];
    [self checkPublishEnable];
    
    self.view = self.baseView;
    self.title = @"发布内容";
    self.shouldSwipeToBack = NO;
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)systemBackButtonClicked{
    [self.baseView endEditing:YES];
    __weak __typeof__(self) weakSelf = self;
    if(_content.length || _imageArr.count){
        [ZYAlert showWithTitle:nil
                       content:@"确定要取消发布？"
                  buttonTitles:@[@"保存并退出",@"继续编辑"]
                  buttonAction:^(ZYAlert *alert, int index) {
                      if(0 == index){
                          ZYMoment *moment = [ZYMoment new];
                          moment.content = weakSelf.content;
                          moment.images = weakSelf.imageArr;
                          [ZYMomentsDB saveMoment:moment];
                          [super systemBackButtonClicked];
                      }
                      [alert dismiss];
                  }];
    }else{
        [super systemBackButtonClicked];
    }
}

#pragma mark - 监听键盘弹出
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.baseView.publishBtn.bottom = endFrame.origin.y;
}

#pragma mark - 监听键盘消失
- (void)keyboardWillHidden:(NSNotification *)notification{
    self.baseView.publishBtn.bottom = SCREEN_HEIGHT - DOWN_DANGER_HEIGHT;
}

#pragma mark - 上传图像
- (void)uploadImg:(UIImage *)image{
    if(image){
        //把图片转成NSData类型的数据来保存文件
        NSData *data=UIImageJPEGRepresentation(image, 0.3);
        _p_ZYUploadImage *parm = [[_p_ZYUploadImage alloc] init];
        parm.scene = @"news/img";
        [[ZYHttpClient client] upload:parm showHUD:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"uploadFile"
                                    fileName:[NSString stringWithFormat:@"%lld.jpeg",[[NSDate date] millisecondSince1970]]
                                    mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
            if(responseObj.success){
                _m_ZYUploadImage *model = [_m_ZYUploadImage mj_objectWithKeyValues:responseObj.data];
                [self.imageArr addObject:model.url];
                [self.baseView.collectionView reloadData];
            } else {
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
}

#pragma mark - 发布
- (void)publish{
    if(!self.content.length){
        [ZYToast showWithTitle:@"写点什么吧 >_<"];
        return;
    }
    _p_AddUserRelease *param = [_p_AddUserRelease new];
    param.content = self.content.length ? self.content : nil;
    param.images = self.imageArr;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [ZYAlert showWithTitle:@"发布成功"
                                               content:@"你可以在个人中心查看你所发布的内容哦"
                                          buttonTitles:@[@"我知道啦"]
                                          buttonAction:^(ZYAlert *alert, int index) {
                                              [alert dismiss];
                                          }];
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                [ZYAlert showWithTitle:@"发布失败TAT"
                                               content:@"可以再试一次吧"
                                          buttonTitles:@[@"好哒"]
                                          buttonAction:^(ZYAlert *alert, int index) {
                                              [alert dismiss];
                                          }];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [ZYAlert showWithTitle:@"发布失败TAT"
                                           content:@"可以再试一次吧"
                                      buttonTitles:@[@"好哒"]
                                      buttonAction:^(ZYAlert *alert, int index) {
                                          [alert dismiss];
                                      }];
                        } authFail:nil];
}

#pragma mark - 处理按钮状态
- (void)checkPublishEnable{
    if(self.content.length){
        [self.baseView.publishBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [self.baseView.publishBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }else{
        [self.baseView.publishBtn setBackgroundColor:HexRGB(0x7EDCA6) forState:UIControlStateNormal];
        [self.baseView.publishBtn setBackgroundColor:HexRGB(0x7EDCA6) forState:UIControlStateHighlighted];
    }
}

#pragma mark - 调起相机
- (void)callCamera{
    __weak __typeof__(self) weakSelf = self;
    [[ZYPhotoUtils utils] callCamera:weakSelf
                            callback:^(UIImage *image) {
                                [weakSelf uploadImg:image];
                            }];
}

#pragma mark - 调起相册
- (void)callAlbum{
    __weak __typeof__(self) weakSelf = self;
    [[ZYPhotoUtils utils] callAlbum:weakSelf
                           callback:^(UIImage *image) {
                               [weakSelf uploadImg:image];
                           }];
}


#pragma mark - UICollectionViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.baseView endEditing:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.baseView endEditing:YES];
    
    __weak __typeof__(self) weakSelf = self;
    if(indexPath.row >= self.imageArr.count){
        //点击了添加项
        ZYSheetMenu *menu = [ZYSheetMenu new];
        menu.dateArr = @[@"从手机中选择",@"拍摄照片"];
        [menu selectionAction:^(NSUInteger index) {
            if(0 == index){
                [weakSelf callAlbum];
            }else{
                [weakSelf callCamera];
            }
        }];
        [menu show];
    }else{
        NSMutableArray *tempArr = [NSMutableArray array];
        [self.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowserModel *model = [YBImageBrowserModel new];
            model.url = [NSURL URLWithString:obj];
            ZYPublishMomentCell *cell = (ZYPublishMomentCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            model.sourceImageView = cell.iv;
            model.previewModel = [YBImageBrowserModel new];
            model.previewModel.image = cell.iv.image;
            
            [tempArr addObject:model];
        }];
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataArray = tempArr;
        browser.currentIndex = indexPath.row;
        [browser show];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count >= 9 ? self.imageArr.count : self.imageArr.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYPublishMomentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPublishMomentCellIdentifier forIndexPath:indexPath];
    
    __weak __typeof__(self) weakSelf = self;
    if(indexPath.row < self.imageArr.count){
        //添加了的图片
        NSString *url = self.imageArr[indexPath.row];
        url = [url imageStyleUrlNoCut:CGSizeMake(ZYPublishMomentCellSize * 2, ZYPublishMomentCellSize * 2)];
        [cell.iv loadImage:url];
        cell.removeBtn.hidden = NO;
        [cell.removeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf.imageArr removeObjectAtIndex:indexPath.row];
            [weakSelf.baseView.collectionView reloadData];
        }];
    }else{
        //添加项
        cell.iv.image = [UIImage imageNamed:@"zy_found_publish_add_image"];
        cell.removeBtn.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        ZYPublishMomentHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPublishMomentHeaderIdentifier forIndexPath:indexPath];
        __weak __typeof__(self) weakSelf = self;
        header.textView.text = _content;
        header.block = ^(NSString *content) {
            weakSelf.content = content;
            [weakSelf checkPublishEnable];
        };
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ZYPublishMomentCellSize, ZYPublishMomentCellSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(11 * UI_H_SCALE, 15 * UI_H_SCALE, 11 * UI_H_SCALE, 15 * UI_H_SCALE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5 * UI_H_SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7 * UI_H_SCALE;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, ZYPublishMomentHeaderHeight);
}

#pragma mark - getter
- (ZYPublishMomentView *)baseView{
    if(!_baseView){
        _baseView = [ZYPublishMomentView new];
        _baseView.collectionView.delegate = self;
        _baseView.collectionView.dataSource = self;
        [_baseView.collectionView registerClass:[ZYPublishMomentCell class]
                     forCellWithReuseIdentifier:kPublishMomentCellIdentifier];
        [_baseView.collectionView registerClass:[ZYPublishMomentHeader class]
                         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                withReuseIdentifier:kPublishMomentHeaderIdentifier];
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.publishBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"publish_publish"];
            [weakSelf.baseView endEditing:YES];
            [weakSelf publish];
        }];
    }
    return _baseView;
}

- (NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

@end
