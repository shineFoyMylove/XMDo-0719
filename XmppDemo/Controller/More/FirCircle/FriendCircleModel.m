//
//  FriendCircleModel.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
// 朋友圈数据模型

#import "FriendCircleModel.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation FriendCircleModel
{
    CGFloat _lastContentWidth;
}

-(NSString *)msgContent{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:contentLabelFontSize]} context:NULL];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        }else{
            _shouldShowMoreButton = NO;
        }
    }
    return _msgContent;
}

-(void)setIsOpening:(BOOL)isOpening{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    }else{
        _isOpening = isOpening;
    }
}

@end


/***  朋友圈点赞 model  ***/
@implementation FriCircleLikeItemModel

@end

/***  朋友圈评论 model  ***/
@implementation FriCircleCommentItemModel

@end
