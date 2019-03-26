//
//  ZYContactUtils.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#if !TARGET_IPHONE_SIMULATOR

#import "ZYContactUtils.h"
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UIAlertView+ZYExtension.h"
#import "ZYAppUtils.h"

@implementation ZYContact @end


@interface ZYContactUtils ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
@property (nonatomic , strong) CNContactPickerViewController *contactPicker; //IOS9后用
#pragma clang diagnostic pop
@property (nonatomic , strong) ABPeoplePickerNavigationController *peoplePicker; //IOS7后用
@property (nonatomic , copy) ZYContactUtilsPickBlock pickBlock; //选择后回调

@end

@implementation ZYContactUtils

+ (instancetype) utils{
    static ZYContactUtils *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYContactUtils alloc] init];
    });
    
    return _instance;
}

#pragma mark - override
- (instancetype) init{
    if(self = [super init]){
        
    }
    return self;
}

#pragma mark - getter
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (CNContactPickerViewController *)contactPicker{
    if(!_contactPicker){
        _contactPicker = [CNContactPickerViewController new];
        _contactPicker.delegate = self;
        _contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];//只显示手机号
    }
    return _contactPicker;
}
#pragma clang diagnostic pop

- (ABPeoplePickerNavigationController *)peoplePicker{
    if(!_peoplePicker){
        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplePicker.peoplePickerDelegate = self;
        _peoplePicker.displayedProperties = @[[NSNumber numberWithInt:kABPersonPhoneProperty]];
    }
    return _peoplePicker;
}

#pragma mark - CNContactPickerDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *phoneStr = phoneNumber.stringValue;
    CNContact *contact = contactProperty.contact;
    !_pickBlock ? : _pickBlock(contact.givenName,contact.familyName,phoneStr);
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
}
#pragma clang diagnostic pop

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

//ios8走这个 选中联系人的某个属性的时候调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    // 获取该联系人多重属性--电话号
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    // 获取该联系人的名字，简单属性，只需ABRecordCopyValue取一次值
    ABMutableMultiValueRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *firstname = (__bridge NSString *)(firstName);
    ABMutableMultiValueRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *lastname = (__bridge NSString *)(lastName);
    
    __weak __typeof__(self) weakSelf = self;
    // 点击某个联系人电话后dismiss联系人控制器，并回调点击的数据
    [_peoplePicker dismissViewControllerAnimated:YES completion:^{
        // 从多重属性——电话号中取值，参数2是取点击的索引
        NSString *aPhone =  (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, ABMultiValueGetIndexForIdentifier(phoneMulti,identifier));
        !weakSelf.pickBlock ? : weakSelf.pickBlock(firstname,lastname,aPhone);
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([self respondsToSelector:@selector(peoplePickerNavigationController:shouldContinueAfterSelectingPerson:property:identifier:)]){
        [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
    }
#pragma clang diagnostic pop
}


#pragma mark - 获取读取权限
+ (BOOL)isAuthAddressBookWithRequire:(BOOL)should success:(void(^)(void))success{
    BOOL isAuth = NO;
    BOOL shouldRequest = NO;
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            if(should){
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (!error) {
                        !success ? : success();
                    }
                }];
            }
        }else if(status == CNAuthorizationStatusAuthorized) {
            isAuth = YES;
        }else if(status == CNAuthorizationStatusDenied){
            shouldRequest = YES;
        }
    } else {
        ABAddressBookRef bookref = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusNotDetermined) {
            if(should){
                ABAddressBookRequestAccessWithCompletion(bookref, ^(bool granted, CFErrorRef error) {
                    if (!error) {
                        !success ? : success();
                    }
                });
            }
        }else if (status == kABAuthorizationStatusAuthorized) {
            isAuth = YES;
        }else if(status == kABAuthorizationStatusDenied){
            shouldRequest = YES;
        }
    }
    if(shouldRequest){
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"请授权%@可以访问通讯录,设置方式:设置->%@->通讯录,允许%@访问通讯录",APP_NAME,APP_NAME,APP_NAME]
                                              cancelButtonTitle:@"暂不"
                                              otherButtonTitles:@[@"去设置"]
                                                    clickAction:^(NSInteger index) {
                                                        if(1 == index){
                                                            [ZYAppUtils openURL:UIApplicationOpenSettingsURLString];
                                                        }
                                                    }];
        [alert show];
    }
    if(isAuth){
        !success ? : success();
    }
    return isAuth;
}

