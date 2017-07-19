//
//  LeftViewController.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/3/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIImageView *userHeader;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userAccountLabel;
@property (nonatomic, weak) IBOutlet UILabel *userSignLabel;   /**< 个性签名 */

@property (nonatomic, weak) IBOutlet UITableView *contentList;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, copy) void(^puckActionBlock)();

@end
