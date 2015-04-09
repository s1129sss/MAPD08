//
//  Note.h
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/12.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit; //用來載入下面的 propety

@interface Note : NSObject
@property(nonatomic) NSString *text;
//@property(nonatomic) UIImage *image;
@property(nonatomic) NSString *imageName;
-(UIImage*)image;
-(UIImage*)thumnailImage;
@end
