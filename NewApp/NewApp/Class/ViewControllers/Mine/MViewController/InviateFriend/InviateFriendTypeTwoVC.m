//
//  InviateFriendTypeTwoVC.m
//  NewApp
//
//  Created by gxtc on 17/3/10.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "InviateFriendTypeTwoVC.h"

@interface InviateFriendTypeTwoVC ()

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,assign)CGFloat scroll_h;

@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,strong)UIButton * linkCopyBt;
@property (nonatomic,strong)UIButton * firentBt;
@property (nonatomic,strong)UIButton * wechatBt;
@property (nonatomic,strong)UIButton * QzoneBt;
@property (nonatomic,strong)UIButton * QQBt;


@property (nonatomic,copy)NSString * inviter;
@property (nonatomic,copy)NSString * url;

@property (nonatomic,strong)UILabel * inviateCodeLabel;

@property (nonatomic,strong)MainShareView * shareView;


@end

@implementation InviateFriendTypeTwoVC


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self stopTime];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
    [self addTime];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    
    [self addUI];
    [self inviateCodeAndlink];

}

- (void)addUI{
    [super addUI];
    
    self.titleLabel.text = @"邀请好友";

    [self addRightBarClearButtonNew:@"收徒列表"];
    
    
    [self addHeadImageViewNew];
    
    [self addInviateViewNew];
    
    
    
}


/**收徒链接*/
- (void)inviateCodeAndlink{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net mineInviateCodeAndInviateLink];
    
    __weak InviateFriendTypeTwoVC * weakSelf = self;
    
    net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * message,NSString * str,NSArray * arr1,NSArray * arr2){
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (arr1.count > 0) {
                
                weakSelf.inviter = arr1[0];
                weakSelf.url = arr1[1];
            }
            
             self.inviateCodeLabel.attributedText = [self addAppandRootAttributedText:@"我的邀请码:" andArticleNum:weakSelf.inviter andColor1:[UIColor blackColor] andColor2:[UIColor orangeColor]];
       
        
            self.inviateCodeLabel.font = [UIFont systemFontOfSize:16.0];
        }
        
    };
    
}




- (void)rightBarClearButtonAction{

    FriendListVC * vc = [[FriendListVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}




/**背景图片*/
- (void)addHeadImageViewNew{
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhiliaobanner"]];
    imageV.frame = CGRectMake(0, 64, ScreenWith, ScreenWith * 2/5);
    [self.view addSubview:imageV];
}


/**邀请码背景图*/
- (void)addInviateViewNew{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, ScreenWith /3 + 64, ScreenWith-30, 10 + 30 + 15 + 10 + 20 + ScreenWith/5 + 10)];
    view.layer.cornerRadius = 5.0;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];

    
    [self addMyInviateCodeNewWithView:view];
    
    
    UILabel * littleTitle = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(view.frame) + 15, ScreenWith, 15) andTitleColor:[UIColor lightGrayColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"点击下面按钮去分享赚钱吧!"];
    littleTitle.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:littleTitle];
    
    
    [self fiveButtonViewNewWithLabel:littleTitle];
}


