//
//  XMNChatOtherCollectionCell.h
//  XMNChatFramework
//
//  Created by XMFraker on 16/7/18.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMNChatOtherCollectionCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger apageCount;  //每页数量

-(void)setItems:(NSArray *)items maxCount:(NSInteger)maxCount;

@end
