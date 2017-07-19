//
//  ContactTableCell.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;  //姓名
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;  //头像
@property (nonatomic, weak) IBOutlet UILabel *logoLabel; //名字LOGO

-(void)setDataItem:(id)item;

@end
