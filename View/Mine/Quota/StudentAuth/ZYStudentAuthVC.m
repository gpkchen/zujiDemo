//
//  ZYStudentAuthVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStudentAuthVC.h"
#import "ZYStudentAuthView.h"
#import "ZYStudentAuthCell.h"
#import "ZYStudentAuthFooter.h"
#import "ZYUploadImage.h"
#import "ZYStudentAuthMenu.h"
#import "ZYStudentSchoolListView.h"
#import "PulldownSchool.h"
#import "StudentCard.h"
#import "ZYQuotaService.h"

@interface ZYStudentAuthVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYStudentAuthView *baseView;
@property (nonatomic , strong) ZYStudentAuthFooter *footer;
@property (nonatomic , strong) ZYStudentSchoolListView *schoolListView;

@property (nonatomic , strong) NSURLSessionDataTask *searchSchoolTask; //搜索学校请求

@property (nonatomic , strong) NSArray *educationArr; //学历
@property (nonatomic , strong) NSArray *educationMap; //学历对应键值
@property (nonatomic , strong) NSArray *inDateArr; //入学时间
@property (nonatomic , strong) NSArray *outDateArr; //毕业时间

@property (nonatomic , copy) NSString *schoolName; //选择的学校名
@property (nonatomic , strong) _m_PulldownSchool *selectedSchool; //选中的学校
@property (nonatomic , copy) NSString *cardUrl; //选择的学生证地址
@property (nonatomic , copy) NSString *education; //选择的学历 1：高中 2：本科 3：大专 4：硕士 5：博士 6：其他
@property (nonatomic , copy) NSString *inDate; //选择的入学年份 不带单位
@property (nonatomic , copy) NSString *outDate; //选择的毕业年份 不带单位

@end

@implementation ZYStudentAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"在校学生认证";
}

