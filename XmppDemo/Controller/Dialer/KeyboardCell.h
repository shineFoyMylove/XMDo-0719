//
//  KeyboardCell.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/4.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeyboard.h"

@interface KeyboardCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;   /**<数字 */
@property (nonatomic, weak) IBOutlet UILabel *letterLabel;  /**<字母*/
@property (nonatomic, weak) IBOutlet UIImageView *iconImg;

@property (nonatomic, assign) NumberKeyboardTextStyle textType;


@end
