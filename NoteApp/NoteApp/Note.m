//
//  Note.m
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/12.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import "Note.h"

@implementation Note

-(UIImage *)image{
    
    //找到Documents目錄位置
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //組成檔案名稱，UUID.jpg
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.imageName];
    //組成最後的檔案路徑 = Documents目錄/UUID.jpg
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return [UIImage imageWithContentsOfFile:filePath];
}

-(UIImage*)thumnailImage{
    
    UIImage *image = [self image];
    if ( !image){
        return nil;
    }
    CGSize thumbnailSize = CGSizeMake(50, 50); //設定縮圖大小
    CGFloat scale = [UIScreen mainScreen].scale; //找出目前螢幕的scale，視網膜技術為2.0
    //產生畫布，指定大小,不透明,scale為螢幕scale
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, YES, scale);
    //取得目前畫布，注意沒有*號
    CGContextRef context = UIGraphicsGetCurrentContext();
    //暫存目前狀態
    CGContextSaveGState(context);
    
    //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
    //最小值MIN會變成UIViewContentModeScaleAspectFit
    CGFloat widthRatio = thumbnailSize.width / image.size.width;
    CGFloat heightRadio = thumbnailSize.height / image.size.height;
    CGFloat ratio = MAX(widthRatio,heightRadio);
    
    CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    [image drawInRect:CGRectMake(-(imageSize.width-50.0)/2.0, -(imageSize.height-50.0)/2.0,
                                 imageSize.width, imageSize.height)];
    
    //回復狀態，如果接下來沒有程式需要用，可以不用這行
    CGContextRestoreGState(context);
    //取得畫布上的縮圖
    image = UIGraphicsGetImageFromCurrentImageContext();
    //關掉畫布
    UIGraphicsEndImageContext();
    return image;
}

@end