#pragma mark - 上传信息
- (void)uploadInfo{
    if(!_schoolName){
        [ZYToast showWithTitle:@"请先输入学校"];
        return;
    }
    if(!_education){
        [ZYToast showWithTitle:@"请先选择学历"];
        return;
    }
    if(!_inDate){
        [ZYToast showWithTitle:@"请先选择入学年份"];
        return;
    }
    if(!_outDate){
        [ZYToast showWithTitle:@"请先选择毕业年份"];
        return;
    }
    if(!_cardUrl){
        [ZYToast showWithTitle:@"请先上传学生证正面照片"];
        return;
    }
    _p_StudentCard *param = [_p_StudentCard new];
    param.schoolName = _schoolName;
    param.schoolId = _selectedSchool.schoolId;
    param.education = _education;
    param.inDate = _inDate;
    param.outDate = _outDate;
    param.cardUrl = _cardUrl;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [ZYQuotaService startAuthing:nil success:^{
                                    [ZYToast showWithTitle:@"学生认证信息上传成功！"];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
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

#pragma mark - 模糊查询学校
- (void)searchSchool{
    _p_PulldownSchool *param = [_p_PulldownSchool new];
    param.str = _schoolName;
    _searchSchoolTask = [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                if(self.searchSchoolTask && [self.searchSchoolTask isEqual:task]){
                                    NSMutableArray *schools = [_m_PulldownSchool mj_objectArrayWithKeyValuesArray:responseObj.data[@"list"]];
                                    self.schoolListView.schools = schools;
                                    if(schools.count){
                                        self.schoolListView.hidden = NO;
                                        [self.baseView.tableView bringSubviewToFront:self.schoolListView];
                                    }else{
                                        self.schoolListView.hidden = YES;
                                    }
                                }
                            }
                        } failure:nil authFail:nil];
}

#pragma mark - 上传图像
- (void)uploadImg:(UIImage *)image{
    if(image){
        //把图片转成NSData类型的数据来保存文件
        NSData *data=UIImageJPEGRepresentation(image, 0.3);
        _p_ZYUploadImage *parm = [[_p_ZYUploadImage alloc] init];
        parm.scene = @"user/student";
        [[ZYHttpClient client] upload:parm showHUD:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"uploadFile"
                                    fileName:[NSString stringWithFormat:@"%lld.jpeg",[[NSDate date] millisecondSince1970]]
                                    mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
            if(responseObj.success){
                _m_ZYUploadImage *model = [_m_ZYUploadImage mj_objectWithKeyValues:responseObj.data];
                self.cardUrl = model.url;
                self.footer.cardIV.image = image;
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

#pragma mark - 学校名输入改变监听
- (void)schoolNameChanges:(ZYTextField *)textField{
    _schoolName = textField.text;
    [self searchSchool];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYStudentAuthVCCell";
    ZYStudentAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYStudentAuthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textField addTarget:self action:@selector(schoolNameChanges:) forControlEvents:UIControlEventEditingChanged];
    }
    
    cell.separator.hidden = indexPath.row == 0;
    if(indexPath.row == 0){
        cell.showArrow = NO;
        cell.textField.hidden = NO;
    }else{
        cell.showArrow = YES;
        cell.textField.hidden = YES;
    }
    
    if(0 == indexPath.row){
        cell.titleLab.text = @"学校";
        cell.contentLab.text = @"";
        cell.textField.text = _schoolName;
    }else if(1 == indexPath.row){
        cell.titleLab.text = @"学历";
        if(_education){
            cell.contentLab.text = self.educationArr[[self.educationMap indexOfObject:_education]];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else{
            cell.contentLab.text = @"请选择";
            cell.contentLab.textColor = WORD_COLOR_GRAY;
        }
    }else if(2 == indexPath.row){
        cell.titleLab.text = @"入学年份";
        if(_inDate){
            cell.contentLab.text = [NSString stringWithFormat:@"%@年",_inDate];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else{
            cell.contentLab.text = @"请选择";
            cell.contentLab.textColor = WORD_COLOR_GRAY;
        }
    }else if(3 == indexPath.row){
        cell.titleLab.text = @"毕业年份";
        if(_outDate){
            cell.contentLab.text = [NSString stringWithFormat:@"%@年",_outDate];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else{
            cell.contentLab.text = @"请选择";
            cell.contentLab.textColor = WORD_COLOR_GRAY;
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.baseView endEditing:YES];
    self.schoolListView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYStudentAuthCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ZYStudentAuthFooterHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.baseView endEditing:YES];
    self.schoolListView.hidden = YES;
    
    if(0 == indexPath.row){
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    ZYStudentAuthMenu *menu = [ZYStudentAuthMenu new];
    if(1 == indexPath.row){
        //学历
        menu.titles = self.educationArr;
        menu.selectedIndex = _education ? (int)[self.educationMap indexOfObject:_education] : -1;
        menu.selectAction = ^(int index) {
            weakSelf.education = weakSelf.educationMap[index];
            [weakSelf.baseView.tableView reloadData];
        };
        
    }else if(2 == indexPath.row){
        //入学年份
        int year = (int)[[NSDate date] getYearValue];
        menu.selectedIndex = _inDate ? year - [_inDate intValue] : -1;
        menu.titles = self.inDateArr;
        menu.selectAction = ^(int index) {
            weakSelf.inDate = [NSString stringWithFormat:@"%d",year - index];
            [weakSelf.baseView.tableView reloadData];
        };
    }else if(3 == indexPath.row){
        //毕业年份
        int year = (int)[[NSDate date] getYearValue];
        menu.selectedIndex = _outDate ? [_outDate intValue] - year : -1;
        menu.titles = self.outDateArr;
        menu.selectAction = ^(int index) {
            weakSelf.outDate = [NSString stringWithFormat:@"%d",year + index];
            [weakSelf.baseView.tableView reloadData];
        };
    }
    [menu show];
}

#pragma mark - getter
- (ZYStudentAuthView *)baseView{
    if(!_baseView){
        _baseView = [ZYStudentAuthView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addSubview:self.schoolListView];
        self.schoolListView.selectAction = ^(_m_PulldownSchool *school) {
            weakSelf.selectedSchool = school;
            weakSelf.schoolName = school.schoolName;
            weakSelf.schoolListView.hidden = YES;
            [weakSelf.baseView.tableView reloadData];
        };
    }
    return _baseView;
}

- (ZYStudentAuthFooter *)footer{
    if(!_footer){
        _footer = [ZYStudentAuthFooter new];
        
        __weak __typeof__(self) weakSelf = self;
        [_footer.cardIV tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYPhotoUtils utils] callCamera:weakSelf
                                    callback:^(UIImage *image) {
                                        [weakSelf uploadImg:image];
                                    }];
        } delegate:nil];
        
        [_footer.submitBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf uploadInfo];
            self.schoolListView.hidden = YES;
        }];
    }
    return _footer;
}

- (NSArray *)educationArr{
    if(!_educationArr){
        _educationArr = @[@"博士",@"硕士",@"本科",@"大专",@"高中",@"其他"];
    }
    return _educationArr;
}

- (NSArray *)educationMap{
    if(!_educationMap){
        _educationMap = @[@"5",@"4",@"2",@"3",@"1",@"6"];
    }
    return _educationMap;
}

- (NSArray *)inDateArr{
    if(!_inDateArr){
        int year = (int)[[NSDate date] getYearValue];
        _inDateArr = @[[NSString stringWithFormat:@"%d年",year],
                       [NSString stringWithFormat:@"%d年",year - 1],
                       [NSString stringWithFormat:@"%d年",year - 2],
                       [NSString stringWithFormat:@"%d年",year - 3],
                       [NSString stringWithFormat:@"%d年",year - 4],
                       [NSString stringWithFormat:@"%d年",year - 5],
                       [NSString stringWithFormat:@"%d年",year - 6],
                       [NSString stringWithFormat:@"%d年",year - 7]];
    }
    return _inDateArr;
}

- (NSArray *)outDateArr{
    if(!_outDateArr){
        int year = (int)[[NSDate date] getYearValue];
        _outDateArr = @[[NSString stringWithFormat:@"%d年",year],
                       [NSString stringWithFormat:@"%d年",year + 1],
                       [NSString stringWithFormat:@"%d年",year + 2],
                       [NSString stringWithFormat:@"%d年",year + 3],
                       [NSString stringWithFormat:@"%d年",year + 4],
                       [NSString stringWithFormat:@"%d年",year + 5],
                       [NSString stringWithFormat:@"%d年",year + 6],
                       [NSString stringWithFormat:@"%d年",year + 7]];
    }
    return _outDateArr;
}

- (ZYStudentSchoolListView *)schoolListView{
    if(!_schoolListView){
        _schoolListView = [ZYStudentSchoolListView new];
        _schoolListView.hidden = YES;
    }
    return _schoolListView;
}

@end
