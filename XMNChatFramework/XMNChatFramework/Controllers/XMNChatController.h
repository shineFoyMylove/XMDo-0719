//
//  XMNChatController.h
//  XMNChatFramework
//
//  Created by XMFraker on 16/4/25.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNChatViewModel.h"
#import "XMNChatConfiguration.h"


@class XMNChatBaseMessage;


@interface XMNChatController : UIViewController

@property (nonatomic, strong) XMNChatViewModel<UITableViewDataSource> *chatVM;
@property (nonatomic, assign, readonly) XMNChatMode chatMode;


- (instancetype)initWithChatMode:(XMNChatMode)aChatMode;


/**
 *  @brief 发送一个消息
 *
 *  @param aMessage 发送的消息内容
 */
- (void)sendMessage:(XMNChatBaseMessage *)aMessage;

- (void)scrollBottom:(BOOL)animated;

- (void)tableViewReload;

- (void)tableViewReloadAtIndex:(NSIndexPath *)indexPath;


/**
 更多other功能*/
- (void)setupChatOtherItems:(NSArray *)items;

-(void)setupChatOtherItemsDefault;


#pragma mark - Menu Item Action

- (void)menuCopy:(id)sender;   /**<cell menu操作*/

- (void)menuDelete:(id)sender;

-(void)menuPaste:(id)sender;


@end
