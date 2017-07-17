//
//  InviateFriendVC.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "InviateFriendVC.h"

@interface InviateFriendVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView * line;
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)NSArray * titleArray;
@property (nonatomic,strong)NSArray * imageArray;

//邀请好友链接
@property (nonatomic,copy)NSString * shareLink;
@property (nonatomic,copy)NSString * inviateCode;


@property (nonatomic,strong)UILabel * inviateCodeLabel;

@property (nonatomic,strong)MainShareView * shareView;

@end

@implementation InviateFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addUI];

    
    [self getNet];
    
    
}



- (void)getNet{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    __weak InviateFriendVC * weakSelf = self;
    
    [net mineInviateCodeAndInviateLink];
    
    net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * message,NSString * str,NSArray * data,NSArray * arr){
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (data.count > 0) {
                
            
            weakSelf.shareLink = data[1];
            weakSelf.inviateCode = data[0];
        
            weakSelf.inviateCodeLabel.text = [NSString stringWithFormat:@"[ %@ ]",data[0]];
            }
            
        }
        
    };
    
}




- (void)addUI{
    [super addUI];
    
    [self UIdataSource];
    self.titleLabel.text = @"邀请好友";
    
    [self addButtonNew];
    [self lineNew];
    
    [self scrollViewNew];
    
    
    self.shareView = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    [self.shareView addAdvertisementViewNew];
    
    [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)UIdataSource{

    
    NSArray * images00 = @[@"copy",@"wdyqm"];
    NSArray * images11 = @[@"wx",@"wxf",@"qq",@"qzone"];
    
    
    NSArray * title0 = @[@"我的邀请链接",@"我的邀请码"];
    NSArray * title1 = @[@"邀请朋友圈好友",@"邀请微信好友",@"邀请QQ好友",@"邀请QQ空间好友"];
    
    self.titleArray = [NSArray arrayWithObjects:title0,title1, nil];
    self.imageArray = [NSArray arrayWithObjects:images00,images11, nil];
    
}

#pragma mark- addButtonNew
- (void)addButtonNew{
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWith/2 * i, 64, ScreenWith/2, ScreenWith/10);
        if (i == 0) {
            [button setTitle:@"邀请好友" forState:UIControlStateNormal];
            button.selected = YES;
        }else{
            [button setTitle:@"邀请收益" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
}

- (void)buttonAction:(UIButton *)button{
    
    UIButton * bt1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton * bt2 = (UIButton *)[self.view viewWithTag:1001];
    
    if (button.tag == 1000) {
        
        bt1.selected = YES;
        bt2.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            
            self.line.frame = CGRectMake(0, 64 +ScreenWith/10 - 1, ScreenWith/2, 1);
            
        }];
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
    }else{
        bt1.selected = NO;
        bt2.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            
            self.line.frame = CGRectMake(ScreenWith/2, 64 +ScreenWith/10 - 1, ScreenWith/2, 1);
            
        }];
        self.scrollView.contentOffset = CGPointMake(ScreenWith, 0);

    }
    
}


#pragma mark- lineNew
- (void)lineNew{
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 64 +ScreenWith/10 - 1, ScreenWith/2, 1)];
    self.line = line;
    line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    [self.view addSubview:line];
    
}


#pragma mark- scrollViewNew
- (void)scrollViewNew{
    [self addScrollViewNew];
    [self addTableViewNew];
}

- (void)addScrollViewNew{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/10, ScreenWith, ScreenHeight-64-ScreenWith/10)];
    scrollView.contentSize = CGSizeMake(ScreenWith * 2, 0);
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
}


/**
 *邀请收益
 */
- (UIView *)inviateIncomTableHeadView{

    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/4)];
    headView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith/16 - ScreenWith/20, ScreenWith, ScreenWith/8)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    [headView addSubview:view];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWith/2 - 10, ScreenWith/8)];
    title.text = @"邀请收益未到帐说明";
    title.userInteractionEnabled = YES;
    title.font = [UIFont systemFontOfSize:15];
    title.backgroundColor = [UIColor clearColor];
    [view addSubview:title];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWith - ScreenWith/8 - 10, (ScreenWith/8 - ScreenWith/13)/2, ScreenWith/8, ScreenWith/13);
    button.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    [button setTitle:@"查看" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(cheackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    NSArray * titles = @[@"注册时间",@"用户",@"邀请收益"];
    for (int i = 0; i < 3; i ++) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/3 * i,ScreenWith/8 + ScreenWith/8 - ScreenWith/10, ScreenWith/3, ScreenWith/10)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:label];
    }
    
    return headView;
}

