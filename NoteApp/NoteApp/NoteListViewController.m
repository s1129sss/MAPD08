//
//  NoteListViewController.m
//  NoteApp
//
//  Created by iiiedu3 on 2015/2/12.
//  Copyright (c) 2015年 MAPD01_03. All rights reserved.
//

#import "NoteListViewController.h"
#import "Note.h"
#import "NoteCell.h"
#import "NoteViewController.h"

@interface NoteListViewController ()<UITableViewDataSource,UITableViewDelegate,NoteViewControllerDelgate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray *notes;

@end

@implementation NoteListViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.notes = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            Note *note = [[Note alloc]init];
            
            note.text = [NSString stringWithFormat:@"noteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee %d",i];
            
            [self.notes addObject:note];
        }
        //註冊接收 NoteUpdated 的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdate:) name:@"NoteUpdated" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)finishUpdate:(NSNotification* )notification{
    
    Note *note = notification.userInfo[@"note"];
    
    //取得note物件在原本notes NSArray中的位置
    NSUInteger index = [self.notes indexOfObject:note];
    // 建立NSIndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //通知tableView做更新
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
   // self.tableView.estimatedSectionFooterHeight = 44; //講義p242
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem; // 上方控制列左邊按鈕設定
}
- (IBAction)addNote:(id)sender {
    Note *note = [[Note alloc]init];
    note.text = @"new note";
    
    //新增到第一筆
//    [self.notes insertObject:note atIndex:0]; //插入 到 第0筆（開頭）
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0]; //要加到最後一筆就看 矩陣長度-1
    
    //新增到最後一筆
    [self.notes addObject:note];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.notes.count-1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //專門給self.editButtonItem使用
    [super setEditing:editing animated:YES];
    [self.tableView setEditing:editing animated:YES];
}
//edit鈕設定
- (IBAction)edit:(id)sender {
    //self.tableView.editing = !self.tableView.editing; //一般切換
    [self.tableView setEditing:!self.tableView.editing animated:YES]; //有動畫切換
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellid"]; //內建table的樣式選擇 NoteCell為.h檔 customcell為拉出來的物件命名
    Note *note = self.notes[indexPath.row];
    
    cell.textLabel.text = note.text;
    cell.imageView.image = note.image; //設定開頭每條的圖片顯示
    
//     NoteCell *cell =[tableView dequeueReusableCellWithIdentifier:@"customcell"]; //自定義table的樣式選擇 NoteCell為.h檔 customcell為拉出來的物件命名
//    cell.contentLabel.text = note.text;
    
    
    //cell.textLabel.text = note.text;
    cell.showsReorderControl = YES;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //選單後面的圖示 可以直接選樣式
//    cell.accessoryType = [[UISwitch alloc]init]; //上面的客製化範例
    return cell;
}

//edit內的刪除資料功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Note *note = self.notes[sourceIndexPath.row];
    [self.notes removeObject:note];
    [self.notes insertObject:note atIndex:destinationIndexPath.row];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld筆被找到了",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    //#import "NoteViewController" 用程式寫出換頁
    NoteViewController *noteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"noteViewController"];
    [self.navigationController pushViewController:noteViewController animated:YES];
     */
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    
    if ( [segue.identifier isEqualToString:@"noteView"]){
        
        NoteViewController *noteViewController =  segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        noteViewController.note = self.notes[indexPath.row];
        noteViewController.delegate = self;
    }
}

-(void)didFinishUpdateNote:(Note *)note
{
    //取得note物件在原本notes NSArray中的位置
    NSUInteger index = [self.notes indexOfObject:note];
    //建立NSIndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //通知tableView做更新
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
