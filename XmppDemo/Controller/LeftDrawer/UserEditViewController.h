//
//  UserEditViewController.h
//  YinKa
//
//  Created by IntelcentMacMini on 16/10/7.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    UserEditTypeForNickname  = 1,
    UserEditTypeForSexType   = 2,

} UserEditType;


@interface UserEditViewController : BaseViewController

@property (nonatomic, retain) NSString *tmpNickName;   //当前显示昵称
@property (nonatomic, retain) NSString *tmpSexName;    //当前显示性别

@property (nonatomic, copy) void(^nickNameEditBlock)(NSString *name);   /**<昵称编辑回调*/
@property (nonatomic, copy) void(^sexTypeEditBlock)(NSString *sexType, NSString *sexName);  /**<性别编辑回调 0-未知 1-男 2-女 */
@property (nonatomic, copy) void(^areaEditBlock)(NSString *country,NSString *province,NSString *city);    /**<地区设置回调*/



-(void)setUserEditType:(UserEditType)editType;


@end