- (void)cheackButtonAction{

    NSLog(@"查看");
}

- (void)addTableViewNew{
    
    for (int i = 0; i < 2; i ++) {
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(i * ScreenWith, 0, ScreenWith, ScreenHeight-64 - ScreenWith/13) style:UITableViewStyleGrouped];
        tableView.tag = 1100 + i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = ScreenWith/7;
        tableView.tableFooterView = [[UIView alloc]init];
        
        if (i== 1) {
            
            tableView.tableHeaderView = [self inviateIncomTableHeadView];
        }
        
        [self.scrollView addSubview:tableView];
    }
}

#pragma mark- tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1100) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"];
            if (indexPath.section == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                
            }else{
            
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWith - ScreenWith/8 - 15, (ScreenWith/7 - ScreenWith/13)/2, ScreenWith/8, ScreenWith/13);
                button.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
                [button setTitle:@"复制" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                button.layer.cornerRadius = 5;
                button.clipsToBounds = YES;
                button.tag = indexPath.row + 1200;
                [button addTarget:self action:@selector(buttonCopyAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        NSArray * title = self.titleArray[indexPath.section];
        NSArray * image = self.imageArray[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:image[indexPath.row]];
        cell.textLabel.text = title[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/2, (ScreenWith/7 - ScreenWith/13)/2, ScreenWith/3 - 5, ScreenWith/13)];
            label.textColor = [UIColor orangeColor];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"*****";
            
            self.inviateCodeLabel = label;
        }

        
        
        return cell;
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"];
            
        }
        
        return cell;
    }
    
   
}


- (void)buttonCopyAction:(UIButton *)bt{

    NSLog(@"复制");
    
    if (bt.tag == 1200) {
        NSLog(@"复制1200");

        [self rootCopyLinkWith:self.shareLink];
        
        
    }else{
        NSLog(@"复制1201");

        [self rootCopyLinkWith:self.inviateCode];

    }
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView.tag == 1100) {
        return 2;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag ==1100) {
        
        if (indexPath.section == 1 ) {
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            [window addSubview:self.shareView];
            
            
            if (indexPath.row == 0 || indexPath.row == 1) {
                
                NSLog(@"wx");
                self.shareView.shareType = WeiXinShareType;

            }else if (indexPath.row == 2){
                NSLog(@"qq");

                self.shareView.shareType = QQShareType;

            }else{
                NSLog(@"qzone");

                self.shareView.shareType = QzoneShareType;

            }
            
       
        }
        
    }
}



- (void)rootAdvCancleButtonAction{
    
    [self.shareView removeFromSuperview];
    
}

- (void)rootShareEnterButtonAction{
    
    [self.shareView removeFromSuperview];
    
    
    NSString * advString;
    
    if (self.shareView.selectAdvString) {
        
        advString = self.shareView.selectAdvString;
    }
    
    
    if (advString == nil) {
        
        advString = @"不能提现的红包，都是耍流氓，下载送5元现金红包，能提现，绝对真实，不忽悠!!！";
    }
    
    
    if (self.shareView.shareType == WeiXinShareType ||self.shareView.shareType == WeiXinFriendShareType) {
        
        [self rootLocationWeiXinShareWithImage:[UIImage imageNamed:@"icon_180"] andImageUrl:nil andString:advString andUrl:self.shareLink];
        
    }else if (self.shareView.shareType == QQShareType ){
        
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ andTitle:advString andContent:advString andUrl:self.shareLink andThumbImage:[UIImage imageNamed:@"icon_180"]];
        
    }else if (self.shareView.shareType == QzoneShareType ){
        
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone andTitle:advString andContent:advString andUrl:self.shareLink andThumbImage:[UIImage imageNamed:@"icon_180"]];
        
    }
    
    
    
    
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1100) {
        
        NSArray * array = self.titleArray[section];
        
        return array.count;
        
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.tag == 1100) {
        
        return ScreenWith/7;

    }else{
    
        return ScreenWith/8;
    }
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
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
