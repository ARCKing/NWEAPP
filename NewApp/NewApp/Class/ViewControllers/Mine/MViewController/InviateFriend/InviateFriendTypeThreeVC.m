//
//  InviateFriendTypeThreeVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "InviateFriendTypeThreeVC.h"

@interface InviateFriendTypeThreeVC ()
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
@property (nonatomic,copy)NSString * font;


@property (nonatomic,strong)UILabel * inviateCodeLabel;

@property (nonatomic,strong)UILabel * tuDiIncomeLabel;
@property (nonatomic,strong)UILabel * tuSunIncomeLabel;

@property (nonatomic,strong)UILabel * tuDiNumLabel;
@property (nonatomic,strong)UILabel * tuSunNumLabel;

@property (nonatomic,strong)MainShareView * shareView;

@property (nonatomic,strong)UIView * unLoginView;
@end

@implementation InviateFriendTypeThreeVC

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

        
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if ([dic[@"login"] isEqualToString:@"1"]) {
        
        [self.unLoginView removeFromSuperview];
        
        [self inviateCodeAndlink];
        
    }else{
        
        [self addLoginViewNewWithTitle:@"邀请"];
        
    
    }

    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    
    [self addUI];
    

}

- (void)addUI{
    


    [self addscrollViewCreatNew];
    [self addHeadImageViewNew];
    [self addInviateViewNew];
    
    
}


- (void)addLoginViewNewWithTitle:(NSString *)title{

    
    if (self.unLoginView ) {
        
        [self.view addSubview:self.unLoginView];
        
        return;
    }
    
    UIView * BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 49)];
    BGview.backgroundColor = [UIColor whiteColor];
    self.unLoginView = BGview;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 64)];
    titleLabel.backgroundColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [BGview addSubview:titleLabel];
    
    
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_un_login"]];
    imagev.frame = CGRectMake(ScreenWith/4, ScreenWith/4, ScreenWith/3, ScreenWith/4);
    imagev.center = CGPointMake(ScreenWith/2,ScreenWith/2 + ScreenWith/4);
    [BGview addSubview:imagev];
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith/5, ScreenWith/10) andSel:@selector(goToLogin) andTitle:@"点我登录"];
    bt.center = CGPointMake(ScreenWith/2, ScreenWith);
    bt.layer.cornerRadius = 3.0;
    bt.layer.backgroundColor = [UIColor clearColor].CGColor;
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    [BGview addSubview:bt];
    
    [self.view addSubview:BGview];
    
    
    
}



- (void)loginViewAlterViewShow{

    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，请登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alert show];


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    LoginViewController * vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)goToLogin{
    LoginViewController * vc = [[LoginViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



#pragma mark- 收徒-二维码-邀请码-收益
/**收徒链接*/
- (void)inviateCodeAndlink{

    
    BOOL netOK = [self RootCurrentNetState];
    
    
    if (netOK == NO) {
    
        return;
    }
    
    
    
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net mineInviateCodeAndInviateLink];
    
    __weak InviateFriendTypeThreeVC * weakSelf = self;
    
    net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * message,NSString * str,NSArray * arr1,NSArray * arr2){
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (arr1.count >0) {
                
                weakSelf.inviter = arr1[0];
                weakSelf.url = arr1[1];
                weakSelf.font = arr1[6];
                
                weakSelf.tuDiIncomeLabel.text = [NSString stringWithFormat:@"累计收益:%@元",arr1[4]];
                weakSelf.tuDiNumLabel.text = [NSString stringWithFormat:@"%@人",arr1[2]];
                weakSelf.tuSunIncomeLabel.text = [NSString stringWithFormat:@"累计收益:%@元",arr1[5]];
                weakSelf.tuSunNumLabel.text = [NSString stringWithFormat:@"%@人",arr1[3]];

                weakSelf.inviateCodeLabel.attributedText = [weakSelf addAppandRootAttributedText:@"我的邀请码:" andArticleNum:weakSelf.inviter andColor1:[UIColor blackColor] andColor2:[UIColor orangeColor]];
                weakSelf.inviateCodeLabel.font = [UIFont systemFontOfSize:16.0];
                
                
                UIView * bgview = (UIView *)[weakSelf.scrollView viewWithTag:321123];
                UILabel * label = (UILabel *)[bgview viewWithTag:123321];
                
                [weakSelf addQRCodeImageViewNewWithView:bgview andTitle:label andInviateLink:weakSelf.url];
                
            }
        }
        
    };
  
}




