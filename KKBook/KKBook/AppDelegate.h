//
//  AppDelegate.h
//  KKBooK
//
//  Created by PromptNow Ltd. on 29/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BaseWindow.h"
#import "KKBookMainVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) BaseWindow *window;
@property (strong, nonatomic) KKBookMainVC *kkbookMainVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

