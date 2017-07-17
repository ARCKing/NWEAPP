//
//  SetVC.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SetVC.h"
#import <UMMobClick/MobClick.h>

@interface SetVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UILabel * cacheLabel;
@property (strong,nonatomic)UILabel * messageLabel;

//存放缓存的大小
@property (nonatomic ,assign)CGFloat Cache;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self addUI];
    [self showTheBlackMessageAleterNewWithFram:CGRectMake(ScreenWith/2 - 50, -30, 100, 30)];

}

- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"设置";

    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith, ScreenWith/10) andSel:@selector(outAction) andTitle:@"退出登录"];
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self tableViewNew:bt];
}

- (void)outAction{

    [self addAlterWarning];
    
}


- (void)addAlterWarning{

    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"退出登录" message:@"亲，真的要退出登录吗？" delegate:self cancelButtonTitle:@"留下" otherButtonTitles:@"残忍退出", nil];
    
    [alter show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        NSLog(@"退出登录");
        
        NetWork * net = [NetWork shareNetWorkNew];
        [net outOfLoginWithTokenAndUid];
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        __weak SetVC * weakSelf = self;
        net.outLoginBK=^(NSString *code,NSString *message){
            
            [hud hideAnimated:YES];
            
            [weakSelf showTheBlackMessageAlter:message];
            
            
            if ([code isEqualToString:@"1"]) {
                
                [MobClick profileSignOff];
                
                [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1.7];
            }
            
        };

    }else{
    
    
    }


}



- (void)tableViewNew:(UIView *)footView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/9;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = footView;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * titleArray = @[@"关于我们",@"当前版本",@"清除缓存"];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_zero"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_zero"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 1) {
        
      NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

      
      UILabel * vison = [self addRootLabelWithfram:CGRectMake(ScreenWith - ScreenWith/6, 0, ScreenWith/6, ScreenWith/9) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor whiteColor] andTitle:currentVersion];
        vison.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:vison];
    }
    
    
    if (indexPath.row == 2) {
        UILabel * cache = [self addRootLabelWithfram:CGRectMake(ScreenWith - ScreenWith/6 -5 - 25, 0, ScreenWith/6 + 5, ScreenWith/9) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"0.0M"];
        cache.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:cache];
        
        self.cacheLabel = cache;
        
        [self cacheCount];
    }
    
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return ScreenWith/9;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        AboutUsVC * vc = [[AboutUsVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        
        [self clearAlertShow];
    }
    
    
}

#pragma mark-清理缓存文件

- (void)clearAlertShow{
    UIAlertController * alertController =[ UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:[NSString stringWithFormat:@"是否清除缓存"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self ClearManager];
    }];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"取消"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消清除缓存！");
    }];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];


}

/**当前缓存大小*/
- (void)cacheCount{
    //程序进入就计算缓存大小
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    self.Cache = [self folderSizeAtPath:cachesDir];
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",_Cache];

}

//清空数据库
-(void)ClearManager
{
    if (self.Cache==0) {
        return;
    }
    //清理缓存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    [self clearCache:cachesDir];
    
    self.cacheLabel.text = @"0.00M";
}


//清理缓存文件
//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
- (void)clearCache:(NSString*)path
{
    
    NSFileManager*fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        for(NSString * fileName in childerFiles) {
            
            //如有需要，加入条件，过滤掉不想删除的文件
            
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    // SDImageCache 自带缓存
    //    [[SDImageCache sharedImageCache] cleanDisk];
}


#pragma mark-计算目录大小
//计算目录大小
- (float)folderSizeAtPath:(NSString*)path
{
    NSFileManager*fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    
    if([fileManager fileExistsAtPath:path]) {
        
        NSArray * childerFiles=[fileManager subpathsAtPath:path];
        
        for(NSString *fileName in childerFiles) {
            
            NSString*absolutePath = [path stringByAppendingPathComponent:fileName];
            // 计算单个文件大小
            folderSize += [self fileSizeAtPath:absolutePath];
        }
    }
    return folderSize;
}


#pragma mark- 计算单个文件大小返回值是M
//计算单个文件大小返回值是M
- (float)fileSizeAtPath:(NSString*)path
{
    NSFileManager*fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        // 返回值是字节B K M
        return size/1024.0/1024.0;
    }
    return 0;
}

#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 0.1;//section头部高度

}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 30)];
        view.backgroundColor = [UIColor clearColor];
        return view ;

    
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 4.9;
    
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//黑色提示框====
- (void)showTheBlackMessageAleterNewWithFram:(CGRect)fram{
    
    self.messageLabel =  [self addRootLabelWithfram:fram andTitleColor:[UIColor whiteColor] andFont: 12 andBackGroundColor:[UIColor blackColor] andTitle:@"Message"];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.messageLabel];
}


- (void)showTheBlackMessageAlter:(NSString *)message{
    
    self.messageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, 64, 100, 30);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(dissmissMessageAleart) withObject:nil afterDelay:1.5];
        
    }];
}

- (void)dissmissMessageAleart{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, -30, 100, 30);
        
    }];
}
@end
