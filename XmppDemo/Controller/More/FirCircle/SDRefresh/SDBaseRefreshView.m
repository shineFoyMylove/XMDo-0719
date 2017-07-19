//
//  SDBaseRefreshView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/5.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 *
 * GSD_WeiXin
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * 新浪微博:GSD_iOS
 *
 *
 *********************************************************************************
 
 */

#import "SDBaseRefreshView.h"

NSString *const kSDBaseRefreshViewObserveKeyPath = @"contentOffset";

@implementation SDBaseRefreshView

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [scrollView addObserver:self forKeyPath:kSDBaseRefreshViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:kSDBaseRefreshViewObserveKeyPath];
    }
}

- (void)endRefreshing
{
    self.refreshState = SDWXRefreshViewStateNormal;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 子类实现
}

@end
