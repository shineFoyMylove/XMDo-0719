//
//  BaseTableViewCell.h
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/10.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageIcon;
@property (nonatomic, weak) IBOutlet UILabel *R_textLabel;

@property (nonatomic, assign) BOOL haveBottomLine;

@end
