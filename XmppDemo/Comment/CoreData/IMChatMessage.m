//
//  IMChatMessage.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/11.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "IMChatMessage.h"
#import "ChatMessage+CoreDataClass.h"

@interface IMChatMessage ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

@implementation IMChatMessage

-(id)init{
    if (self = [super init]) {
        
        
    }
    return self;
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

#pragma mark  - 保存到 XMPPMessageArchiving_Message_CoreDataObject CoreData
-(void)insertCoreData{
    
    
}

-(void)saveContext{
    
}


#pragma mark CoreData属性
-(NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator == nil) {
        
        NSURL *storeURL = [[self documentsDirectoryURL] URLByAppendingPathComponent:@"im_chat_message.sqlite"];
        NSError *error = nil;
        
        
    }
    
    return _persistentStoreCoordinator;
}

-(NSURL *)documentsDirectoryURL{
    NSURL *URL = [[[NSFileManager defaultManager] URLsForDirectory:(NSDocumentDirectory) inDomains:NSUserDomainMask] lastObject];
    return URL;
}

@end
