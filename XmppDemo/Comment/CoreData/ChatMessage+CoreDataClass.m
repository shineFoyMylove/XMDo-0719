//
//  ChatMessage+CoreDataClass.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ChatMessage+CoreDataClass.h"

@implementation ChatMessage
@synthesize isFromOwn = _isFromOwn;

-(void)updateWithMessageModel:(MessageModel *)model{
    if ([model isKindOfClass:[MessageModel class]]) {
        
        NSString *userphone = UDGetString(username_preference);
        if (userphone.length >0 && [model.from.phone isEqualToString:userphone]) {
            self.conversationId = model.to.phone;  //你 -> 对方
        }else{
            self.conversationId = model.from.phone;  //对方 -> 你
        }
        
        self.userphone = userphone;
        self.messageID = model.messageID;
        
        self.from_uid   = @"";
        self.from_phone         = model.from.phone;
        self.from_name          = model.from.name;
        self.from_headerImage   = model.from.headUrl;
        
        self.to_uid     = @"";
        self.to_phone       = model.to.phone;
        self.to_name        = model.to.name;
        self.to_headerImage = model.to.headUrl;
        
        self.msgType     = model.typeFile;
        self.textContent = model.content;
        
        self.img_url    = model.image.url;
        self.img_width  = model.image.width.floatValue;
        self.img_height = model.image.height.floatValue;
        
        self.video_url    = model.video.url;
        self.video_length = model.video.length.intValue;
        
        self.voice_url    = model.voice.url;
        self.voice_length = model.voice.length.intValue;
        
        self.file_url     = model.file.url;
        self.file_name    = model.file.fileName;
        self.file_suffix  = model.file.fileSuffix;
        self.file_size    = model.file.fileSize.doubleValue;
        
        self.loc_lng      = model.lng.floatValue;
        self.loc_lat      = model.lat.floatValue;
        
//        self.timeInterval = model.time.doubleValue;
        self.timeInterval = [NSDate timeInterval];
    }
}

-(BOOL)isFromOwn{
    NSString *userphone = UDGetString(username_preference);
    if (userphone.length >0 && [self.from_phone isEqualToString:userphone]) {
        _isFromOwn = YES;
    }else{
        _isFromOwn = NO;
    }
    return  _isFromOwn;
}

@end
