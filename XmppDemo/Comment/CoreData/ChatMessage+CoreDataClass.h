//
//  ChatMessage+CoreDataClass.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessage : NSManagedObject

@property (nonatomic, assign) BOOL isFromOwn;  //是否来源自己发送

-(void)updateWithMessageModel:(MessageModel *)model;


@end

NS_ASSUME_NONNULL_END

#import "ChatMessage+CoreDataProperties.h"
