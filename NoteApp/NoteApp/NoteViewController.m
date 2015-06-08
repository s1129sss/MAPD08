//
//  NoteViewController.m
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/13.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import "NoteViewController.h"
@import GoogleMobileAds;

@interface NoteViewController ()<UIImagePickerControllerDelegate,GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textVieew;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) BOOL isNewImage;
@property(nonatomic) GADInterstitial *interstitial;


@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //從note物件取出文字，設定在畫面的textView
    self.textVieew.text = self.note.text;
    
    //秀出儲存的圖片
    self.imageView.image = self.note.image;
    
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    
    
    //googAD 插頁式廣告
    self.interstitial = [[GADInterstitial alloc]init];
    self.interstitial.adUnitID = @"ca-app-pub-7371395485278776/5571713242";
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
}

-(IBAction)done:(id)sender
{
    //將輸入文字儲存
    self.note.text = self.textVieew.text;
    //將選擇圖片儲存
    //self.note.image = self.imageView.image;
    
    if(self.isNewImage)
    {
        //產生一串幾乎不會重複的字串，用來儲存圖片
        NSUUID *uuid = [NSUUID UUID];
        NSString *imageName = [uuid UUIDString]; //fasdfasdf-fsdfasd-fadsfaxxcxx
        self.note.imageName = imageName;
        //找到Documents目錄位置
        NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //組成檔案名稱，UUID.jpg
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
        //組成最後的檔案路徑 = Documents目錄/UUID.jpg
        filePath = [filePath stringByAppendingPathComponent:fileName];
        //轉成JPEG格式的Data,0-1之間，1表示Quality最好，壓縮比最低，檔案最大
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, .9);
        
        
    }
    
    
    //因為是optional，你自己要負責檢查，如果不是optional，就不用檢查，如果對方沒有實作，就讓它當掉
    if ([self.delegate respondsToSelector:@selector(didFinishUpdateNote:)]) {
        //[self.delegate didFinishUpdateNote:self.note]; //通知  done是事件 [誰 方法：]
        
        //送NoteUpdated通知,self.note當作資訊傳給接受方
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteUpdated" object:nil userInfo:@{@"note":self.note}];
        
    }
    
    
    //googleAD
    if(self.interstitial.isReady)
    {
        //有廣告時，跳廣告
        [self.interstitial presentFromRootViewController:self];
    }
    else
    {
        //沒廣告時，則走一般流程
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    //回上一頁
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark GADInterstitalDelegate

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    //按下X
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    //點了廣告
    [self dismissViewControllerAnimated:YES completion:^{[self.navigationController popViewControllerAnimated:YES];}];
}

//相機設定
-(IBAction)camera:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

//圖片設定
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    self.isNewImage = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