- (void)rightBarClearButtonAction{
    
    FriendListVC * vc = [[FriendListVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}




/**背景图片*/
- (void)addHeadImageViewNew{
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_invite_top"]];
    imageV.frame = CGRectMake(0, 0, ScreenWith, ScreenWith * 2/5);
    [self.scrollView addSubview:imageV];
}


/**邀请二维码码背景图*/
- (void)addInviateViewNew{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, ScreenWith /3 , ScreenWith-30, ScreenHeight * 2/5)];
    view.layer.cornerRadius = 5.0;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 321123;
    
    [self.scrollView addSubview:view];
    
    
    [self addMyInviateCodeNewWithView:view];
    
    
    
    UILabel * label0 = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(view.frame) + 5, (ScreenWith)/4, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"我的徒弟"];
    label0.textAlignment = NSTextAlignmentCenter;

    
    UILabel * label1 = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(label0.frame), CGRectGetMaxY(view.frame) + 5, (ScreenWith)/2, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"累计收益:0.00"];
    label1.textAlignment = NSTextAlignmentCenter;
    self.tuDiIncomeLabel = label1;
    
    UILabel * label2 = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMaxY(view.frame) + 5, (ScreenWith)/4, ScreenWith/10) andTitleColor:[UIColor redColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"--人"];
    label2.textAlignment = NSTextAlignmentCenter;
    self.tuDiNumLabel = label2;
    
    UILabel * label3 = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(label0.frame) + 5, (ScreenWith)/4, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"我的徒孙"];
    label3.textAlignment = NSTextAlignmentCenter;
    
    UILabel * label4 = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(label3.frame), CGRectGetMaxY(label0.frame) +5, (ScreenWith)/2, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"累计收益:0.00"];
    label4.textAlignment = NSTextAlignmentCenter;
    self.tuSunIncomeLabel = label4;
    
    UILabel * label5 = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(label4.frame), CGRectGetMaxY(label0.frame) +5, (ScreenWith)/4, ScreenWith/10) andTitleColor:[UIColor redColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"--人"];
    self.tuSunNumLabel = label5;
    label5.textAlignment = NSTextAlignmentCenter;

    
    [self.scrollView addSubview:label0];
    [self.scrollView addSubview:label1];
    [self.scrollView addSubview:label2];
    [self.scrollView addSubview:label3];
    [self.scrollView addSubview:label4];
    [self.scrollView addSubview:label5];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(label0.frame), ScreenWith - 80, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:1.0 alpha:1.0];
    [self.scrollView addSubview:line];
    
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(15, CGRectGetMinY(label0.frame), ScreenWith-30, ScreenWith/5) andSel:@selector(rightBarClearButtonAction) andTitle:nil];
    bt.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:bt];
    
    
    
    
    UILabel * littleTitle = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(label3.frame) + 10, ScreenWith, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"点击下面按钮去分享吧!"];
    littleTitle.textAlignment = NSTextAlignmentCenter;
    
    [self.scrollView addSubview:littleTitle];
    
    
    [self fiveButtonViewNewWithLabel:littleTitle];
}




/**五个按钮*/
- (void)fiveButtonViewNewWithLabel:(UILabel *)little{
    
    NSArray * images = @[@"invite_link",@"invite_friend",@"invite_wechat",@"invite_zone",@"invite_qq"];
    NSArray * title = @[@"复制链接",@"发朋友圈",@"  发微信",@"发QQ空间",@"  发QQ"];
    
    UIView * fiveButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(little.frame) + 5, ScreenWith , ScreenWith/4)];
    fiveButtonView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:fiveButtonView];
    
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
    
    [self.scrollView addSubview:teach];
    
    
    
    UILabel * teachLabel = [self addRootLabelWithfram:CGRectMake(15, CGRectGetMaxY(teach.frame) + 20, ScreenWith - 30, 10) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"为什么邀请好友后未收到奖励？\n答:好友注册完成后，分享文章并首次获得分享收益后系统才会发放邀请奖励。"];
    teachLabel.numberOfLines = 0;
    [teachLabel sizeToFit];
    [self.scrollView addSubview:teachLabel];
}


