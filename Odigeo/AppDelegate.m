//
//  AppDelegate.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FCPCoreDataStore.h"
#import "WSManager.h"
#import "FCPCoreDataImporter.h"

@interface AppDelegate ()

@property (strong,nonatomic) UINavigationController *navController;
@property (strong,nonatomic) FCPCoreDataImporter *importer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
      self.navController =[[UINavigationController alloc] initWithRootViewController:homeViewController];

    self.window.rootViewController = _navController;
    
    [self.window makeKeyAndVisible];
   
   // [self startWebServicesConnection];
    
    return YES;
    
}

-(void) startWebServicesConnection{
    
    WSManager *wsManager= [[WSManager alloc] init];
    
    _importer = [[FCPCoreDataImporter alloc] initWithContext:[FCPCoreDataStore privateQueueContext] webservice:wsManager];
    
    [_importer import];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
