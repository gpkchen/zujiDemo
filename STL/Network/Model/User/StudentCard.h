//
//  StudentCard.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**上传学生证信息参数*/
@interface _p_StudentCard : ZYBaseParam

/**学校名*/
@property (nonatomic , copy) NSString *schoolName;
/**学校Id*/
@property (nonatomic , copy) NSString *schoolId;
/**学历 1：高中 2：本科 3：大专 4：硕士 5：博士 6：其他*/
@property (nonatomic , copy) NSString *education;
/**入学时间*/
@property (nonatomic , copy) NSString *inDate;
/**毕业时间*/
@property (nonatomic , copy) NSString *outDate;
/**学生证路径*/
@property (nonatomic , copy) NSString *cardUrl;

@end