- (void)teachAction{
    
    NSLog(@"赚钱教程");
    
    WKWebViewController * vc = [[WKWebViewController alloc]init];
    
    vc.urlString = [NSString stringWithFormat:@"%@/App/Index/make_money",DomainURL];
    vc.isNewTeach = YES;
    vc.isPost = NO;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}


#pragma mark- 五个按钮Action
- (void)fiveBtAction:(UIButton *)bt{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if (![dic[@"login"] isEqualToString:@"1"]) {
        
        [self goToLogin];
        
        return;
    }
    
    
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
        
        
        NSString * messageFont = self.font;
        
        NSLog(@"%@",messageFont);
        
        
        messageFont=[messageFont stringByReplacingOccurrencesOfString:@"\\\\n"withString:@"\n"];
        NSLog(@"replaceStr=>%@",messageFont);
        
        NSString * link = [NSString stringWithFormat:@"%@%@",messageFont,self.url];

        
        [self rootCopyLinkWith:link];
        
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
    
    
    UILabel * inviateCode = [self addRootLabelWithfram:CGRectMake(10, 10, ScreenWith - 50, 30) andTitleColor:[UIColor blackColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:@""];
    
    inviateCode.attributedText = [self addAppandRootAttributedText:@"我的邀请码:" andArticleNum:@"---" andColor1:[UIColor blackColor] andColor2:[UIColor orangeColor]];
    
    inviateCode.font = [UIFont systemFontOfSize:17.0];
    self.inviateCodeLabel = inviateCode;
    
    [bgView addSubview:inviateCode];
    
    
    UIButton * copyButton = [self addRootButtonNewFram:CGRectMake(ScreenWith - 30 - 10 - 50, 10, 50, 30) andSel:@selector(copyButtonAction) andTitle:@"复制"];
    copyButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    copyButton.layer.cornerRadius = 3.0;
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:copyButton];
    
    
    UILabel * titles = [self addRootLabelWithfram:CGRectMake(10, CGRectGetMaxY(copyButton.frame) + 5, ScreenWith - 50, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"面对面收徒"];
    titles.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titles];
    titles.tag = 123321;
    
}

/**复制按钮*/
- (void)copyButtonAction{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if (![dic[@"login"] isEqualToString:@"1"]) {
        [self goToLogin];
        return;
    }
    
    
    [self rootCopyLinkWith:self.inviter];
}


/**滚动信息*/
- (void)addscrollViewCreatNew{
    
    
    UILabel * teachLabel = [self addRootLabelWithfram:CGRectMake(0,0, ScreenWith - 30, 10) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"为什么邀请好友后未收到奖励？\n答:要求您的好友符合活跃度标准，系统才会为您发放邀请奖励。活跃度的定义标准为用户为每天签到，阅读新闻以及正常分享新闻行为。"];
    teachLabel.numberOfLines = 0;
    [teachLabel sizeToFit];
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 49)];
    scrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(0, ScreenWith * 2/5 + ScreenHeight * 2/5 + ScreenWith/5 + ScreenWith/15 + ScreenWith/4 + ScreenWith/10 + teachLabel.bounds.size.height + 55);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    
    self.scrollView = scrollView;
    
  
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



#pragma mark- 二维码
/**二维码*/
- (void)addQRCodeImageViewNewWithView:(UIView * )view andTitle:(UILabel *)label andInviateLink:(NSString *)urlLink{

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if (![dic[@"login"] isEqualToString:@"1"]) {
        
        return;
    }
    
    
    UIImageView * QRCode = [self QrCodeWithViewFram:CGRectMake((ScreenWith - 30)/4,CGRectGetMaxY(label.frame),(ScreenWith - 30)/2,(ScreenWith - 30)/2) andCodeString:urlLink];

    [view addSubview:QRCode];
    
}

@end
