//
//  MessageModel.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/3.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "MessageModel.h"
#import "UIImage+Size.h"
#import <objc/message.h>

@implementation MessageModel

-(id)init{
    if (self = [super init]) {
        self.from = [[CTFromModel alloc] init];
        self.to = [[CTToModel alloc] init];
    }
    return self;
}

-(NSData *)jsonData{
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t thisProperty = propertyList[i];
        const char *proName = property_getName(thisProperty);
        NSString *key = [NSString stringWithUTF8String:proName];
        id value = [self valueForKeyPath:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            if (value == nil || (NSNull *)value == [NSNull null]) {
                value = @"";
            }
        }
        
        if ([key isEqualToString:@"from"] ||
            [key isEqualToString:@"to"] ||
            [key isEqualToString:@"image"] ||
            [key isEqualToString:@"file"] ||
            [key isEqualToString:@"video"] ||
            [key isEqualToString:@"voice"]) {
            if (class_respondsToSelector([value class], sel_getUid("jsonDic"))) {
                id data = objc_msgSend(value,sel_getUid("jsonDic"));
                if ([data isKindOfClass:[NSDictionary class]]) {
                    [msgDic setObject:data forKey:key];
                }
            }
        }else if (value){
            [msgDic setObject:value forKey:key];
        }
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:(NSJSONWritingPrettyPrinted) error:nil];
    return jsonData;
    
}

-(void)updateWithDictionary:(NSDictionary *)dict{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
    }
}

@end


    //消息来源Item
@implementation CTFromModel

-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}

@end

    //消息目标Item
@implementation CTToModel

-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}

@end

    //图片 Item
@implementation CTImageItem
-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}

    // 400 - 250
-(void)setImageSizeWithImage:(UIImage *)image{
    self.width = [NSString stringWithFormat:@"%.2f",image.size.width];
    self.height = [NSString stringWithFormat:@"%.2f",image.size.height];
}


@end

    //视频 Item
@implementation CTVideoItem
-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}
@end

    //音频 Item
@implementation CTAudioItem
-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}
@end

    //文件 Item
@implementation CTFileItem
-(NSDictionary *)jsonDic{
    NSDictionary *dict = converObjToDictionary(self);
    return dict;
}
@end


NSDictionary *converObjToDictionary(id obj){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([obj class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t thisProperty = propertyList[i];
        const char *proName = property_getName(thisProperty);
        NSString *key = [NSString stringWithUTF8String:proName];
        id value = [obj valueForKeyPath:key];
        if (value == nil || (NSNull *)value == [NSNull null]) {
            value = @"";
        }
        [dict setObject:value forKey:key];
    }
//    if (dict.count == 0) {
//        return nil;
//    }
    return dict;
}