#pragma mark - public
- (void) showWithViewController:(UIViewController *)viewController pickBlock:(ZYContactUtilsPickBlock)block{
    __weak __typeof__(self) weakSelf = self;
    [ZYContactUtils isAuthAddressBookWithRequire:YES success:^{
        weakSelf.pickBlock = block;
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(osVersion > 9.0){
            [viewController presentViewController:self.contactPicker
                                         animated:YES
                                       completion:^{
                                       }];
        }else{
            [viewController presentViewController:self.peoplePicker
                                         animated:YES
                                       completion:^{
                                       }];
        }
    }];
}

- (void) enumerateAllContactInfo:(void(^)(ZYContact *contact))block{
    [ZYContactUtils isAuthAddressBookWithRequire:YES success:^{
        ABAddressBookRef addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //获取所有联系人的数组
        CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
        //获取联系人总数
        CFIndex number = ABAddressBookGetPersonCount(addBook);
        //进行遍历
        for (NSInteger i=0; i<number; i++) {
            ZYContact *contact = [ZYContact new];
            //获取联系人对象的引用
            ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            contact.firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            //获取当前联系人姓氏
            contact.lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
            //获取当前联系人中间名
            contact.middleName = (__bridge NSString*)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
            //            //获取当前联系人的名字前缀
            //            NSString*prefix=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonPrefixProperty));
            //            //获取当前联系人的名字后缀
            //            NSString*suffix=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonSuffixProperty));
            //            //获取当前联系人的昵称
            //            NSString*nickName=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonNicknameProperty));
            //            //获取当前联系人的名字拼音
            //            NSString*firstNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonFirstNamePhoneticProperty));
            //            //获取当前联系人的姓氏拼音
            //            NSString*lastNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonLastNamePhoneticProperty));
            //            //获取当前联系人的中间名拼音
            //            NSString*middleNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonMiddleNamePhoneticProperty));
            //            //获取当前联系人的公司
            //            NSString*organization=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonOrganizationProperty));
            //            //获取当前联系人的职位
            //            NSString*job=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonJobTitleProperty));
            //            //获取当前联系人的部门
            //            NSString*department=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonDepartmentProperty));
            //            //获取当前联系人的生日
            //            NSString *birthday=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonBirthdayProperty));
            //            NSMutableArray * emailArr = [[NSMutableArray alloc]init];
            //            //获取当前联系人的邮箱 注意是数组
            //            ABMultiValueRef emails= ABRecordCopyValue(people, kABPersonEmailProperty);
            //            for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
            //                [emailArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, j))];
            //            }
            //            //获取当前联系人的备注
            //            NSString*notes=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonNoteProperty));
            //获取当前联系人的电话 数组
            NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
            ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
                if(!phone){
                    phone = @"";
                }
                [phoneArr addObject:phone];
            }
            contact.phones = phoneArr;
            !block ? : block(contact);
            //            //获取创建当前联系人的时间 注意是NSDate
            //            NSDate*creatTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonCreationDateProperty));
            //            //获取最近修改当前联系人的时间
            //            NSDate*alterTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonModificationDateProperty));
            //            //获取地址
            //            ABMultiValueRef address = ABRecordCopyValue(people, kABPersonAddressProperty);
            //            for (int j=0; j<ABMultiValueGetCount(address); j++) {
            //                //地址类型
            //                NSString * type = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(address, j));
            //                NSDictionary * temDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(address, j));
            //                //地址字符串，可以按需求格式化
            //                NSString * adress = [NSString stringWithFormat:@"国家:%@\n省:%@\n市:%@\n街道:%@\n邮编:%@",[temDic valueForKey:(NSString*)kABPersonAddressCountryKey],[temDic valueForKey:(NSString*)kABPersonAddressStateKey],[temDic valueForKey:(NSString*)kABPersonAddressCityKey],[temDic valueForKey:(NSString*)kABPersonAddressStreetKey],[temDic valueForKey:(NSString*)kABPersonAddressZIPKey]];
            //            }
            //            //获取当前联系人头像图片
            //            NSData*userImage=(__bridge NSData*)(ABPersonCopyImageData(people));
            //            //获取当前联系人纪念日
            //            NSMutableArray * dateArr = [[NSMutableArray alloc]init];
            //            ABMultiValueRef dates= ABRecordCopyValue(people, kABPersonDateProperty);
            //            for (NSInteger j=0; j<ABMultiValueGetCount(dates); j++) {
            //                //获取纪念日日期
            //                NSDate * data =(__bridge NSDate*)(ABMultiValueCopyValueAtIndex(dates, j));
            //                //获取纪念日名称
            //                NSString * str =(__bridge NSString*)(ABMultiValueCopyLabelAtIndex(dates, j));
            //                NSDictionary * temDic = [NSDictionary dictionaryWithObject:data forKey:str];
            //                [dateArr addObject:temDic];
            //            }
        }
    }];
}

@end


#endif
