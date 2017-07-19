//
//  AppDelegate.h
//  XmppDemo
//
//  Created by IntelcentMac on 17/6/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MMDrawerController.h"
#import "AppManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@property (nonatomic, strong) MMDrawerController *DrawerController;
@property (strong, nonatomic) AppManager *appManager;

+(AppDelegate *)instance;       /**< AppDelegate instance */

- (void)saveContext;


@end