/**五个按钮*/
- (void)fiveButtonViewNewWithLabel:(UILabel *)little{

    NSArray * images = @[@"invite_link",@"invite_friend",@"invite_wechat",@"invite_zone",@"invite_qq"];
    NSArray * title = @[@"复制链接",@"发朋友圈",@"  发微信",@"发QQ空间",@"  发QQ"];

    UIView * fiveButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(little.frame) + 5, ScreenWith , ScreenWith/4)];
    fiveButtonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fiveButtonView];
    
    for (int i = 0; i < 5; i ++) {
        
        UIButton * button = [self addRootButtonTypeTwoNewFram:CGRectMake(( ScreenWith - ScreenWith/8 * 5)/6 + (( ScreenWith - ScreenWith/8 * 5)/6 + ScreenWith/8) * i, 10, ScreenWith/8, ScreenWith/8) andImageName:images[i] andTitle:@"" andBackGround:[UIColor clearColor] andTitleColor:[UIColor clearColor] andFont:17.0 andCornerRadius:0.0];
        button.tag = 2120 + i;
        
        [button addTarget:self action:@selector(fiveBtAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label = [self addRootLabelWithfram:CGRectMake(CGRectGetMinX(button.frame) - 2, CGRectGetMaxY(button.frame) + 10, ScreenWith/5, 15) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:title[i]];
        label.textAlignment = NSTextAlignmentLeft;
        [fiveButtonView addSubview:button];
        [fiveButtonView addSubview:label];
    
        
//        if (i == 0) {
//            
//            self.linkCopyBt = button;
//        }else if (i == 1){
//            self.firentBt = button;
//
//        }else if (i == 2){
//            self.wechatBt = button;
//
//        }else if (i == 3){
//            self.QzoneBt = button;
//
//        }else if (i == 4){
//            self.QQBt = button;
//
//        }
        
        
    }
    

    UIButton * teach = [self addRootButtonTypeTwoNewFram:CGRectMake(30, CGRectGetMaxY(fiveButtonView.frame) + 10, ScreenWith - 60, ScreenWith/10) andImageName:@"" andTitle:@"收徒赚钱教程" andBackGround:[UIColor orangeColor] andTitleColor:[UIColor whiteColor] andFont:16.0 andCornerRadius:10.0];
    [teach addTarget:self action:@selector(teachAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:teach];
    
    
    
    UILabel * teachLabel = [self addRootLabelWithfram:CGRectMake(15, CGRectGetMaxY(teach.frame) + 20, ScreenWith - 30, 10) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"为什么邀请好友后未收到奖励？\n答:要求您的好友符合活跃度标准，系统才会为您发放邀请奖励。活跃度的定义标准为用户为每天签到，阅读新闻以及正常分享新闻行为。"];
    teachLabel.numberOfLines = 0;
    [teachLabel sizeToFit];
    [self.view addSubview:teachLabel];
}


- (void)teachAction{

    NSLog(@"赚钱教程");
    
    WKWebViewController * vc = [[WKWebViewController alloc]init];
    
    vc.urlString = [NSString stringWithFormat:@"%@/App/Index/make_money",DomainURL];
    vc.isNewTeach = YES;
    vc.isPost = NO;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark- 五个按钮Action
- (void)fiveBtAction:(UIButton *)bt{
    
    if (bt.tag != 2120) {
        
        if (self.shareView == nil) {
        
            self.shareView = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 0)];
        
            [self.shareView addAdvertisementViewNew];
        
            [self.shareView.advCancleButton addTarget:self action:@selector(rootAdvCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
            [self.shareView.shareEnterButton addTarget:self action:@selector(rootShareEnterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
    
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        [window addSubview:self.shareView];
    
    }
    
    if (bt.tag == 2120) {
        NSLog(@"复制链接");

        [self rootCopyLinkWith:self.url];
        
    }else if (bt.tag == 2121){
        NSLog(@"发朋友圈");

        self.shareView.shareType = WeiXinFriendShareType;

        
    }else if (bt.tag == 2122){
        NSLog(@"发微信");

        self.shareView.shareType = WeiXinShareType;

    }else if (bt.tag == 2123){
        NSLog(@"发QZONE");
        self.shareView.shareType = QzoneShareType;

    }else if (bt.tag == 2124){
        NSLog(@"发QQ");
        self.shareView.shareType = QQShareType;

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
        
        [self rootLocationWeiXinShareWithImage:[UIImage imageNamed:@"icon_180"] andImageUrl:nil andString:advString andUrl:self.url];

        
    }else if (self.shareView.shareType == QQShareType ){
    
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ andTitle:advString andContent:advString andUrl:self.url andThumbImage:[UIImage imageNamed:@"icon_180"]];

    }else if (self.shareView.shareType == QzoneShareType ){
    
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone andTitle:advString andContent:advString andUrl:self.url andThumbImage:[UIImage imageNamed:@"icon_180"]];

    }
    
    
    
    
}

//[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1]

/***我的邀请码*/
- (void)addMyInviateCodeNewWithView:(UIView *)bgView{


    UILabel * inviateCode = [self addRootLabelWithfram:CGRectMake(10, 10, ScreenWith - 50, 30) andTitleColor:[UIColor blackColor] andFont:16.0 andBackGroundColor:[UIColor whiteColor] andTitle:@""];
    
    inviateCode.attributedText = [self addAppandRootAttributedText:@"我的邀请码:" andArticleNum:@" t2hXcj" andColor1:[UIColor blackColor] andColor2:[UIColor orangeColor]];
    
    inviateCode.font = [UIFont systemFontOfSize:17.0];
    self.inviateCodeLabel = inviateCode;
    
    [bgView addSubview:inviateCode];
    
    
    UIButton * copyButton = [self addRootButtonNewFram:CGRectMake(ScreenWith - 30 - 10 - 50, 10, 50, 30) andSel:@selector(copyButtonAction) andTitle:@"复制"];
    copyButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    copyButton.layer.cornerRadius = 3.0;
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:copyButton];
    
    
    UILabel * titles = [self addRootLabelWithfram:CGRectMake(10, CGRectGetMaxY(copyButton.frame) + 15, ScreenWith - 50, 10) andTitleColor:[UIColor lightGrayColor] andFont:13.0 andBackGroundColor:[UIColor whiteColor] andTitle:@"分享即可获得收益！"];
    [bgView addSubview:titles];
    
    
    [self addscrollViewNewWithView:bgView andLabel:titles];
    
}

/**复制按钮*/
- (void)copyButtonAction{
    
    [self rootCopyLinkWith:self.inviter];
}


/**滚动信息*/
- (void)addscrollViewNewWithView:(UIView *)bgview andLabel:(UILabel *)titles{

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titles.frame) + 20, ScreenWith - 50, ScreenWith/5)];
    scrollView.backgroundColor = [UIColor orangeColor];
    [bgview addSubview:scrollView];

    scrollView.contentSize = CGSizeMake(0, ScreenWith * 3 / 5);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    
    self.scrollView = scrollView;
    
    CGFloat label_H = ScreenWith/5 / 3;
    
    self.scroll_h = ScreenWith/5 / 3;
    
    NSArray * titleArray = @[@"恭喜 187****4589 分享成功 +2000金币 2小时前",
                             @"恭喜 138****9573 分享成功 +2000金币 7小时前",
                             @"恭喜 157****4449 分享成功 +2000金币 33分前",
                             
                             @"恭喜 139****7567 分享成功 +2000金币 12小时前",
                             @"恭喜 182****4953 分享成功 +2000金币 8小时前",
                             @"恭喜 159****6589 分享成功 +2000金币 1小时前",
                             
                             @"恭喜 187****4589 分享成功 +2000金币 2小时前",
                             @"恭喜 138****9573 分享成功 +2000金币 7小时前",
                             @"恭喜 157****4449 分享成功 +2000金币 33分前"];

    
    for (int i = 0; i < 9; i++) {
        
        UILabel * label = [self addRootLabelWithfram:CGRectMake(0, label_H * i, ScreenWith - 50, label_H) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor whiteColor] andTitle:titleArray[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
    }
    
    
    [self addTime];
}


- (void)addTime{

    if (self.timer == nil) {
        
        NSTimer * time = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeScrollViewContOfSet) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
        self.timer = time;
    }

}


- (void)changeScrollViewContOfSet{

    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGFloat currentOffset = self.scrollView.contentOffset.y;
        
        self.scrollView.contentOffset = CGPointMake(0, self.scroll_h + currentOffset);

    }completion:^(BOOL finished) {
        
        if (self.scrollView.contentOffset.y >= self.scroll_h * 6) {
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        
    }];
    
    
}


- (void)stopTime{

    [self.timer invalidate];
    
    self.timer = nil;
    
}









@end
