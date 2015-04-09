//
//  AppDelegate.h
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/12.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) Reachability *reachability;


@end

