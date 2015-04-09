//
//  NoteViewController.h
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/13.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol NoteViewControllerDelgate <NSObject>
@optional
-(void)didFinishUpdateNote:(Note*)note;

@end

@interface NoteViewController : UIViewController
@property(nonatomic)Note *note;
@property(nonatomic)id<NoteViewControllerDelgate> delegate;

@end
