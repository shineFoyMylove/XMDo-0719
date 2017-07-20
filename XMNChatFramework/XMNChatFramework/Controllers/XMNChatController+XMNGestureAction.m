//
//  XMNChatController+XMNMenu.m
//  XMNChatFramework
//
//  Created by XMFraker on 16/7/15.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNChatController+XMNGestureAction.h"

#import "XMNChatController_Private.h"
#import "XMNChatCell.h"
#import "XMNChatReuseMessageView.h"

@implementation XMNChatController (XMNGestureAction)

#pragma mark - Override Methods


- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
//    return NO;
    if (action == @selector(test:) || action == @selector(copy:) || action == @selector(paste:) || action == @selector(delete:)) {
        return YES;
    }
    return NO;
}

#pragma mark - Methods

- (void)setupMenuItems {
    
//    UIMenuItem *testMenuItem = [[UIMenuItem alloc] initWithTitle:@"测试1" action:@selector(test:)];
    
    [[UIMenuController sharedMenuController] setArrowDirection:UIMenuControllerArrowDown];
    [[UIMenuController sharedMenuController] update];
}

- (void)setupGestures {
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGes.numberOfTouchesRequired = 1;
    longPressGes.minimumPressDuration = .5f;
    [self.tableView addGestureRecognizer:longPressGes];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - UIGestrure Action

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    
    XMNLog(@"this is view tap ");
    [self cleanMenu];
    
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tap locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath) {
            XMNChatCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (CGRectContainsPoint(cell.messageContentView.frame, [tap locationInView:cell])) {
                if (cell.delegate && [cell.delegate respondsToSelector:@selector(messageCellDidTapContent:)]) {
                    [cell.delegate messageCellDidTapContent:cell];
                }
            }else if (CGRectContainsPoint(cell.avatarImageView.frame, [tap locationInView:cell])) {
                if (cell.delegate && [cell.delegate respondsToSelector:@selector(messageCellDidTapAvatar:)]) {
                    [cell.delegate messageCellDidTapAvatar:cell];
                }
            }else {
                XMNLog(@"点中了cell 的空白部分");
                [self chatBarShowingViewDidChanged:XMNChatShowingNoneView];
            }
        }
    }
}

- (void)handleDoubleTapAction:(UITapGestureRecognizer *)tap {
    
    XMNLog(@"this is view tap ");
    [self cleanMenu];
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tap locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath) {
            XMNChatCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (CGRectContainsPoint(cell.messageContentView.frame, [tap locationInView:cell])) {
                if (cell.delegate && [cell.delegate respondsToSelector:@selector(messageCellDidDoubleTapContent:)]) {
                    [cell.delegate messageCellDidDoubleTapContent:cell];
                }
            }
        }
    }
}


- (void)handleLongPress:(UIGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        [self cleanMenu];
        self.tableView.scrollEnabled = NO;
        
        CGPoint point = [ges locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath) {
            XMNChatCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (CGRectContainsPoint(cell.messageContentView.frame, [ges locationInView:cell])) {
                [cell setSelected:YES animated:YES];
                
                CGRect rect = [self.tableView convertRect:cell.frame toView:self.view];
                /** 需要另外加上tabBar高度 保证menuController 可以完整显示*/
                
                UIMenuController *menuContr = [UIMenuController sharedMenuController];
                [self becomeFirstResponder];
                
                if (rect.origin.y <= (45 + (self.navigationController.navigationBar.isHidden ? 0 : 64))) {
                    [menuContr setArrowDirection:UIMenuControllerArrowUp];
                    [menuContr setTargetRect:[cell.contentView convertRect:cell.messageContentView.frame toView:self.tableView] inView:self.tableView];
                    [menuContr setMenuVisible:YES animated:YES];
                }else {
                    [menuContr setArrowDirection:UIMenuControllerArrowDown];
                    
                    CGRect rect = [cell.contentView convertRect:cell.messageContentView.frame toView:self.tableView];
                    
                    [menuContr setTargetRect:[cell.contentView convertRect:cell.messageContentView.frame toView:self.tableView] inView:self.tableView];
                    [menuContr setMenuVisible:YES animated:YES];
                }

            }
        }
    }else if (ges.state == UIGestureRecognizerStateChanged) {
        
    }else {
        self.tableView.scrollEnabled = YES;
    }
}


- (void)cleanMenu {
    
    self.tableView.scrollEnabled = YES;
    if ([UIMenuController sharedMenuController].menuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:NO];
    }];
    
    [self resignFirstResponder]; //
}

#pragma mark - Menu Item Action

- (void)copy:(id)sender {
    
    NSLog(@"%@",sender);
}

- (void)delete:(id)sender{
    NSLog(@"%@",sender);
}

-(void)paste:(id)sender{
    NSLog(@"%@",sender);
}

- (void)test:(UIMenuController *)sender {
    
}

@end
