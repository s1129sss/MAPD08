//
//  AppDelegate.m
//  NoteApp
//
//  Created by Vincent on 2015/2/12.
//  Copyright (c) 2015年 Vincent. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"home: %@",NSHomeDirectory());
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    [self.reachability startNotifier]; //網路有變化時，他會通知
    
    //註冊接收網路變化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
    
    [self printNetwork];
    return YES;
}
-(void)networkChange:(NSNotification*)notification{
    [self printNetwork];
}
-(void)printNetwork{
    
    if ( [self.reachability currentReachabilityStatus] == ReachableViaWiFi ){
        NSLog(@"wifi");
    }else if ( [self.reachability currentReachabilityStatus] == ReachableViaWWAN){
        NSLog(@"3G 4G");
    }else if ( [self.reachability currentReachabilityStatus] == NotReachable){
        NSLog(@"無法連線");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
