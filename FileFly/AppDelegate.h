//
//  AppDelegate.h
//  FileFly
//
//  Created by jx on 16/4/25.
//  Copyright © 2016年 jx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"
#import <CoreData/CoreData.h>
#import "MultipeerTools.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property ITRAirSideMenu *itrAirSideMenu;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong) MultipeerTools *multipeer;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

