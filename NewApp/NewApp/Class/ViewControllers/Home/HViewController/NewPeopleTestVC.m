//
//  NewPeopleTestVC.m
//  NewApp
//
//  Created by gxtc on 17/2/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "NewPeopleTestVC.h"

@interface NewPeopleTestVC ()

/**保存按钮的数组*/
@property (nonatomic,strong)NSArray * buttonSaveArray;

@property (nonatomic,strong)FistNewUserTestModel * model;

@property (nonatomic,strong)UIButton * finishTestButton;
@end

@implementation NewPeopleTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addUI];
    
    [self getDataFromNet];
}



- (void)getDataFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    [net personNewTestStatue];
    
    __weak NewPeopleTestVC * weakSelf = self;
    
    net.personNewTestBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        
        NSLog(@"%@",message);
        
        if (dataArray.count > 0) {
            
            self.model = dataArray[0];
        }
    
        NSLog(@"%@",self.model);
        
        if (self.model) {
            
            [weakSelf setButtonStatue];
        }
        
        
        
    };
    
}

- (void)setButtonStatue{
    
    NSString * sign_money = self.model.sign_money;
    NSString * read_count = self.model.read_count;
    NSString * share_count = self.model.share_count;
    NSString * comment = self.model.comment;
    NSString * up = self.model.up;
    NSString * invite_friend = self.model.invite_friend;
//    NSString * stauts = self.model.stauts;
    
    if ([sign_money isEqualToString:@"1"]) {
    
        UIButton * bt = self.buttonSaveArray[0];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
        
    }
        
    if ([read_count isEqualToString:@"1"]) {
        
        UIButton * bt = self.buttonSaveArray[1];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
    }
        
    if ([share_count isEqualToString:@"1"]) {
        
        UIButton * bt = self.buttonSaveArray[2];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
    }
       

    
    if ([comment isEqualToString:@"1"]) {
        
        UIButton * bt = self.buttonSaveArray[3];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
    }
        
    
    if ([up isEqualToString:@"1"]) {
        
        UIButton * bt = self.buttonSaveArray[4];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
    }
        
#warning mark- Not Finish!!!!!!!!!!!!!!!!!!!!!!!!!!
    if ([invite_friend isEqualToString:@"1"]) {
        
        UIButton * bt = self.buttonSaveArray[5];
        [bt setTitle:@"已完成" forState:UIControlStateNormal];
        bt.enabled = NO;
        bt.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    if ([sign_money isEqualToString:@"1"] && [read_count isEqualToString:@"1"] &&[share_count isEqualToString:@"1"] &&[comment isEqualToString:@"1"] &&[up isEqualToString:@"1"] &&[invite_friend isEqualToString:@"1"] ) {
        
        self.finishTestButton.enabled = YES;
        self.finishTestButton.backgroundColor = [UIColor orangeColor];
    }
    
}


- (void)addUI{
    
    [self addNavBarViewNew];
    [self backGroundImageViewNew];
    
}


- (void)addNavBarViewNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addLineNew];
    
    [self addLeftBarButtonNew];
    [self addTitleLabelNew];
    
    self.titleLabel.text = @"新手任务";
}

#pragma mark- backgroundImageView
- (void)backGroundImageViewNew{
    
    UIScrollView * scrollView =  [self imageScrollViewNew];
    [self imageViewNew:scrollView];
}

- (UIScrollView *)imageScrollViewNew{
    UIScrollView  * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64)];
    scrollView.contentSize = CGSizeMake(0, (ScreenHeight -64)*3/2);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:243.0/255.0 blue:213.0/255.0 alpha:1.0];
    [self.view addSubview:scrollView];
    return scrollView;
}


