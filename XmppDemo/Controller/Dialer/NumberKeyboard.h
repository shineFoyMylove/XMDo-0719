//
//  NumberKeyboard.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/4.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, NumberKeyboardTextStyle) {
    NumberKeyboardTextStyleNumber,      //数字
    NumberKeyboardTextStylePaste,       /**<粘贴 */
    NumberKeyboardTextStyleAdd,         /**<添加联系人 add -> dialer_add.png */
    NumberKeyboardTextStyleSetting,     /**<跳转设置 set -> dialer_set.png*/
    NumberKeyboardTextStyleDelete       /**<退格键  delete -> dialer_delete.png */
};

@interface NumberKeyboard : UIView

@property (nonatomic,copy) void(^KeyboardDidTapBlock)(NSInteger tapNum, NumberKeyboardTextStyle textStyle);    /**<按钮点击回调 */

@property (nonatomic, copy) void(^numberLongDeleteBlock)();   /**<长按删除 */

@end
