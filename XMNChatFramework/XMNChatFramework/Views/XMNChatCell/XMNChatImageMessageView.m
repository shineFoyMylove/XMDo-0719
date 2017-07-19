//
//  XMNChatImageMessageView.m
//  XMNChatFramework
//
//  Created by XMFraker on 16/7/15.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNChatImageMessageView.h"
#import "YYWebImage.h"
#import "XMNChatMessage.h"

@interface XMNChatImageMessageView ()

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;

@end

@implementation XMNChatImageMessageView

#pragma mark - Override Methods

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

#pragma mark - Methods

- (void)setupViewWithMessage:(XMNChatImageMessage *)aMessage {
    
    if (aMessage.image) {
        self.imageView.image = aMessage.image;
        self.contentSize = CGSizeMake(MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth), ((MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth) * aMessage.imageSize.height) / aMessage.imageSize.width));
        
        NSLog(@"图片以及下载, \n contentSize = %@",NSStringFromCGSize(self.contentSize));
    }else if (aMessage.imagePath) {
//        [self.imageView yy_setImageWithURL:[NSURL URLWithString:aMessage.imagePath] placeholder:[UIImage yy_imageWithColor:[UIColor clearColor] size:aMessage.imageSize] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:nil];
//        self.contentSize = CGSizeMake(MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth), ((MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth) * aMessage.imageSize.height) / aMessage.imageSize.width));
        
        __weak __typeof(&*self)weakSelf = self;
        
        [self.imageView yy_setImageWithURL:[NSURL URLWithString:aMessage.imagePath] placeholder:[UIImage yy_imageWithColor:[UIColor clearColor]] options:YYWebImageOptionProgressive progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            NSLog(@"gif 下载进度：%.2f",(float)receivedSize/expectedSize);
            
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//            NSLog(@"url:%@",url.absoluteString);
            return image;
            
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            if (stage == YYWebImageStageFinished) {
//                NSLog(@"图片下载前Size, \n contentSize = %@",NSStringFromCGSize(self.contentSize));
                
                weakSelf.contentSize = CGSizeMake(MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth), ((MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth) * aMessage.imageSize.height) / aMessage.imageSize.width));
                
                
//                NSLog(@"图片下载后Size, \n contentSize = %@",NSStringFromCGSize(self.contentSize));
            }
            
        }];
        
        self.contentSize = CGSizeMake(MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth), ((MIN(aMessage.imageSize.width, kXMNMessageViewMaxWidth) * aMessage.imageSize.height) / aMessage.imageSize.width));
        
    }else {
        XMNLog(@"unknown image type");
        self.contentSize = CGSizeMake(100, 100);
    }
}
@end