- (void)imageViewNew:(UIScrollView *)bgScrollView{

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith * 3/7)];
    imageView.image = [UIImage imageNamed:@"img_novice_task_head"];
    imageView.userInteractionEnabled = YES;
    [bgScrollView addSubview:imageView];
    [self addTestButtonNew:bgScrollView];
    
    UILabel * textLabel = [self addRootLabelWithfram:CGRectMake(0, ScreenWith * 3/7, ScreenWith, 30) andTitleColor:[UIColor orangeColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:@"完成任务并领取奖励"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:textLabel];
    
    
    UIImageView * footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (ScreenHeight -64)*3/2 - ScreenWith/2, ScreenWith, ScreenWith /2)];
    footImageView.image = [UIImage imageNamed:@"img_novice_task_foot"];
    footImageView.userInteractionEnabled = YES;
    [bgScrollView addSubview:footImageView];
    
}

- (void)addTestButtonNew:(UIScrollView *)scrollView{

    NSMutableArray * array = [NSMutableArray new];
    NSArray * titleArray = @[@"签到1次",@"阅读文章1次",@"分享文章1次",@"发表评论1次",@"评论点赞1次",@"邀请好友1次"];
    
    for (int i = 0; i < 6; i++) {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, (ScreenHeight - 64)/3 + (10 + ScreenWith/6)*i, ScreenWith - 20, ScreenWith/6)];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:199.0/255.0 blue:59.0/255.0 alpha:YES];
        view.tag = 100 + i;
        [scrollView addSubview:view];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (ScreenWith/6 - ScreenWith/12)/2, ScreenWith/12, ScreenWith/12)];
        imageView.image =[ UIImage imageNamed:@"zq"];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = ScreenWith/24;
        [view addSubview:imageView];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, (ScreenWith/6 - 20)/2, ScreenWith/3, 20)];
        title.text = titleArray[i];
        title.textColor = [UIColor redColor];
        title.font = [UIFont systemFontOfSize:15];
        [view addSubview:title];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWith - 20 - ScreenWith/5 - 10, (ScreenWith/6 - ScreenWith/10)/2, ScreenWith/5, ScreenWith/10);
        [button setTitle:@"去完成" forState:UIControlStateNormal];
        [button setTitle:@"已完成" forState:UIControlStateSelected];
        button.backgroundColor = [UIColor orangeColor];
        button.tag = 200 + i;
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [array addObject:button];
    }
    
    self.buttonSaveArray = [NSArray arrayWithArray:array];
    
    UIButton * finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"领取奖励" forState:UIControlStateNormal];
    finishButton.backgroundColor = [UIColor lightGrayColor];
    finishButton.tag = 6;
    
    finishButton.enabled = NO;
    
    UIView * view = (UIView *)[scrollView viewWithTag:105];
    finishButton.frame = CGRectMake(30, CGRectGetMaxY(view.frame) + 20, ScreenWith- 60, ScreenWith/8);
    finishButton.layer.cornerRadius = 5;
    finishButton.clipsToBounds = YES;
    [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:finishButton];
    
    self.finishTestButton = finishButton;
    
    
}


- (void)testButtonAction:(UIButton * )bt{

    
    if (bt.tag == 200) {
        
        NSLog(@"任务%ld",bt.tag);
        
        TestCenterVC * vc = [[TestCenterVC alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (bt.tag == 201){
        NSLog(@"任务%ld",bt.tag);

        [self.navigationController popViewControllerAnimated:YES];

    }else if (bt.tag == 202){
        NSLog(@"任务%ld",bt.tag);

        [self.navigationController popViewControllerAnimated:YES];

        
    }else if (bt.tag == 203){
        NSLog(@"任务%ld",bt.tag);
        [self.navigationController popViewControllerAnimated:YES];

    }else if (bt.tag == 204){
        NSLog(@"任务%ld",bt.tag);
        [self.navigationController popViewControllerAnimated:YES];

    }else if (bt.tag == 205){
        NSLog(@"任务邀请好友:%ld",bt.tag);
        
        
        InviateFriendTypeTwoVC * vc = [[InviateFriendTypeTwoVC alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}

- (void)finishButtonAction{

    NSLog(@"完成任务");

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net personNewTestFinish];
    
    
    __weak NewPeopleTestVC * weakSelf = self;
    
    net.personNewTestFinishBK=^(NSString * code,NSString * message){
    
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
    };
    
}


@end
